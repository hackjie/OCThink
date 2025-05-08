//
//  LAKBaseLayout.h
//  MyLayout
//
//  Created by 李杰 on 2025/03/12.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "LAKLayoutDef.h"
#import "LAKLayoutPos.h"
#import "LAKLayoutSize.h"

@class LAKBaseLayout;

@interface UIView (LAKLayoutExt)
@property (nonatomic, readonly) LAKLayoutPos *topPos;
@property (nonatomic, readonly) LAKLayoutPos *leadingPos;
@property (nonatomic, readonly) LAKLayoutPos *bottomPos;
@property (nonatomic, readonly) LAKLayoutPos *trailingPos;
@property (nonatomic, readonly) LAKLayoutPos *centerXPos;
@property (nonatomic, readonly) LAKLayoutPos *centerYPos;
@property (nonatomic, readonly) LAKLayoutPos *leftPos;
@property (nonatomic, readonly) LAKLayoutPos *rightPos;
@property (nonatomic, readonly) LAKLayoutPos *baselinePos;
@property (nonatomic, assign) CGFloat myTop;
@property (nonatomic, assign) CGFloat myLeading;
@property (nonatomic, assign) CGFloat myBottom;
@property (nonatomic, assign) CGFloat myTrailing;
@property (nonatomic, assign) CGFloat myCenterX;
@property (nonatomic, assign) CGFloat myCenterY;
@property (nonatomic, assign) CGPoint myCenter;
@property (nonatomic, assign) CGFloat myLeft;
@property (nonatomic, assign) CGFloat myRight;
@property (nonatomic, assign) CGFloat myMargin;
@property (nonatomic, readonly) LAKLayoutSize *widthSize;
@property (nonatomic, readonly) LAKLayoutSize *heightSize;
@property (nonatomic, assign) CGFloat myWidth;
@property (nonatomic, assign) CGFloat myHeight;
@property (nonatomic, assign) CGSize mySize;
@property (nonatomic, assign) CGFloat weight;
@property (nonatomic, assign) BOOL useFrame;
@property (nonatomic, assign) BOOL noLayout;
@property (nonatomic, assign) LAKVisibility visibility;
//@property (nonatomic, assign) LAKGravity alignment;

- (void)resetMyLayoutSetting;
- (void)resetMyLayoutSettingInSizeClass:(LAKSizeClass)sizeClass;
- (instancetype)fetchLayoutSizeClass:(LAKSizeClass)sizeClass;
- (instancetype)fetchLayoutSizeClass:(LAKSizeClass)sizeClass copyFrom:(LAKSizeClass)srcSizeClass;
- (void)setLayoutSizeClass:(LAKSizeClass)sizeClass withValue:(id)value;

@end

@interface LAKBaseLayout : UIView

@property (class, nonatomic, assign) BOOL isRTL;
+ (void)updateRTL:(BOOL)isRTL inWindow:(UIWindow *)window;
@property (nonatomic, assign) UIEdgeInsets padding;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingLeading;
@property (nonatomic, assign) CGFloat paddingBottom;
@property (nonatomic, assign) CGFloat paddingTrailing;
@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingRight;
@property (nonatomic, assign) BOOL zeroPadding;
@property (nonatomic, assign) LAKGravity gravity;
- (void)removeAllSubviews;
@property (nonatomic, assign, readonly) BOOL isMyLayouting;


// 评估布局视图的尺寸。这个方法并不会让布局视图进行真正的布局
- (CGSize)sizeThatFits:(CGSize)size;
- (CGSize)sizeThatFits:(CGSize)size inSizeClass:(LAKSizeClass)sizeClass;

@end
