//
//  LAKLayoutSizeClass.h
//  MyLayout
//
//  Created by 李杰 on 2025/03/13.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "LAKLayoutDef.h"
#import "LAKLayoutPos.h"
#import "LAKLayoutSize.h"

@class LAKBaseLayout;

@class LAKViewTraits;

//视图的布局引擎。
@interface LAKLayoutEngine : NSObject
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat leading;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat trailing;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGRect frame;

//默认的布局分类，所有视图的布局相关的属性，都是设置到这个分类上。
@property (nonatomic, weak) LAKViewTraits *defaultSizeClass;

//当前的布局分类，当前正在执行布局时所用的布局分类。
@property (nonatomic, weak) LAKViewTraits *currentSizeClass;
@property (nonatomic, assign, readonly) BOOL multiple; //是否设置了多个sizeclass
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, LAKViewTraits*> *sizeClasses;
@property (nonatomic, assign) BOOL hasObserver;
- (void)reset;
- (LAKViewTraits *)fetchView:(UIView *)view layoutSizeClass:(LAKSizeClass)sizeClass copyFrom:(LAKSizeClass)srcSizeClass;
- (LAKViewTraits *)fetchView:(UIView *)view bestLayoutSizeClass:(LAKSizeClass)sizeClass;
- (void)setView:(UIView *)view layoutSizeClass:(LAKSizeClass)sizeClass withTraits:(LAKViewTraits *)traits;

@end

@interface UIView (LAKLayoutExtInner)

@property (nonatomic, strong, readonly) LAKLayoutEngine *myEngine;
@property (nonatomic, strong, readonly) LAKLayoutEngine *myEngineInner;
- (id)createSizeClassInstance;
- (instancetype)myDefaultSizeClass;
- (instancetype)myDefaultSizeClassInner;
- (instancetype)myCurrentSizeClass;
- (instancetype)myCurrentSizeClassInner;

@property (nonatomic, readonly) LAKLayoutPos *topPosInner;
@property (nonatomic, readonly) LAKLayoutPos *leadingPosInner;
@property (nonatomic, readonly) LAKLayoutPos *bottomPosInner;
@property (nonatomic, readonly) LAKLayoutPos *trailingPosInner;
@property (nonatomic, readonly) LAKLayoutPos *centerXPosInner;
@property (nonatomic, readonly) LAKLayoutPos *centerYPosInner;
@property (nonatomic, readonly) LAKLayoutSize *widthSizeInner;
@property (nonatomic, readonly) LAKLayoutSize *heightSizeInner;

@property (nonatomic, readonly) LAKLayoutPos *leftPosInner;
@property (nonatomic, readonly) LAKLayoutPos *rightPosInner;

@property (nonatomic, readonly) LAKLayoutPos *baselinePosInner;

@property (nonatomic, readonly) CGFloat myEstimatedWidth;
@property (nonatomic, readonly) CGFloat myEstimatedHeight;

@end



/*
 布局的属性特征集合类，这个类的功能用来存储涉及到布局的各种属性。LAKViewTraits类中定义的各种属性跟视图和布局的各种扩展属性是一致的。
 */
@interface LAKViewTraits : NSObject <NSCopying>

@property (nonatomic, weak) UIView *view;

//所有视图通用
@property (nonatomic, strong) LAKLayoutPos *topPos;
@property (nonatomic, strong) LAKLayoutPos *leadingPos;
@property (nonatomic, strong) LAKLayoutPos *bottomPos;
@property (nonatomic, strong) LAKLayoutPos *trailingPos;
@property (nonatomic, strong) LAKLayoutPos *centerXPos;
@property (nonatomic, strong) LAKLayoutPos *centerYPos;

@property (nonatomic, strong, readonly) LAKLayoutPos *leftPos;
@property (nonatomic, strong, readonly) LAKLayoutPos *rightPos;

@property (nonatomic, strong) LAKLayoutPos *baselinePos;

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
@property (nonatomic, assign) CGFloat myHorzMargin;
@property (nonatomic, assign) CGFloat myVertMargin;

@property (nonatomic, strong) LAKLayoutSize *widthSize;
@property (nonatomic, strong) LAKLayoutSize *heightSize;

@property (nonatomic, assign) CGFloat myWidth;
@property (nonatomic, assign) CGFloat myHeight;
@property (nonatomic, assign) CGSize mySize;

@property (nonatomic, assign) BOOL useFrame;
@property (nonatomic, assign) BOOL noLayout;

@property (nonatomic, assign) LAKVisibility visibility;
@property (nonatomic, assign) LAKGravity alignment;

//线性布局和浮动布局和流式布局子视图专用
@property (nonatomic, assign) CGFloat weight;

//浮动布局子视图专用
@property (nonatomic, assign, getter=isReverseFloat) BOOL reverseFloat;
@property (nonatomic, assign) BOOL clearFloat;

//内部属性
@property (nonatomic, strong, readonly) LAKLayoutPos *topPosInner;
@property (nonatomic, strong, readonly) LAKLayoutPos *leadingPosInner;
@property (nonatomic, strong, readonly) LAKLayoutPos *bottomPosInner;
@property (nonatomic, strong, readonly) LAKLayoutPos *trailingPosInner;
@property (nonatomic, strong, readonly) LAKLayoutPos *centerXPosInner;
@property (nonatomic, strong, readonly) LAKLayoutPos *centerYPosInner;
@property (nonatomic, strong, readonly) LAKLayoutSize *widthSizeInner;
@property (nonatomic, strong, readonly) LAKLayoutSize *heightSizeInner;

@property (nonatomic, strong, readonly) LAKLayoutPos *leftPosInner;
@property (nonatomic, strong, readonly) LAKLayoutPos *rightPosInner;

@property (nonatomic, strong, readonly) LAKLayoutPos *baselinePosInner;

@property (class, nonatomic, assign) BOOL isRTL;

//内部方法
- (BOOL)invalid;

+ (LAKGravity)convertLeadingTrailingGravityFromLeftRightGravity:(LAKGravity)horzGravity;
- (LAKGravity)finalVertGravityFrom:(LAKGravity)layoutVertGravity;
- (LAKGravity)finalHorzGravityFrom:(LAKGravity)layoutHorzGravity;

@end

@interface LAKLayoutTraits : LAKViewTraits

@property (nonatomic, assign) BOOL zeroPadding;

@property (nonatomic, assign) LAKGravity gravity;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingLeading;
@property (nonatomic, assign) CGFloat paddingBottom;
@property (nonatomic, assign) CGFloat paddingTrailing;
@property (nonatomic, assign) UIEdgeInsets padding;

@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingRight;

//为支持iOS11的safeArea而进行的padding的转化
- (CGFloat)myLayoutPaddingTop;
- (CGFloat)myLayoutPaddingBottom;
- (CGFloat)myLayoutPaddingLeft;
- (CGFloat)myLayoutPaddingRight;
- (CGFloat)myLayoutPaddingLeading;
- (CGFloat)myLayoutPaddingTrailing;

//从全部子视图引擎数组中过滤出需要进行布局的子视图布局引擎数组子集。
- (NSMutableArray<LAKLayoutEngine *> *)filterEngines:(NSMutableArray<LAKLayoutEngine *> *)subviewEngines;

@end

@interface MySequentLayoutFlexSpacing : NSObject
@property (nonatomic, assign) CGFloat subviewSize;
@property (nonatomic, assign) CGFloat minSpace;
@property (nonatomic, assign) CGFloat maxSpace;
@property (nonatomic, assign) BOOL centered;

- (CGFloat)calcMaxMinSubviewSizeForContent:(CGFloat)selfSize paddingStart:(CGFloat *)pStarPadding paddingEnd:(CGFloat *)pEndPadding space:(CGFloat *)pSpace;
- (CGFloat)calcMaxMinSubviewSize:(CGFloat)selfSize arrangedCount:(NSInteger)arrangedCount paddingStart:(CGFloat *)pStarPadding paddingEnd:(CGFloat *)pEndPadding space:(CGFloat *)pSpace;

@end

@interface MySequentLayoutTraits : LAKLayoutTraits

@property (nonatomic, assign) LAKOrientation orientation;
@property (nonatomic, strong) MySequentLayoutFlexSpacing *flexSpace;

@end

@interface LAKLinearLayoutTraits : MySequentLayoutTraits

@property (nonatomic, assign) LAKSubviewsShrinkType shrinkType;

@end

@interface LAKFrameLayoutTraits : LAKLayoutTraits

@end
