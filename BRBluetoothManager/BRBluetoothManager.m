//
//  BRBluetoothManager.m
//  BRBluetoothManager
//
//  Created by Ben Reed on 06/02/2013.
//  Copyright (c) 2013 Ben Reed. All rights reserved.
//

#import "BRBluetoothManager.h"

NSString * const BRBluetoothManagerSessionName = @"me.benreed.Gretel";

@implementation BRBluetoothManager {
    GKSession *gameKitSession;
    NSMutableData *receivedData;
    NSString *peer;
}

-(void)displayPeerPicker {

    if (gameKitSession == nil) {
        //create peer picker and show picker of connections
        GKPeerPickerController *peerPicker = [[GKPeerPickerController alloc] init];
        peerPicker.delegate = self;
        peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
        [peerPicker show];
    }
    
}

-(void)resetSession {
    
    //Reset all values
    gameKitSession = nil;
    receivedData = nil;
    self.isConnected = NO;
    self.isSending = NO;
    peer = nil;
    
    //Inform the delegate that we have disconnected
    [self.delegate bluetoothManager:self didDisconnectFromPeer:peer];
    
}

-(void)cancelCurrentTransfer {
    
    //Reset the data
    receivedData = nil;
    self.isSending = NO;

    //Create an error and notify the delegate we have cancelled the transfer
    NSError *error = [[NSError alloc] initWithDomain:BRBluetoothManagerSessionName code:0 userInfo:nil];
    [self.delegate bluetoothManager:self receiveDataFailedWithError:error];
    
}

#pragma mark GKPeerPickerControllerDelegate methods
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    //create GKSession object
    GKSession *session = [[GKSession alloc] initWithSessionID:BRBluetoothManagerSessionName displayName:nil sessionMode:GKSessionModePeer];
    return session;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    
    gameKitSession = session;
    gameKitSession.delegate = self;
    
    peer = peerID;
    
    [gameKitSession setDataReceiveHandler:self withContext:nil];
    
    picker.delegate = nil;
    [picker dismiss];
    
}

#pragma mark GKSessionDelegate methods
-(void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    
    switch (state) {
        case GKPeerStateAvailable:
            
            NSLog(@"Available");
            break;
            
        case GKPeerStateUnavailable:
            
            NSLog(@"Unavailable");
            break;
            
        case GKPeerStateConnected:
            
            NSLog(@"Connected");
            self.isConnected = YES;
            [self.delegate bluetoothManager:self didConnectToPeer:peerID];
            
            break;
            
        case GKPeerStateDisconnected:
            
            NSLog(@"Disconnected");
            [self resetSession];
            
            break;
            
        case GKPeerStateConnecting:
            NSLog(@"Connecting");
            
            break;
    }
    
}

#pragma mark data sending methods
-(void)sendData:(NSData *)data toReceivers:(NSArray *)recievers {
    
    [self.delegate bluetoothManager:self didBeginToSendData:nil];
    
    //Flag that we are sending data
    self.isSending = YES;
    
    //Set up variables needed to split and send
    NSUInteger length = [data length];
    NSUInteger chunkSize = 45 * 1024;
    NSUInteger offset = 0;
    
    NSError *error = nil;
        
    //Iterate over the data, sending it in "chunks"
    do {
        
        NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
        NSData* chunk = [NSData dataWithBytesNoCopy:(char *)[data bytes] + offset
                                             length:thisChunkSize
                                       freeWhenDone:NO];
        
        offset += thisChunkSize;
        
        //Create the data packet
        BRDataPacket *packet = [[BRDataPacket alloc] init];
        packet.packet = chunk;
        packet.totalSize = length;
        packet.remaining = offset ;
        
        NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:packet];
        
        //send it
        [gameKitSession sendDataToAllPeers:dataToSend withDataMode:GKSendDataReliable error:&error];
        [self.delegate bluetoothManager:self didSendDataOfLength:[packet.packet length] fromTotal:length withRemaining:offset];
        
    } while (offset < length);
    
    //Reset the is sending flag
    self.isSending = NO;
    
    //Send a nil sentinel to tell the receiver we are done.
    [self.delegate bluetoothManager:self didCompleteTransferOfData:receivedData];
    
}


#pragma mark data receiving methods
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
  
    //If we haven't received any data yet, this is the first packet
    if(!receivedData){
        receivedData = [NSMutableData data];
        [self.delegate bluetoothManager:self didBeginToReceiveData:nil];
    }
    
    NSLog(@"Data length: %i",[receivedData length]);
    
    BRDataPacket *packet = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    [receivedData appendData:packet.packet];
    [self.delegate bluetoothManager:self didReceiveDataOfLength:[packet.packet length] fromTotal:packet.totalSize withRemaining:packet.remaining];
    
}

@end
