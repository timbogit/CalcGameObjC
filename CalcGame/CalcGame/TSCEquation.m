//
//  TSCEquation.m
//  CalcGame
//
//  Created by Tim Schmelmer on 3/7/15.
//  Copyright (c) 2015 Tim Schmelmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSCEquation.h"


static NSString *const EQUATION_ADDITION_OPERATOR = @"+";
static NSString *const EQUATION_SUBTRACTION_OPERATOR = @"-";
static NSString *const EQUATION_MULTIPLICATION_OPERATOR = @"*";
static NSString *const EQUATION_DIVISION_OPERATOR = @"/";

@interface TSCEquation()

@property (strong, nonatomic, readwrite) NSNumber *result;
@property (strong, nonatomic, readwrite) NSString *operator;
@property (strong, nonatomic, readwrite) NSMutableArray *operands;

@end

@implementation TSCEquation

- (instancetype)initWithOperator:(NSString *)operator
                         operands:(NSArray *)operands
{
    self = [super init];
    if (self) {
        _result = @13;
        _operator = [operator copy];
        _operands = [operands mutableCopy];
        
    }
    return self;
}


- (instancetype)init
{
    return [self initWithOperator:EQUATION_ADDITION_OPERATOR
                  operands:@[@(arc4random_uniform(10)), @(arc4random_uniform(10))]];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@ = ?",
                                        self.operands[0],
                                        self.operator,
                                        self.operands[1]];
}

// TODO: add a result Accessor that calculates the result based on the operands / operator
@end