//
//  LAKBaseLayout.m
//  MyLayout
//
//  Created by 李杰 on 2025/03/12.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "LAKBaseLayout.h"
#import "LAKLayoutInner.h"
#import <objc/runtime.h>

const char *const ASSOCIATEDOBJECT_KEY_MYLAYOUT_ENGINE = "LAK_ASSOCIATEDOBJECT_KEY_MYLAYOUT_ENGINE";

void *_myObserverContextA = (void *)20250318;
void *_myObserverContextB = (void *)20250319;
void *_myObserverContextC = (void *)20250320;

/**
 窗口对RTL的支持。
 */

@interface UIWindow (MyLayoutExt)

- (void)myUpdateRTL:(BOOL)isRTL;

@end

@implementation UIView (LAKLayoutExt)

- (LAKLayoutPos *)topPos {
    return self.myDefaultSizeClass.topPos;
}

- (LAKLayoutPos *)leadingPos {
    return self.myDefaultSizeClass.leadingPos;
}

- (LAKLayoutPos *)bottomPos {
    return self.myDefaultSizeClass.bottomPos;
}

- (LAKLayoutPos *)trailingPos {
    return self.myDefaultSizeClass.trailingPos;
}

- (LAKLayoutPos *)centerXPos {
    return self.myDefaultSizeClass.centerXPos;
}

- (LAKLayoutPos *)centerYPos {
    return self.myDefaultSizeClass.centerYPos;
}

- (LAKLayoutPos *)leftPos {
    return self.myDefaultSizeClass.leftPos;
}

- (LAKLayoutPos *)rightPos {
    return self.myDefaultSizeClass.rightPos;
}

- (LAKLayoutPos *)baselinePos {
    return self.myDefaultSizeClass.baselinePos;
}

- (CGFloat)myTop {
    return self.myDefaultSizeClassInner.myTop;
}

- (void)setMyTop:(CGFloat)myTop {
    self.myDefaultSizeClass.myTop = myTop;
}

- (CGFloat)myLeading {
    return self.myDefaultSizeClassInner.myLeading;
}

- (void)setMyLeading:(CGFloat)myLeading {
    self.myDefaultSizeClass.myLeading = myLeading;
}

- (CGFloat)myBottom {
    return self.myDefaultSizeClassInner.myBottom;
}

- (void)setMyBottom:(CGFloat)myBottom {
    self.myDefaultSizeClass.myBottom = myBottom;
}

- (CGFloat)myTrailing {
    return self.myDefaultSizeClassInner.myTrailing;
}

- (void)setMyTrailing:(CGFloat)myTrailing {
    self.myDefaultSizeClass.myTrailing = myTrailing;
}

- (CGFloat)myCenterX {
    return self.myDefaultSizeClassInner.myCenterX;
}

- (void)setMyCenterX:(CGFloat)myCenterX {
    self.myDefaultSizeClass.myCenterX = myCenterX;
}

- (CGFloat)myCenterY {
    return self.myDefaultSizeClassInner.myCenterY;
}

- (void)setMyCenterY:(CGFloat)myCenterY {
    self.myDefaultSizeClass.myCenterY = myCenterY;
}

- (CGPoint)myCenter {
    return self.myDefaultSizeClassInner.myCenter;
}

- (void)setMyCenter:(CGPoint)myCenter {
    self.myDefaultSizeClass.myCenter = myCenter;
}

- (CGFloat)myLeft {
    return self.myDefaultSizeClassInner.myLeft;
}

- (void)setMyLeft:(CGFloat)myLeft {
    self.myDefaultSizeClass.myLeft = myLeft;
}

- (CGFloat)myRight {
    return self.myDefaultSizeClassInner.myRight;
}

- (void)setMyRight:(CGFloat)myRight {
    self.myDefaultSizeClass.myRight = myRight;
}

- (CGFloat)myMargin {
    return self.myDefaultSizeClassInner.myMargin;
}

- (void)setMyMargin:(CGFloat)myMargin {
    self.myDefaultSizeClass.myMargin = myMargin;
}

- (LAKLayoutSize *)widthSize {
    return self.myDefaultSizeClass.widthSize;
}

- (LAKLayoutSize *)heightSize {
    return self.myDefaultSizeClass.heightSize;
}

- (CGFloat)myWidth {
    return self.myDefaultSizeClassInner.myWidth;
}

- (void)setMyWidth:(CGFloat)myWidth {
    self.myDefaultSizeClass.myWidth = myWidth;
}

- (CGFloat)myHeight {
    return self.myDefaultSizeClassInner.myHeight;
}

- (void)setMyHeight:(CGFloat)myHeight {
    self.myDefaultSizeClass.myHeight = myHeight;
}

- (CGSize)mySize {
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.myDefaultSizeClassInner.mySize;
}

- (void)setMySize:(CGSize)mySize {
    self.myDefaultSizeClass.mySize = mySize;
}

- (CGFloat)weight {
    return self.myDefaultSizeClassInner.weight;
}

- (void)setWeight:(CGFloat)weight {
    LAKViewTraits *viewTraits = (LAKViewTraits*)self.myDefaultSizeClass;
    if (viewTraits.weight != weight) {
        viewTraits.weight = weight;
        if (self.superview != nil) {
            [self.superview setNeedsLayout];
        }
    }
}

- (BOOL)useFrame {
    return self.myDefaultSizeClassInner.useFrame;
}

- (void)setUseFrame:(BOOL)useFrame {
    LAKViewTraits *viewTraits = (LAKViewTraits*)self.myDefaultSizeClass;
    if (viewTraits.useFrame != useFrame) {
        viewTraits.useFrame = useFrame;
        if (self.superview != nil) {
            [self.superview setNeedsLayout];
        }
    }
}

- (BOOL)noLayout {
    return self.myDefaultSizeClassInner.noLayout;
}

- (void)setNoLayout:(BOOL)noLayout {
    LAKViewTraits *viewTraits = (LAKViewTraits*)self.myDefaultSizeClass;
    if (viewTraits.noLayout != noLayout) {
        viewTraits.noLayout = noLayout;
        if (self.superview != nil) {
            [self.superview setNeedsLayout];
        }
    }
}

- (LAKVisibility)visibility {
    return self.myDefaultSizeClassInner.visibility;
}

- (void)setVisibility:(LAKVisibility)visibility {
    LAKViewTraits *viewTraits = (LAKViewTraits*)self.myDefaultSizeClass;
    if (viewTraits.visibility != visibility) {
        viewTraits.visibility = visibility;
        self.hidden = (visibility != LAKVisibility_Visible);
        if (self.superview != nil) {
            //修复布局视图在从隐藏转到不隐藏并且有尺寸自适应时，位置和尺寸不会重新计算的BUG。
            if (!self.isHidden &&
                [self isKindOfClass:LAKBaseLayout.class] && (viewTraits.widthSizeInner.isWrap || viewTraits.heightSizeInner.isWrap)) {
                [self setNeedsLayout];
            }
            [self.superview setNeedsLayout];
        }
    }
}

- (void)resetMyLayoutSetting {
    [self resetMyLayoutSettingInSizeClass:LAKSizeClass_wAny | LAKSizeClass_hAny];
}

- (void)resetMyLayoutSettingInSizeClass:(LAKSizeClass)sizeClass {
    [self.myEngine.sizeClasses removeObjectForKey:@(sizeClass)];
}

- (instancetype)fetchLayoutSizeClass:(LAKSizeClass)sizeClass {
    return [self fetchLayoutSizeClass:sizeClass copyFrom:0xFF];
}

- (instancetype)fetchLayoutSizeClass:(LAKSizeClass)sizeClass copyFrom:(LAKSizeClass)srcSizeClass {
    return (UIView *)[self.myEngine fetchView:self layoutSizeClass:sizeClass copyFrom:srcSizeClass];
}

- (void)setLayoutSizeClass:(LAKSizeClass)sizeClass withValue:(id)value {
    [self.myEngine setView:self layoutSizeClass:sizeClass withTraits:value];
}

@end

@implementation UIView (LAKLayoutExtInner)

- (instancetype)myDefaultSizeClass {
    LAKLayoutEngine *viewEngine = self.myEngine;
    if (viewEngine.defaultSizeClass == nil) {
        viewEngine.defaultSizeClass = [viewEngine fetchView:self layoutSizeClass:LAKSizeClass_wAny | LAKSizeClass_hAny copyFrom:0xFF];
    }
    return (UIView *)viewEngine.defaultSizeClass;
}

- (instancetype)myDefaultSizeClassInner {
    return (UIView *)self.myEngineInner.defaultSizeClass;
}

- (instancetype)myCurrentSizeClass {
    LAKLayoutEngine *viewEngine = self.myEngine;
    if (viewEngine.currentSizeClass == nil) {
        viewEngine.currentSizeClass = (LAKViewTraits *)[self myDefaultSizeClass];
    }
    return (UIView *)viewEngine.currentSizeClass;
}

- (instancetype)myCurrentSizeClassInner {
    //如果没有则不会建立，为了优化减少不必要的建立。
    return (UIView *)self.myEngineInner.currentSizeClass;
}

- (LAKLayoutEngine *)myEngine {
    LAKLayoutEngine *obj = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_ENGINE);
    if (obj == nil) {
        obj = [LAKLayoutEngine new];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_ENGINE, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

- (LAKLayoutEngine *)myEngineInner {
    return (LAKLayoutEngine*)objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_ENGINE);
}

- (id)createSizeClassInstance {
    return [LAKViewTraits new];
}

- (LAKLayoutPos *)topPosInner {
    return self.myDefaultSizeClassInner.topPosInner;
}

- (LAKLayoutPos *)leadingPosInner {
    return self.myDefaultSizeClassInner.leadingPosInner;
}

- (LAKLayoutPos *)bottomPosInner {
    return self.myDefaultSizeClassInner.bottomPosInner;
}

- (LAKLayoutPos *)trailingPosInner {
    return self.myDefaultSizeClassInner.trailingPosInner;
}

- (LAKLayoutPos *)centerXPosInner {
    return self.myDefaultSizeClassInner.centerXPosInner;
}

- (LAKLayoutPos *)centerYPosInner {
    return self.myDefaultSizeClassInner.centerYPosInner;
}

- (LAKLayoutPos *)leftPosInner {
    return self.myDefaultSizeClassInner.leftPosInner;
}

- (LAKLayoutPos *)rightPosInner {
    return self.myDefaultSizeClassInner.rightPosInner;
}

- (LAKLayoutPos *)baselinePosInner {
    return self.myDefaultSizeClassInner.baselinePosInner;
}

- (LAKLayoutSize *)widthSizeInner {
    return self.myDefaultSizeClassInner.widthSizeInner;
}

- (LAKLayoutSize *)heightSizeInner {
    return self.myDefaultSizeClassInner.heightSizeInner;
}

- (CGFloat)myEstimatedWidth {
    //如果视图的父视图不是布局视图则直接返回宽度值。
    if (![self.superview isKindOfClass:[LAKBaseLayout class]]) {
        return CGRectGetWidth(self.bounds);
    } else {
        LAKLayoutEngine *viewEngine = self.myEngine;
        if (viewEngine.width == CGFLOAT_MAX) {
            return CGRectGetWidth(self.bounds);
        }
        return viewEngine.width;
    }
}

- (CGFloat)myEstimatedHeight {
    if (![self.superview isKindOfClass:[LAKBaseLayout class]]) {
        return CGRectGetHeight(self.bounds);
    } else {
        LAKLayoutEngine *viewEngine = self.myEngine;
        if (viewEngine.height == CGFLOAT_MAX) {
            return CGRectGetHeight(self.bounds);
        }
        return viewEngine.height;
    }
}

@end

@implementation LAKBaseLayout {
    BOOL _isAddSuperviewKVO;
    BOOL _useCacheRects;
    LAKLayoutEngine *_myEngine;
}

- (void)dealloc {
    
}

#pragma mark-- Public Methods

+ (BOOL)isRTL {
    return [LAKViewTraits isRTL];
}

+ (void)setIsRTL:(BOOL)isRTL {
    [LAKViewTraits setIsRTL:isRTL];
}

+ (void)updateRTL:(BOOL)isRTL inWindow:(UIWindow *)window {
    [window myUpdateRTL:isRTL];
}
//+ (void)myUpArabicUI:(BOOL)isArabicUI inWindow:(UIWindow *)window {
//    [self updateRTL:isArabicUI inWindow:window];
//}

- (CGFloat)paddingTop {
    return self.myDefaultSizeClassInner.paddingTop;
}

- (void)setPaddingTop:(CGFloat)paddingTop {
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.paddingTop != paddingTop) {
        layoutTraits.paddingTop = paddingTop;
        [self setNeedsLayout];
    }
}

- (CGFloat)paddingLeading {
    return self.myDefaultSizeClassInner.paddingLeading;
}

- (void)setPaddingLeading:(CGFloat)paddingLeading {
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.paddingLeading != paddingLeading) {
        layoutTraits.paddingLeading = paddingLeading;
        [self setNeedsLayout];
    }
}

- (CGFloat)paddingBottom {
    return self.myDefaultSizeClassInner.paddingBottom;
}

- (void)setPaddingBottom:(CGFloat)paddingBottom {
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.paddingBottom != paddingBottom) {
        layoutTraits.paddingBottom = paddingBottom;
        [self setNeedsLayout];
    }
}

- (CGFloat)paddingTrailing {
    return self.myDefaultSizeClassInner.paddingTrailing;
}

- (void)setPaddingTrailing:(CGFloat)paddingTrailing {
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.paddingTrailing != paddingTrailing) {
        layoutTraits.paddingTrailing = paddingTrailing;
        [self setNeedsLayout];
    }
}

- (UIEdgeInsets)padding {
    return self.myDefaultSizeClassInner.padding;
}

- (void)setPadding:(UIEdgeInsets)padding {
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)self.myDefaultSizeClass;
    if (!UIEdgeInsetsEqualToEdgeInsets(layoutTraits.padding, padding)) {
        layoutTraits.padding = padding;
        [self setNeedsLayout];
    }
}

- (CGFloat)paddingLeft {
    return self.myDefaultSizeClassInner.paddingLeft;
}

- (void)setPaddingLeft:(CGFloat)paddingLeft {
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.paddingLeft != paddingLeft) {
        layoutTraits.paddingLeft = paddingLeft;
        [self setNeedsLayout];
    }
}

- (CGFloat)paddingRight {
    return self.myDefaultSizeClassInner.paddingRight;
}

- (void)setPaddingRight:(CGFloat)paddingRight {
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.paddingRight != paddingRight) {
        layoutTraits.paddingRight = paddingRight;
        [self setNeedsLayout];
    }
}

- (BOOL)zeroPadding {
    //这里不用myDefaultSizeClassInner的原因是这个属性默认是YES!
    return self.myDefaultSizeClass.zeroPadding;
}

- (void)setZeroPadding:(BOOL)zeroPadding {
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.zeroPadding != zeroPadding) {
        layoutTraits.zeroPadding = zeroPadding;
        [self setNeedsLayout];
    }
}

- (void)setGravity:(LAKGravity)gravity {
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.gravity != gravity) {
        layoutTraits.gravity = gravity;
        [self setNeedsLayout];
    }
}

- (LAKGravity)gravity {
    return self.myDefaultSizeClassInner.gravity;
}

- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark-- KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context {
    //监控非布局父视图的frame的变化，而改变自身的位置和尺寸
    if (context == _myObserverContextC) {
        //只监控父视图的尺寸变换
        CGRect rcOld = [change[NSKeyValueChangeOldKey] CGRectValue];
        CGRect rcNew = [change[NSKeyValueChangeNewKey] CGRectValue];
        if (!_myCGSizeEqual(rcOld.size, rcNew.size)) {
            [self myUpdateLayoutRectInNoLayoutSuperview:object];
        }
        return;
    }

    //监控子视图的frame的变化以便重新进行布局
    if (!self.isMyLayouting) {
        if (context == _myObserverContextA) {
            if (!object.myCurrentSizeClassInner.useFrame) {
                [self setNeedsLayout];
                //这里添加的原因是有可能子视图取消隐藏后不会绘制自身，所以这里要求子视图重新绘制自身
                if ([keyPath isEqualToString:@"hidden"] && ![change[NSKeyValueChangeNewKey] boolValue]) {
                    [(UIView *)object setNeedsDisplay];
                }
            }
        } else if (context == _myObserverContextB) { //针对UILabel特殊处理。。
            LAKViewTraits *subviewTraits = (LAKViewTraits*)object.myDefaultSizeClass;
            if (subviewTraits.widthSizeInner.wrapVal || subviewTraits.heightSizeInner.wrapVal) {
                [self setNeedsLayout];
            }
        }
    }
}

#pragma mark-- Override Methods
- (CGSize)calcLayoutSize:(CGSize)size subviewEngines:(NSMutableArray *)subviewEngines context:(MyLayoutContext *)context {
    if (context->isEstimate) {
        context->selfSize = size;
    } else {
        context->selfSize = self.bounds.size;
        if (size.width != 0) {
            context->selfSize.width = size.width;
        }
        if (size.height != 0) {
            context->selfSize.height = size.height;
        }
    }

    return context->selfSize;
}

- (id)createSizeClassInstance {
    return [LAKLayoutTraits new];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self sizeThatFits:size inSizeClass:LAKSizeClass_wAny | LAKSizeClass_hAny];
}

- (CGSize)sizeThatFits:(CGSize)size inSizeClass:(LAKSizeClass)sizeClass {
    return [self myEstimateLayoutSize:size inSizeClass:sizeClass subviews:nil];
}

- (void)setHidden:(BOOL)hidden {
    if (self.isHidden == hidden) {
        return;
    }
    [super setHidden:hidden];
    UIView *superview = self.superview;
    if ([superview isKindOfClass:[LAKBaseLayout class]]) {
        if (!((LAKBaseLayout *)superview).isMyLayouting) {
            [superview setNeedsLayout];
        }
    }
}

- (void)setCenter:(CGPoint)center {
    CGPoint oldCenter = self.center;
    [super setCenter:center];
    UIView *superview = self.superview;
    if (!CGPointEqualToPoint(oldCenter, center) && [superview isKindOfClass:[LAKBaseLayout class]]) {
        if (!((LAKBaseLayout *)superview).isMyLayouting) {
            [superview setNeedsLayout];
        }
    }
}

- (void)setFrame:(CGRect)frame {
    CGRect oldFrame = self.frame;
    [super setFrame:frame];
    UIView *superview = self.superview;
    if (!CGRectEqualToRect(oldFrame, frame) && [superview isKindOfClass:[LAKBaseLayout class]]) {
        if (!((LAKBaseLayout *)superview).isMyLayouting) {
            [superview setNeedsLayout];
        }
    }
}

- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];

    [self myInvalidateIntrinsicContentSize];
}

- (void)willRemoveSubview:(UIView *)subview {
    [super willRemoveSubview:subview];

    [self myRemoveSubviewObserver:subview];

    [self myInvalidateIntrinsicContentSize];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    LAKBaseLayout *layoutTraits = self.myDefaultSizeClass;

    //特殊处理如果视图是控制器根视图则取消高度或者宽度包裹
    @try {
        if (newSuperview != nil) {
            id vc = [self valueForKey:@"viewDelegate"];
            if (vc != nil) {
                if (![newSuperview isKindOfClass:[LAKBaseLayout class]]) {
                    if (layoutTraits.widthSizeInner.wrapVal) {
                        [layoutTraits.widthSizeInner _myEqualTo:nil];
                    }
                    if (layoutTraits.heightSizeInner.wrapVal) {
                        [layoutTraits.heightSizeInner _myEqualTo:nil];
                    }
                }
            }
        }

    } @catch (NSException *exception) {
    }

    //将要添加到父视图时，如果不是MyLayout派生则则跟需要根据父视图的frame的变化而调整自身的位置和尺寸
    if (newSuperview != nil && ![newSuperview isKindOfClass:[LAKBaseLayout class]]) {
        if ([self myUpdateLayoutRectInNoLayoutSuperview:newSuperview]) {
            //有可能父视图不为空，所以这里先把以前父视图的KVO删除。否则会导致程序崩溃

            //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
            //然后在左边将异常断点清除即可

            if (_isAddSuperviewKVO && self.superview != nil && ![self.superview isKindOfClass:[LAKBaseLayout class]]) {
                @try {
                    [self.superview removeObserver:self forKeyPath:@"frame"];
                }@catch (NSException *exception) {
                }
                
                @try {
                    [self.superview removeObserver:self forKeyPath:@"bounds"];
                }@catch (NSException *exception) {
                }
            }

            [newSuperview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:_myObserverContextC];
            [newSuperview addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:_myObserverContextC];
            _isAddSuperviewKVO = YES;
        }
    }

    if (_isAddSuperviewKVO && newSuperview == nil && self.superview != nil && ![self.superview isKindOfClass:[LAKBaseLayout class]]) {
        //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
        //然后在左边将异常断点清除即可
        _isAddSuperviewKVO = NO;
        @try {
            [self.superview removeObserver:self forKeyPath:@"frame"];
        }@catch (NSException *exception) {
        }
        
        @try {
            [self.superview removeObserver:self forKeyPath:@"bounds"];
        }@catch (NSException *exception) {
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

    if (self.superview != nil && ![self.superview isKindOfClass:[LAKBaseLayout class]]) {
        [self myUpdateLayoutRectInNoLayoutSuperview:self.superview];
    }
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self myInvalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    if (self.translatesAutoresizingMaskIntoConstraints == NO && (self.widthSizeInner.wrapVal || self.heightSizeInner.wrapVal)) {
        if (self.widthSizeInner.wrapVal && self.heightSizeInner.wrapVal) {
            size = [self sizeThatFits:CGSizeZero];
        } else if (self.widthSizeInner.wrapVal) {
            //动态宽度
            NSLayoutConstraint *heightConstraint = nil;
            for (NSLayoutConstraint *constraint in self.constraints) {
                if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeHeight) {
                    heightConstraint = constraint;
                    break;
                }
            }

            if (heightConstraint == nil) {
                for (NSLayoutConstraint *constraint in self.superview.constraints) {
                    if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeHeight) {
                        heightConstraint = constraint;
                        break;
                    }
                }
            }

            if (heightConstraint != nil) {
                CGFloat dependHeight = UIViewNoIntrinsicMetric;
                if ([heightConstraint.secondItem isKindOfClass:[UIView class]]) {
                    UIView *dependView = (UIView *)heightConstraint.secondItem;
                    CGRect dependViewRect = dependView.bounds;
                    if (heightConstraint.secondAttribute == NSLayoutAttributeHeight) {
                        dependHeight = CGRectGetHeight(dependViewRect);
                    }

                    else if (heightConstraint.secondAttribute == NSLayoutAttributeWidth) {
                        dependHeight = CGRectGetWidth(dependViewRect);
                    }

                    else {
                        dependHeight = UIViewNoIntrinsicMetric;
                    }
                } else if (heightConstraint.secondItem == nil) {
                    dependHeight = 0;
                }
                if (dependHeight != UIViewNoIntrinsicMetric) {
                    dependHeight *= heightConstraint.multiplier;
                    dependHeight += heightConstraint.constant;
                    size.width = [self sizeThatFits:CGSizeMake(0, dependHeight)].width;
                }
            }
        } else {
            //动态高度
            NSLayoutConstraint *widthConstraint = nil;
            for (NSLayoutConstraint *constraint in self.constraints) {
                if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeWidth) {
                    widthConstraint = constraint;
                    break;
                }
            }

            if (widthConstraint == nil) {
                for (NSLayoutConstraint *constraint in self.superview.constraints) {
                    if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeWidth) {
                        widthConstraint = constraint;
                        break;
                    }
                }
            }

            CGFloat dependWidth = UIViewNoIntrinsicMetric;
            if (widthConstraint != nil) {
                if ([widthConstraint.secondItem isKindOfClass:[UIView class]]) {
                    UIView *dependView = (UIView *)widthConstraint.secondItem;
                    CGRect dependViewRect = dependView.bounds;
                    if (widthConstraint.secondAttribute == NSLayoutAttributeWidth) {
                        dependWidth = CGRectGetWidth(dependViewRect);
                    }

                    else if (widthConstraint.secondAttribute == NSLayoutAttributeHeight) {
                        dependWidth = CGRectGetHeight(dependViewRect);
                    } else {
                        dependWidth = UIViewNoIntrinsicMetric;
                    }
                } else if (widthConstraint.secondItem == nil) {
                    dependWidth = 0;
                }
                if (dependWidth != UIViewNoIntrinsicMetric) {
                    dependWidth *= widthConstraint.multiplier;
                    dependWidth += widthConstraint.constant;
                    size.height = [self sizeThatFits:CGSizeMake(dependWidth, 0)].height;
                }
            }
        }
    }
    return size;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    return [self sizeThatFits:targetSize];
}

- (void)doLayoutSubviews {
    int currentScreenOrientation = 0;

    if (!self.isMyLayouting) {
        self.isMyLayouting = YES;
        //减少每次调用就计算设备方向以及sizeclass的次数。
        LAKSizeClass sizeClass = [self myGetGlobalSizeClass];
        if ((sizeClass & 0xF0) == LAKSizeClass_Portrait) {
            currentScreenOrientation = 1;
        } else if ((sizeClass & 0xF0) == LAKSizeClass_Landscape) {
            currentScreenOrientation = 2;
        }
        //得到当前布局视图和子视图的最佳的sizeClass
        LAKLayoutEngine *layoutViewEngine = self.myEngine;
        layoutViewEngine.currentSizeClass = [layoutViewEngine fetchView:self bestLayoutSizeClass:sizeClass];
        
        NSMutableArray<LAKLayoutEngine *> *subviewEngines = [NSMutableArray arrayWithCapacity:self.subviews.count];
        for (UIView *subview in self.subviews) {
            LAKLayoutEngine *subviewEngine = subview.myEngine;
            subviewEngine.currentSizeClass = [subviewEngine fetchView:subview bestLayoutSizeClass:sizeClass];
            
            if (!subviewEngine.hasObserver && subviewEngine.currentSizeClass != nil && !subviewEngine.currentSizeClass.useFrame) {
                subviewEngine.hasObserver = YES;
                [self myAddSubviewObserver:subview];
            }
            
            [subviewEngines addObject:subviewEngine];
        }

        LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)layoutViewEngine.currentSizeClass;

        //计算布局
        CGSize oldSelfSize = self.bounds.size;
        CGSize newSelfSize;
        if (_useCacheRects && layoutViewEngine.width != CGFLOAT_MAX && layoutViewEngine.height != CGFLOAT_MAX) {
            newSelfSize = CGSizeMake(layoutViewEngine.width, layoutViewEngine.height);
        } else {
            
            MyLayoutContext context;
            context.isEstimate = NO;
            context.sizeClass = sizeClass;
            context.layoutViewEngine = layoutViewEngine;
            context.selfSize = oldSelfSize;
    
            newSelfSize = [self calcLayoutSize:[self myCalcSizeInNoLayoutSuperview:self.superview currentSize:oldSelfSize] subviewEngines:subviewEngines context:&context];
        }

        newSelfSize = _myCGSizeRound(newSelfSize);
        _useCacheRects = NO;

        static CGFloat sSizeError = 0;
        if (sSizeError == 0) {
            sSizeError = 1 / [UIScreen mainScreen].scale + 0.0001; //误差量。
        }
        //设置子视图的frame并还原
        for (UIView *subview in self.subviews) {
            CGRect sbvOldBounds = subview.bounds;
            CGPoint sbvOldCenter = subview.center;

            LAKLayoutEngine *subviewEngine = subview.myEngine;
            LAKViewTraits *subviewTraits = subviewEngine.currentSizeClass;

            if (subviewEngine.leading != CGFLOAT_MAX && subviewEngine.top != CGFLOAT_MAX && !subviewTraits.noLayout && !subviewTraits.useFrame) {
                if (subviewEngine.width < 0) {
                    subviewEngine.width = 0;
                }
                if (subviewEngine.height < 0) {
                    subviewEngine.height = 0;
                }
                //这里的位置需要进行有效像素的舍入处理，否则可能出现文本框模糊，以及视图显示可能多出一条黑线的问题。
                //原因是当frame中的值不能有效的转化为最小可绘制的物理像素时就会出现模糊，虚化，多出黑线，以及layer处理圆角不圆的情况。
                //所以这里要将frame中的点转化为有效的点。
                //这里之所以将布局子视图的转化方法和一般子视图的转化方法区分开来是因为我们要保证布局子视图不能出现细微的重叠，因为布局子视图有边界线
                //如果有边界线而又出现细微重叠的话，那么边界线将无法正常显示，因此这里做了一个特殊的处理。
                CGRect rect;
                if ([subview isKindOfClass:[LAKBaseLayout class]]) {
                    rect = _myLayoutCGRectRound(subviewEngine.frame);

                    CGRect subviewTempBounds = CGRectMake(sbvOldBounds.origin.x, sbvOldBounds.origin.y, rect.size.width, rect.size.height);

                    if (_myCGFloatErrorEqual(subviewTempBounds.size.width, sbvOldBounds.size.width, sSizeError)) {
                        subviewTempBounds.size.width = sbvOldBounds.size.width;
                    }
                    if (_myCGFloatErrorEqual(subviewTempBounds.size.height, sbvOldBounds.size.height, sSizeError)) {
                        subviewTempBounds.size.height = sbvOldBounds.size.height;
                    }
                    if (_myCGFloatErrorNotEqual(subviewTempBounds.size.width, sbvOldBounds.size.width, sSizeError) ||
                        _myCGFloatErrorNotEqual(subviewTempBounds.size.height, sbvOldBounds.size.height, sSizeError)) {
                        subview.bounds = subviewTempBounds;
                    }
                    CGPoint subviewTempCenter = CGPointMake(rect.origin.x + subview.layer.anchorPoint.x * subviewTempBounds.size.width, rect.origin.y + subview.layer.anchorPoint.y * subviewTempBounds.size.height);

                    if (_myCGFloatErrorEqual(subviewTempCenter.x, sbvOldCenter.x, sSizeError)) {
                        subviewTempCenter.x = sbvOldCenter.x;
                    }
                    if (_myCGFloatErrorEqual(subviewTempCenter.y, sbvOldCenter.y, sSizeError)) {
                        subviewTempCenter.y = sbvOldCenter.y;
                    }
                    if (_myCGFloatErrorNotEqual(subviewTempCenter.x, sbvOldCenter.x, sSizeError) ||
                        _myCGFloatErrorNotEqual(subviewTempCenter.y, sbvOldCenter.y, sSizeError)) {
                        subview.center = subviewTempCenter;
                    }
                } else {
                    rect = _myCGRectRound(subviewEngine.frame);
                    subview.center = CGPointMake(rect.origin.x + subview.layer.anchorPoint.x * rect.size.width, rect.origin.y + subview.layer.anchorPoint.y * rect.size.height);
                    subview.bounds = CGRectMake(sbvOldBounds.origin.x, sbvOldBounds.origin.y, rect.size.width, rect.size.height);
                }
            }

            if (subviewTraits.visibility == LAKVisibility_Gone && !subview.isHidden) {
                subview.bounds = CGRectMake(sbvOldBounds.origin.x, sbvOldBounds.origin.y, 0, 0);
            }

            [subviewEngine reset];
        }

        if (newSelfSize.width != CGFLOAT_MAX && (layoutTraits.widthSizeInner.wrapVal || layoutTraits.heightSizeInner.wrapVal)) {
            //因为布局子视图的新老尺寸计算在上面有两种不同的方法，因此这里需要考虑两种计算的误差值，而这两种计算的误差值是不超过1/屏幕精度的。
            //因此我们认为当二者的值超过误差时我们才认为有尺寸变化。
            BOOL isWidthAlter = _myCGFloatErrorNotEqual(newSelfSize.width, oldSelfSize.width, sSizeError);
            BOOL isHeightAlter = _myCGFloatErrorNotEqual(newSelfSize.height, oldSelfSize.height, sSizeError);

            //如果父视图也是布局视图，并且自己隐藏则不调整自身的尺寸和位置。
            BOOL isAdjustSelf = YES;
            if (self.superview != nil && [self.superview isKindOfClass:[LAKBaseLayout class]]) {
                if ([(LAKViewTraits*)self.myCurrentSizeClass invalid]) {
                    isAdjustSelf = NO;
                }
            }
            if (isAdjustSelf && (isWidthAlter || isHeightAlter)) {
                if (newSelfSize.width < 0) {
                    newSelfSize.width = 0;
                }

                if (newSelfSize.height < 0) {
                    newSelfSize.height = 0;
                }
                if (CGAffineTransformIsIdentity(self.transform)) {
                    CGRect currentFrame = self.frame;
                    if (isWidthAlter && layoutTraits.widthSizeInner.wrapVal) {
                        currentFrame.size.width = newSelfSize.width;
                    }
                    if (isHeightAlter && layoutTraits.heightSizeInner.wrapVal) {
                        currentFrame.size.height = newSelfSize.height;
                    }
                    self.frame = currentFrame;
                } else {
                    CGRect currentBounds = self.bounds;
                    CGPoint currentCenter = self.center;

                    //针对滚动父视图做特殊处理，如果父视图是滚动视图，而且当前的缩放比例不为1时系统会调整中心点的位置，因此这里需要特殊处理。
                    CGFloat superViewZoomScale = 1.0;
                    if ([self.superview isKindOfClass:[UIScrollView class]]) {
                        superViewZoomScale = ((UIScrollView *)self.superview).zoomScale;
                    }
                    if (isWidthAlter && layoutTraits.widthSizeInner.wrapVal) {
                        currentBounds.size.width = newSelfSize.width;
                        currentCenter.x += (newSelfSize.width - oldSelfSize.width) * self.layer.anchorPoint.x * superViewZoomScale;
                    }
                    if (isHeightAlter && layoutTraits.heightSizeInner.wrapVal) {
                        currentBounds.size.height = newSelfSize.height;
                        currentCenter.y += (newSelfSize.height - oldSelfSize.height) * self.layer.anchorPoint.y * superViewZoomScale;
                    }
                    self.bounds = currentBounds;
                    self.center = currentCenter;
                }
            }
        }

        //这里只用width判断的原因是如果newSelfSize被计算成功则size中的所有值都不是CGFLOAT_MAX，所以这里选width只是其中一个代表。
        if (newSelfSize.width != CGFLOAT_MAX) {
            UIView *superview = self.superview;
            //如果自己的父视图是非UIScrollView以及非布局视图。以及自己的宽度或者高度是包裹的，并且如果设置了在父视图居中或者居下或者居右时要在父视图中更新自己的位置。
            if (superview != nil && ![superview isKindOfClass:[LAKBaseLayout class]]) {
                CGPoint centerPonintSelf = self.center;
                CGRect rectSelf = self.bounds;
                CGRect rectSuper = superview.bounds;
                
                //如果自己的父视图是非UIScrollView以及非布局视图。以及自己的宽度或者高度是包裹的时，并且如果设置了在父视图居中或者居下或者居右时要在父视图中更新自己的位置。
                if (![superview isKindOfClass:[UIScrollView class]] && (layoutTraits.widthSizeInner.wrapVal || layoutTraits.heightSizeInner.wrapVal)) {

                    if ([LAKBaseLayout isRTL]) {
                        centerPonintSelf.x = rectSuper.size.width - centerPonintSelf.x;
                    }
                    if (layoutTraits.widthSizeInner.wrapVal) {
                        //如果只设置了右边，或者只设置了居中则更新位置。。
                        if (layoutTraits.centerXPosInner.val != nil) {
                            centerPonintSelf.x = (rectSuper.size.width - rectSelf.size.width) / 2 + self.layer.anchorPoint.x * rectSelf.size.width;

                            centerPonintSelf.x += [layoutTraits.centerXPosInner measureWith:rectSuper.size.width];
                        } else if (layoutTraits.trailingPosInner.val != nil && layoutTraits.leadingPosInner.val == nil) {
                            centerPonintSelf.x = rectSuper.size.width - rectSelf.size.width - [layoutTraits.trailingPosInner measureWith:rectSuper.size.width] + self.layer.anchorPoint.x * rectSelf.size.width;
                        }
                    }

                    if (layoutTraits.heightSizeInner.wrapVal) {
                        if (layoutTraits.centerYPosInner.val != nil) {
                            centerPonintSelf.y = (rectSuper.size.height - rectSelf.size.height) / 2 + [layoutTraits.centerYPosInner measureWith:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                        } else if (layoutTraits.bottomPosInner.val != nil && layoutTraits.topPosInner.val == nil) {
                            //这里可能有坑，在有安全区时。但是先不处理了。
                            centerPonintSelf.y = rectSuper.size.height - rectSelf.size.height - [layoutTraits.bottomPosInner measureWith:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                        }
                    }

                    if ([LAKBaseLayout isRTL]) {
                        centerPonintSelf.x = rectSuper.size.width - centerPonintSelf.x;
                    }
                }

                //如果有变化则只调整自己的center。而不变化
                if (!_myCGPointEqual(self.center, centerPonintSelf)) {
                    self.center = centerPonintSelf;
                }
            }

            //这里处理当布局视图的父视图是非布局父视图，且父视图具有wrap属性时需要调整父视图的尺寸。
            if (superview != nil && ![superview isKindOfClass:[LAKBaseLayout class]]) {
                if (superview.heightSizeInner.wrapVal || superview.widthSizeInner.wrapVal) {
                    //调整父视图的高度和宽度。frame值。
                    CGRect superBounds = superview.bounds;
                    CGPoint superCenter = superview.center;

                    if (superview.heightSizeInner.wrapVal) {
                        superBounds.size.height = [self myValidMeasure:superview.heightSizeInner subview:superview calcSize:layoutTraits.myTop + newSelfSize.height + layoutTraits.myBottom subviewSize:superBounds.size selfLayoutSize:newSelfSize];
                        superCenter.y += (superBounds.size.height - superview.bounds.size.height) * superview.layer.anchorPoint.y;
                    }

                    if (superview.widthSizeInner.wrapVal) {
                        superBounds.size.width = [self myValidMeasure:superview.widthSizeInner subview:superview calcSize:layoutTraits.myLeading + newSelfSize.width + layoutTraits.myTrailing subviewSize:superBounds.size selfLayoutSize:newSelfSize];
                        superCenter.x += (superBounds.size.width - superview.bounds.size.width) * superview.layer.anchorPoint.x;
                    }

                    if (!_myCGRectEqual(superview.bounds, superBounds)) {
                        superview.center = superCenter;
                        superview.bounds = superBounds;
                    }
                }
            }
        }

        self.isMyLayouting = NO;
    }
}

- (void)layoutSubviews {
    if (!self.autoresizesSubviews) {
        return;
    }

    [self doLayoutSubviews];
}

#pragma mark-- Private Methods

- (LAKLayoutEngine *)myEngine {
    if (_myEngine == nil) {
        _myEngine = [LAKLayoutEngine new];
    }
    return _myEngine;
}

- (LAKLayoutEngine *)myEngineInner {
    return _myEngine;
}

- (CGSize)myEstimateLayoutSize:(CGSize)size inSizeClass:(LAKSizeClass)sizeClass subviews:(NSMutableArray<UIView *> *)subviews {
    
    NSArray *tuple = [self myUpdateCurrentSizeClass:sizeClass subviews:subviews];
    LAKLayoutEngine *layoutViewEngine = tuple.firstObject;
    NSMutableArray<LAKLayoutEngine *> *subviewEngines = tuple.lastObject;
    
    
    
    MyLayoutContext context;
    context.isEstimate = YES;
    context.sizeClass = sizeClass;
    context.layoutViewEngine = layoutViewEngine;
    
    if (layoutViewEngine.currentSizeClass.widthSizeInner.numberVal != nil) {
        size.width = MAX(layoutViewEngine.currentSizeClass.widthSizeInner.measure, size.width);
    }
    
    if (layoutViewEngine.currentSizeClass.heightSizeInner.numberVal != nil) {
        size.height = MAX(layoutViewEngine.currentSizeClass.heightSizeInner.measure, size.height);
    }
    
    CGSize selfSize = [self calcLayoutSize:size subviewEngines:subviewEngines context:&context];
    
    layoutViewEngine.width = selfSize.width;
    layoutViewEngine.height = selfSize.height;
    
    return  _myCGSizeRound(selfSize);
}

- (CGFloat)myCalcSubview:(LAKLayoutEngine *)subviewEngine
             vertGravity:(LAKGravity)vertGravity
             baselinePos:(CGFloat)baselinePos
                 withContext:(MyLayoutContext *)context {
    
    LAKViewTraits *subviewTraits = subviewEngine.currentSizeClass;
    UIView *subview = subviewTraits.view;
    CGFloat layoutViewContentHeight = context->selfSize.height - context->paddingTop - context->paddingBottom;

    CGFloat marginTop = [self myValidMargin:subviewTraits.topPosInner subview:subview calcPos:[subviewTraits.topPosInner measureWith:layoutViewContentHeight] selfLayoutSize:context->selfSize];
    CGFloat marginCenter = [self myValidMargin:subviewTraits.centerYPosInner subview:subview calcPos:[subviewTraits.centerYPosInner measureWith:layoutViewContentHeight] selfLayoutSize:context->selfSize];
    CGFloat marginBottom = [self myValidMargin:subviewTraits.bottomPosInner subview:subview calcPos:[subviewTraits.bottomPosInner measureWith:layoutViewContentHeight] selfLayoutSize:context->selfSize];

    //垂直压缩。
    CGFloat fixedHeight = marginTop + marginCenter + marginBottom + subviewEngine.height;
    if (fixedHeight > context->selfSize.height) {
        CGFloat spareHeight = context->selfSize.height - fixedHeight;
        CGFloat totalShrink = subviewTraits.topPosInner.shrink + subviewTraits.centerYPosInner.shrink + subviewTraits.bottomPosInner.shrink + subviewTraits.heightSizeInner.shrink;
        if (totalShrink != 0.0) {
            marginTop += (subviewTraits.topPosInner.shrink / totalShrink) * spareHeight;
            marginCenter += (subviewTraits.centerYPosInner.shrink / totalShrink) * spareHeight;
            marginBottom += (subviewTraits.bottomPosInner.shrink / totalShrink) * spareHeight;
            subviewEngine.height += (subviewTraits.heightSizeInner.shrink / totalShrink) * spareHeight;
        }
    }

    //如果是设置垂直拉伸则，如果子视图有约束则不受影响，否则就变为和填充一个意思。
    if (vertGravity == LAKGravity_Vert_Stretch) {
        if (subviewTraits.heightSizeInner.val != nil && subviewTraits.heightSizeInner.priority != MyPriority_Low) {
            vertGravity = LAKGravity_Vert_Top;
        } else {
            vertGravity = LAKGravity_Vert_Fill;
        }
    }

    //确保设置基线对齐的视图都是UILabel,UITextField,UITextView
    if (baselinePos == CGFLOAT_MAX && vertGravity == LAKGravity_Vert_Baseline) {
        vertGravity = LAKGravity_Vert_Top;
    }
    UIFont *subviewFont = nil;
    if (vertGravity == LAKGravity_Vert_Baseline) {
        subviewFont = [self myGetSubviewFont:subview];
    }
    if (subviewFont == nil && vertGravity == LAKGravity_Vert_Baseline) {
        vertGravity = LAKGravity_Vert_Top;
    }

    if (vertGravity == LAKGravity_Vert_Top) {
        subviewEngine.top = context->paddingTop + marginTop;
    } else if (vertGravity == LAKGravity_Vert_Bottom) {
        subviewEngine.top = context->selfSize.height - context->paddingBottom - marginBottom - subviewEngine.height;
    } else if (vertGravity == LAKGravity_Vert_Baseline) {
        //得到基线位置。
        subviewEngine.top = baselinePos - subviewFont.ascender - (subviewEngine.height - subviewFont.lineHeight) / 2;
    } else if (vertGravity == LAKGravity_Vert_Fill) {
        subviewEngine.top = context->paddingTop + marginTop;
        subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subview calcSize:layoutViewContentHeight - marginTop - marginBottom subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
    } else if (vertGravity == LAKGravity_Vert_Center) {
        subviewEngine.top = (layoutViewContentHeight - marginTop - marginBottom - subviewEngine.height) / 2 + context->paddingTop + marginTop + marginCenter;
    } else if (vertGravity == LAKGravity_Vert_Window_Center) {
        if (self.window != nil) {
            subviewEngine.top = (CGRectGetHeight(self.window.bounds) - marginTop - marginBottom - subviewEngine.height) / 2 + marginTop + marginCenter;
            subviewEngine.top = [self.window convertPoint:subviewEngine.origin toView:self].y;
        }
    }
    return marginTop + marginCenter + marginBottom + subviewEngine.height;
}

- (CGFloat)myCalcSubview:(LAKLayoutEngine *)subviewEngine
             horzGravity:(LAKGravity)horzGravity
                 withContext:(MyLayoutContext *)context {
    
    LAKViewTraits *subviewTraits = subviewEngine.currentSizeClass;
    UIView *subview = subviewTraits.view;
    CGFloat layoutViewContentWidth = context->selfSize.width - context->paddingLeading - context->paddingTrailing;
    CGFloat marginLeading = [self myValidMargin:subviewTraits.leadingPosInner subview:subview calcPos:[subviewTraits.leadingPosInner measureWith:layoutViewContentWidth] selfLayoutSize:context->selfSize];
    CGFloat marginCenter = [self myValidMargin:subviewTraits.centerXPosInner subview:subview calcPos:[subviewTraits.centerXPosInner measureWith:layoutViewContentWidth] selfLayoutSize:context->selfSize];
    CGFloat marginTrailing = [self myValidMargin:subviewTraits.trailingPosInner subview:subview calcPos:[subviewTraits.trailingPosInner measureWith:layoutViewContentWidth] selfLayoutSize:context->selfSize];

    //水平压缩。
    CGFloat fixedWidth = marginLeading + marginCenter + marginTrailing + subviewEngine.width;
    if (fixedWidth > context->selfSize.width) {
        CGFloat spareWidth = context->selfSize.width - fixedWidth;
        CGFloat totalShrink = subviewTraits.leadingPosInner.shrink + subviewTraits.centerXPosInner.shrink + subviewTraits.trailingPosInner.shrink + subviewTraits.widthSizeInner.shrink;
        if (totalShrink != 0.0) {
            marginLeading += (subviewTraits.leadingPosInner.shrink / totalShrink) * spareWidth;
            marginCenter += (subviewTraits.centerXPosInner.shrink / totalShrink) * spareWidth;
            marginTrailing += (subviewTraits.trailingPosInner.shrink / totalShrink) * spareWidth;
            subviewEngine.width += (subviewTraits.widthSizeInner.shrink / totalShrink) * spareWidth;
        }
    }

    //如果是设置水平拉伸则，如果子视图有约束则不受影响，否则就变为和填充一个意思。
    if (horzGravity == LAKGravity_Horz_Stretch) {
        if (subviewTraits.widthSizeInner.val != nil && subviewTraits.widthSizeInner.priority != MyPriority_Low) {
            horzGravity = LAKGravity_Horz_Leading;
        } else {
            horzGravity = LAKGravity_Horz_Fill;
        }
    }

    if (horzGravity == LAKGravity_Horz_Leading) {
        subviewEngine.leading = context->paddingLeading + marginLeading;
    } else if (horzGravity == LAKGravity_Horz_Trailing) {
        subviewEngine.leading = context->selfSize.width - context->paddingTrailing - marginTrailing - subviewEngine.width;
    }
    if (horzGravity == LAKGravity_Horz_Fill) {
        subviewEngine.leading = context->paddingLeading + marginLeading;
        subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subview calcSize:layoutViewContentWidth - marginLeading - marginTrailing subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
    } else if (horzGravity == LAKGravity_Horz_Center) {
        subviewEngine.leading = (layoutViewContentWidth - marginLeading - marginTrailing - subviewEngine.width) / 2 + context->paddingLeading + marginLeading + marginCenter;
    } else if (horzGravity == LAKGravity_Horz_Window_Center) {
        if (self.window != nil) {
            subviewEngine.leading = (CGRectGetWidth(self.window.bounds) - marginLeading - marginTrailing - subviewEngine.width) / 2 + marginLeading + marginCenter;
            subviewEngine.leading = [self.window convertPoint:subviewEngine.origin toView:self].x;

            //因为从右到左布局最后统一进行了转换，但是窗口居中是不按布局来控制的，所以这里为了保持不变需要进行特殊处理。
            if ([LAKBaseLayout isRTL]) {
                subviewEngine.leading = context->selfSize.width - subviewEngine.leading - subviewEngine.width;
            }
        }
    }
    return marginLeading + marginCenter + marginTrailing + subviewEngine.width;
}

- (CGSize)myCalcSizeInNoLayoutSuperview:(UIView *)newSuperview currentSize:(CGSize)size {
    if (newSuperview == nil || [newSuperview isKindOfClass:[LAKBaseLayout class]]) {
        return size;
    }
    CGRect rectSuper = newSuperview.bounds;
    LAKViewTraits *superviewTraits = (LAKViewTraits*)newSuperview.myDefaultSizeClassInner; //非布局父视图只有默认布局样式
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)self.myCurrentSizeClass;

    if (!superviewTraits.widthSizeInner.wrapVal) {
        if (layoutTraits.widthSizeInner.anchorVal.view == newSuperview) {
            if (layoutTraits.widthSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Width) {
                size.width = [layoutTraits.widthSizeInner measureWith:rectSuper.size.width];
            } else {
                size.width = [layoutTraits.widthSizeInner measureWith:rectSuper.size.height];
            }
            size.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:size.width subviewSize:size selfLayoutSize:rectSuper.size];
        } else if (layoutTraits.widthSizeInner.fillVal) {
            size.width = [layoutTraits.widthSizeInner measureWith:rectSuper.size.width];
        }

        if (layoutTraits.leadingPosInner.val != nil && layoutTraits.trailingPosInner.val != nil) {
            if (layoutTraits.widthSizeInner.val == nil || layoutTraits.widthSizeInner.priority == MyPriority_Low) {
                CGFloat marginLeading = [layoutTraits.leadingPosInner measureWith:rectSuper.size.width];
                CGFloat marginTrailing = [layoutTraits.trailingPosInner measureWith:rectSuper.size.width];
                size.width = rectSuper.size.width - marginLeading - marginTrailing;
                size.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:size.width subviewSize:size selfLayoutSize:rectSuper.size];
            }
        }
        if (size.width < 0) {
            size.width = 0;
        }
    }

    if (!superviewTraits.heightSizeInner.wrapVal) {
        if (layoutTraits.heightSizeInner.anchorVal.view == newSuperview) {
            if (layoutTraits.heightSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Height) {
                size.height = [layoutTraits.heightSizeInner measureWith:rectSuper.size.height];
            } else {
                size.height = [layoutTraits.heightSizeInner measureWith:rectSuper.size.width];
            }
            size.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:size.height subviewSize:size selfLayoutSize:rectSuper.size];
        } else if (layoutTraits.heightSizeInner.fillVal) {
            size.height = [layoutTraits.heightSizeInner measureWith:rectSuper.size.height];
        }

        if (layoutTraits.topPosInner.val != nil && layoutTraits.bottomPosInner.val != nil) {
            if (layoutTraits.heightSizeInner.val == nil || layoutTraits.heightSizeInner.priority == MyPriority_Low) {
                CGFloat marginTop = [layoutTraits.topPosInner measureWith:rectSuper.size.height];
                CGFloat marginBottom = [layoutTraits.bottomPosInner measureWith:rectSuper.size.height];
                size.height = rectSuper.size.height - marginTop - marginBottom;
                size.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:size.height subviewSize:size selfLayoutSize:rectSuper.size];
            }
        }
        if (size.height < 0) {
            size.height = 0;
        }
    }
    return size;
}

- (BOOL)myUpdateLayoutRectInNoLayoutSuperview:(UIView *)newSuperview {
    BOOL isAdjust = NO; //这个变量表明是否后续父视图尺寸变化后需要调整更新布局视图的尺寸。

    CGRect rectSuper = newSuperview.bounds;
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits *)self.myCurrentSizeClass;

    CGFloat marginLeading = [layoutTraits.leadingPosInner measureWith:rectSuper.size.width];
    CGFloat marginTrailing = [layoutTraits.trailingPosInner measureWith:rectSuper.size.width];
    CGFloat marginTop = [layoutTraits.topPosInner measureWith:rectSuper.size.height];
    CGFloat marginBottom = [layoutTraits.bottomPosInner measureWith:rectSuper.size.height];
    CGRect rectSelf = self.bounds;

    //针对滚动父视图做特殊处理，如果父视图是滚动视图，而且当前的缩放比例不为1时系统会调整中心点的位置，因此这里需要特殊处理。
    CGFloat superViewZoomScale = 1.0;
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        superViewZoomScale = ((UIScrollView *)newSuperview).zoomScale;
    }
    //得到在设置center后的原始值。
    rectSelf.origin.x = self.center.x - rectSelf.size.width * self.layer.anchorPoint.x * superViewZoomScale;
    rectSelf.origin.y = self.center.y - rectSelf.size.height * self.layer.anchorPoint.y * superViewZoomScale;
    CGRect oldRectSelf = rectSelf;

    //确定左右边距和宽度。
    if (layoutTraits.widthSizeInner.val != nil) {
        if (layoutTraits.widthSizeInner.anchorVal != nil) {
            if (layoutTraits.widthSizeInner.anchorVal.view == newSuperview) {
                isAdjust = YES;

                if (layoutTraits.widthSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Width) {
                    rectSelf.size.width = [layoutTraits.widthSizeInner measureWith:rectSuper.size.width];
                } else {
                    rectSelf.size.width = [layoutTraits.widthSizeInner measureWith:rectSuper.size.height];
                }
            } else {
                rectSelf.size.width = [layoutTraits.widthSizeInner measureWith:layoutTraits.widthSizeInner.anchorVal.view.myEstimatedWidth];
            }
        } else if (layoutTraits.widthSizeInner.numberVal != nil) {
            rectSelf.size.width = layoutTraits.widthSizeInner.measure;
        } else if (layoutTraits.widthSizeInner.fillVal) {
            isAdjust = YES;
            rectSelf.size.width = [layoutTraits.widthSizeInner measureWith:rectSuper.size.width];
        }
    }

    //这里要判断自己的宽度设置了最小和最大宽度依赖于父视图的情况。如果有这种情况，则父视图在变化时也需要调整自身。
    if (layoutTraits.widthSizeInner.lBoundValInner.anchorVal.view == newSuperview || layoutTraits.widthSizeInner.uBoundValInner.anchorVal.view == newSuperview) {
        isAdjust = YES;
    }

    rectSelf.size.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:rectSelf.size.width subviewSize:rectSelf.size selfLayoutSize:rectSuper.size];

    if ([LAKBaseLayout isRTL]) {
        rectSelf.origin.x = rectSuper.size.width - rectSelf.origin.x - rectSelf.size.width;
    }
    if (layoutTraits.leadingPosInner.val != nil && layoutTraits.trailingPosInner.val != nil) {
        isAdjust = YES;
        //如果宽度约束的优先级很低都按左右边距来决定布局视图的宽度。
        if (layoutTraits.widthSizeInner.priority == MyPriority_Low) {
            [layoutTraits.widthSizeInner _myEqualTo:nil];
        }
        if (layoutTraits.widthSizeInner.val == nil) {
            rectSelf.size.width = rectSuper.size.width - marginLeading - marginTrailing;
            rectSelf.size.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:rectSelf.size.width subviewSize:rectSelf.size selfLayoutSize:rectSuper.size];
        }
        rectSelf.origin.x = marginLeading;
    } else if (layoutTraits.centerXPosInner.val != nil) {
        isAdjust = YES;
        rectSelf.origin.x = (rectSuper.size.width - rectSelf.size.width) / 2;
        rectSelf.origin.x += [layoutTraits.centerXPosInner measureWith:rectSuper.size.width];
    } else if (layoutTraits.leadingPosInner.val != nil) {
        rectSelf.origin.x = marginLeading;
    } else if (layoutTraits.trailingPosInner.val != nil) {
        isAdjust = YES;
        rectSelf.origin.x = rectSuper.size.width - rectSelf.size.width - marginTrailing;
    }

    if (layoutTraits.heightSizeInner.val != nil) {
        if (layoutTraits.heightSizeInner.anchorVal != nil) {
            if (layoutTraits.heightSizeInner.anchorVal.view == newSuperview) {
                isAdjust = YES;
                if (layoutTraits.heightSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Height) {
                    rectSelf.size.height = [layoutTraits.heightSizeInner measureWith:rectSuper.size.height];
                } else {
                    rectSelf.size.height = [layoutTraits.heightSizeInner measureWith:rectSuper.size.width];
                }
            } else {
                rectSelf.size.height = [layoutTraits.heightSizeInner measureWith:layoutTraits.heightSizeInner.anchorVal.view.myEstimatedHeight];
            }
        } else if (layoutTraits.heightSizeInner.numberVal != nil) {
            rectSelf.size.height = layoutTraits.heightSizeInner.measure;
        } else if (layoutTraits.heightSizeInner.fillVal) {
            isAdjust = YES;
            rectSelf.size.height = [layoutTraits.heightSizeInner measureWith:rectSuper.size.height];
        }
    }

    //这里要判断自己的高度设置了最小和最大高度依赖于父视图的情况。如果有这种情况，则父视图在变化时也需要调整自身。
    if (layoutTraits.heightSizeInner.lBoundValInner.anchorVal.view == newSuperview || layoutTraits.heightSizeInner.uBoundValInner.anchorVal.view == newSuperview) {
        isAdjust = YES;
    }

    rectSelf.size.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:rectSelf.size.height subviewSize:rectSelf.size selfLayoutSize:rectSuper.size];

    if (layoutTraits.topPosInner.val != nil && layoutTraits.bottomPosInner.val != nil) {
        isAdjust = YES;
        //如果高度约束优先级很低则按上下边距来决定布局视图高度。
        if (layoutTraits.heightSizeInner.priority == MyPriority_Low) {
            [layoutTraits.heightSizeInner _myEqualTo:nil];
        }

        if (layoutTraits.heightSizeInner.val == nil) {
            rectSelf.size.height = rectSuper.size.height - marginTop - marginBottom;
            rectSelf.size.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:rectSelf.size.height subviewSize:rectSelf.size selfLayoutSize:rectSuper.size];
        }
        rectSelf.origin.y = marginTop;
    } else if (layoutTraits.centerYPosInner.val != nil) {
        isAdjust = YES;
        rectSelf.origin.y = (rectSuper.size.height - rectSelf.size.height) / 2 + [layoutTraits.centerYPosInner measureWith:rectSuper.size.height];
    } else if (layoutTraits.topPosInner.val != nil) {
        rectSelf.origin.y = marginTop;
    } else if (layoutTraits.bottomPosInner.val != nil) {
        isAdjust = YES;
        rectSelf.origin.y = rectSuper.size.height - rectSelf.size.height - marginBottom;
    }

    if ([LAKBaseLayout isRTL]) {
        rectSelf.origin.x = rectSuper.size.width - rectSelf.origin.x - rectSelf.size.width;
    }
    rectSelf = _myCGRectRound(rectSelf);
    if (!_myCGRectEqual(rectSelf, oldRectSelf)) {
        if (rectSelf.size.width < 0) {
            rectSelf.size.width = 0;
        }
        if (rectSelf.size.height < 0) {
            rectSelf.size.height = 0;
        }
        if (CGAffineTransformIsIdentity(self.transform)) {
            self.frame = rectSelf;
        } else {
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, rectSelf.size.width, rectSelf.size.height);
            self.center = CGPointMake(rectSelf.origin.x + self.layer.anchorPoint.x * rectSelf.size.width * superViewZoomScale, rectSelf.origin.y + self.layer.anchorPoint.y * rectSelf.size.height * superViewZoomScale);
        }
    } else if (layoutTraits.widthSizeInner.wrapVal || layoutTraits.heightSizeInner.wrapVal) {
        [self setNeedsLayout];
    }
    return isAdjust;
}

- (CGFloat)mySubview:(LAKViewTraits *)subviewTraits wrapHeightSizeFits:(CGSize)size withContext:(MyLayoutContext *)context {
    UIView *subview = subviewTraits.view;
    
    CGFloat height = 0.0;
    
    if (![subviewTraits.view isKindOfClass:[LAKBaseLayout class]]) {
        
        height = [subview sizeThatFits:CGSizeMake(size.width, 0)].height;
        if ([subview isKindOfClass:[UIImageView class]]) {
            //根据图片的尺寸进行等比缩放得到合适的高度。
            if (!subviewTraits.widthSizeInner.wrapVal) {
                UIImage *img = ((UIImageView *)subview).image;
                if (img != nil && img.size.width != 0) {
                    height = img.size.height * (size.width / img.size.width);
                }
            }
        } else if ([subview isKindOfClass:[UIButton class]]) {
            //按钮特殊处理多行的。。
            UIButton *button = (UIButton *)subview;
            if (button.titleLabel != nil) {
                //得到按钮本身的高度，以及单行文本的高度，这样就能算出按钮和文本的间距
                CGSize buttonSize = [button sizeThatFits:CGSizeMake(0, 0)];
                CGSize buttonTitleSize = [button.titleLabel sizeThatFits:CGSizeMake(0, 0)];
                CGSize sz = [button.titleLabel sizeThatFits:CGSizeMake(size.width, 0)];
                height = sz.height + buttonSize.height - buttonTitleSize.height; //这个sz只是纯文本的高度，所以要加上原先按钮和文本的高度差。。
            }
        }
        
    } else if (context->isEstimate) {
        //只有在评估时才这么处理。
        LAKBaseLayout *sublayout = (LAKBaseLayout*)subviewTraits.view;
        height = [sublayout sizeThatFits:CGSizeMake(size.width, 0) inSizeClass:context->sizeClass].height;
    } else {
        height = size.height;
    }
    return [subviewTraits.heightSizeInner measureWith:height];
}

- (CGFloat)myGetBoundLimitMeasure:(LAKLayoutSize *)anchor subview:(UIView *)subview anchorType:(MyLayoutAnchorType)anchorType subviewSize:(CGSize)subviewSize selfLayoutSize:(CGSize)selfLayoutSize isUBound:(BOOL)isUBound {
    CGFloat value = isUBound ? CGFLOAT_MAX : -CGFLOAT_MAX;
    if (anchor == nil || !anchor.isActive || anchor.valType == MyLayoutValType_Nil) {
        return value;
    }
    MyLayoutValType valType = anchor.valType;
    if (valType == MyLayoutValType_Number) {
        value = anchor.numberVal.doubleValue;
    } else if (valType == MyLayoutValType_LayoutSize) {
        if (anchor.anchorVal.view == self) {
            if (anchor.anchorVal.anchorType == MyLayoutAnchorType_Width) {
                value = selfLayoutSize.width - (self.myLayoutPaddingLeading + self.myLayoutPaddingTrailing);
            } else {
                value = selfLayoutSize.height - (self.myLayoutPaddingTop + self.myLayoutPaddingBottom);
            }
        } else if (anchor.anchorVal.view == subview) {
            if (anchor.anchorVal.anchorType == anchorType) {
                //约束冲突：无效的边界设置方法
                NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting", subview);
            } else {
                if (anchor.anchorVal.anchorType == MyLayoutAnchorType_Width) {
                    value = subviewSize.width;
                } else {
                    value = subviewSize.height;
                }
            }
        } else {
            if (anchor.anchorVal.anchorType == MyLayoutAnchorType_Width) {
                value = anchor.anchorVal.view.myEstimatedWidth;
            } else {
                value = anchor.anchorVal.view.myEstimatedHeight;
            }
        }

    } else if (valType == MyLayoutValType_Wrap) {
        if (anchorType == MyLayoutAnchorType_Width) {
            value = subviewSize.width;
        } else {
            value = subviewSize.height;
        }
    } else {
        //约束冲突：无效的边界设置方法
        NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting", subview);
    }

    if (value == CGFLOAT_MAX || value == -CGFLOAT_MAX) {
        return value;
    }
    return [anchor measureWith:value];
}

- (CGFloat)myValidMeasure:(LAKLayoutSize *)anchor subview:(UIView *)subview calcSize:(CGFloat)calcSize subviewSize:(CGSize)subviewSize selfLayoutSize:(CGSize)selfLayoutSize {
    if (calcSize < 0.0) {
        calcSize = 0.0;
    }
    if (anchor == nil) {
        return calcSize;
    }
    //算出最大最小值。
    if (anchor.isActive) {
        if (anchor.lBoundValInner != nil || anchor.uBoundValInner != nil) {
            CGFloat min = [self myGetBoundLimitMeasure:anchor.lBoundValInner subview:subview anchorType:anchor.anchorType subviewSize:subviewSize selfLayoutSize:selfLayoutSize isUBound:NO];
            CGFloat max = [self myGetBoundLimitMeasure:anchor.uBoundValInner subview:subview anchorType:anchor.anchorType subviewSize:subviewSize selfLayoutSize:selfLayoutSize isUBound:YES];
            
            calcSize = _myCGFloatMax(min, calcSize);
            calcSize = _myCGFloatMin(max, calcSize);
        }
    }
    return calcSize;
}

- (CGFloat)myGetBound:(LAKLayoutPos *)anchor limitMarginOfSubview:(UIView *)subview {
    CGFloat value = 0;
    if (anchor == nil) {
        return value;
    }
    MyLayoutValType valType = anchor.valType;
    if (valType == MyLayoutValType_Number) {
        value = anchor.numberVal.doubleValue;
    } else if (valType == MyLayoutValType_LayoutPos) {
        CGRect rect = anchor.anchorVal.view.myEngine.frame;
        MyLayoutAnchorType anchorType = anchor.anchorVal.anchorType;
        if (anchorType == MyLayoutAnchorType_Leading) {
            if (rect.origin.x != CGFLOAT_MAX) {
                value = CGRectGetMinX(rect);
            }
        } else if (anchorType == MyLayoutAnchorType_CenterX) {
            if (rect.origin.x != CGFLOAT_MAX) {
                value = CGRectGetMidX(rect);
            }
        } else if (anchorType == MyLayoutAnchorType_Trailing) {
            if (rect.origin.x != CGFLOAT_MAX) {
                value = CGRectGetMaxX(rect);
            }
        } else if (anchorType == MyLayoutAnchorType_Top) {
            if (rect.origin.y != CGFLOAT_MAX) {
                value = CGRectGetMinY(rect);
            }
        } else if (anchorType == MyLayoutAnchorType_CenterY) {
            if (rect.origin.y != CGFLOAT_MAX) {
                value = CGRectGetMidY(rect);
            }
        } else if (anchorType == MyLayoutAnchorType_Bottom) {
            if (rect.origin.y != CGFLOAT_MAX) {
                value = CGRectGetMaxY(rect);
            }
        }
    } else {
        //约束冲突：无效的边界设置方法
        NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting", subview);
    }
    return value + anchor.offsetVal;
}

- (CGFloat)myValidMargin:(LAKLayoutPos *)anchor subview:(UIView *)subview calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize {
    if (anchor == nil) {
        return calcPos;
    }
    //算出最大最小值
    if (anchor.isActive) {
        if (anchor.lBoundValInner != nil || anchor.uBoundValInner != nil) {
            CGFloat min = (anchor.lBoundValInner != nil) ? [self myGetBound:anchor.lBoundValInner limitMarginOfSubview:subview] : -CGFLOAT_MAX;
            CGFloat max = (anchor.uBoundValInner != nil) ? [self myGetBound:anchor.uBoundValInner limitMarginOfSubview:subview] : CGFLOAT_MAX;
            
            calcPos = _myCGFloatMax(min, calcPos);
            calcPos = _myCGFloatMin(max, calcPos);
        }
    }
    return calcPos;
}

- (NSArray *)myUpdateCurrentSizeClass:(LAKSizeClass)sizeClass subviews:(NSArray<UIView *> *)subviews {
    
    LAKLayoutEngine *layoutViewEngine = self.myEngine;
    layoutViewEngine.currentSizeClass = (LAKViewTraits*)[self fetchLayoutSizeClass:sizeClass];
    
    if (subviews == nil) {
        subviews = self.subviews;
    }
    NSMutableArray<LAKLayoutEngine *> *subviewEngines = [NSMutableArray arrayWithCapacity:subviews.count];
    for (UIView *subview in subviews) {
        LAKLayoutEngine *subviewEngine = subview.myEngine;
        subviewEngine.currentSizeClass = (LAKViewTraits*)[subview fetchLayoutSizeClass:sizeClass];
        [subviewEngines addObject:subviewEngine];
    }
    
    return @[layoutViewEngine, subviewEngines];
}

- (CGSize)myAdjustLayoutViewSizeWithContext:(MyLayoutContext *)context {
    
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    
    //调整布局视图自己的尺寸。
    context->selfSize.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:context->selfSize.height subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];

    context->selfSize.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:context->selfSize.width subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];

    //对所有子视图进行RTL设置
    if ([LAKBaseLayout isRTL]) {
        for (LAKLayoutEngine *subviewEngine in context->subviewEngines) {
            subviewEngine.leading = context->selfSize.width - subviewEngine.leading - subviewEngine.width;
            subviewEngine.trailing = subviewEngine.leading + subviewEngine.width;
        }
    }

    //如果没有子视图，并且padding不参与空子视图尺寸计算则尺寸应该扣除padding的值。
    if (context->subviewEngines.count == 0 && !layoutTraits.zeroPadding) {
        if (layoutTraits.widthSizeInner.wrapVal) {
            context->selfSize.width -= (context->paddingLeading + context->paddingTrailing);
        }
        if (layoutTraits.heightSizeInner.wrapVal) {
            context->selfSize.height -= (context->paddingTop + context->paddingBottom);
        }
    }
    return context->selfSize;
}

- (UIFont *)myGetSubviewFont:(UIView *)subview {
    UIFont *subviewFont = nil;
    if ([subview isKindOfClass:[UILabel class]] ||
        [subview isKindOfClass:[UITextField class]] ||
        [subview isKindOfClass:[UITextView class]] ||
        [subview isKindOfClass:[UIButton class]]) {
        subviewFont = [subview valueForKey:@"font"];
    }
    return subviewFont;
}

- (CGFloat)myLayoutPaddingTop {
    return self.myCurrentSizeClass.myLayoutPaddingTop;
}
- (CGFloat)myLayoutPaddingBottom {
    return self.myCurrentSizeClass.myLayoutPaddingBottom;
}
- (CGFloat)myLayoutPaddingLeft {
    return self.myCurrentSizeClass.myLayoutPaddingLeft;
}
- (CGFloat)myLayoutPaddingRight {
    return self.myCurrentSizeClass.myLayoutPaddingRight;
}
- (CGFloat)myLayoutPaddingLeading {
    return self.myCurrentSizeClass.myLayoutPaddingLeading;
}
- (CGFloat)myLayoutPaddingTrailing {
    return self.myCurrentSizeClass.myLayoutPaddingTrailing;
}

LAKSizeClass _myGlobalSizeClass = 0xFF;

#if TARGET_OS_IOS
- (UIDeviceOrientation)myGetDeviceOrientation {
    UIDeviceOrientation devOri = UIDeviceOrientationPortrait;
    UIInterfaceOrientation intOri = UIInterfaceOrientationUnknown;
    
    //先用界面方向，再用设备方向。这样可以处理一些强制屏幕旋转的问题。
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 130000)
    if (@available(iOS 13.0, *)) {
        intOri = self.window.windowScene.interfaceOrientation;
    } else
#endif
    {   //因为App Extension 中不支持 sharedApplication 所以这里要特殊处理。
        BOOL isApp = [UIApplication respondsToSelector:@selector(sharedApplication)];
        if (isApp) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
#pragma clang diagnostic pop
            intOri = application.statusBarOrientation;
        }
    }
    
    if (intOri != UIInterfaceOrientationUnknown) {
        devOri = (UIDeviceOrientation)intOri;
    } else {
        devOri = [UIDevice currentDevice].orientation;
    }
    
    return devOri;
}
#endif

//获取全局的当前的SizeClass,减少获取次数的调用。
- (LAKSizeClass)myGetGlobalSizeClass {
    //找到最根部的父视图。
    if (_myGlobalSizeClass == 0xFF || ![self.superview isKindOfClass:[LAKBaseLayout class]]) {
        LAKSizeClass sizeClass = (LAKSizeClass)((self.traitCollection.verticalSizeClass << 2) | self.traitCollection.horizontalSizeClass);
#if TARGET_OS_IOS
        UIDeviceOrientation ori = [self myGetDeviceOrientation];
        if (UIDeviceOrientationIsPortrait(ori)) {
            sizeClass |= LAKSizeClass_Portrait;
        } else if (UIDeviceOrientationIsLandscape(ori)) {
            sizeClass |= LAKSizeClass_Landscape;
        } else { //如果 ori == UIDeviceOrientationUnknown 的话, 默认给竖屏设置
            //当方向为未知时，尝试得到VC的方向，而不是设置默认方向。
            sizeClass |= LAKSizeClass_Portrait;
        }
#endif
        _myGlobalSizeClass = sizeClass;
    }
    return _myGlobalSizeClass;
}

- (void)myRemoveSubviewObserver:(UIView *)subview {
    LAKLayoutEngine *subviewEngine = subview.myEngineInner;
    if (subviewEngine != nil) {
        if (subviewEngine.hasObserver) {
            subviewEngine.hasObserver = NO;
            if (![subview isKindOfClass:[LAKBaseLayout class]]) {
                [subview removeObserver:self forKeyPath:@"hidden"];
                [subview removeObserver:self forKeyPath:@"frame"];

                if ([subview isKindOfClass:[UIScrollView class]]) {
                    [subview removeObserver:self forKeyPath:@"center"];
                } else if ([subview isKindOfClass:[UILabel class]]) {
                    [subview removeObserver:self forKeyPath:@"text"];
                    [subview removeObserver:self forKeyPath:@"attributedText"];
                }
            }
        }
    }
}

- (void)myAddSubviewObserver:(UIView *)subview {
    //非布局子视图添加hidden, frame的属性变化通知。
    if (![subview isKindOfClass:[LAKBaseLayout class]]) {
        [subview addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:_myObserverContextA];
        [subview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:_myObserverContextA];
        if ([subview isKindOfClass:[UIScrollView class]]) { //如果是UIScrollView则需要特殊监听center属性
            //有时候我们可能会把滚动视图加入到布局视图中去，滚动视图的尺寸有可能设置为高度自适应,这样就会调整center。从而需要重新激发滚动视图的布局
            //这也就是为什么只监听center的原因了。
            [subview addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:_myObserverContextA];
        } else if ([subview isKindOfClass:[UILabel class]]) { //如果是UILabel则监听text和attributedText属性
            [subview addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:_myObserverContextB];
            [subview addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:_myObserverContextB];
        }
    }
}

- (void)myAdjustSizeSettingOfSubviewEngine:(LAKLayoutEngine *)subviewEngine withContext:(MyLayoutContext *)context {
    
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    LAKViewTraits *subviewTraits = subviewEngine.currentSizeClass;
    UIView *subview = subviewTraits.view;

    if (!context->isEstimate) {
        subviewEngine.frame = CGRectMake(0, 0, CGRectGetWidth(subview.bounds), CGRectGetHeight(subview.bounds));
    }
    //只要子视图是包裹并且布局视图是fill填充，都应该清除子视图的包裹设置。
    if (subviewTraits.widthSizeInner.wrapVal && context->horzGravity == LAKGravity_Horz_Fill) {
        [subviewTraits.widthSizeInner _myEqualTo:nil];
    }
    if (subviewTraits.heightSizeInner.wrapVal && context->vertGravity == LAKGravity_Vert_Fill) {
        [subviewTraits.heightSizeInner _myEqualTo:nil];
    }
    if (subviewTraits.leadingPosInner.val != nil &&
        subviewTraits.trailingPosInner.val != nil &&
        (subviewTraits.widthSizeInner.priority == MyPriority_Low || !layoutTraits.widthSizeInner.wrapVal)) {
        [subviewTraits.widthSizeInner _myEqualTo:nil];
    }
    if (subviewTraits.topPosInner.val != nil &&
        subviewTraits.bottomPosInner.val != nil &&
        (subviewTraits.heightSizeInner.priority == MyPriority_Low || !layoutTraits.heightSizeInner.wrapVal)) {
        [subviewTraits.heightSizeInner _myEqualTo:nil];
    }
    if ([subview isKindOfClass:[LAKBaseLayout class]]) {
        
        if (context->isEstimate && (subviewTraits.heightSizeInner.wrapVal || subviewTraits.widthSizeInner.wrapVal)) {
            [(LAKBaseLayout *)subview sizeThatFits:subviewEngine.size inSizeClass:context->sizeClass];
        }
    }
}

- (CGFloat)myWidthSizeValueOfSubviewEngine:(LAKLayoutEngine *)subviewEngine
                               withContext:(MyLayoutContext *)context {
    
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    LAKViewTraits *subviewTraits = subviewEngine.currentSizeClass;
    CGFloat retVal = subviewEngine.width;
    LAKLayoutSize *sbvWidthSizeInner = subviewTraits.widthSizeInner;
    if (sbvWidthSizeInner.numberVal != nil) { //宽度等于固定的值。
        retVal = sbvWidthSizeInner.measure;
    } else if (sbvWidthSizeInner.anchorVal != nil && sbvWidthSizeInner.anchorVal.view != subviewTraits.view) { //宽度等于其他的依赖的视图。
        if (sbvWidthSizeInner.anchorVal == layoutTraits.widthSizeInner) {
            retVal = [sbvWidthSizeInner measureWith:context->selfSize.width - context->paddingLeading - context->paddingTrailing];
        } else if (sbvWidthSizeInner.anchorVal == layoutTraits.heightSizeInner) {
            retVal = [sbvWidthSizeInner measureWith:context->selfSize.height - context->paddingTop - context->paddingBottom];
        } else {
            if (sbvWidthSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Width) {
                retVal = [sbvWidthSizeInner measureWith:sbvWidthSizeInner.anchorVal.view.myEstimatedWidth];
            } else {
                retVal = [sbvWidthSizeInner measureWith:sbvWidthSizeInner.anchorVal.view.myEstimatedHeight];
            }
        }
    } else if (sbvWidthSizeInner.fillVal) {
        retVal = [sbvWidthSizeInner measureWith:context->selfSize.width - context->paddingLeading - context->paddingTrailing];
    } else if (sbvWidthSizeInner.wrapVal) {
        if (![subviewTraits.view isKindOfClass:[LAKBaseLayout class]]) {
            retVal = [sbvWidthSizeInner measureWith:[subviewTraits.view sizeThatFits:CGSizeMake(0, subviewEngine.height)].width];
        } else if (context->isEstimate) {
            LAKBaseLayout *sublayout = (LAKBaseLayout*)subviewTraits.view;
            retVal = [sublayout sizeThatFits:subviewEngine.size inSizeClass:context->sizeClass].width;
            retVal = [sbvWidthSizeInner measureWith:retVal];
        }
    }
    return retVal;
}

- (CGFloat)myHeightSizeValueOfSubviewEngine:(LAKLayoutEngine *)subviewEngine
                                withContext:(MyLayoutContext *)context {
    
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    LAKViewTraits *subviewTraits = subviewEngine.currentSizeClass;
    LAKLayoutSize *subviewHeightSizeInner = subviewTraits.heightSizeInner;

    CGFloat contentWidth = context->selfSize.width - context->paddingLeading - context->paddingTrailing;
    CGFloat contentHeight = context->selfSize.height - context->paddingTop - context->paddingBottom;
    
    CGFloat retVal = subviewEngine.height;
    if (subviewHeightSizeInner.numberVal != nil) { //高度等于固定的值。
        retVal = subviewHeightSizeInner.measure;
    } else if (subviewHeightSizeInner.anchorVal != nil && subviewHeightSizeInner.anchorVal.view != subviewTraits.view) { //高度等于其他依赖的视图
        if (subviewHeightSizeInner.anchorVal == layoutTraits.heightSizeInner) {
            retVal = [subviewHeightSizeInner measureWith:contentHeight];
        } else if (subviewHeightSizeInner.anchorVal == layoutTraits.widthSizeInner) {
            retVal = [subviewHeightSizeInner measureWith:contentWidth];
        } else {
            if (subviewHeightSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Width) {
                retVal = [subviewHeightSizeInner measureWith:subviewHeightSizeInner.anchorVal.view.myEstimatedWidth];
            } else {
                retVal = [subviewHeightSizeInner measureWith:subviewHeightSizeInner.anchorVal.view.myEstimatedHeight];
            }
        }
    } else if (subviewHeightSizeInner.fillVal) {
        retVal = [subviewHeightSizeInner measureWith:contentHeight];
    } else if (subviewHeightSizeInner.wrapVal) {
        retVal = [self mySubview:subviewTraits wrapHeightSizeFits:subviewEngine.size withContext:context];
    }
    return retVal;
}

- (void)myCalcRectOfSubviewEngine:(LAKLayoutEngine *)subviewEngine
                     pMaxWrapSize:(CGSize *)pMaxWrapSize
                      withContext:(MyLayoutContext *)context {
    
    LAKLayoutTraits *layoutTraits = (LAKLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    LAKViewTraits *subviewTraits = subviewEngine.currentSizeClass;
    
    subviewEngine.width = [self myWidthSizeValueOfSubviewEngine:subviewEngine withContext:context];
    subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
    [self myCalcSubview:subviewEngine horzGravity:[subviewTraits finalHorzGravityFrom:context->horzGravity] withContext:context];

    subviewEngine.height = [self myHeightSizeValueOfSubviewEngine:subviewEngine withContext:context];

    subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
    [self myCalcSubview:subviewEngine vertGravity:[subviewTraits finalVertGravityFrom:context->vertGravity] baselinePos:CGFLOAT_MAX withContext:context];

    //特殊处理宽度等于高度
    if (subviewTraits.widthSizeInner.anchorVal.view == subviewTraits.view && subviewTraits.widthSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Height) {
        subviewEngine.width = [subviewTraits.widthSizeInner measureWith:subviewEngine.height];
        subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];

        [self myCalcSubview:subviewEngine horzGravity:[subviewTraits finalHorzGravityFrom:context->horzGravity] withContext:context];
    }

    //特殊处理高度等于宽度。
    if (subviewTraits.heightSizeInner.anchorVal.view == subviewTraits.view && subviewTraits.heightSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Width) {
        subviewEngine.height = [subviewTraits.heightSizeInner measureWith:subviewEngine.width];

        if (subviewTraits.heightSizeInner.wrapVal) {
            subviewEngine.height = [self mySubview:subviewTraits wrapHeightSizeFits:subviewEngine.size withContext:context];
        }
        subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        [self myCalcSubview:subviewEngine vertGravity:[subviewTraits finalVertGravityFrom:context->vertGravity] baselinePos:CGFLOAT_MAX withContext:context];
    }
    
    subviewEngine.bottom = subviewEngine.top + subviewEngine.height;
    subviewEngine.trailing = subviewEngine.leading + subviewEngine.width;

    if (pMaxWrapSize != NULL) {
        if (layoutTraits.widthSizeInner.wrapVal) {
            //如果同时设置左右边界则左右边界为最小的宽度
            if (subviewTraits.leadingPosInner.val != nil && subviewTraits.trailingPosInner.val != nil) {
                if (_myCGFloatLess(pMaxWrapSize->width, subviewTraits.leadingPosInner.measure + subviewTraits.trailingPosInner.measure + context->paddingLeading + context->paddingTrailing)) {
                    pMaxWrapSize->width = subviewTraits.leadingPosInner.measure + subviewTraits.trailingPosInner.measure + context->paddingLeading + context->paddingTrailing;
                }
            }

            //宽度不依赖布局则参与最大宽度计算。
            if ((subviewTraits.widthSizeInner.anchorVal == nil || subviewTraits.widthSizeInner.anchorVal != layoutTraits.widthSizeInner) && !subviewTraits.widthSizeInner.fillVal) {
                if (_myCGFloatLess(pMaxWrapSize->width, subviewEngine.width + subviewTraits.leadingPosInner.measure + subviewTraits.centerXPosInner.measure + subviewTraits.trailingPosInner.measure + context->paddingLeading + context->paddingTrailing)) {
                    pMaxWrapSize->width = subviewEngine.width + subviewTraits.leadingPosInner.measure + subviewTraits.centerXPosInner.measure + subviewTraits.trailingPosInner.measure + context->paddingLeading + context->paddingTrailing;
                }
                //只有不居中和底部对齐才比较底部。
                if (subviewTraits.centerXPosInner.val == nil &&
                    subviewTraits.trailingPosInner.val == nil &&
                    _myCGFloatLess(pMaxWrapSize->width, subviewEngine.trailing + subviewTraits.trailingPosInner.measure + context->paddingTrailing)) {
                    pMaxWrapSize->width = subviewEngine.trailing + subviewTraits.trailingPosInner.measure + context->paddingTrailing;
                }
            }
        }

        if (layoutTraits.heightSizeInner.wrapVal) {
            //如果同时设置上下边界则上下边界为最小的高度
            if (subviewTraits.topPosInner.val != nil && subviewTraits.bottomPosInner.val != nil) {
                if (_myCGFloatLess(pMaxWrapSize->height, subviewTraits.topPosInner.measure + subviewTraits.bottomPosInner.measure + context->paddingTop + context->paddingBottom)) {
                    pMaxWrapSize->height = subviewTraits.topPosInner.measure + subviewTraits.bottomPosInner.measure + context->paddingTop + context->paddingBottom;
                }
            }

            //高度不依赖布局则参与最大高度计算。
            if ((subviewTraits.heightSizeInner.anchorVal == nil || subviewTraits.heightSizeInner.anchorVal != layoutTraits.heightSizeInner) && !subviewTraits.heightSizeInner.fillVal) {
                if (_myCGFloatLess(pMaxWrapSize->height, subviewEngine.height + subviewTraits.topPosInner.measure + subviewTraits.centerYPosInner.measure + subviewTraits.bottomPosInner.measure + context->paddingTop + context->paddingBottom)) {
                    pMaxWrapSize->height = subviewEngine.height + subviewTraits.topPosInner.measure + subviewTraits.centerYPosInner.measure + subviewTraits.bottomPosInner.measure + context->paddingTop + context->paddingBottom;
                }

                //只有在不居中对齐和底部对齐时才比较底部。
                if (subviewTraits.centerYPosInner.val == nil &&
                    subviewTraits.bottomPosInner.val == nil &&
                    _myCGFloatLess(pMaxWrapSize->height, subviewEngine.bottom + subviewTraits.bottomPosInner.measure + context->paddingBottom)) {
                    pMaxWrapSize->height = subviewEngine.bottom + subviewTraits.bottomPosInner.measure + context->paddingBottom;
                }
            }
        }
    }
}

- (void)myInvalidateIntrinsicContentSize {
//    if (!self.translatesAutoresizingMaskIntoConstraints) {
//        if (self.widthSizeInner.wrapVal || self.heightSizeInner.wrapVal) {
//            [self invalidateIntrinsicContentSize];
//        }
//    }
}

- (void)myCalcSubviewsWrapContentSize:(MyLayoutContext *)context withCustomSetting:(void (^)(LAKViewTraits *subviewTraits))customSetting {
    for (LAKLayoutEngine *subviewEngine in context->subviewEngines) {
        LAKViewTraits *subviewTraits = subviewEngine.currentSizeClass;
        UIView *subview = subviewTraits.view;

        if (customSetting != nil) {
            customSetting(subviewTraits);
        }
        CGSize size = subview.bounds.size;
        subviewEngine.width = size.width;
        subviewEngine.height = size.height;
    }
}

@end

@implementation UIWindow (MyLayoutExt)

- (void)myUpdateRTL:(BOOL)isRTL {
    BOOL oldRTL = [LAKBaseLayout isRTL];
    if (oldRTL != isRTL) {
        [LAKBaseLayout setIsRTL:isRTL];
        [self mySetNeedLayoutAllSubviews:self];
    }
}

- (void)mySetNeedLayoutAllSubviews:(UIView *)view {
    NSArray *subviews = view.subviews;
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[LAKBaseLayout class]]) {
            [subview setNeedsLayout];
        }
        [self mySetNeedLayoutAllSubviews:subview];
    }
}
@end
