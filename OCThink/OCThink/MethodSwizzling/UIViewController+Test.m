//
//  UIViewController+Test.m
//  OCThink
//
//  Created by 李杰 on 2018/11/5.
//  Copyright © 2018年 leoli. All rights reserved.
//

#import "UIViewController+Test.h"
#import <objc/runtime.h>

// http://blog.leichunfeng.com/blog/2015/06/14/objective-c-method-swizzling-best-practice/
@implementation UIViewController (Test)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(lj_viewDidLoad);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

        if (success) {
            // 主类本身没有实现需要替换的方法，而是继承了父类的实现，即 class_addMethod 方法返回 YES 。这时使用 class_getInstanceMethod 函数获取到的 originalSelector 指向的就是父类的方法，我们再通过执行 class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod)); 将父类的实现替换到我们自定义的 mrc_viewWillAppear 方法中
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            // 主类本身实现需要替换的方法
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)lj_viewDidLoad
{
    [self lj_viewDidLoad];
    
    NSLog(@"swizzling succeed");
}

@end
