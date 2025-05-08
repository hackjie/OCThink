//
//  LAKLinearLayout.h
//  MyLayout
//
//  Created by 李杰 on 2025/03/13.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "LAKBaseLayout.h"

@interface LAKLinearLayout : LAKBaseLayout
+ (instancetype)linearLayoutWithOrientation:(LAKOrientation)orientation;
- (instancetype)initWithOrientation:(LAKOrientation)orientation;
- (instancetype)initWithFrame:(CGRect)frame orientation:(LAKOrientation)orientation;

@property (nonatomic, assign) LAKOrientation orientation;
@property (nonatomic, assign) LAKSubviewsShrinkType shrinkType;
@property (nonatomic, assign) UIView *baselineBaseView;

@end
