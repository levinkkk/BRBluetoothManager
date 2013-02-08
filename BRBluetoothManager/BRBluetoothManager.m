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
    gameKitSession = nil;
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
            [self.delegate bluetoothManager:self didConnectToPeer:peerID];
            
            break;
            
        case GKPeerStateDisconnected:
            NSLog(@"Disconnected");
            [self.delegate bluetoothManager:self didDisconnectFromPeer:peerID];
            
            break;
            
        case GKPeerStateConnecting:
            NSLog(@"Connecting");
            
            break;
    }
    
}

#pragma mark data sending methods
-(void)sendData:(NSData *)data toReceivers:(NSArray *)recievers {
    
    //Set up variables needed to split and send
    NSUInteger length = [data length];
    NSUInteger chunkSize = 45 * 1024;
    NSUInteger offset = 0;
    
    NSLog(@"Total to send: %i kb", length/1024);
    
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
        
    } while (offset < length);
    
    //Send a nil sentinel to tell the receiver we are done.
    [gameKitSession sendDataToAllPeers:nil withDataMode:GKSendDataReliable error:&error];
    
}


#pragma mark data receiving methods
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    
    //Append the received data to the recieved data object
    if(data != nil){
        
        BRDataPacket *packet = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [receivedData appendData:packet.packet];
        [self.delegate bluetoothManager:self didReceiveDataOfLength:[packet.packet length] fromTotal:packet.totalSize withRemaining:packet.remaining];
        
    }else{
        [self handleReceivedData];
    }
    
}

-(void)handleReceivedData {
    
    [self.delegate bluetoothManager:self didCompleteTransferOfData:receivedData];
    
}

@end
