//
//  LAKLayoutInner.h
//  MyLayout
//
//  Created by 李杰 on 2025/03/14.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "LAKLayoutDef.h"
#import "LAKLayoutMath.h"
#import "LAKLayoutPosInner.h"
#import "LAKLayoutSizeClass.h"
#import "LAKLayoutSizeInner.h"

typedef struct _MyLayoutContext {

    BOOL isEstimate;
    
    LAKSizeClass sizeClass;
    
    LAKGravity vertGravity;
    LAKGravity horzGravity;

    LAKLayoutEngine *layoutViewEngine;
    NSMutableArray<LAKLayoutEngine *> *subviewEngines;
    
    //布局视图相关属性。
    CGSize selfSize;
    CGFloat paddingLeading;
    CGFloat paddingTrailing;
    CGFloat paddingTop;
    CGFloat paddingBottom;

    CGFloat horzSpace;
    CGFloat vertSpace;
    
} MyLayoutContext;

@interface LAKBaseLayout ()

@property (nonatomic, assign) BOOL isMyLayouting;

//派生类重载这个函数进行布局
- (CGSize)calcLayoutSize:(CGSize)size subviewEngines:(NSMutableArray *)subviewEngines context:(MyLayoutContext *)context;

- (id)createSizeClassInstance;

- (CGFloat)myCalcSubview:(LAKLayoutEngine *)subviewEngine
             vertGravity:(LAKGravity)vertGravity
             baselinePos:(CGFloat)baselinePos
                 withContext:(MyLayoutContext *)context;

- (CGFloat)myCalcSubview:(LAKLayoutEngine *)subviewEngine
             horzGravity:(LAKGravity)horz
                 withContext:(MyLayoutContext *)context;

- (CGFloat)mySubview:(LAKViewTraits *)subviewTraits wrapHeightSizeFits:(CGSize)size withContext:(MyLayoutContext *)context;

- (CGFloat)myGetBoundLimitMeasure:(LAKLayoutSize *)anchor subview:(UIView *)subview anchorType:(MyLayoutAnchorType)anchorType subviewSize:(CGSize)subviewSize selfLayoutSize:(CGSize)selfLayoutSize isUBound:(BOOL)isUBound;

- (CGFloat)myValidMeasure:(LAKLayoutSize *)anchor subview:(UIView *)subview calcSize:(CGFloat)calcSize subviewSize:(CGSize)subviewSize selfLayoutSize:(CGSize)selfLayoutSize;

- (CGFloat)myValidMargin:(LAKLayoutPos *)anchor subview:(UIView *)subview calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize;

- (NSArray *)myUpdateCurrentSizeClass:(LAKSizeClass)sizeClass subviews:(NSArray<UIView *> *)subviews;


- (CGSize)myAdjustLayoutViewSizeWithContext:(MyLayoutContext *)context;

- (CGFloat)myLayoutPaddingTop;
- (CGFloat)myLayoutPaddingBottom;
- (CGFloat)myLayoutPaddingLeft;
- (CGFloat)myLayoutPaddingRight;
- (CGFloat)myLayoutPaddingLeading;
- (CGFloat)myLayoutPaddingTrailing;

- (void)myAdjustSizeSettingOfSubviewEngine:(LAKLayoutEngine *)subviewEngine withContext:(MyLayoutContext *)context;

//根据子视图的宽度约束得到宽度值
- (CGFloat)myWidthSizeValueOfSubviewEngine:(LAKLayoutEngine *)subviewEngine
                               withContext:(MyLayoutContext *)context;

//根据子视图的高度约束得到高度值
- (CGFloat)myHeightSizeValueOfSubviewEngine:(LAKLayoutEngine *)subviewEngine
                                withContext:(MyLayoutContext *)context;

- (void)myCalcRectOfSubviewEngine:(LAKLayoutEngine *)subviewEngine
                pMaxWrapSize:(CGSize *)pMaxWrapSize
                 withContext:(MyLayoutContext *)context;

- (UIFont *)myGetSubviewFont:(UIView *)subview;

- (LAKSizeClass)myGetGlobalSizeClass;
- (void)myCalcSubviewsWrapContentSize:(MyLayoutContext *)context withCustomSetting:(void (^)(LAKViewTraits *subviewTraits))customSetting;

@end
