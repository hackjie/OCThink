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
// http://nshipster.com/method-swizzling/
// https://www.mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html
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
        
        // 1. 判断给当前类（而不是父类）添加方法是否成功
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

        if (success) {
            // 2. 如果第一步成功了，说明当前类里面没有对应方法的实现，如果这个时候直接调用 method_exchangeImplementations 会将
            // 当前类的父类里面的对应方法替换了，这不是我们想要的，我们只是想要替换当前类的方法实现
            
            // 主类本身没有实现需要替换的方法，而是继承了父类的实现，即 class_addMethod 方法返回 YES 。这时使用 class_getInstanceMethod 函数获取到的 originalSelector 指向的就是父类的方法，我们再通过执行 class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod)); 将父类的实现替换到我们自定义的方法中
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
    
//    NSLog(@"swizzling succeed");
}

@end
