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

@interface GKBorder : NSObject <NSArchive>

@property (nonatomic, strong) GKPoint *from;
@property (nonatomic, strong) GKPoint *to;
@property (nonatomic, strong) GKGraph *graph;
@property (nonatomic) GKPower power;
@property (nonatomic, strong) id tag;

- (id)initFormPoint:(GKPoint *)from toPoint:(GKPoint *)to withPower:(GKPower)power inGraph:(GKGraph *)graph;
- (id)initFromArchive:(NSDictionary *)archive inGraph:(GKGraph *)graph;

@end
