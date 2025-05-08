//
//  LinearLayout.m
//  OCThink
//
//  Created by 李杰 on 2025/2/14.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "TestLinearLayout.h"
#import "UIView+Constraints.h"
#import <Masonry/Masonry.h>

@interface TestLinearLayout()
@property (nonatomic, strong) UIView *contentView;
@end


@implementation TestLinearLayout

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _direction = KDirectionHorizontal;
        _gravity = KGravityLeft;
        _contentView = [UIView new];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_contentView];
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
    UIView *lastView = nil;
    NSInteger existSubsCount = _contentView.subviews.count;
    if (existSubsCount > 0) {
        lastView = _contentView.subviews.lastObject;
    }
    CGFloat containerWidth = self.frame.size.width;
    CGFloat containerHeight = self.frame.size.height;
    
    [_contentView addSubview:view];

    view.translatesAutoresizingMaskIntoConstraints = NO;
    if (_direction == KDirectionHorizontal) {
        // left KGravityCenterVertical
        switch (_gravity) {
            case KGravityCenter: {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.contentView);
                    make.centerX.equalTo(self.contentView);
                    view.topConstraint = make.top.greaterThanOrEqualTo(_contentView).offset(cTop);
                    view.leftConstraint = make.left.greaterThanOrEqualTo(_contentView).offset(cLeft);
                    view.rightConstraint = make.right.lessThanOrEqualTo(_contentView).offset(-cLeft);
                    view.bottomConstraint = make.bottom.lessThanOrEqualTo(_contentView).offset(-cTop);
                    if (existSubsCount == 0) {
                        view.leftConstraint = make.left.greaterThanOrEqualTo(_contentView).offset(cLeft);
                    } else {
                        [lastView.rightConstraint uninstall];
                        view.leftConstraint = make.left.equalTo(lastView.mas_right).offset(cLeft);
                    }
                    if (cWidth == Match_Parent) {
                        view.rightConstraint = make.right.equalTo(_contentView).offset(-cLeft);
                        view.leftConstraint = make.left.equalTo(_contentView).offset(cLeft);
                    } else if (cWidth == Wrap_Content) {
                        
                    } else {
                        view.widthConstraint = make.width.mas_equalTo(cWidth);
                    }
                    
                    if (containerWidth == Wrap_Content) {
                        //view.rightConstraint = make.right.lessThanOrEqualTo(_contentView);
                    }
                    
                    
                    if (cHeight == Match_Parent) {
                        view.topConstraint = make.top.equalTo(_contentView).offset(cTop);
                        view.bottomConstraint = make.bottom.equalTo(_contentView).offset(-cTop);
                    } else if (cHeight == Wrap_Content) {
                        
                    } else {
                        view.heightConstraint = make.height.mas_equalTo(cHeight);
                    }
                    if (containerHeight == Wrap_Content) {
                        
                    }
                    
                }];
            }
                break;
            case KGravityLeft: {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    view.topConstraint = make.top.equalTo(_contentView).offset(cTop);
                    view.rightConstraint = make.right.lessThanOrEqualTo(_contentView);
                    view.bottomConstraint = make.bottom.lessThanOrEqualTo(_contentView);
                    if (existSubsCount == 0) {
                        view.leftConstraint = make.left.equalTo(_contentView).offset(cLeft);
                    } else {
                        [lastView.rightConstraint uninstall];
                        view.leftConstraint = make.left.equalTo(lastView.mas_right).offset(cLeft);
                    }
                    if (cWidth == Match_Parent) {
                        view.rightConstraint = make.right.equalTo(_contentView);
                    } else if (cWidth == Wrap_Content) {
                        if (view.weight == 1) {
                            view.rightConstraint = make.right.equalTo(_contentView);
                            [view setContentHuggingPriority:100 forAxis:UILayoutConstraintAxisHorizontal];
                        }
                    } else {
                        view.widthConstraint = make.width.mas_equalTo(cWidth);
                    }
                    
                    if (containerWidth == Wrap_Content) {
                        //view.rightConstraint = make.right.lessThanOrEqualTo(_contentView);
                    }
                    
                    
                    if (cHeight == Match_Parent) {
                        view.bottomConstraint = make.bottom.equalTo(_contentView);
                    } else if (cHeight == Wrap_Content) {
                        
                    } else {
                        view.heightConstraint = make.height.mas_equalTo(cHeight);
                    }
                    if (containerHeight == Wrap_Content) {
                        
                    }
                }];
            }
                
                break;
            case KGravityRight: {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    view.topConstraint = make.top.equalTo(_contentView).offset(cTop);
                    view.rightConstraint = make.right.equalTo(_contentView);
                    view.bottomConstraint = make.bottom.lessThanOrEqualTo(_contentView);
                    if (existSubsCount == 0) {
                        view.leftConstraint = make.left.greaterThanOrEqualTo(_contentView).offset(cLeft);
                    } else {
                        [lastView.rightConstraint uninstall];
                        view.leftConstraint = make.left.equalTo(lastView.mas_right).offset(cLeft);
                    }
                    if (cWidth == Match_Parent) {
                        view.leftConstraint = make.left.equalTo(_contentView).offset(cLeft);
                    } else if (cWidth == Wrap_Content) {
                        
                    } else {
                        view.widthConstraint = make.width.mas_equalTo(cWidth);
                    }
                    
                    if (containerWidth == Wrap_Content) {}
                    
                    if (cHeight == Match_Parent) {
                        view.bottomConstraint = make.bottom.equalTo(_contentView);
                    } else if (cHeight == Wrap_Content) {
                        
                    } else {
                        view.heightConstraint = make.height.mas_equalTo(cHeight);
                    }
                    if (containerHeight == Wrap_Content) {}
                }];
            }
                
                break;
            case KGravityCenterVertical: {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(_contentView);
                    view.topConstraint = make.top.greaterThanOrEqualTo(_contentView).offset(cTop);
                    view.rightConstraint = make.right.lessThanOrEqualTo(_contentView);
                    view.bottomConstraint = make.bottom.lessThanOrEqualTo(_contentView).offset(-cTop);
                    if (existSubsCount == 0) {
                        view.leftConstraint = make.left.equalTo(_contentView).offset(cLeft);
                    } else {
                        [lastView.rightConstraint uninstall];
                        view.leftConstraint = make.left.equalTo(lastView.mas_right).offset(cLeft);
                    }
                    if (cWidth == Match_Parent) {
                        view.rightConstraint = make.right.equalTo(_contentView);
                    } else if (cWidth == Wrap_Content) {
                        
                    } else {
                        view.widthConstraint = make.width.mas_equalTo(cWidth);
                    }
                    
                    if (containerWidth == Wrap_Content) {
                        //view.rightConstraint = make.right.lessThanOrEqualTo(_contentView);
                    }
                    
                    
                    if (cHeight == Match_Parent) {
                        view.topConstraint = make.top.equalTo(_contentView).offset(cTop);
                        view.bottomConstraint = make.bottom.equalTo(_contentView).offset(-cTop);
                    } else if (cHeight == Wrap_Content) {
                        
                    } else {
                        view.heightConstraint = make.height.mas_equalTo(cHeight);
                    }
                    if (containerHeight == Wrap_Content) {
                        
                    }
                    
                }];
                
            }
                break;
                
            default:
                break;
        }
        
    } else if (_direction == KDirectionVertical) {
        // top KGravityCenterHorizontal
        switch (_gravity) {
            case KGravityTop: {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    view.leftConstraint = make.left.equalTo(_contentView).offset(cLeft);
                    view.rightConstraint = make.right.lessThanOrEqualTo(_contentView);
                    view.bottomConstraint = make.bottom.lessThanOrEqualTo(_contentView);
                    if (existSubsCount == 0) {
                        view.topConstraint = make.top.equalTo(_contentView).offset(cTop);
                    } else {
                        [lastView.bottomConstraint uninstall];
                        view.topConstraint = make.top.equalTo(lastView.mas_bottom).offset(cTop);
                    }
                    if (cWidth == Match_Parent) {
                        view.rightConstraint = make.right.equalTo(_contentView);
                    } else if (cWidth == Wrap_Content) {
                        
                    } else {
                        view.widthConstraint = make.width.mas_equalTo(cWidth);
                    }
                    
                    if (containerWidth == Wrap_Content) {
                        
                    }
                    
                    if (cHeight == Match_Parent) {
                        view.bottomConstraint = make.bottom.equalTo(_contentView);
                    } else if (cHeight == Wrap_Content) {
                        
                    } else {
                        view.heightConstraint = make.height.mas_equalTo(cHeight);
                    }
                    if (containerHeight == Wrap_Content) {
                        
                    }
                }];
            }
                
                break;
            case KGravityBottom: {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    view.leftConstraint = make.left.equalTo(_contentView).offset(cLeft);
                    view.rightConstraint = make.right.lessThanOrEqualTo(_contentView);
                    view.bottomConstraint = make.bottom.equalTo(_contentView);
                    if (existSubsCount == 0) {
                        view.topConstraint = make.top.greaterThanOrEqualTo(_contentView).offset(cTop);
                    } else {
                        [lastView.bottomConstraint uninstall];
                        view.topConstraint = make.top.equalTo(lastView.mas_bottom).offset(cTop);
                    }
                    if (cWidth == Match_Parent) {
                        view.rightConstraint = make.right.equalTo(_contentView);
                    } else if (cWidth == Wrap_Content) {
                        
                    } else {
                        view.widthConstraint = make.width.mas_equalTo(cWidth);
                    }
                    
                    if (containerWidth == Wrap_Content) {}
                    
                    if (cHeight == Match_Parent) {
                        view.topConstraint = make.top.equalTo(_contentView);
                    } else if (cHeight == Wrap_Content) {
                        
                    } else {
                        view.heightConstraint = make.height.mas_equalTo(cHeight);
                    }
                    if (containerHeight == Wrap_Content) {}
                }];
            }
                
                break;
            case KGravityCenterHorizontal: {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(_contentView);
                    view.leftConstraint = make.left.greaterThanOrEqualTo(_contentView).offset(cLeft);
                    view.rightConstraint = make.right.lessThanOrEqualTo(_contentView).offset(-cLeft);
                    view.bottomConstraint = make.bottom.lessThanOrEqualTo(_contentView);
                    if (existSubsCount == 0) {
                        view.topConstraint = make.top.equalTo(_contentView).offset(cTop);
                    } else {
                        [lastView.bottomConstraint uninstall];
                        view.topConstraint = make.top.equalTo(lastView.mas_bottom).offset(cTop);
                    }
                    if (cWidth == Match_Parent) {
                        view.leftConstraint = make.left.equalTo(_contentView).offset(cLeft);
                        view.rightConstraint = make.right.equalTo(_contentView).offset(-cLeft);
                    } else if (cWidth == Wrap_Content) {
                        
                    } else {
                        view.widthConstraint = make.width.mas_equalTo(cWidth);
                    }
                    
                    if (containerWidth == Wrap_Content) {
                    }
                    
                    
                    if (cHeight == Match_Parent) {
                        view.bottomConstraint = make.bottom.equalTo(_contentView);
                    } else if (cHeight == Wrap_Content) {
                        
                    } else {
                        view.heightConstraint = make.height.mas_equalTo(cHeight);
                    }
                    if (containerHeight == Wrap_Content) {
                        //
                    }
                }];
                
            }
                break;
                
            default:
                break;
        }
        
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
