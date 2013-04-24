//
//  GKBorder.h
//  GraphFunhouse
//
//  Created by Maxthon Chan on 12-5-8.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import <GraphKit/GKCommon.h>

@class GKGraph;
@class GKPoint;

@interface GKBorder : NSObject <NSCoding>

@property GKPoint *from;
@property GKPoint *to;
@property GKGraph *graph;
@property GKPower power;
@property id tag;

- (id)initFormPoint:(GKPoint *)from toPoint:(GKPoint *)to withPower:(GKPower)power inGraph:(GKGraph *)graph;
- (id)initFromArchive:(NSDictionary *)archive inGraph:(GKGraph *)graph;

@end
