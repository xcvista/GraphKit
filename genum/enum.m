//
//  enum.m
//  GraphFunhouse
//
//  Created by Maxthon Chan on 12-11-28.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import "enum.h"
#import "NSMutableArray+Stack.h"

void depthSearch(GKGraph *graph, GKPoint *point)
{
    NSMutableArray *stack = [NSMutableArray arrayWithCapacity:graph.points.count];
    [stack push:point];
    
    while (stack.count)
    {
        GKPoint *current = [stack pop];
        printf("Hit: %s\n", [current.name cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        current.tag = @{@"visited": @YES};
        NSArray *nexts = [graph bordersFromPoint:current];
        for (GKBorder *next in nexts)
        {
            GKPoint *nextp = next.to;
            if (!nextp.tag && ([stack indexOfObject:nextp] == NSNotFound))
                [stack push:nextp];
        }
    }
}

void widthSearch(GKGraph *graph, GKPoint *point)
{
    NSMutableArray *stack = [NSMutableArray arrayWithCapacity:graph.points.count];
    [stack push:point];
    
    while (stack.count)
    {
        GKPoint *current = [stack dequeue];
        printf("Hit: %s\n", [current.name cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        current.tag = @{@"visited": @YES};
        NSArray *nexts = [graph bordersFromPoint:current];
        for (GKBorder *next in nexts)
        {
            GKPoint *nextp = next.to;
            if (!nextp.tag && ([stack indexOfObject:nextp] == NSNotFound))
                [stack push:nextp];
        }
    }
}
