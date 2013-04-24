//
//  GKPoint.h
//  GraphFunhouse
//
//  Created by Maxthon Chan on 12-5-26.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GKGraph;
@class GKBorder;

@interface GKPoint : NSObject <NSCoding>

@property NSString *name;
@property GKGraph *graph;
@property id tag;

- (id)initWithName:(NSString *)name inGraph:(GKGraph *)graph;
- (NSArray *)incomingBorders;
- (NSArray *)outgoingBorders;

@end
