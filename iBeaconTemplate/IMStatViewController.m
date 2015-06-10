//
//  IMStatViewController.m
//  iBeaconTemplate
//
//  Created by Bravoure on 10/06/15.
//  Copyright (c) 2015 iBeaconModules.us. All rights reserved.
//

#import "IMStatViewController.h"
#import "IMAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface IMStatViewController ()

@end

@implementation IMStatViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scoreStage1 = 0;
    self.scoreStage2 = 0;
    self.scoreStage3 = 0;
    
    [self updateScore];
    
}

- (void)updateScore {
 
    if ([self.beacons count] > 0) {
        
        CLBeacon *beacon = (CLBeacon*)[self.beacons objectAtIndex:0];
        
        self.beaconMinorLabel.text = [NSString stringWithFormat:@"%d", beacon.minor.intValue];
        
        switch (beacon.minor.intValue) {
            case 1:
                self.scoreStage1++;
                self.iBeacon1ValueLabel.text = [NSString stringWithFormat:@"%d", self.scoreStage1];
                break;
            case 2:
                self.scoreStage2++;
                self.iBeacon2ValueLabel.text = [NSString stringWithFormat:@"%d", self.scoreStage2];
                break;
            case 3:
                self.scoreStage3++;
                self.iBeacon3ValueLabel.text = [NSString stringWithFormat:@"%d", self.scoreStage3];
                break;
        }
        
        switch (beacon.proximity) {
            case CLProximityFar:
                self.proximityLabel.text = @"Far";
                break;
            case CLProximityNear:
                self.proximityLabel.text = @"Near";
                break;
            case CLProximityImmediate:
                self.proximityLabel.text = @"Immediate";
                break;
            case CLProximityUnknown:
                self.proximityLabel.text = @"Unknown";
                break;
        }
        
    } else {
        self.proximityLabel.text = @"No iBeacon";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startRangingButton:(id)sender {
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(startRanging)];
}

- (IBAction)stopRangingButton:(id)sender {
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(stopRanging)];
}
@end
