//
//  NSMutableArray+TSCShuffling.m
//  CalcGame
//
//  Created by Tim Schmelmer on 3/7/15.
//  Copyright (c) 2015 Tim Schmelmer. All rights reserved.
//

#import "NSMutableArray+TSCShufflingAndReversing.h"

@implementation NSMutableArray (TSCShufflingAndReversing)


- (void)tsc_shuffle {
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

- (void)tsc_reverse {
    if ([self count] <= 1)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end
