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

@interface GKPoint : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) GKGraph *graph;
@property (nonatomic, strong) id tag;

- (id)initWithName:(NSString *)name inGraph:(GKGraph *)graph;
- (NSArray *)incomingBorders;
- (NSArray *)outgoingBorders;

@end
