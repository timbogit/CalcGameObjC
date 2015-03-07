//
//  TSCEquation.h
//  CalcGame
//
//  Created by Tim Schmelmer on 3/7/15.
//  Copyright (c) 2015 Tim Schmelmer. All rights reserved.
//

#ifndef CalcGame_TSCEquation_h
#define CalcGame_TSCEquation_h
@interface TSCEquation : NSObject

@property (strong, nonatomic, readonly) NSNumber *result;
@property (strong, nonatomic, readonly) NSString *operator;
@property (strong, nonatomic, readonly) NSArray *operands;


@end

#endif
