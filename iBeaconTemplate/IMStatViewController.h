//
//  IMStatViewController.h
//  iBeaconTemplate
//
//  Created by Bravoure on 10/06/15.
//  Copyright (c) 2015 iBeaconModules.us. All rights reserved.
//

#import "IMViewController.h"
#import <UIKit/UIKit.h>

@interface IMStatViewController : IMViewController

@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;
@property (strong) NSArray *beacons;

@end
