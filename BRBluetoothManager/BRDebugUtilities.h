//
//  BRDebugUtilities.h
//  BRBluetoothManager
//
//  Created by Ben Reed on 07/02/2013.
//  Copyright (c) 2013 Ben Reed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRDebugUtilities : NSObject

+(BRDebugUtilities*)sharedManager;

///Data generating methods
-(NSData*)createRandomNSDataWithSize:(int)sizeInMb;

@end
