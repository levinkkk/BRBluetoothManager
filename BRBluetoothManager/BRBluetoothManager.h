/**
 *  BRBluetoothManager.h
 *  BRBluetoothManager
 *
 *  Created by Ben Reed on 06/02/2013.
 *  Copyright (c) 2013 Ben Reed. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "BRDataPacket.h"

/**
 * Constant for the session name you want to use in your app
 */
extern NSString * const BRBluetoothManagerSessionName;

@class BRBluetoothManager;

@protocol BRBluetoothManagerDelegate <NSObject>

/**
 * Called when a connection is made to another device
 * @param peer NSString - can be used for updating the GUI etc.
 * @return void
 */
-(void)bluetoothManager:(BRBluetoothManager *)manager didConnectToPeer:(NSString *)peer;

/**
 * Called when a the connected device terminates the session and disconnects
 * @param peer NSString - can be used for updating the GUI etc.
 * @return void
 */
-(void)bluetoothManager:(BRBluetoothManager *)manager didDisconnectFromPeer:(NSString *)peer;

@optional

/**
 * Called when the receiving device receives a packet. Use this method to update any progress indicators, GUI etc.
 * @param length int - size of packet that has been recevied in bytes
 * @param totalLength int - total size of data being sent in bytes
 * @param remaining - remaining data to be sent in bytes
 * @return void
 */
-(void)bluetoothManager:(BRBluetoothManager *)manager didReceiveDataOfLength:(int)length fromTotal:(int)totalLength withRemaining:(int)remaining;

/**
 * Called when all data has been received.
 * This data can be reconstructed into whatever format it was before sending.
 * @param data NSData - the complete data objet. This is built up by the packets received in didReceiveDataOfLength:(int)length fromTotal:(int)totalLength withRemaining:(int)remaining.
 * @return void
 */
-(void)bluetoothManager:(BRBluetoothManager *)manager didCompleteTransferOfData:(NSData *)data;

/**
 * Called when data sending is interrupted and fails
 * @param error NSError
 * @return void
 */
-(void)bluetoothManager:(BRBluetoothManager *)manager receiveDataFailedWithError:(NSError *)error;

@end

@interface BRBluetoothManager : NSObject <GKSessionDelegate, GKPeerPickerControllerDelegate>

@property (nonatomic, strong) id <BRBluetoothManagerDelegate> delegate;

/**
 * Displays the built in Peer picker used by GameKit to pair devices.
 * @return void
 */
-(void)displayPeerPicker;

/**
 * Sends data to an array of receivers.
 * @return void
 */
-(void)sendData:(NSData *)data toReceivers:(NSArray *)recievers;

/**
 * Resets any current gamekit session
 * @return void
 */
-(void)resetSession;

@end
