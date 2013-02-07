//
//  BRDebugUtilities.m
//  BRBluetoothManager
//
//  Created by Ben Reed on 07/02/2013.
//  Copyright (c) 2013 Ben Reed. All rights reserved.
//

#import "BRDebugUtilities.h"

@implementation BRDebugUtilities

#pragma mark - Singleton methods
+(BRDebugUtilities*)sharedManager {
    
    static BRDebugUtilities *sharedManager = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

-(id)init {
    
    self = [super init];
    
    if(self != nil){
        
        //configure here
        
    }
    
    return self;
}

/***
 * Method for generating NSData at a given size. Used for testing file sending/receiving.
 * http://stackoverflow.com/questions/4917968/best-way-to-generate-nsdata-object-with-random-bytes-of-a-specific-length
 * 
 * @param int sizeInMb
 * @return NSData
 **/
-(NSData*)createRandomNSDataWithSize:(int)sizeInMb {
    NSMutableData* theData = [NSMutableData dataWithCapacity:sizeInMb];
    for( unsigned int i = 0 ; i < sizeInMb/4 ; ++i )
    {
        u_int32_t randomBits = arc4random();
        [theData appendBytes:(void*)&randomBits length:4];
    }
    return theData;
}

@end
