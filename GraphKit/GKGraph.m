//
//  GKGraph.m
//  GraphFunhouse
//
//  Created by Maxthon Chan on 12-5-26.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import "GKGraph.h"

#import "GKBorder.h"
#import "GKPoint.h"
#import "GKGraph.h"

static BOOL verbose_path;

@interface GKGraph ()

@property (nonatomic, strong) NSMutableDictionary *pointsInternal;

@end

@implementation GKGraph

@synthesize borders = _borders;
@synthesize pointsInternal = _pointsInternal;
@synthesize tag = _tag;
@dynamic points;

- (id)init
{
    if (self = [super init])
    {
        self.borders = [NSSet set];
        self.pointsInternal = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSSet *)points
{
    @synchronized (_pointsInternal)
    {
        return [NSSet setWithArray:self.pointsInternal.allValues];
    }
}

- (void)setPoints:(NSSet *)points
{
    @synchronized (_pointsInternal)
    {
        NSMutableDictionary *destdict = [NSMutableDictionary dictionaryWithCapacity:points.count];
        for (GKPoint *obj in points)
        {
            obj.graph = self;
            [destdict setValue:obj forKey:obj.name];
        }
        self.pointsInternal = destdict;
    }
}

- (GKPoint *)pointWithName:(NSString *)name
{
    GKPoint *point = [self.pointsInternal objectForKey:name];
    if (!point)
    {
        point = [[GKPoint alloc] initWithName:name inGraph:self];
        [self.pointsInternal setValue:point forKey:name];
    }
    return point;
}

- (void)connectPoint:(GKPoint *)point1 withPoint:(GKPoint *)point2
{
    [self connectFromPoint:point1 toPoint:point2];
    [self connectFromPoint:point2 toPoint:point1];
}

- (void)connectPoint:(GKPoint *)point1 withPoint:(GKPoint *)point2 withPower:(GKPower)power
{
    [self connectFromPoint:point1 toPoint:point2 withPower:power];
    [self connectFromPoint:point2 toPoint:point1 withPower:power];
}

- (void)connectFromPoint:(GKPoint *)point1 toPoint:(GKPoint *)point2
{
    [self connectFromPoint:point1 toPoint:point2 withPower:1.0];
}

- (void)connectFromPoint:(GKPoint *)point1 toPoint:(GKPoint *)point2 withPower:(GKPower)power
{
    
    GKBorder *border = [[GKBorder alloc] initFormPoint:point1 toPoint:point2 withPower:power inGraph:self];
    self.borders = [self.borders setByAddingObject:border];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        NSArray *borders = [aDecoder decodeObjectForKey:@"borders"];
        NSArray *points = [aDecoder decodeObjectForKey:@"points"];
        
        for (NSArray *arr in @[borders, points])
            for (id obj in arr)
                if ([obj respondsToSelector:@selector(setGraph:)])
                    [obj setGraph:self];
        
        self.borders = [NSSet setWithArray:borders];
        self.points = [NSSet setWithArray:points];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self.borders allObjects] forKey:@"borders"];
    [aCoder encodeObject:[self.points allObjects] forKey:@"points"];
}

- (NSArray *)bordersToPoint:(GKPoint *)point
{
    NSMutableArray *borders = [NSMutableArray arrayWithCapacity:self.borders.count];
    for (GKBorder *border in self.borders)
        if ([border.to isEqual:point])
            [borders addObject:border];
    return borders.copy;
}

- (NSArray *)bordersFromPoint:(GKPoint *)point
{
    NSMutableArray *borders = [NSMutableArray arrayWithCapacity:self.borders.count];
    for (GKBorder *border in self.borders)
        if ([border.from isEqual:point])
            [borders addObject:border];
    return borders.copy;
}

- (GKBorder *)borderFromPoint:(GKPoint *)point1 toPoint:(GKPoint *)point2
{
    GKBorder *border = nil;
    for (GKBorder *obj in self.borders)
        if ([obj.from isEqual:point1] && [obj.to isEqual:point2])
        {
            border = obj;
            break;
        }
    return border;
}

- (NSArray *)bordersFromPoint:(GKPoint *)point1 toPoint:(GKPoint *)point2
{
    NSMutableArray *output = [NSMutableArray arrayWithCapacity:self.borders.count];
    for (GKBorder *obj in self.borders)
        if ([obj.from isEqual:point1] && [obj.to isEqual:point2])
        {
            [output addObject:obj];
        }
    return output.copy;
}

- (NSArray *)shortestPathFromPoint:(GKPoint *)point1 toPoint:(GKPoint *)point2
{
    if ([point1 isEqual:point2])
    {
        return [NSArray array];
    }
    
    //Initialize the points, paint the 1st point (tag.visited = YES)
    for (GKPoint *p in self.points)
    {
        if ([p isEqual:point1])
        {
            p.tag = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:0], @"distance", [NSNumber numberWithBool:YES], @"visited", nil];
        }
        else
        {
            p.tag = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1e10], @"distance", [NSNumber numberWithBool:NO], @"visited", nil];
        }
    }
    for (GKBorder *b in self.borders)
    {
        b.tag = nil;
    }
    
    //Go until visit the last point
    GKPoint *current = point1;
    
    while (![current isEqual:point2])
    {
        BOOL no_path = YES;
        GKPoint *min_point;
        GKPower min_power = 1e10;
        GKBorder *min_border;
        
        for (GKPoint *p in self.points)
        {
            if (![[p.tag objectForKey:@"visited"] boolValue])
            {
                NSArray *connections = [self bordersFromPoint:current toPoint:p];
                GKBorder *connection = nil;
                if (connections.count)
                {
                    connection = connections.lastObject;
                    for (GKBorder *b in connections)
                    {
                        if (b.power < connection.power)
                            connection = b;
                    }
                }
                GKPower dist = MIN([[p.tag objectForKey:@"distance"] doubleValue], connection ? connection.power + [[current.tag objectForKey:@"distance"] doubleValue] : 1e10);
                
                if (min_power > dist)
                {
                    min_power = dist;
                    min_point = p;
                    min_border = connection;
                }
                
                if (dist != [[p.tag objectForKey:@"distance"] doubleValue]) {
                    [p.tag setObject:[NSNumber numberWithDouble:dist] forKey:@"distance"];
                    [p.tag setObject:connection forKey:@"source"];
                }
                if (dist < 1e10)
                {
                    no_path = NO;
                }
            }
        }
        
        if (no_path) //blocked
        {
            //Clean up
            for (GKPoint *p in self.points)
            {
                p.tag = nil;
            }
            for (GKBorder *b in self.borders)
            {
                b.tag = nil;
            }
            
            return nil;
        }
        
        if (verbose_path)
        {
            fprintf(stderr, "Nearest: %s", [min_point.name cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        }
        
        [(GKBorder *)[min_point.tag objectForKey:@"source"] setTag:[NSNumber numberWithBool:YES]];
        [min_point.tag setObject:[NSNumber numberWithBool:YES] forKey:@"visited"];
        current = min_point;
    }
    
    //Backtrace to the head - the output array is an array of borders leading to the end
    NSArray *output = [NSArray array];
    current = point2;
    do
    {
        NSArray *inb = [self bordersToPoint:current];
        for (GKBorder *b in inb)
        {
            if (verbose_path)
            {
                fprintf(stderr, "Border: %s%s\n", [b.description cStringUsingEncoding:[NSString defaultCStringEncoding]], b.tag ? "*" : "");
            }
            if ([b.tag boolValue])
            {
                output = [[NSArray arrayWithObject:b] arrayByAddingObjectsFromArray:output],
                current = b.from;
                break;
            }
        }
    }
    while (![current isEqual:point1]);
    
    //Clean up
    for (GKPoint *p in self.points)
    {
        p.tag = nil;
    }
    for (GKBorder *b in self.borders)
    {
        b.tag = nil;
    }
    
    return output;
}

@end
