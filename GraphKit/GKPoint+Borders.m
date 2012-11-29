//
//  GKPoint+Borders.m
//  GraphFunhouse
//
//  Created by Maxthon Chan on 12-5-27.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import "GKPoint+Borders.h"

#import "GKGraph+BorderSearch.h"

@implementation GKPoint (Borders)

- (NSArray *)incomingBorders
{
    return [self.graph bordersToPoint:self];
}

- (NSArray *)outgoingBorders
{
    return [self.graph bordersFromPoint:self];
}

@end
