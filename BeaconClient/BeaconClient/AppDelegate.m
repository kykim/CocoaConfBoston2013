//
//  AppDelegate.m
//  BeaconClient
//
//  Created by Kevin Y. Kim on 10/22/13.
//  Copyright (c) 2013 AppOrchard, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "BeaconCat+Image.h"

@interface AppDelegate () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if (YES) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        self.locationManager.activityType = CLActivityTypeFitness;
        self.locationManager.delegate = self;
    }

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    if ([beaconRegion.identifier isEqualToString:BEACON_CATS_ID]) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        if(state == CLRegionStateInside) {
            notification.alertBody = @"I HAZ KITTEHS!";
        }
        else if(state == CLRegionStateOutside) {
            notification.alertBody = @"OH NOES! DEREZ NO KITTEHS!";
        }
        else {
            return;
        }
        
        // If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
        // If its not, iOS will display the notification to the user.
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

@end
