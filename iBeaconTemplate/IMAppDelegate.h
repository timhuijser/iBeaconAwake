//
//  IMAppDelegate.h
//  iBeaconTemplate
//
//  Created by James Nick Sears on 5/29/14.
//  Copyright (c) 2014 iBeaconModules.us. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface IMAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property CLBeaconRegion *beaconRegion;
@property CLProximity lastProximity;
@property int lastBeaconMinor;

-(void)startRanging;
-(void)stopRanging;

@end
