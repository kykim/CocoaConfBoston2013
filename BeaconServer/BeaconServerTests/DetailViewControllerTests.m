//
//  DetailViewControllerTests.m
//  BeaconServer
//
//  Created by Kevin Y. Kim on 10/22/13.
//  Copyright (c) 2013 AppOrchard, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DetailViewController.h"
#import "Cat.h"
#import "PeripheralManager.h"

@interface DetailViewControllerTests : XCTestCase
@property (nonatomic, strong) DetailViewController *target;
@end

@implementation DetailViewControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.target = [[DetailViewController alloc] init];
}

- (void)tearDown
{
    self.target = nil;
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testStartAdvertisingAndStopAdvertisingSetIsAdvertising
{
    self.target.cat = [[Cat alloc] initWithDictionary:@{ @"id" : @"TestID", @"major" : @0, @"minor" : @0 }];

    // STARTING
    [self.target startAdvertising];
    
    BOOL isAdvertising = NO;
    NSDate *stopAt = [NSDate dateWithTimeIntervalSinceNow:5.0];
    while (!isAdvertising && [stopAt timeIntervalSinceNow] > 0)
    {
        NSDate *runFor = [NSDate dateWithTimeIntervalSinceNow:1.0];
        [[NSRunLoop currentRunLoop] runUntilDate:runFor];
        isAdvertising = [[PeripheralManager sharedInstance] isAdvertising];
    }
    
    XCTAssertTrue([[PeripheralManager sharedInstance] isAdvertising], @"Expected PeripheralManager to be Advertising");

    // STOPPING
    [self.target stopAdvertising];
    stopAt = [NSDate dateWithTimeIntervalSinceNow:5.0];
    while ([stopAt timeIntervalSinceNow] > 0)
    {
        NSDate *runFor = [NSDate dateWithTimeIntervalSinceNow:1.0];
        [[NSRunLoop currentRunLoop] runUntilDate:runFor];
    }
    
    XCTAssertFalse([[PeripheralManager sharedInstance] isAdvertising], @"Expected PeripheralManager to not be Advertising");
}

#if TARGET_IPHONE_SIMULATOR
- (void)testStartAdvertisingToSetAdvertisingData
{
    self.target.cat = [[Cat alloc] initWithDictionary:@{ @"id" : @"TestID", @"major" : @0, @"minor" : @0 }];
    
    CLBeaconRegion *region = self.target.cat.beaconRegion;
    NSDictionary *expected = [region peripheralDataWithMeasuredPower:nil];

    [self.target startAdvertising];
    
    NSDictionary *actual = [[PeripheralManager sharedInstance] simulatorAdvertismentData];
    
    XCTAssertEqualObjects(actual, expected, @"Expected CLPeripheralManager advertisingData to be set with CLBeaconRegion data");
}
#endif

@end
