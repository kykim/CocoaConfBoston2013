//
//  BeaconCat.h
//  BeaconCat
//
//  Created by Kevin Y. Kim on 10/22/13.
//  Copyright (c) 2013 AppOrchard, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define BEACON_CATS_UUID @"31FD3DD3-28D5-4DEA-BDB4-BDF020937E07"
#define BEACON_CATS_ID   @"org.kittyloft.beacons"

@interface BeaconCat : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSNumber *major;
@property (nonatomic, strong) NSNumber *minor;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *bio;

+ (NSArray *)catsFromContentsOfFile:(NSString *)aPath;
+ (CLBeaconRegion *)catRegion;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (CLBeaconRegion *)beaconRegion;

@end
