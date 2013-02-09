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
    [bluetoothManager displayPeerPicker];
    
}

-(IBAction)sendData:(id)sender {
    /**
     * Convert anything you want to send into NSData and send it. The delegate methods will then take over.
     */
    NSData *testData = [[BRDebugUtilities sharedManager] createRandomNSDataWithSize:20971520];
    [bluetoothManager sendData:testData toReceivers:nil];
}


#pragma mark BRBluetoothManagerDelegate methods
-(void)bluetoothManager:(BRBluetoothManager *)manager didConnectToPeer:(NSString *)peer {
    
    NSLog(@"Delegate: connected to peer");
    
    /**
     * Handle a successful conncetion to the peer. Update the UI to reflect the connection etc.
     * The picker will dismiss itself.
     */
    
    [self.connectButton setEnabled:NO];
    [self.sendButton setEnabled:YES];
    
}

-(void)bluetoothManager:(BRBluetoothManager *)manager didDisconnectFromPeer:(NSString *)peer {
    
    NSLog(@"Delegate: disconnected from peer");
    /**
     * Handle disconnecting from a peer
     */
    
    [self.connectButton setEnabled:YES];
    [self.sendButton setEnabled:NO];
}

-(void)bluetoothManager:(BRBluetoothManager *)manager didReceiveDataOfLength:(int)length fromTotal:(int)totalLength withRemaining:(int)remaining {
    
    NSLog(@"Delegate: received %ikb of %ikb",remaining/1024,totalLength/1024);
    
    /**
     * Handle receiving packets from a peer. Use this for updating the UI / progress bar etc.
     */
    
}

-(void)bluetoothManager:(BRBluetoothManager *)manager didCompleteTransferOfData:(NSData *)data {
    
    NSLog(@"All done!");
    
    /**
     * Handle handle the completed transfer. This method will return an NSData object that will need to be
     * transformed into whatever it was you were sending.
     */
    
}

-(void)bluetoothManager:(BRBluetoothManager *)manager receiveDataFailedWithError:(NSError *)error {
    
    NSLog(@"Delegate: transfer of data failed");
    
    /**
     * Handle any failures in communication here. This will be called if the state of the session changes to disconnected.
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
