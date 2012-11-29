//
//  NSMutableArray+Stack.h
//  GraphFunhouse
//
//  Created by Maxthon Chan on 12-11-28.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)

- (id)push:(id)object;
- (id)pop;
- (id)peek;
- (id)dequeue;

@end
