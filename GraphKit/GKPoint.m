//
//  GKPoint.m
//  GraphFunhouse
//
//  Created by Maxthon Chan on 12-5-26.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import "GKPoint.h"

#import "GKBorder.h"
#import "GKGraph.h"

@implementation GKPoint

@synthesize name = _name;
@synthesize graph = _graph;
@synthesize tag = _tag;

- (id)initWithName:(NSString *)name inGraph:(GKGraph *)graph
{
    if (self = [super init])
    {
        self.name = name;
        self.graph = graph;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]])
        return NO;
    return [[object name] isEqual:self.name];
}

- (NSString *)description
{
    return self.name;
}

- (NSArray *)incomingBorders
{
    return [self.graph bordersToPoint:self];
}

- (NSArray *)outgoingBorders
{
    return [self.graph bordersFromPoint:self];
}

@end
