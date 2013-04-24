//
//  GKGraph.h
//  GraphFunhouse
//
//  Created by Maxthon Chan on 12-5-26.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import <GraphKit/GKCommon.h>

@class GKBorder;
@class GKPoint;

@interface GKGraph : NSObject <NSCoding>

@property NSSet *borders;
@property NSSet *points;
@property id tag;

- (void)connectPoint:(GKPoint *)point1 withPoint:(GKPoint *)point2;
- (void)connectPoint:(GKPoint *)point1 withPoint:(GKPoint *)point2 withPower:(GKPower)power;

- (void)connectFromPoint:(GKPoint *)point1 toPoint:(GKPoint *)point2;
- (void)connectFromPoint:(GKPoint *)point1 toPoint:(GKPoint *)point2 withPower:(GKPower)power;

- (GKPoint *)pointWithName:(NSString *)name;

- (NSArray *)bordersToPoint:(GKPoint *)point;
- (NSArray *)bordersFromPoint:(GKPoint *)point;
- (GKBorder *)borderFromPoint:(GKPoint *)point1 toPoint:(GKPoint *)point2;
- (NSArray *)bordersFromPoint:(GKPoint *)point1 toPoint:(GKPoint *)point2;
- (NSArray *)shortestPathFromPoint:(GKPoint *)point1 toPoint:(GKPoint *)point2;

@end
