//
//  CatViewController.m
//  BeaconClient
//
//  Created by Kevin Y. Kim on 10/22/13.
//  Copyright (c) 2013 AppOrchard, LLC. All rights reserved.
//

#import "CatViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BeaconCat+Image.h"

@interface CatViewController () <CLLocationManagerDelegate> {
    BOOL __MONITORING;
    BOOL __RANGING;
}

@property (nonatomic, strong) NSArray *cats;
@property (nonatomic, strong) BeaconCat *cat;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLProximity currentProximity;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UITextView *bio;

- (void)setupView;
- (void)setupCats;
- (void)setupLocationManager;
- (void)setupRanging;
- (void)setupMonitoring;

- (void)setCatForMajor:(NSNumber *)major andMinor:(NSNumber *)minor;
- (void)configureCatView;
- (void)configureNoCatView;
- (void)logProximity:(NSString *)proximity forBeacon:(CLBeacon *)beacon;
@end

@implementation CatViewController

- (void)MONITOR_RANGING
{
    __MONITORING = NO;
    __RANGING    = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self MONITOR_RANGING];
    
    [self setupView];
    [self setupCats];
    [self setupLocationManager];
    self.currentProximity = CLProximityUnknown;
    
    if (__MONITORING) [self setupMonitoring];
    if (__RANGING)    [self setupRanging];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self configureNoCatView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (__MONITORING) {
        for (CLRegion *region in [self.locationManager monitoredRegions])
            [self.locationManager stopMonitoringForRegion:region];
    }

    if (__RANGING) {
        for (CLBeaconRegion *region in [self.locationManager rangedRegions])
            [self.locationManager stopRangingBeaconsInRegion:region];
    }
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"Failure: %@ - %@ %@", [error localizedDescription], region, error);
    [self configureNoCatView];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // CoreLocation will call this delegate method at 1 Hz with updated range information.
    // Beacons will be categorized and displayed by proximity.
    for (CLBeacon *beacon in beacons) {
        if (beacon.proximity != _currentProximity) {
            _currentProximity = beacon.proximity;
            switch (_currentProximity) {
                case CLProximityUnknown:
                    [self logProximity:@"Unknown" forBeacon:beacon];
                    break;
                case CLProximityImmediate:
                    [self logProximity:@"Immediate" forBeacon:beacon];
                    if (__RANGING) [self setCatForMajor:beacon.major andMinor:beacon.minor];
                    break;
                case CLProximityNear:
                    [self logProximity:@"Near" forBeacon:beacon];
                    break;
                case CLProximityFar:
                    [self logProximity:@"Near" forBeacon:beacon];
                    break;
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if (__MONITORING) {
        NSLog(@"Entered: %@", region);
        CLBeaconRegion *beacon = (CLBeaconRegion *)region;
        if (beacon.major && beacon.minor) {
            [self setCatForMajor:beacon.major andMinor:beacon.minor];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if (__MONITORING) {
        NSLog(@"Exited: %@", region);
    }
}

#pragma mark - Private Instance Methods

- (void)setupView
{
    UIView *view = self.view;
    UIScrollView *scrollView  = [[UIScrollView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] init];
    UILabel *nameLabel = [[UILabel alloc] init];
    UITextView *bioView = [[UITextView alloc] init];
    
    // Add the scroll view to our view.
    [self.view addSubview:scrollView];
    
    // Add the image view to the scroll view.
    [scrollView addSubview:imageView];
    [scrollView addSubview:nameLabel];
    [scrollView addSubview:bioView];
    
    // Set the translatesAutoresizingMaskIntoConstraints to NO so that the views autoresizing mask is not translated into auto layout constraints.
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    bioView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(view, scrollView, imageView, nameLabel, bioView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[imageView(<=320)]-[nameLabel(<=44)]-[bioView]-64-|" options:0 metrics:nil views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView(==view)]|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView(==view)]|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[nameLabel]-|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[bioView]-|" options:0 metrics:nil views:viewsDictionary]];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    nameLabel.font = [UIFont boldSystemFontOfSize:32.0f];
    nameLabel.textAlignment = NSTextAlignmentCenter;

    bioView.font = [UIFont systemFontOfSize:18.0f];
    bioView.textAlignment = NSTextAlignmentLeft;
    bioView.scrollEnabled = NO;
    
    self.imageView = imageView;
    self.name = nameLabel;
    self.bio = bioView;
}

- (void)setupCats
{
    NSString *catsPlist = [[NSBundle mainBundle] pathForResource:@"Cats" ofType:@"plist"];
    self.cats = [BeaconCat catsFromContentsOfFile:catsPlist];
}

- (void)setupLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self;
}

- (void)setupRanging
{
    CLBeaconRegion *catRegion = [BeaconCat catRegion];
    if (catRegion) {
        catRegion.notifyOnEntry = NO;
        catRegion.notifyOnExit = NO;
        catRegion.notifyEntryStateOnDisplay = NO;
        [self.locationManager startRangingBeaconsInRegion:catRegion];
    }
}

- (void)setupMonitoring
{
    // MAXIMUM REGIONS TO MONITOR IS ~20....
    for (BeaconCat *cat in self.cats) {
        CLBeaconRegion *catRegion = [cat beaconRegion];
        if (catRegion) {
            catRegion.notifyOnEntry = YES;
            catRegion.notifyOnExit = YES;
            catRegion.notifyEntryStateOnDisplay = NO;
            [self.locationManager startMonitoringForRegion:catRegion];
        }
    }
}

- (void)setCatForMajor:(NSNumber *)major andMinor:(NSNumber *)minor
{
    if (self.cat && [self.cat.major isEqualToNumber:major] && [self.cat.minor isEqualToNumber:minor]) {
        return;
    }
    
    NSUInteger index = [self.cats indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        BeaconCat *cat = (BeaconCat *)obj;
        if ([major isEqualToNumber:cat.major] && [minor isEqualToNumber:cat.minor]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    if (index != NSNotFound) {
        self.cat = self.cats[index];
        [self configureCatView];
    }
}

- (void)configureCatView
{
    self.imageView.image = self.cat.image;
    self.name.text = self.cat.name;
    self.bio.text = self.cat.bio;
    self.bio.textAlignment = NSTextAlignmentLeft;
    
    [self.bio sizeToFit];
    [self.view updateConstraintsIfNeeded];
}

- (void)configureNoCatView
{
    NSString *defaultImagePath = [[NSBundle mainBundle] pathForResource:@"ohnoes" ofType:@"jpg"];
    self.imageView.image = [UIImage imageWithContentsOfFile:defaultImagePath];
    self.name.text = @"OH NOES!";
    self.bio.text = @"DEREZ NO KITTEH!";
    self.bio.textAlignment = NSTextAlignmentCenter;
}

- (void)logProximity:(NSString *)proximity forBeacon:(CLBeacon *)beacon
{
    NSLog(@"Proximity %@ - Major: %@, Minor: %@, Acc: %.2fm", proximity, beacon.major, beacon.minor, beacon.accuracy);
}

@end
