//
//  TSCSettingsViewController.m
//  CalcGame
//
//  Created by Tim Schmelmer on 3/10/15.
//  Copyright (c) 2015 Tim Schmelmer. All rights reserved.
//

#import "TSCSettingsViewController.h"
#import "TSCCalcGameViewController.h"

@interface TSCSettingsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end

@implementation TSCSettingsViewController


#pragma mark - UIViewController overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - Button callbacks

- (IBAction)resetButtonTapped:(UIButton *)sender {
    NSLog(@"Reset button pressed!");
    if(self.gameController) {
        [self.gameController resetScoresAndTries];
    }
}


@end
