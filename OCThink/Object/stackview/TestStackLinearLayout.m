//
//  TestStackLinearLayout.m
//  OCThink
//
//  Created by 李杰 on 2025/3/5.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "TestStackLinearLayout.h"

@implementation TestStackLinearLayout
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _direction = KDirectionHorizontal;
        _gravity = KGravityLeft;
        self.axis = UILayoutConstraintAxisHorizontal;
        self.alignment = UIStackViewAlignmentLeading;
        self.distribution = UIStackViewDistributionFill;
        self.spacing = 0;
    }
    return self;
}

- (void)setDirection:(KDirection)direction {
    switch (direction) {
        case KDirectionHorizontal:
            self.axis = UILayoutConstraintAxisHorizontal;
            break;
        case KDirectionVertical:
            self.axis = UILayoutConstraintAxisVertical;
            break;
        default:
            break;
    }
}

// UIStackView去实现LinearLayout可以解决大多数问题，但是Fill模式下总是会被拉伸这一点特性同Android LinearLayout还是有些区别
// 解决：通过添加一个空白view给他去拉伸压缩使用

//


@end
