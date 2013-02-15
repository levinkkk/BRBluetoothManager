//
//  BRViewController.h
//  BRBluetoothManager
//
//  Created by Ben Reed on 06/02/2013.
//  Copyright (c) 2013 Ben Reed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRBluetoothManager.h"

@interface BRViewController : UIViewController <BRBluetoothManagerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *sendButton;
@property (nonatomic, strong) IBOutlet UIButton *connectButton;

@property (nonatomic, strong) IBOutlet UIView *transferProgressWrapper;
@property (nonatomic, strong) IBOutlet UIProgressView *transferProgress;
@property (nonatomic, strong) IBOutlet UILabel *transferProgressLabel;

@end
