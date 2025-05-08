//
//  FrameLayout.m
//  OCThink
//
//  Created by 李杰 on 2025/2/14.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "TestFrameLayout.h"
#import <Masonry/Masonry.h>
#import "ContainerEnum.h"
#import "UIView+Constraints.h"
#import "TestLinearLayout.h"
#import "TestLinearLayout.h"

@interface TestFrameLayout()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) MASConstraint *bottomConstraint;
@end

@implementation TestFrameLayout
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [UIView new];
        [self addSubview:_contentView];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)containerAddView:(UIView *)view {
    CGFloat cWidth = view.frame.size.width;
    CGFloat cHeight = view.frame.size.height;
    CGFloat cLeft = view.frame.origin.x;
    CGFloat cTop = view.frame.origin.y;
    
    CGFloat containerWidth = self.frame.size.width;
    CGFloat containerHeight = self.frame.size.height;
    
    [_contentView addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        view.leftConstraint = make.left.equalTo(_contentView).offset(cLeft);
        view.topConstraint = make.top.equalTo(_contentView).offset(cTop);
        view.rightConstraint = make.right.lessThanOrEqualTo(_contentView);
        view.bottomConstraint = make.bottom.lessThanOrEqualTo(_contentView);
        if (cWidth == Match_Parent) {
            view.rightConstraint = make.right.equalTo(_contentView);
        } else if (cWidth == Wrap_Content) {
            if (![TestFrameLayout viewIsContainer:view]) {
                view.rightConstraint = make.right.lessThanOrEqualTo(_contentView);
            }
        } else {
            view.widthConstraint = make.width.mas_equalTo(cWidth);
        }
        
        if (containerWidth == Wrap_Content) {}
        
        // 高度
        if (cHeight == Match_Parent) {
            view.bottomConstraint = make.bottom.equalTo(_contentView);
        } else if (cHeight == Wrap_Content) {
            
        } else {
            view.heightConstraint = make.height.mas_equalTo(cHeight);
        }
        if (containerHeight == Wrap_Content) {
            if (view.tag == 1000) {
                view.bottomConstraint = make.bottom.equalTo(_contentView);
            }
        }
    }];
    
    if ([TestFrameLayout viewIsContainer:view]) {
//        for (UIView *item in view.subviews) {
//            [item layoutIfNeeded];
//        }
        [view layoutIfNeeded];
    }
}

+ (BOOL)viewIsContainer:(UIView *)view {
    if ([view isKindOfClass:[TestFrameLayout class]] || [view isKindOfClass:[TestLinearLayout class]]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setPadding:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom {
    [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(left);
        make.top.equalTo(self).offset(top);
        make.right.equalTo(self).offset(-right);
        make.bottom.equalTo(self).offset(-bottom);
    }];
}

@end
