//
//  MsgViewController.m
//  OCThink
//
//  Created by leoli on 2018/8/20.
//  Copyright © 2018 leoli. All rights reserved.
//

#import "MsgViewController.h"
#import <objc/runtime.h>

#import "YingDuan.h"

// 用来验证消息发送、转发的整个过程
@interface MsgViewController ()

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self performSelector:@selector(catEat)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)catName:(NSString *)name
{
    return @"buou";
}

#pragma 消息发送


#pragma Method resolution
// 给机会动态添加方法
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(catEat)) {
        SEL proxySEL = @selector(dynamicAdd_catEat);
        // SEL proxySEL2 = NSSelectorFromString(@"dynamicAdd_catEat");
        // SEL proxySEL3 = sel_registerName(@"dynamicAdd_catEat");

        IMP proxyIMP = class_getMethodImplementation([self class], proxySEL);

        Method *proxyMethod = class_getInstanceMethod([self class], proxySEL);

        // 返回值和参数类型
        const char *proxyType = method_getTypeEncoding(proxyMethod);

        SEL originSEL = @selector(catEat);

        class_addMethod([self class], originSEL, proxyIMP, proxyType);
    }
    // 返回是 YES 还是 NO 无所谓，重要的是添加方法成功了
    return YES;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    // 尚未实现的是类方法，会首先调用
    return YES;
}

- (void)dynamicAdd_catEat
{
    NSLog(@"haha----dynamicAdd_catEat");
}

#pragma 消息转发
#pragma first -- Fast forward
// 转发给另一个对象处理
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    YingDuan *yingduan = [[YingDuan alloc] init];

    if ([yingduan respondsToSelector:@selector(catEat)]) {
        // 整个消息发送过程会被重启
        return yingduan;
    }
    // 不能进入转发流程
    return nil;
}

#pragma second -- Normal forward
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [NSMethodSignature methodSignatureForSelector:aSelector];
    
    if (signature == nil) {
        if ([YingDuan instancesRespondToSelector:aSelector]) {
            signature = [YingDuan instanceMethodSignatureForSelector:aSelector];
            return signature;
        }
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([YingDuan instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:[[YingDuan alloc] init]];
    }
}

#pragma 查找、动态添加方法、直接转发(快)、正常转发(慢)都失败
- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"没有这个方法");
}

@end

