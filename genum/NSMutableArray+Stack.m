//
//  NSMutableArray+Stack.m
//  GraphFunhouse
//
//  Created by Maxthon Chan on 12-11-28.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)

- (id)push:(id)object
{
    [self addObject:object];
    return object;
}

- (id)pop
{
    id object = [self lastObject];
    [self removeLastObject];
    return object;
}

- (id)peek
{
    return [self lastObject];
}

- (id)dequeue
{
    id object = [self objectAtIndex:0];
    [self removeObjectAtIndex:0];
    return object;
}

@end
