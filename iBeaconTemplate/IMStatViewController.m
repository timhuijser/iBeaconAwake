//
//  IMStatViewController.m
//  iBeaconTemplate
//
//  Created by Bravoure on 10/06/15.
//  Copyright (c) 2015 iBeaconModules.us. All rights reserved.
//

#import "IMStatViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface IMStatViewController ()

@end

@implementation IMStatViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.beacons count] > 0) {
        CLBeacon *beacon = (CLBeacon*)[self.beacons objectAtIndex:0];
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

@end
