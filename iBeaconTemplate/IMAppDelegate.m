//
//  IMAppDelegate.m
//  iBeaconTemplate
//
//  Created by James Nick Sears on 5/29/14.
//  Copyright (c) 2014 iBeaconModules.us. All rights reserved.
//

#import "IMAppDelegate.h"
#import "IMViewController.h"
#import "IMStatViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

Boolean logged_in;
NSDate *previousSave = 0;

@implementation IMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    // Initialize Parse.
    [Parse setApplicationId:@"NrUWNfbs3IS5hp4EAPNbPf12VzFnXdR2TvO05Ei0"
                  clientKey:@"UfjnXje2aThNZ12QN8Hi59JX9osc9B432qmqn0Wj"];
    
    // Login with static User
    [PFUser logInWithUsernameInBackground:@"tim" password:@"awakenings"
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            logged_in = 1;
                                        } else {
                                            // The login failed. Check error to see why.
                                        }
                                    }];
    
    /*PFUser *user = [PFUser user];
    user.username = @"tim";
    user.password = @"awakenings";
    user.email = @"timhuijser@gmail.com";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
        } else {
        }
    }];
    */
    // Override point for customization after application launch.
    NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:@"FDA50693-A4E2-4FB1-AFCF-C6EB07647825"];
    NSString *regionIdentifier = @"us.iBeaconModules";
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID identifier:regionIdentifier];

    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Authorized Always");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"Authorized when in use");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"Not determined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
            
        default:
            break;
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [self.locationManager startUpdatingLocation];
    
    return YES;
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager startUpdatingLocation];
    
    NSLog(@"You entered the region.");
    [self sendLocalNotificationWithMessage:@"You entered the region."];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"You exited the region.");
    [self sendLocalNotificationWithMessage:@"You exited the region."];
}

-(void)startRanging {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)stopRanging {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

-(void)sendLocalNotificationWithMessage:(NSString*)message {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60];
    notification.alertBody = message;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    NSString *message = @"";
    int proximity_type;
    
    IMStatViewController *viewController = (IMStatViewController*)self.window.rootViewController;
    viewController.beacons = beacons;
    //[viewController.tableView reloadData];
    [viewController updateScore];
    
    
    if(beacons.count > 0) {
        
        CLBeacon *nearestBeacon = beacons.firstObject;
        if((nearestBeacon.proximity == self.lastProximity && nearestBeacon.minor.intValue == self.lastBeaconMinor) || nearestBeacon.proximity == CLProximityUnknown) {
            return;
        }
        self.lastProximity = nearestBeacon.proximity;
        
        switch(nearestBeacon.proximity) {
            case CLProximityFar:
                message = @"You are far away from the beacon";
                proximity_type = 3;
                break;
            case CLProximityNear:
                message = @"You are near the beacon";
                proximity_type = 2;
                break;
            case CLProximityImmediate:
                message = @"You are in the immediate proximity of the beacon";
                proximity_type = 1;
                break;
            case CLProximityUnknown:
                return;
        }
        
        if (logged_in == 1) {
            
            NSDate *now = [NSDate date];
            NSTimeInterval secondsBetweenPreviousSave = [now timeIntervalSinceDate:previousSave];
            
            if (secondsBetweenPreviousSave > 10 || previousSave == 0) {
             
                PFObject *proximityEntry = [PFObject objectWithClassName:@"proximityEntry"];
                proximityEntry[@"proximity"] = [NSNumber numberWithInt:proximity_type];
                proximityEntry[@"rssi"] = [NSNumber numberWithInt:nearestBeacon.rssi];
                proximityEntry[@"accuracy"] = [NSNumber numberWithFloat:nearestBeacon.accuracy];
                proximityEntry[@"major"] = [NSNumber numberWithInt:nearestBeacon.major.intValue];
                proximityEntry[@"minor"] = [NSNumber numberWithInt:nearestBeacon.minor.intValue];
                proximityEntry[@"uuid"] = nearestBeacon.proximityUUID.UUIDString;
                PFUser *user = [PFUser currentUser];
                [proximityEntry setObject:user forKey:@"User"];
                
                [proximityEntry saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        previousSave = now;
                        NSLog(@"Save successful");
                    } else {
                        // There was a problem, check error.description
                    }
                }];
                
            }
        }
        
    } else {
        message = @"No beacons are nearby";
    }
    
    NSLog(@"%@", message);
    //[self sendLocalNotificationWithMessage:message];
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

@end
