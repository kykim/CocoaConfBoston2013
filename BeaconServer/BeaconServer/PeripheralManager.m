//
//  PeripheralManager.m
//  BeaconServer
//
//  Created by Kevin Y. Kim on 10/22/13.
//  Copyright (c) 2013 AppOrchard, LLC. All rights reserved.
//

#import "PeripheralManager.h"

@interface PeripheralManager () <CBPeripheralManagerDelegate>
@end

@implementation PeripheralManager

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super initWithDelegate:self queue:nil];
    if (self) {
        
    }
    return self;
}

#pragma mark - CBPeripheralManager Delegate Methods

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSString *state = nil;
    switch (peripheral.state) {
        case CBPeripheralManagerStateUnknown:
            state = @"CBPeripheralManagerStateUnknown";
            break;
        case CBPeripheralManagerStateResetting:
            state = @"CBPeripheralManagerStateResetting";
            break;
        case CBPeripheralManagerStateUnsupported:
            state = @"CBPeripheralManagerStateUnsupported";
            break;
        case CBPeripheralManagerStateUnauthorized:
            state = @"CBPeripheralManagerStateUnauthorized";
            break;
        case CBPeripheralManagerStatePoweredOff:
            state = @"CBPeripheralManagerStatePoweredOff";
            break;
        case CBPeripheralManagerStatePoweredOn:
            state = @"CBPeripheralManagerStatePoweredOn";
            break;
    }
    NSLog(@"Did UpdateState: %@", state);
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    NSLog(@"Did Start Advertising: %@ (%@)", peripheral, error);
}

#pragma mark - 

- (void)checkBluetooth
{
    if (self.state < CBPeripheralManagerStatePoweredOn) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Bluetooth must be enabled" message:@"To configure your device as a beacon" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    return;
}

#pragma mark - Simulator overrides

#if TARGET_IPHONE_SIMULATOR

- (void)startAdvertising:(NSDictionary *)advertisementData
{
    self.simulatorAdvertismentData = advertisementData;
    self.advertising = YES;
    if (self.delegate) {
        [self.delegate peripheralManagerDidStartAdvertising:nil error:nil];
    }
}

- (void)stopAdvertising
{
    self.simulatorAdvertismentData = nil;
    self.advertising = NO;
}

#endif

@end
