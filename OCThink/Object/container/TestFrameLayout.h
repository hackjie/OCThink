//
//  FrameLayout.h
//  OCThink
//
//  Created by 李杰 on 2025/2/14.
//  Copyright © 2025 leoli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestFrameLayout : UIView
- (void)containerAddView:(UIView *)view;
- (void)setPadding:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom;
@end

NS_ASSUME_NONNULL_END
