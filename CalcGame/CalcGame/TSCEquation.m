//
//  TSCEquation.m
//  CalcGame
//
//  Created by Tim Schmelmer on 3/7/15.
//  Copyright (c) 2015 Tim Schmelmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSCEquation.h"
#import "NSMutableArray+TSCShufflingAndReversing.h"

typedef NSInteger (^OperationBlock)(NSArray *);

static NSString *const EQUATION_ADDITION_OPERATOR = @"+";
static NSString *const EQUATION_SUBTRACTION_OPERATOR = @"-";
static NSString *const EQUATION_MULTIPLICATION_OPERATOR = @"*";
static NSString *const EQUATION_DIVISION_OPERATOR = @"/";
static OperationBlock const PLUS_OPERATION = ^(NSArray *operands){
    NSInteger op1 = [operands[0] integerValue],
              op2 = [operands[1] integerValue];
    return (op1 + op2);
};
static OperationBlock const MINUS_OPERATION = ^(NSArray *operands){
    NSInteger op1 = [operands[0] integerValue],
    op2 = [operands[1] integerValue];
    return (op1 - op2);
};
static OperationBlock const TIMES_OPERATION = ^(NSArray *operands){
    NSInteger op1 = [operands[0] integerValue],
    op2 = [operands[1] integerValue];
    return (op1 * op2);
};
static OperationBlock const DIVIDE_BY_OPERATION = ^(NSArray *operands){
    NSInteger op1 = [operands[0] integerValue],
    op2 = [operands[1] integerValue];
    return (op1 / op2);
};

@interface TSCEquation()

@property (strong, nonatomic, readwrite) NSString *result;
@property (strong, nonatomic, readwrite) NSString *operator;
@property (strong, nonatomic, readwrite) NSMutableArray *operands;

@end

@implementation TSCEquation

- (instancetype)initWithOperator:(NSString *)operator
                         operands:(NSArray *)operands
{
    self = [super init];
    if (self) {
        _operator = [operator copy];
        _operands = [operands mutableCopy];
        _result = [[self calculateResult] description];
        
    }
    return self;
}


- (instancetype)init
{
    return [self initWithOperator:(arc4random_uniform(100) % 2 == 0) ? EQUATION_SUBTRACTION_OPERATOR : EQUATION_ADDITION_OPERATOR
                  operands:@[@(arc4random_uniform(100)), @(arc4random_uniform(100))]];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@ = ?",
                                        self.operands[0],
                                        self.operator,
                                        self.operands[1]];
}

-(NSNumber *)resultAsNumber {
    return [NSNumber numberWithLong:[self.result integerValue]];
}


+ (OperationBlock)operationBlockForOperator:(NSString *)operator {
    static NSDictionary *opsToOperations;
    if (!opsToOperations) {
        opsToOperations =  @{EQUATION_ADDITION_OPERATOR : PLUS_OPERATION,
                             EQUATION_SUBTRACTION_OPERATOR : MINUS_OPERATION,
                             EQUATION_MULTIPLICATION_OPERATOR : TIMES_OPERATION,
                             EQUATION_DIVISION_OPERATOR : DIVIDE_BY_OPERATION};
    }
    return [opsToOperations objectForKey:operator];
}


-(NSNumber *)calculateResult {
    NSInteger result = [TSCEquation operationBlockForOperator: _operator](_operands);
    if (result < 0) {
        result = -result;
        [_operands tsc_reverse];
    }
    
    return [NSNumber numberWithLong:result];
}
@end