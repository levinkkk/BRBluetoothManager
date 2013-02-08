//
//  BRBluetoothManager.h
//  BRBluetoothManager
//
//  Created by Ben Reed on 06/02/2013.
//  Copyright (c) 2013 Ben Reed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "BRDataPacket.h"

extern NSString * const BRBluetoothManagerSessionName;

@class BRBluetoothManager;

@protocol BRBluetoothManagerDelegate <NSObject>

-(void)bluetoothManager:(BRBluetoothManager *)manager didConnectToPeer:(NSString *)peer;
-(void)bluetoothManager:(BRBluetoothManager *)manager didDisconnectFromPeer:(NSString *)peer;
-(void)bluetoothManager:(BRBluetoothManager *)manager didReceiveDataOfLength:(int)length fromTotal:(int)totalLength withRemaining:(int)remaining;
-(void)bluetoothManager:(BRBluetoothManager *)manager didCompleteTransferOfData:(NSData *)data;
-(void)bluetoothManager:(BRBluetoothManager *)manager receiveDataFailedWithError:(NSError *)error;

@end

@interface BRBluetoothManager : NSObject <GKSessionDelegate, GKPeerPickerControllerDelegate>

@property (nonatomic, strong) id <BRBluetoothManagerDelegate> delegate;

-(void)displayPeerPicker;
-(void)sendData:(NSData *)data toReceivers:(NSArray *)recievers;
-(void)resetSession;

@end
