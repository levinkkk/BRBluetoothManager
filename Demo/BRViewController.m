//
//  BRViewController.m
//  BRBluetoothManager
//
//  Created by Ben Reed on 06/02/2013.
//  Copyright (c) 2013 Ben Reed. All rights reserved.
//

#import "BRViewController.h"
#import "BRDebugUtilities.h"

@interface BRViewController ()

@end

@implementation BRViewController {
    BRBluetoothManager *bluetoothManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    /**
     * Create a file manager instance and configure it
     */
    bluetoothManager = [[BRBluetoothManager alloc] init];
    bluetoothManager.delegate = self;
    
    [self.sendButton setEnabled:NO];
    
}

-(IBAction)connectButtonHandler:(id)sender {
    
    /**
     * Initiate a connection, displays the built in peer picker.
     */
    
    if(!bluetoothManager.isConnected){
        [bluetoothManager displayPeerPicker];
    }else{
        [bluetoothManager resetSession];
    }

}

-(IBAction)sendData:(id)sender {
    
    /**
     * Convert anything you want to send into NSData and send it. The delegate methods will then take over.
     */
    
    //If we are not sending anything, create the data and send it
    if(!bluetoothManager.isSending){
        
        NSData *testData = [[BRDebugUtilities sharedManager] createRandomNSDataWithSize:20971520];
        [bluetoothManager sendData:testData toReceivers:nil];
        
        [self.transferProgress setProgress:0.0f];
        [self.transferProgressWrapper setHidden:NO];
        
        [self.sendButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    //Else we are sending, so cancel the current transfer
    }else{
        
        [bluetoothManager cancelCurrentTransfer];
        
    }
    
}



#pragma mark BRBluetoothManagerDelegate methods
-(void)bluetoothManager:(BRBluetoothManager *)manager didConnectToPeer:(NSString *)peer {
    
    NSLog(@"Delegate: connected to peer");
    
    /**
     * Handle a successful conncetion to the peer. Update the UI to reflect the connection etc.
     * The picker will dismiss itself.
     */
    
    //Set the connect button state and enable the send button
    [self.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    [self.sendButton setEnabled:YES];
}

-(void)bluetoothManager:(BRBluetoothManager *)manager didBeginToSendData:(NSData *)data {
    NSLog(@"Start sending data to receiver");
    [self.transferProgressWrapper setHidden:NO];
}

-(void)bluetoothManager:(BRBluetoothManager *)manager didBeginToReceiveData:(NSData *)data {
    NSLog(@"First packet received");
}

-(void)bluetoothManager:(BRBluetoothManager *)manager didSendDataOfLength:(int)length fromTotal:(int)totalLength withRemaining:(int)remaining {
    
    NSLog(@"Delegate: sent %ikb of %ikb",remaining/1024,totalLength/1024);
    
    float fRemaining = remaining;
    float fTotalLength = totalLength;

    self.transferProgress.progress = fRemaining/fTotalLength;
}

-(void)bluetoothManager:(BRBluetoothManager *)manager didDisconnectFromPeer:(NSString *)peer {
    
    NSLog(@"Delegate: disconnected from peer");
    /**
     * Handle disconnecting from a peer
     */
    
    [self.connectButton setEnabled:YES];
    [self.sendButton setEnabled:NO];
    
    [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
}

-(void)bluetoothManager:(BRBluetoothManager *)manager didReceiveDataOfLength:(int)length fromTotal:(int)totalLength withRemaining:(int)remaining {
    
    NSLog(@"Delegate: received %ikb of %ikb",remaining/1024,totalLength/1024);
    
    float percent = 100/totalLength * remaining;
    
    [self.transferProgress setProgress:percent];
    
    /**
     * Handle receiving packets from a peer. Use this for updating the UI / progress bar etc.
     */
    
}

-(void)bluetoothManager:(BRBluetoothManager *)manager didCompleteTransferOfData:(NSData *)data {
    
    /**
     * Handle handle the completed transfer. This method will return an NSData object that will need to be
     * transformed into whatever it was you were sending.
     */
    
    NSLog(@"All done!");
    
    [self.transferProgress setProgress:0.0f];
    [self.transferProgressWrapper setHidden:YES];
    
    [self.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
}

-(void)bluetoothManager:(BRBluetoothManager *)manager receiveDataFailedWithError:(NSError *)error {
    
    NSLog(@"Delegate: transfer of data failed");
    
    /**
     * Handle any failures in communication here. This will be called if the state of the session changes to disconnected.
     */
    
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
