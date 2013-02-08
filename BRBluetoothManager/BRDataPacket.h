//
//  BRDataPacket.h
//  BRBluetoothManager
//
//  Created by Ben Reed on 08/02/2013.
//  Copyright (c) 2013 Ben Reed. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const BRDataPacketPacket;
extern NSString * const BRDataPacketTotalSize;

@interface BRDataPacket : NSObject

@property (nonatomic, readwrite) int totalSize;
@property (nonatomic, readwrite) int remaining;
@property (nonatomic, weak) NSData *packet;

@end
