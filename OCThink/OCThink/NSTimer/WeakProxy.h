//
//  WeakProxy.h
//  OCThink
//
//  Created by leoli on 2018/8/20.
//  Copyright © 2018 leoli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakProxy : NSProxy

// the proxy target
@property (nullable, nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithTarget:(id)target;

@end
