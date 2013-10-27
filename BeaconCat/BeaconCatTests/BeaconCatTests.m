//
//  BeaconCatTests.m
//  BeaconCatTests
//
//  Created by Kevin Y. Kim on 10/22/13.
//  Copyright (c) 2013 AppOrchard, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BeaconCat.h"

@interface BeaconCatTests : XCTestCase
@property (nonatomic, strong) BeaconCat *target;
@property (nonatomic, strong) NSDictionary *cat_fixture;
@end

@implementation BeaconCatTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    NSString *catFixturePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"CatFixture" ofType:@"plist"];
    self.cat_fixture = [NSDictionary dictionaryWithContentsOfFile:catFixturePath];
    self.target = [[BeaconCat alloc] initWithDictionary:self.cat_fixture];
}

- (void)tearDown
{
    self.target = nil;
    self.cat_fixture = nil;
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testInitWithDictionarySetsId
{
    XCTAssertNotNil(self.target.id, @"Expected BeaconCat id to not be NIL");
}

- (void)testInitWithDictionarySetsMajorAndMinor
{
    XCTAssertNotNil(self.target.major, @"Expected BeaconCat major to not be NIL");
    XCTAssertNotNil(self.target.minor, @"Expected BeaconCat minor to not be NIL");
}

//- (void)testImageReturnsUIImage
//{
//    XCTAssertTrue([self.target.image isKindOfClass:[UIImage class]], @"Expected UIImage to be returned");
//}

- (void)testBeaconRegionReturnsCLBeaconRegion
{
    XCTAssertTrue([self.target.beaconRegion isKindOfClass:[CLBeaconRegion class]], @"Expected CLBeaconRegion to be returned");
}

- (void)testBeaconRegionHasCATSUUID
{
    NSUUID *expected = [[NSUUID alloc] initWithUUIDString:BEACON_CATS_UUID];
    NSUUID *actual = self.target.beaconRegion.proximityUUID;
    
    XCTAssertEqualObjects(actual, expected, "Expect CLBeaconRegion ProximityUUID to be %@", expected);
}

- (void)testBeaconRegionHasMajorAndMinor
{
    NSNumber *expectedMajor = [self.cat_fixture objectForKey:@"major"];
    NSNumber *expectedMinor = [self.cat_fixture objectForKey:@"minor"];
    
    NSNumber *actualMajor = self.target.beaconRegion.major;
    NSNumber *actualMinor = self.target.beaconRegion.minor;
    
    XCTAssertEqualObjects(actualMajor, expectedMajor, "Expect CLBeaconRegion Major to be %@", expectedMajor);
    XCTAssertEqualObjects(actualMinor, expectedMinor, "Expect CLBeaconRegion Minor to be %@", expectedMinor);
}

@end
