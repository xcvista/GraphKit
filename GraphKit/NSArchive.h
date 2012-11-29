//
//  NSArchive.h
//  GraphFunhouse
//
//  Created by Maxthon Chan on 12-5-27.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSArchive <NSObject>

- (id)initFromArchive:(NSDictionary *)archive;
- (NSDictionary *)archive;

@end
