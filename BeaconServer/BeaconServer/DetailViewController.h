//
//  DetailViewController.h
//  BeaconServer
//
//  Created by Kevin Y. Kim on 10/22/13.
//  Copyright (c) 2013 AppOrchard, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeaconCat/BeaconCat.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) BeaconCat *cat;

- (void)startAdvertising;
- (void)stopAdvertising;

@end
