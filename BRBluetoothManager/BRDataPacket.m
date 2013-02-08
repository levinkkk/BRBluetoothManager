//
//  BRDataPacket.m
//  BRBluetoothManager
//
//  Created by Ben Reed on 08/02/2013.
//  Copyright (c) 2013 Ben Reed. All rights reserved.
//

#import "BRDataPacket.h"

NSString * const BRDataPacketPacket = @"packet";
NSString * const BRDataPacketTotalSize = @"totalSize";
NSString * const BRDataPacketRemaining = @"remaining";


@implementation BRDataPacket

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    if (self){
        self.packet = [decoder decodeObjectForKey:BRDataPacketPacket];
        self.totalSize = [decoder decodeIntForKey:BRDataPacketTotalSize];
        self.remaining = [decoder decodeIntForKey:BRDataPacketRemaining];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.packet forKey:BRDataPacketPacket];
    [encoder encodeInt:self.totalSize forKey:BRDataPacketTotalSize];
    [encoder encodeInt:self.remaining forKey:BRDataPacketRemaining];
}



@end
