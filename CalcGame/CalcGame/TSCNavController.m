//
//  TSCNavController.m
//  CalcGame
//
//  Created by Tim Schmelmer on 3/10/15.
//  Copyright (c) 2015 Tim Schmelmer. All rights reserved.
//

#import "TSCNavController.h"

@interface TSCNavController ()

@end

@implementation TSCNavController


- (NSUInteger) supportedInterfaceOrientations {
    // On all devices, return portrait or portrait upside-down
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}


@end
