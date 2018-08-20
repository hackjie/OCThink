//
//  SubProxy.h
//  OCThink
//
//  Created by leoli on 2018/8/15.
//  Copyright © 2018 leoli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubProxy : NSProxy
// 代理别人来做什么
- (instancetype)initWithTarget:(id)target;
@end
