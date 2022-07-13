//
//  OCTools.m
//  OCThink
//
//  Created by 李杰 on 2022/7/13.
//  Copyright © 2022 leoli. All rights reserved.
//

#import "OCTools.h"

@implementation OCTools
- (CGFloat)getWindowSafeAreaTop {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.top;
    }
    return 0.0;
}

- (CGFloat)getWindowSafeAreaBottom {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    }
    return 0.0;
}

@end
