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
	// Do any additional setup after loading the view, typically from a nib.
    
    bluetoothManager = [[BRBluetoothManager alloc] init];
    bluetoothManager.delegate = self;
    
}

-(IBAction)connectButtonHandler:(id)sender {

    [bluetoothManager displayPeerPicker];
    
}

#pragma mark BRBluetoothManagerDelegate methods
-(void)bluetoothManager:(BRBluetoothManager *)manager didConnectToPeer:(NSString *)peer {
    NSLog(@"Delegate: connected to peer");
    
    NSData *testData = [[BRDebugUtilities sharedManager] createRandomNSDataWithSize:20971520];
    
    [bluetoothManager sendData:testData toReceivers:nil];
}

-(void)bluetoothManager:(BRBluetoothManager *)manager didDisconnectFromPeer:(NSString *)peer {
    NSLog(@"Delegate: disconnected from peer");
}

-(void)bluetoothManager:(BRBluetoothManager *)manager didReceiveDataOfLength:(int)length fromTotal:(int)totalLength withRemaining:(int)remaining {
    
    NSLog(@"Delegate: received %ikb of %ikb",remaining/1024,totalLength/1024);
    
}

-(void)bluetoothManager:(BRBluetoothManager *)manager didCompleteTransferOfData:(NSData *)data {
    
    NSLog(@"All done!");
    
}

-(void)bluetoothManager:(BRBluetoothManager *)manager receiveDataFailedWithError:(NSError *)error {
    NSLog(@"Delegate: transfer of data failed");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
