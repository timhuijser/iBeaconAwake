//
//  IMStatViewController.h
//  iBeaconTemplate
//
//  Created by Bravoure on 10/06/15.
//  Copyright (c) 2015 iBeaconModules.us. All rights reserved.
//

#import "IMViewController.h"
#import <UIKit/UIKit.h>

@interface IMStatViewController : UIViewController

- (IBAction)startRangingButton:(id)sender;
- (IBAction)stopRangingButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;
@property (weak, nonatomic) IBOutlet UILabel *beaconMinorLabel;

@property (weak, nonatomic) IBOutlet UILabel *iBeacon1ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *iBeacon2ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *iBeacon3ValueLabel;

@property (strong) NSArray *beacons;

@property int scoreStage1;
@property int scoreStage2;
@property int scoreStage3;

- (void)updateScore;

@end
