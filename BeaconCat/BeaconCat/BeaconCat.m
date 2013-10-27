//
//  BeaconCat.m
//  BeaconCat
//
//  Created by Kevin Y. Kim on 10/22/13.
//  Copyright (c) 2013 AppOrchard, LLC. All rights reserved.
//

#import "BeaconCat.h"

@implementation BeaconCat

+ (NSArray *)catsFromContentsOfFile:(NSString *)aPath
{
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:aPath];
    NSMutableArray *catRecords = [NSMutableArray array];
    for (NSDictionary *record in plistArray) {
        [catRecords addObject:[[BeaconCat alloc] initWithDictionary:record]];
    }
    return catRecords;
}

+ (CLBeaconRegion *)catRegion
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:BEACON_CATS_UUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:BEACON_CATS_ID];
    return region;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id = [dictionary objectForKey:@"id"];
        self.major = [dictionary objectForKey:@"major"];
        self.minor = [dictionary objectForKey:@"minor"];
        self.name = [dictionary objectForKey:@"name"];
        self.bio = [dictionary objectForKey:@"bio"];
    }
    return self;
}

- (CLBeaconRegion *)beaconRegion
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:BEACON_CATS_UUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[self.major shortValue] minor:[self.minor shortValue] identifier:BEACON_CATS_ID];
    return region;
}

@end
