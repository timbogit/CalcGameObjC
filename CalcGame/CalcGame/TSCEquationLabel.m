//
//  TSCEquationLabel.m
//  CalcGame
//
//  Created by Tim Schmelmer on 3/7/15.
//  Copyright (c) 2015 Tim Schmelmer. All rights reserved.
//

#import "TSCEquationLabel.h"
#import "TSCEquation.h"

@implementation TSCEquationLabel

-(instancetype)initWithParentView:(UIView *)parent
                        equation:(TSCEquation *)equation {
    self = [super init];
    self.frame = [self frameWithParent:parent];
    self.font = [UIFont systemFontOfSize:30.f];
    self.text = equation.description;
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

#pragma mark - private helpers
-(CGRect)frameWithParent:(UIView *)parent {
    NSInteger margin = 20;
    CGRect frame = CGRectMake(margin,
                              3 * margin,
                              parent.frame.size.width - margin * 2,
                              40);
    return frame;
}


@end
