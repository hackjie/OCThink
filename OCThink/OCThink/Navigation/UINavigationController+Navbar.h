//
//  UINavigationController+Navbar.h
//  OCThink
//
//  Created by 李杰 on 2018/11/12.
//  Copyright © 2018年 leoli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Navbar)

/// A view controller is able to control navigation bar's appearance by itself,
/// rather than a global way, checking "lj_prefersNavigationBarHidden" property.
/// Default to YES, disable it if you don't want so.
@property (nonatomic, assign) BOOL lj_viewControllerBasedNavigationBarAppearanceEnabled;

@end

@interface UIViewController (LJNavbarPublic)

/// Indicate this view controller prefers its navigation bar hidden or not,
/// checked when view controller based navigation bar's appearance is enabled.
/// Default to NO, bars are more likely to show.
@property (nonatomic, assign) BOOL lj_prefersNavigationBarHidden;

@end
