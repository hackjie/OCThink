//
//  LAKLayoutSizeClass.m
//  MyLayout
//
//  Created by 李杰 on 2025/03/13.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "LAKLayoutSizeClass.h"
#import "LAKLayoutPosInner.h"
#import "LAKLayoutSizeInner.h"

@implementation LAKLayoutEngine
- (id)init {
    self = [super init];
    if (self != nil) {
        _leading = CGFLOAT_MAX;
        _trailing = CGFLOAT_MAX;
        _top = CGFLOAT_MAX;
        _bottom = CGFLOAT_MAX;
        _width = CGFLOAT_MAX;
        _height = CGFLOAT_MAX;
    }

    return self;
}

- (void)reset {
    _leading = CGFLOAT_MAX;
    _trailing = CGFLOAT_MAX;
    _top = CGFLOAT_MAX;
    _bottom = CGFLOAT_MAX;
    _width = CGFLOAT_MAX;
    _height = CGFLOAT_MAX;
}

- (CGRect)frame {
    return CGRectMake(_leading, _top, _width, _height);
}

- (void)setFrame:(CGRect)frame {
    _leading = frame.origin.x;
    _top = frame.origin.y;
    _width = frame.size.width;
    _height = frame.size.height;
    _trailing = _leading + _width;
    _bottom = _top + _height;
}

- (CGSize)size {
    return CGSizeMake(_width, _height);
}

- (void)setSize:(CGSize)size {
    _width = size.width;
    _height = size.height;
}

- (CGPoint)origin {
    return CGPointMake(_leading, _top);
}

- (void)setOrigin:(CGPoint)origin {
    _leading = origin.x;
    _top = origin.y;
}

- (BOOL)multiple {
    return self.sizeClasses.count > 1;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"leading:%g, top:%g, width:%g, height:%g, trailing:%g, bottom:%g", _leading, _top, _width, _height, _trailing, _bottom];
}

- (LAKViewTraits *)fetchView:(UIView *)view layoutSizeClass:(LAKSizeClass)sizeClass copyFrom:(LAKSizeClass)srcSizeClass {
    LAKViewTraits *viewTraits = nil;
    if (self.sizeClasses == nil) {
        self.sizeClasses = [NSMutableDictionary new];
    } else {
      viewTraits = (LAKViewTraits *)[self.sizeClasses objectForKey:@(sizeClass)];
    }
     
    if (viewTraits == nil) {
        LAKViewTraits *srcTraits = (LAKViewTraits *)[self.sizeClasses objectForKey:@(srcSizeClass)];
        if (srcTraits == nil) {
            viewTraits = [view createSizeClassInstance];
        } else {
            viewTraits = [srcTraits copy];
        }
        viewTraits.view = view;
        [self.sizeClasses setObject:viewTraits forKey:@(sizeClass)];
    }
    return viewTraits;
}

- (LAKViewTraits *)fetchView:(UIView *)view bestLayoutSizeClass:(LAKSizeClass)sizeClass {

    LAKSizeClass wscType = sizeClass & 0x03;
    LAKSizeClass hscType = sizeClass & 0x0C;
    LAKSizeClass oriType = sizeClass & 0xC0;

    if (self.sizeClasses == nil) {
        self.sizeClasses = [NSMutableDictionary new];
    }
    LAKSizeClass searchType;
    LAKViewTraits *viewTraits = nil;
    if (self.sizeClasses.count > 1) {
        //first search the most exact SizeClass
        searchType = wscType | hscType | oriType;
        viewTraits = [self.sizeClasses objectForKey:@(searchType)];
        if (viewTraits != nil) {
            return viewTraits;
        }
        searchType = wscType | hscType;
        if (searchType != sizeClass) {
            viewTraits = [self.sizeClasses objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = LAKSizeClass_wAny | hscType | oriType;
        if (oriType != 0 && searchType != sizeClass) {
            viewTraits = [self.sizeClasses objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = LAKSizeClass_wAny | hscType;
        if (searchType != sizeClass) {
            viewTraits = [self.sizeClasses objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = wscType | LAKSizeClass_hAny | oriType;
        if (oriType != 0 && searchType != sizeClass) {
            viewTraits = [self.sizeClasses objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = wscType | LAKSizeClass_hAny;
        if (searchType != sizeClass) {
            viewTraits = [self.sizeClasses objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = LAKSizeClass_wAny | LAKSizeClass_hAny | oriType;
        if (oriType != 0 && searchType != sizeClass) {
            viewTraits = [self.sizeClasses objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }
    }

    searchType = LAKSizeClass_wAny | LAKSizeClass_hAny;
    viewTraits = [self.sizeClasses objectForKey:@(searchType)];
    if (viewTraits == nil) {
        viewTraits = [view createSizeClassInstance];
        viewTraits.view = view;
        [self.sizeClasses setObject:viewTraits forKey:@(searchType)];
    }
    return viewTraits;
}

- (void)setView:(UIView *)view layoutSizeClass:(LAKSizeClass)sizeClass withTraits:(LAKViewTraits *)traits {
    if (self.sizeClasses == nil) {
        self.sizeClasses = [NSMutableDictionary new];
    }
    traits.view = view;
    traits.topPosInner.view = view;
    traits.bottomPosInner.view = view;
    traits.leadingPosInner.view = view;
    traits.trailingPosInner.view = view;
    traits.centerXPosInner.view = view;
    traits.centerYPosInner.view = view;
    traits.baselinePosInner.view = view;
    traits.widthSizeInner.view = view;
    traits.heightSizeInner.view = view;
    
    [self.sizeClasses setObject:traits forKey:@(sizeClass)];
}


@end


@implementation LAKViewTraits

BOOL _myisRTL = NO;

+ (BOOL)isRTL {
    return _myisRTL;
}

+ (void)setIsRTL:(BOOL)isRTL {
    _myisRTL = isRTL;
}

- (id)init {
    return [super init];
}

- (LAKLayoutPos *)topPosInner {
    return _topPos;
}

- (LAKLayoutPos *)leadingPosInner {
    return _leadingPos;
}

- (LAKLayoutPos *)bottomPosInner {
    return _bottomPos;
}

- (LAKLayoutPos *)trailingPosInner {
    return _trailingPos;
}

- (LAKLayoutPos *)centerXPosInner {
    return _centerXPos;
}

- (LAKLayoutPos *)centerYPosInner {
    return _centerYPos;
}

- (LAKLayoutPos *)leftPosInner {
    return [LAKViewTraits isRTL] ? self.trailingPosInner : self.leadingPosInner;
}

- (LAKLayoutPos *)rightPosInner {
    return [LAKViewTraits isRTL] ? self.leadingPosInner : self.trailingPosInner;
}

- (LAKLayoutPos *)baselinePosInner {
    return _baselinePos;
}

- (LAKLayoutSize *)widthSizeInner {
    return _widthSize;
}

- (LAKLayoutSize *)heightSizeInner {
    return _heightSize;
}

//..

- (LAKLayoutPos *)topPos {
    if (_topPos == nil) {
        _topPos = [LAKLayoutPos new];
        _topPos.view = self.view;
        _topPos.anchorType = MyLayoutAnchorType_Top;
    }
    return _topPos;
}

- (LAKLayoutPos *)leadingPos {
    if (_leadingPos == nil) {
        _leadingPos = [LAKLayoutPos new];
        _leadingPos.view = self.view;
        _leadingPos.anchorType = MyLayoutAnchorType_Leading;
    }

    return _leadingPos;
}

- (LAKLayoutPos *)bottomPos {
    if (_bottomPos == nil) {
        _bottomPos = [LAKLayoutPos new];
        _bottomPos.view = self.view;
        _bottomPos.anchorType = MyLayoutAnchorType_Bottom;
    }
    return _bottomPos;
}

- (LAKLayoutPos *)trailingPos {
    if (_trailingPos == nil) {
        _trailingPos = [LAKLayoutPos new];
        _trailingPos.view = self.view;
        _trailingPos.anchorType = MyLayoutAnchorType_Trailing;
    }
    return _trailingPos;
}

- (LAKLayoutPos *)centerXPos {
    if (_centerXPos == nil) {
        _centerXPos = [LAKLayoutPos new];
        _centerXPos.view = self.view;
        _centerXPos.anchorType = MyLayoutAnchorType_CenterX;
    }
    return _centerXPos;
}

- (LAKLayoutPos *)centerYPos {
    if (_centerYPos == nil) {
        _centerYPos = [LAKLayoutPos new];
        _centerYPos.view = self.view;
        _centerYPos.anchorType = MyLayoutAnchorType_CenterY;
    }
    return _centerYPos;
}

- (LAKLayoutPos *)leftPos {
    return [LAKViewTraits isRTL] ? self.trailingPos : self.leadingPos;
}

- (LAKLayoutPos *)rightPos {
    return [LAKViewTraits isRTL] ? self.leadingPos : self.trailingPos;
}

- (LAKLayoutPos *)baselinePos {
    if (_baselinePos == nil) {
        _baselinePos = [LAKLayoutPos new];
        _baselinePos.view = self.view;
        _baselinePos.anchorType = MyLayoutAnchorType_Baseline;
    }
    return _baselinePos;
}

- (CGFloat)myTop {
    return self.topPosInner.measure;
}

- (void)setMyTop:(CGFloat)myTop {
    self.topPos.myEqualTo(@(myTop));
}

- (CGFloat)myLeading {
    return self.leadingPosInner.measure;
}

- (void)setMyLeading:(CGFloat)myLeading {
    self.leadingPos.myEqualTo(@(myLeading));
}

- (CGFloat)myBottom {
    return self.bottomPosInner.measure;
}

- (void)setMyBottom:(CGFloat)myBottom {
    self.bottomPos.myEqualTo(@(myBottom));
}

- (CGFloat)myTrailing {
    return self.trailingPosInner.measure;
}

- (void)setMyTrailing:(CGFloat)myTrailing {
    self.trailingPos.myEqualTo(@(myTrailing));
}

- (CGFloat)myCenterX {
    return self.centerXPosInner.measure;
}

- (void)setMyCenterX:(CGFloat)myCenterX {
    self.centerXPos.myEqualTo(@(myCenterX));
}

- (CGFloat)myCenterY {
    return self.centerYPosInner.measure;
}

- (void)setMyCenterY:(CGFloat)myCenterY {
    self.centerYPos.myEqualTo(@(myCenterY));
}

- (CGPoint)myCenter {
    return CGPointMake(self.myCenterX, self.myCenterY);
}

- (void)setMyCenter:(CGPoint)myCenter {
    self.myCenterX = myCenter.x;
    self.myCenterY = myCenter.y;
}

- (CGFloat)myLeft {
    return self.leftPosInner.measure;
}

- (void)setMyLeft:(CGFloat)myLeft {
    self.leftPos.myEqualTo(@(myLeft));
}

- (CGFloat)myRight {
    return self.rightPosInner.measure;
}

- (void)setMyRight:(CGFloat)myRight {
    self.rightPos.myEqualTo(@(myRight));
}

- (CGFloat)myMargin {
    return self.leftPosInner.measure;
}

- (void)setMyMargin:(CGFloat)myMargin {
    self.topPos.myEqualTo(@(myMargin));
    self.leftPos.myEqualTo(@(myMargin));
    self.rightPos.myEqualTo(@(myMargin));
    self.bottomPos.myEqualTo(@(myMargin));
}

- (CGFloat)myHorzMargin {
    return self.leftPosInner.measure;
}

- (void)setMyHorzMargin:(CGFloat)myHorzMargin {
    self.leftPos.myEqualTo(@(myHorzMargin));
    self.rightPos.myEqualTo(@(myHorzMargin));
}

- (CGFloat)myVertMargin {
    return self.topPosInner.measure;
}

- (void)setMyVertMargin:(CGFloat)myVertMargin {
    self.topPos.myEqualTo(@(myVertMargin));
    self.bottomPos.myEqualTo(@(myVertMargin));
}

- (LAKLayoutSize *)widthSize {
    if (_widthSize == nil) {
        _widthSize = [LAKLayoutSize new];
        _widthSize.view = self.view;
        _widthSize.anchorType = MyLayoutAnchorType_Width;
    }
    return _widthSize;
}

- (LAKLayoutSize *)heightSize {
    if (_heightSize == nil) {
        _heightSize = [LAKLayoutSize new];
        _heightSize.view = self.view;
        _heightSize.anchorType = MyLayoutAnchorType_Height;
    }
    return _heightSize;
}

- (CGFloat)myWidth {
    //特殊处理设置为LAKLayoutSize.wrap和LAKLayoutSize.fill的返回。
    if (self.widthSizeInner.valType == MyLayoutValType_Wrap) {
        return LAKLayoutSize.wrap;
    } else if (self.widthSizeInner.valType == MyLayoutValType_Fill) {
        return LAKLayoutSize.fill;
    } else {
        return self.widthSizeInner.measure;
    }
}

- (void)setMyWidth:(CGFloat)width {
    self.widthSize.myEqualTo(@(width));
}

- (CGFloat)myHeight {
    if (self.heightSizeInner.valType == MyLayoutValType_Wrap) {
        return LAKLayoutSize.wrap;
    } else if (self.heightSizeInner.valType == MyLayoutValType_Fill) {
        return LAKLayoutSize.fill;
    } else {
        return self.heightSizeInner.measure;
    }
}

- (void)setMyHeight:(CGFloat)height {
    self.heightSize.myEqualTo(@(height));
}

- (CGSize)mySize {
    return CGSizeMake(self.myWidth, self.myHeight);
}

- (void)setMySize:(CGSize)mySize {
    self.myWidth = mySize.width;
    self.myHeight = mySize.height;
}

- (void)setWeight:(CGFloat)weight {
    if (weight < 0) {
        weight = 0;
    }
    if (_weight != weight) {
        _weight = weight;
    }
}

#pragma mark-- NSCopying

- (id)copyWithZone:(NSZone *)zone {
    LAKViewTraits *layoutTraits = [[[self class] allocWithZone:zone] init];

    //这里不会复制hidden属性
    layoutTraits->_view = _view;
    layoutTraits->_topPos = [self.topPosInner copy];
    layoutTraits->_leadingPos = [self.leadingPosInner copy];
    layoutTraits->_bottomPos = [self.bottomPosInner copy];
    layoutTraits->_trailingPos = [self.trailingPosInner copy];
    layoutTraits->_centerXPos = [self.centerXPosInner copy];
    layoutTraits->_centerYPos = [self.centerYPosInner copy];
    layoutTraits->_baselinePos = [self.baselinePos copy];
    layoutTraits->_widthSize = [self.widthSizeInner copy];
    layoutTraits->_heightSize = [self.heightSizeInner copy];
    layoutTraits.useFrame = self.useFrame;
    layoutTraits.noLayout = self.noLayout;
    layoutTraits.visibility = self.visibility;
    layoutTraits.alignment = self.alignment;
    layoutTraits.weight = self.weight;
    layoutTraits.reverseFloat = self.isReverseFloat;
    layoutTraits.clearFloat = self.clearFloat;

    return layoutTraits;
}

#pragma mark -- Helper

+ (LAKGravity)convertLeadingTrailingGravityFromLeftRightGravity:(LAKGravity)leftRightGravity{
    if (leftRightGravity == LAKGravity_Horz_Left) {
        if ([self isRTL]) {
            return LAKGravity_Horz_Trailing;
        } else {
            return LAKGravity_Horz_Leading;
        }
    } else if (leftRightGravity == LAKGravity_Horz_Right) {
        if ([self isRTL]) {
            return LAKGravity_Horz_Leading;
        } else {
            return LAKGravity_Horz_Trailing;
        }
    } else {
        return leftRightGravity;
    }
}


- (BOOL)invalid {
    if (self.useFrame) {
        return YES;
    }
    
    if (self.view.isHidden) {
        return self.visibility != LAKVisibility_Invisible;
    } else {
        return self.visibility == LAKVisibility_Gone;
    }
}

- (LAKGravity)finalVertGravityFrom:(LAKGravity)layoutVertGravity {
    LAKGravity finalVertGravity = LAKGravity_Vert_Top; //
    LAKGravity vertAlignment = MYVERTGRAVITY(self.alignment);
    if (layoutVertGravity != LAKGravity_None) {
        finalVertGravity = layoutVertGravity;
        if (vertAlignment != LAKGravity_None) {
            finalVertGravity = vertAlignment;
        }
    } else {
        if (vertAlignment != LAKGravity_None) {
            finalVertGravity = vertAlignment;
        }
        if (self.topPosInner.val != nil && self.bottomPosInner.val != nil) {
            //只有在没有设置高度约束，或者高度约束优先级很低的情况下同时设置上下才转化为填充。
            if (self.heightSizeInner.val == nil || self.heightSizeInner.priority == MyPriority_Low) {
                finalVertGravity = LAKGravity_Vert_Fill;
            }
        } else if (self.centerYPosInner.val != nil) {
            finalVertGravity = LAKGravity_Vert_Center;
        } else if (self.topPosInner.val != nil) {
            finalVertGravity = LAKGravity_Vert_Top;
        } else if (self.bottomPosInner.val != nil) {
            finalVertGravity = LAKGravity_Vert_Bottom;
        }
    }
    return finalVertGravity;
}

- (LAKGravity)finalHorzGravityFrom:(LAKGravity)layoutHorzGravity {
    LAKGravity finalHorzGravity = LAKGravity_Horz_Leading;
    LAKGravity horzAlignment = [LAKViewTraits convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(self.alignment)];
    if (layoutHorzGravity != LAKGravity_None) {
        finalHorzGravity = layoutHorzGravity;
        if (horzAlignment != LAKGravity_None) {
            finalHorzGravity = horzAlignment;
        }
    } else {
        if (horzAlignment != LAKGravity_None) {
            finalHorzGravity = horzAlignment;
        }
        if (self.leadingPosInner.val != nil && self.trailingPosInner.val != nil) {
            //只有在没有设置宽度约束，或者宽度约束优先级很低的情况下同时设置左右才转化为填充。
            if (self.widthSizeInner.val == nil || self.widthSizeInner.priority == MyPriority_Low) {
                finalHorzGravity = LAKGravity_Horz_Fill;
            }
        } else if (self.centerXPosInner.val != nil) {
            finalHorzGravity = LAKGravity_Horz_Center;
        } else if (self.leadingPosInner.val != nil) {
            finalHorzGravity = LAKGravity_Horz_Leading;
        } else if (self.trailingPosInner.val != nil) {
            finalHorzGravity = LAKGravity_Horz_Trailing;
        }
    }
    return finalHorzGravity;
}


@end

@implementation LAKLayoutTraits

- (id)init {
    self = [super init];
    if (self != nil) {
        _zeroPadding = YES;
    }
    return self;
}

- (UIEdgeInsets)padding {
    return UIEdgeInsetsMake(self.paddingTop, self.paddingLeft, self.paddingBottom, self.paddingRight);
}

- (void)setPadding:(UIEdgeInsets)padding {
    self.paddingTop = padding.top;
    self.paddingLeft = padding.left;
    self.paddingBottom = padding.bottom;
    self.paddingRight = padding.right;
}

- (CGFloat)paddingLeft {
    return [LAKViewTraits isRTL] ? self.paddingTrailing : self.paddingLeading;
}

- (void)setPaddingLeft:(CGFloat)paddingLeft {
    if ([LAKViewTraits isRTL]) {
        self.paddingTrailing = paddingLeft;
    } else {
        self.paddingLeading = paddingLeft;
    }
}

- (CGFloat)paddingRight {
    return [LAKViewTraits isRTL] ? self.paddingLeading : self.paddingTrailing;
}

- (void)setPaddingRight:(CGFloat)paddingRight {
    if ([LAKViewTraits isRTL]) {
        self.paddingLeading = paddingRight;
    } else {
        self.paddingTrailing = paddingRight;
    }
}

- (CGFloat)myLayoutPaddingTop {
    return self.paddingTop;
}

- (CGFloat)myLayoutPaddingBottom {
    return self.paddingBottom;
}

- (CGFloat)myLayoutPaddingLeading {
    return self.paddingLeading;
}

- (CGFloat)myLayoutPaddingTrailing {
    return self.paddingTrailing;
}

- (CGFloat)myLayoutPaddingLeft {
    return [LAKViewTraits isRTL] ? [self myLayoutPaddingTrailing] : [self myLayoutPaddingLeading];
}
- (CGFloat)myLayoutPaddingRight {
    return [LAKViewTraits isRTL] ? [self myLayoutPaddingLeading] : [self myLayoutPaddingTrailing];
}

- (id)copyWithZone:(NSZone *)zone {
    LAKLayoutTraits *layoutTraits = [super copyWithZone:zone];
    layoutTraits.paddingTop = self.paddingTop;
    layoutTraits.paddingLeading = self.paddingLeading;
    layoutTraits.paddingBottom = self.paddingBottom;
    layoutTraits.paddingTrailing = self.paddingTrailing;
    layoutTraits.zeroPadding = self.zeroPadding;
    layoutTraits.gravity = self.gravity;

    return layoutTraits;
}

#pragma mark -- Helper

- (NSMutableArray<LAKLayoutEngine *> *)filterEngines:(NSMutableArray<LAKLayoutEngine *> *)subviewEngines {
    
    if (subviewEngines == nil) {
        subviewEngines = [NSMutableArray arrayWithCapacity:self.view.subviews.count];
        for (UIView *subview in self.view.subviews) {
            [subviewEngines addObject:subview.myEngine];
        }
    }
    
    NSInteger count = subviewEngines.count;
    
    for (NSInteger i = count - 1; i >= 0; i--) {
        LAKViewTraits *subviewTraits = subviewEngines[i].currentSizeClass;
        if ([subviewTraits invalid]) {
            [subviewEngines removeObjectAtIndex:i];
        }
    }
    
    return subviewEngines;
}


@end

@implementation MySequentLayoutFlexSpacing

- (CGFloat)calcMaxMinSubviewSizeForContent:(CGFloat)selfSize paddingStart:(CGFloat *)pStarPadding paddingEnd:(CGFloat *)pEndPadding space:(CGFloat *)pSpace {
    CGFloat subviewSize = self.subviewSize;

    CGFloat extralSpace = self.minSpace;
    if (self.centered) {
        extralSpace *= -1;
    }
    NSInteger rowCount = MAX(floor((selfSize - (*pStarPadding) - (*pEndPadding) + extralSpace) / (subviewSize + self.minSpace)), 1);
    NSInteger spaceCount = rowCount - 1;
    if (self.centered) {
        spaceCount += 2;
    }
    if (spaceCount > 0) {
        *pSpace = (selfSize - (*pStarPadding) - (*pEndPadding) - subviewSize * rowCount) / spaceCount;
        if (_myCGFloatGreat(*pSpace, self.maxSpace)) {
            *pSpace = self.maxSpace;
            subviewSize = (selfSize - (*pStarPadding) - (*pEndPadding) - (*pSpace) * spaceCount) / rowCount;
        }
        if (self.centered) {
            *pStarPadding = (*pStarPadding + *pSpace);
            *pEndPadding = (*pEndPadding + *pSpace);
        }
    }
    return subviewSize;
}

- (CGFloat)calcMaxMinSubviewSize:(CGFloat)selfSize arrangedCount:(NSInteger)arrangedCount paddingStart:(CGFloat *)pStarPadding paddingEnd:(CGFloat *)pEndPadding space:(CGFloat *)pSpace {
    CGFloat subviewSize = self.subviewSize;

    NSInteger spaceCount = arrangedCount - 1;
    if (self.centered) {
        spaceCount += 2;
    }
    if (spaceCount > 0) {
        *pSpace = (selfSize - *pStarPadding - *pEndPadding - subviewSize * arrangedCount) / spaceCount;

        if (_myCGFloatGreat(*pSpace, self.maxSpace) || _myCGFloatLess(*pSpace, self.minSpace)) {
            if (_myCGFloatGreat(*pSpace, self.maxSpace)) {
                *pSpace = self.maxSpace;
            }
            if (_myCGFloatLess(*pSpace, self.minSpace)) {
                *pSpace = self.minSpace;
            }
            subviewSize = (selfSize - *pStarPadding - *pEndPadding - (*pSpace) * spaceCount) / arrangedCount;
        }
        if (self.centered) {
            *pStarPadding = (*pStarPadding + *pSpace);
            *pEndPadding = (*pEndPadding + *pSpace);
        }
    }
    return subviewSize;
}

@end

@implementation MySequentLayoutTraits

- (id)copyWithZone:(NSZone *)zone {
    MySequentLayoutTraits *layoutTraits = [super copyWithZone:zone];
    layoutTraits.orientation = self.orientation;
    if (self.flexSpace != nil) {
        layoutTraits.flexSpace = [MySequentLayoutFlexSpacing new];
        layoutTraits.flexSpace.subviewSize = self.flexSpace.subviewSize;
        layoutTraits.flexSpace.minSpace = self.flexSpace.minSpace;
        layoutTraits.flexSpace.maxSpace = self.flexSpace.maxSpace;
        layoutTraits.flexSpace.centered = self.flexSpace.centered;
    }

    return layoutTraits;
}
@end

@implementation LAKLinearLayoutTraits
- (id)copyWithZone:(NSZone *)zone {
    LAKLinearLayoutTraits *layoutTraits = [super copyWithZone:zone];
    layoutTraits.shrinkType = self.shrinkType;
    return layoutTraits;
}
@end

@implementation LAKFrameLayoutTraits
@end

