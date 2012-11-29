//
//  GKBorder.m
//  GraphFunhouse
//
//  Created by Maxthon Chan on 12-5-8.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import "GKBorder.h"

#import "GKGraph.h"
#import "GKPoint.h"

@implementation GKBorder

@synthesize from = _from;
@synthesize to = _to;
@synthesize graph = _graph;
@synthesize power = _power;
@synthesize tag = _tag;

- (id)initFormPoint:(GKPoint *)from toPoint:(GKPoint *)to withPower:(GKPower)power inGraph:(GKGraph *)graph
{
    if (self = [super init])
    {
        self.from = from;
        self.to = to;
        self.graph = graph;
        self.power = power;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]])
        return NO;
    return [[object from] isEqual:self.from] && [[object to] isEqual:self.to] && [object power] == self.power;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ -%lf-> %@%s", self.from, self.power, self.to, self.tag ? " *" : ""];
}

- (NSDictionary *)archive
{
    return [NSDictionary dictionaryWithObjectsAndKeys:self.from.name, @"from", self.to.name, @"to", [NSNumber numberWithDouble:self.power], @"power", nil];
}

- (id)initFromArchive:(NSDictionary *)archive inGraph:(GKGraph *)graph
{
    if (self = [self init])
    {
        self.graph = graph;
        self.power = [[archive objectForKey:@"power"] doubleValue];
        self.from = [graph pointWithName:[archive objectForKey:@"from"]];
        self.to = [graph pointWithName:[archive objectForKey:@"to"]];
    }
    return self;
}

- (id)initFromArchive:(NSDictionary *)archive
{
    return [self initFromArchive:archive inGraph:nil];
}

@end
