//
//  LAKLayoutPos.m
//  MyLayout
//
//  Created by 李杰 on 2025/03/13.
//  Copyright © 2025 leoli. All rights reserved.
//
#import "LAKLayoutPos.h"
#import "LAKBaseLayout.h"
#import "LAKLayoutInner.h"
#import "LAKLayoutPosInner.h"


@implementation LAKLayoutPos
- (id)init {
    self = [super init];
    if (self != nil) {
        _active = YES;
        _view = nil;
        _val = nil;
        _valType = MyLayoutValType_Nil;
        _offsetVal = 0;
        _lBoundVal = nil;
        _uBoundVal = nil;
        _shrink = 0.0;
    }

    return self;
}

- (LAKLayoutPos * (^)(id val))myEqualTo {
    return ^id(id val) {
        [self _myEqualTo:val];
        [self setNeedsLayout];
        return self;
    };
}

- (LAKLayoutPos * (^)(CGFloat val))myOffset {
    return ^id(CGFloat val) {
        [self _myOffset:val];
        [self setNeedsLayout];
        return self;
    };
}

- (LAKLayoutPos * (^)(CGFloat val))myMin {
    return ^id(CGFloat val) {
        [self _myMin:val];
        [self setNeedsLayout];
        return self;
    };
}

- (LAKLayoutPos * (^)(CGFloat val))myMax {
    return ^id(CGFloat val) {
        [self _myMax:val];
        [self setNeedsLayout];
        return self;
    };
}

- (LAKLayoutPos * (^)(id posVal, CGFloat offset))myLBound {
    return ^id(id posVal, CGFloat offset) {
        [self _myLBound:posVal offsetVal:offset];
        [self setNeedsLayout];
        return self;
    };
}

- (LAKLayoutPos * (^)(id posVal, CGFloat offset))myUBound {
    return ^id(id posVal, CGFloat offset) {
        [self _myUBound:posVal offsetVal:offset];
        [self setNeedsLayout];
        return self;
    };
}

- (void)myClear {
    [self _myClear];
    [self setNeedsLayout];
}

- (LAKLayoutPos * (^)(id val))equalTo {
    return self.myEqualTo;
}

- (LAKLayoutPos * (^)(CGFloat val))offset {
    return self.myOffset;
}

- (LAKLayoutPos * (^)(CGFloat val))min {
    return self.myMin;
}

- (LAKLayoutPos * (^)(id posVal, CGFloat offsetVal))lBound {
    return self.myLBound;
}

- (LAKLayoutPos * (^)(CGFloat val))max {
    return self.myMax;
}

- (LAKLayoutPos * (^)(id posVal, CGFloat offsetVal))uBound {
    return self.myUBound;
}

- (void)clear {
    [self myClear];
}

- (void)setActive:(BOOL)active {
    if (_active != active) {
        [self _mySetActive:active];
        [self setNeedsLayout];
    }
}

- (CGFloat)shrink {
    return self.isActive ? _shrink : 0;
}

- (id)val {
    return self.isActive ? _val : nil;
}

- (CGFloat)offsetVal {
    return self.isActive ? _offsetVal : 0;
}

- (CGFloat)minVal {
    return self.isActive && _lBoundVal != nil ? _lBoundVal.numberVal.doubleValue : -CGFLOAT_MAX;
}

- (CGFloat)maxVal {
    return self.isActive && _uBoundVal != nil ?  _uBoundVal.numberVal.doubleValue : CGFLOAT_MAX;
}

#pragma mark-- NSCopying

- (id)copyWithZone:(NSZone *)zone {
    LAKLayoutPos *layoutPos = [[[self class] allocWithZone:zone] init];
    layoutPos.view = self.view;
    layoutPos->_active = _active;
    layoutPos->_shrink = _shrink;
    layoutPos->_anchorType = _anchorType;
    layoutPos->_valType = _valType;
    layoutPos->_val = _val;
    layoutPos->_offsetVal = _offsetVal;
    if (_lBoundVal != nil) {
        layoutPos->_lBoundVal = [[[self class] allocWithZone:zone] init];
        layoutPos->_lBoundVal->_active = _active;
        [[layoutPos->_lBoundVal _myEqualTo:_lBoundVal.val] _myOffset:_lBoundVal.offsetVal];
    }
    if (_uBoundVal != nil) {
        layoutPos->_uBoundVal = [[[self class] allocWithZone:zone] init];
        layoutPos->_uBoundVal->_active = _active;
        [[layoutPos->_uBoundVal _myEqualTo:_uBoundVal.val] _myOffset:_uBoundVal.offsetVal];
    }

    return layoutPos;
}

#pragma mark-- Private Methods

- (NSNumber *)numberVal {
    if (_val == nil || !self.isActive) {
        return nil;
    }
    if (_valType == MyLayoutValType_Number) {
        return _val;
    } else if (_valType == MyLayoutValType_SafeArea) {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

        if (@available(iOS 11.0, *)) {
            UIView *superView = self.view.superview;
            switch (_anchorType) {
                case MyLayoutAnchorType_Leading:
                    return [LAKBaseLayout isRTL] ? @(superView.safeAreaInsets.right) : @(superView.safeAreaInsets.left);
                    break;
                case MyLayoutAnchorType_Trailing:
                    return [LAKBaseLayout isRTL] ? @(superView.safeAreaInsets.left) : @(superView.safeAreaInsets.right);
                    break;
                case MyLayoutAnchorType_Top:
                    return @(superView.safeAreaInsets.top);
                    break;
                case MyLayoutAnchorType_Bottom:
                    return @(superView.safeAreaInsets.bottom);
                    break;
                default:
                    return @(0);
                    break;
            }
        }
#endif
        if (_anchorType == MyLayoutAnchorType_Top) {
            return @([self findContainerVC].topLayoutGuide.length);
        } else if (_anchorType == MyLayoutAnchorType_Bottom) {
            return @([self findContainerVC].bottomLayoutGuide.length);
        }
        return @(0);
    }
    return nil;
}

- (UIViewController *)findContainerVC {
    UIViewController *vc = nil;
    @try {
        UIView *v = self.view;
        while (v != nil) {
            vc = [v valueForKey:@"viewDelegate"];
            if (vc != nil) {
                break;
            }
            v = [v superview];
        }
    } @catch (NSException *exception) {
    }

    return vc;
}

- (LAKLayoutPos *)anchorVal {
    if (_val == nil || !self.isActive) {
        return nil;
    }
    if (_valType == MyLayoutValType_LayoutPos) {
        return _val;
    }
    return nil;
}

- (NSArray *)arrayVal {
    if (_val == nil || !self.isActive) {
        return nil;
    }
    if (_valType == MyLayoutValType_Array) {
        return _val;
    }
    return nil;
}

//- (NSNumber *)mostVal {
//    if (_val == nil || !self.isActive) {
//        return nil;
//    }
//    if (_valType == MyLayoutValType_Most) {
//        return @([((MyLayoutMostPos *)_val) getMostAxisValFrom:self]);
//    }
//    return nil;
//}

- (LAKLayoutPos *)lBoundVal {
    if (_lBoundVal == nil) {
        _lBoundVal = [[LAKLayoutPos alloc] init];
        _lBoundVal->_active = _active;
        [_lBoundVal _myEqualTo:@(-CGFLOAT_MAX)];
    }
    return _lBoundVal;
}

- (LAKLayoutPos *)uBoundVal {
    if (_uBoundVal == nil) {
        _uBoundVal = [[LAKLayoutPos alloc] init];
        _uBoundVal->_active = _active;
        [_uBoundVal _myEqualTo:@(CGFLOAT_MAX)];
    }
    return _uBoundVal;
}

- (LAKLayoutPos *)lBoundValInner {
    return _lBoundVal;
}

- (LAKLayoutPos *)uBoundValInner {
    return _uBoundVal;
}

- (LAKLayoutPos *)_myEqualTo:(id)val {
    if (![_val isEqual:val]) {
        if ([val isKindOfClass:[NSNumber class]]) {
            _valType = MyLayoutValType_Number;
        } else if ([val isKindOfClass:[LAKLayoutPos class]]) {
            _valType = MyLayoutValType_LayoutPos;
        } else if ([val isKindOfClass:[NSArray class]]) {
            _valType = MyLayoutValType_Array;
//        } else if ([val isKindOfClass:[MyLayoutMostPos class]]) {
//            _valType = MyLayoutValType_Most;
        } else if ([val isKindOfClass:[UIView class]]) {
            UIView *rview = (UIView *)val;
            _valType = MyLayoutValType_LayoutPos;

            switch (_anchorType) {
                case MyLayoutAnchorType_Leading:
                    val = rview.leadingPos;
                    break;
                case MyLayoutAnchorType_CenterX:
                    val = rview.centerXPos;
                    break;
                case MyLayoutAnchorType_Trailing:
                    val = rview.trailingPos;
                    break;
                case MyLayoutAnchorType_Top:
                    val = rview.topPos;
                    break;
                case MyLayoutAnchorType_CenterY:
                    val = rview.centerYPos;
                    break;
                case MyLayoutAnchorType_Bottom:
                    val = rview.bottomPos;
                    break;
                case MyLayoutAnchorType_Baseline:
                    val = rview.baselinePos;
                    break;
                default:
                    NSAssert(0, @"oops!");
                    break;
            }
        } else {
            _valType = MyLayoutValType_Nil;
        }
        _val = val;
    }

    return self;
}

- (LAKLayoutPos *)_myOffset:(CGFloat)val {
    if (_offsetVal != val) {
        _offsetVal = val;
    }
    return self;
}

- (LAKLayoutPos *)_myMin:(CGFloat)val {
    if (self.lBoundVal.numberVal.doubleValue != val) {
        [self.lBoundVal _myEqualTo:@(val)];
    }
    return self;
}

- (LAKLayoutPos *)_myLBound:(id)posVal offsetVal:(CGFloat)offsetVal {
    [[self.lBoundVal _myEqualTo:posVal] _myOffset:offsetVal];
    return self;
}

- (LAKLayoutPos *)_myMax:(CGFloat)val {
    if (self.uBoundVal.numberVal.doubleValue != val) {
        [self.uBoundVal _myEqualTo:@(val)];
    }
    return self;
}

- (LAKLayoutPos *)_myUBound:(id)posVal offsetVal:(CGFloat)offsetVal {
    [[self.uBoundVal _myEqualTo:posVal] _myOffset:offsetVal];
    return self;
}

- (void)_myClear {
    _active = YES;
    _val = nil;
    _valType = MyLayoutValType_Nil;
    _offsetVal = 0;
    _lBoundVal = nil;
    _uBoundVal = nil;
    _shrink = 0;
}

- (void)_mySetActive:(BOOL)active {
    _active = active;
    [_lBoundVal _mySetActive:active];
    [_uBoundVal _mySetActive:active];
}

- (CGFloat)measure {
    if (self.isActive) {
        CGFloat retVal = _offsetVal;
        if (self.numberVal != nil) {
            retVal += self.numberVal.doubleValue;
        }
        if (_uBoundVal != nil) {
            retVal = _myCGFloatMin(_uBoundVal.numberVal.doubleValue, retVal);
        }
        if (_lBoundVal != nil) {
            retVal = _myCGFloatMax(_lBoundVal.numberVal.doubleValue, retVal);
        }
        return retVal;
    } else {
        return 0;
    }
}

- (BOOL)isRelativePos {
    if (self.isActive) {
        CGFloat realPos = self.numberVal.doubleValue;
        return realPos > 0 && realPos < 1;
    } else {
        return NO;
    }
}

- (CGFloat)measureWith:(CGFloat)refVal {
    if (self.isActive) {
        CGFloat retVal = self.numberVal.doubleValue;
        if (retVal > 0 && retVal < 1) {
            retVal *= refVal;
        }
        retVal += _offsetVal;

        if (_uBoundVal != nil) {
            retVal = _myCGFloatMin(_uBoundVal.numberVal.doubleValue, retVal);
        }
        if (_lBoundVal != nil) {
            retVal = _myCGFloatMax(_lBoundVal.numberVal.doubleValue, retVal);
        }
        return retVal;
    } else {
        return 0;
    }
}

- (void)setNeedsLayout {
    if (_view != nil && _view.superview != nil && [_view.superview isKindOfClass:[LAKBaseLayout class]]) {
        LAKBaseLayout *lb = (LAKBaseLayout *)_view.superview;
        if (!lb.isMyLayouting) {
            [_view.superview setNeedsLayout];
        }
    }
}

+ (NSString *)axisstrFromAnchor:(LAKLayoutPos *)anchor showView:(BOOL)showView {
    NSString *viewstr = @"";
    if (showView) {
        viewstr = [NSString stringWithFormat:@"view:%p.", anchor.view];
    }
    NSString *axisstr = @"";

    switch (anchor.anchorType) {
        case MyLayoutAnchorType_Leading:
            axisstr = @"leadingPos";
            break;
        case MyLayoutAnchorType_CenterX:
            axisstr = @"centerXPos";
            break;
        case MyLayoutAnchorType_Trailing:
            axisstr = @"trailingPos";
            break;
        case MyLayoutAnchorType_Top:
            axisstr = @"topPos";
            break;
        case MyLayoutAnchorType_CenterY:
            axisstr = @"centerYPos";
            break;
        case MyLayoutAnchorType_Bottom:
            axisstr = @"bottomPos";
            break;
        case MyLayoutAnchorType_Baseline:
            axisstr = @"baselinePos";
            break;
        default:
            break;
    }

    return [NSString stringWithFormat:@"%@%@", viewstr, axisstr];
}

@end
