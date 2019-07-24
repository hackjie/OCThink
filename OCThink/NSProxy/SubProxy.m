//
//  SubProxy.m
//  OCThink
//
//  Created by leoli on 2018/8/15.
//  Copyright © 2018 leoli. All rights reserved.
//

#import "SubProxy.h"

// 1. 模拟多继承
// 2. 解决 NSTimer 无法释放的问题
// 3. 实现两个或者多个不同对象的消息分发

@implementation SubProxy
{
    id _realObject;
}

- (instancetype)initWithTarget:(id)target
{
    _realObject = target;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    id target = [_realObject methodSignatureForSelector:invocation.selector];
    [invocation invokeWithTarget:target];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    NSMethodSignature *signature;
    signature = [_realObject methodSignatureForSelector:sel];
    return signature;
}

@end
