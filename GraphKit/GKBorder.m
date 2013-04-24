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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        NSArray *keys = @[@"from", @"to", @"power"];
        
        for (NSString *key in keys)
        {
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]])
        return NO;
    return [[object from] isEqual:self.from] && [[object to] isEqual:self.to] && [object power] == self.power;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *keys = @[@"from", @"to", @"power"];
    
    for (NSString *key in keys)
    {
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ -%lf-> %@%s", self.from, self.power, self.to, self.tag ? " *" : ""];
}

- (id)initFromArchive:(NSDictionary *)archive
{
    return [self initFromArchive:archive inGraph:nil];
}

@end
