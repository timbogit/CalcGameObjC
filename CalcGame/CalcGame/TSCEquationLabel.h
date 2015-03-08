//
//  TSCEquationLabel.h
//  CalcGame
//
//  Created by Tim Schmelmer on 3/7/15.
//  Copyright (c) 2015 Tim Schmelmer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSCEquation;

@interface TSCEquationLabel : UILabel

-(instancetype)initWithParentView:(UIView *)parent
                         equation:(TSCEquation *)equation;

@end
