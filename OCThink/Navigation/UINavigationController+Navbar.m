//
//  UINavigationController+Navbar.m
//  OCThink
//
//  Created by 李杰 on 2018/11/12.
//  Copyright © 2018年 leoli. All rights reserved.
//

#import "UINavigationController+Navbar.h"
#import <objc/runtime.h>

typedef void(^_LJViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (LJNavbarPrivate)
@property (nonatomic, copy) _LJViewControllerWillAppearInjectBlock lj_willAppearInjectBlock;
@end

@implementation UIViewController (LJNavbarPrivate)
//+ (void)load
//{
//    Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
//    Method swizzledMethod = class_getInstanceMethod(self, @selector(lj_viewWillAppear:));
//    method_exchangeImplementations(originalMethod, swizzledMethod);
//}

- (void)lj_viewWillAppear:(BOOL)animated
{
    [self lj_viewWillAppear:animated];
    
    if (self.lj_willAppearInjectBlock) {
        self.lj_willAppearInjectBlock(self, animated);
    }
}

- (_LJViewControllerWillAppearInjectBlock)lj_willAppearInjectBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLj_willAppearInjectBlock:(_LJViewControllerWillAppearInjectBlock)block
{
    objc_setAssociatedObject(self, @selector(lj_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end

@implementation UIViewController (LJNavbarPublic)
- (BOOL)lj_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLj_prefersNavigationBarHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, @selector(lj_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation UINavigationController (Navbar)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // Inject "-pushViewController:animated:"
        SEL originalPushSelector = @selector(pushViewController:animated:);
        SEL swizzledPushSelector = @selector(lj_pushViewController:animated:);
        
        Method originalPushMethod = class_getInstanceMethod(class, originalPushSelector);
        Method swizzledPushMethod = class_getInstanceMethod(class, swizzledPushSelector);
        
        BOOL pushAddSuccess = class_addMethod(class, originalPushSelector, method_getImplementation(swizzledPushMethod), method_getTypeEncoding(swizzledPushMethod));
        if (pushAddSuccess) {
            class_replaceMethod(class, originalPushSelector, method_getImplementation(originalPushMethod), method_getTypeEncoding(originalPushMethod));
        } else {
            method_exchangeImplementations(originalPushMethod, swizzledPushMethod);
        }
        
        // Inject "-setViewControllers:animated:"
        SEL originalSetSelector = @selector(setViewControllers:animated:);
        SEL swizzledSetSelector = @selector(lj_setViewControllers:animated:);
        
        Method originalSetMethod = class_getInstanceMethod(self, originalSetSelector);
        Method swizzledSetMethod = class_getInstanceMethod(self, swizzledSetSelector);
        
        BOOL setAddSuccess = class_addMethod(class, originalSetSelector, method_getImplementation(swizzledSetMethod), method_getTypeEncoding(swizzledSetMethod));
        if (setAddSuccess) {
            class_replaceMethod(class, swizzledSetSelector, method_getImplementation(originalSetMethod), method_getTypeEncoding(originalSetMethod));
        } else {
            method_exchangeImplementations(originalSetMethod, swizzledSetMethod);
        }
    });
}

- (void)lj_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // Handle perferred navigation bar appearance.
    [self lj_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    
    // Forward to primary implementation.
    [self lj_pushViewController:viewController animated:animated];
}

- (void)lj_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
    // Handle perferred navigation bar appearance.
    for (UIViewController *viewController in viewControllers) {
        [self lj_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    }
    
    // Forward to primary implementation.
    [self lj_setViewControllers:viewControllers animated:animated];
}

- (void)lj_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    if (!self.lj_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _LJViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.lj_prefersNavigationBarHidden animated:animated];
        }
    };
    
    // Setup will appear inject block to appearing view controller.
    // Setup disappearing view controller as well, because not every view controller is added into
    // stack by pushing, maybe by "-setViewControllers:".
    appearingViewController.lj_willAppearInjectBlock = block;
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.lj_willAppearInjectBlock) {
        disappearingViewController.lj_willAppearInjectBlock = block;
    }
}

- (BOOL)lj_viewControllerBasedNavigationBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.lj_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setLj_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enabled
{
    SEL key = @selector(lj_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


