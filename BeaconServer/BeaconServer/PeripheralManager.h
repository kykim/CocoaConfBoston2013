//
//  PeripheralManager.h
//  BeaconServer
//
//  Created by Kevin Y. Kim on 10/22/13.
//  Copyright (c) 2013 AppOrchard, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralManager : CBPeripheralManager

+ (instancetype)sharedInstance;

#if TARGET_IPHONE_SIMULATOR
@property (nonatomic, strong) NSDictionary *simulatorAdvertismentData;
@property (readwrite, getter = isAdvertising) BOOL advertising;
#endif

@end
