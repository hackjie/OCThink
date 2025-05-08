//
//  LAKLayoutSize.m
//  MyLayout
//
//  Created by 李杰 on 2025/03/13.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "LAKLayoutSize.h"
#import "LAKBaseLayout.h"
#import "LAKLayoutInner.h"
#import "LAKLayoutSizeInner.h"

@implementation LAKLayoutSize 

+ (NSInteger)empty {
    return -99999;
}

+ (NSInteger)wrap {
    return 99999;
}

+ (NSInteger)fill {
    return 99998;
}

+ (NSInteger)average {
    return -99997;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        _active = YES;
        _view = nil;
        _val = nil;
        _valType = MyLayoutValType_Nil;
        _addVal = 0;
        _multiVal = 1;
        _lBoundVal = nil;
        _uBoundVal = nil;
        _shrink = 0.0;
        _priority = MyPriority_Normal;
    }
    return self;
}

- (LAKLayoutSize * (^)(id val))myEqualTo {
    return ^id(id val) {
        [self _myEqualTo:val];
        //如果尺寸是自适应，并且当前视图是布局视图则直接布局视图自身刷新布局，否则由视图的父视图来刷新布局，这里特殊处理。
        if ([val isKindOfClass:[NSNumber class]]) {
            if ([val integerValue] == LAKLayoutSize.wrap && [self.view isKindOfClass:[LAKBaseLayout class]]) {
                [self.view setNeedsLayout];
                return self;
            }
        }
        [self setNeedsLayout];
        return self;
    };
}

- (LAKLayoutSize * (^)(CGFloat val))myAdd {
    return ^id(CGFloat val) {
        [self _myAdd:val];
        [self setNeedsLayout];
        return self;
    };
}

- (LAKLayoutSize * (^)(CGFloat val))myMultiply {
    return ^id(CGFloat val) {
        [self _myMultiply:val];
        [self setNeedsLayout];
        return self;
    };
}

- (LAKLayoutSize * (^)(CGFloat val))myMin {
    return ^id(CGFloat val) {
        [self _myMin:val];
        [self setNeedsLayout];
        return self;
    };
}

- (LAKLayoutSize * (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myLBound {
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal) {
        [self _myLBound:sizeVal addVal:addVal multiVal:multiVal];
        [self setNeedsLayout];
        return self;
    };
}

- (LAKLayoutSize * (^)(CGFloat val))myMax {
    return ^id(CGFloat val) {
        [self _myMax:val];
        [self setNeedsLayout];
        return self;
    };
}

- (LAKLayoutSize * (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myUBound {
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal) {
        [self _myUBound:sizeVal addVal:addVal multiVal:multiVal];
        [self setNeedsLayout];
        return self;
    };
}

- (void)myClear {
    [self _myClear];
    [self setNeedsLayout];
}

- (LAKLayoutSize * (^)(id val))equalTo {
    return self.myEqualTo;
}

- (LAKLayoutSize * (^)(CGFloat val))add {
    return self.myAdd;
}

- (LAKLayoutSize * (^)(CGFloat val))multiply {
    return self.myMultiply;
}

- (LAKLayoutSize * (^)(CGFloat val))min {
    return self.myMin;
}

- (LAKLayoutSize * (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))lBound {
    return self.myLBound;
}

- (LAKLayoutSize * (^)(CGFloat val))max {
    return self.myMax;
}

- (LAKLayoutSize * (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))uBound {
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
    return _active ? _shrink : 0.0;
}

- (id)val {
    return self.isActive ? _val : nil;
}

- (BOOL)isWrap {
    return _valType == MyLayoutValType_Wrap;
}

- (BOOL)isFill {
    return _valType == MyLayoutValType_Fill;
}

#pragma mark-- NSCopying

- (id)copyWithZone:(NSZone *)zone {
    LAKLayoutSize *layoutSize = [[[self class] allocWithZone:zone] init];
    layoutSize->_view = _view;
    layoutSize->_active = _active;
    layoutSize->_shrink = _shrink;
    layoutSize->_anchorType = _anchorType;
    layoutSize->_addVal = _addVal;
    layoutSize->_multiVal = _multiVal;
    layoutSize->_val = _val;
    layoutSize->_valType = _valType;
    layoutSize->_priority = _priority;
    if (_lBoundVal != nil) {
        layoutSize->_lBoundVal = [[[self class] allocWithZone:zone] init];
        layoutSize->_lBoundVal->_active = _active;
        [[[layoutSize->_lBoundVal _myEqualTo:_lBoundVal.val] _myAdd:_lBoundVal.addVal] _myMultiply:_lBoundVal.multiVal];
    }
    if (_uBoundVal != nil) {
        layoutSize->_uBoundVal = [[[self class] allocWithZone:zone] init];
        layoutSize->_uBoundVal->_active = _active;
        [[[layoutSize->_uBoundVal _myEqualTo:_uBoundVal.val] _myAdd:_uBoundVal.addVal] _myMultiply:_uBoundVal.multiVal];
    }
    return layoutSize;
}

#pragma mark-- Private Methods

- (NSNumber *)numberVal {
    if (_val == nil || !self.isActive) {
        return nil;
    }
    if (_valType == MyLayoutValType_Number) {
        return _val;
    }
//    if (_valType == MyLayoutValType_Most) {
//        return @([((MyLayoutMostSize *)_val) getMostDimenValFrom:self]);
//    }
    return nil;
}

- (LAKLayoutSize *)anchorVal {
    if (_val == nil || !self.isActive) {
        return nil;
    }
    if (_valType == MyLayoutValType_LayoutSize) {
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

- (BOOL)wrapVal {
    return self.isActive && _valType == MyLayoutValType_Wrap;
}

- (BOOL)fillVal {
    return self.isActive && _valType == MyLayoutValType_Fill;
}

- (LAKLayoutSize *)lBoundVal {
    if (_lBoundVal == nil) {
        _lBoundVal = [[LAKLayoutSize alloc] init];
        _lBoundVal->_active = _active;
        [_lBoundVal _myEqualTo:@(-CGFLOAT_MAX)];
    }
    return _lBoundVal;
}

- (LAKLayoutSize *)uBoundVal {
    if (_uBoundVal == nil) {
        _uBoundVal = [[LAKLayoutSize alloc] init];
        _uBoundVal->_active = _active;
        [_uBoundVal _myEqualTo:@(CGFLOAT_MAX)];
    }
    return _uBoundVal;
}

- (LAKLayoutSize *)lBoundValInner {
    return _lBoundVal;
}

- (LAKLayoutSize *)uBoundValInner {
    return _uBoundVal;
}

- (CGFloat)minVal {
    return (self.isActive && _lBoundVal != nil) ?  _lBoundVal.numberVal.doubleValue : -CGFLOAT_MAX;
}

- (CGFloat)maxVal {
    return (self.isActive && _uBoundVal != nil) ?  _uBoundVal.numberVal.doubleValue : CGFLOAT_MAX;
}

- (LAKLayoutSize *)_myEqualTo:(id)val {
    return [self _myEqualTo:val priority:MyPriority_Normal];
}

- (LAKLayoutSize *)_myEqualTo:(id)val priority:(NSInteger)priority {
    _priority = priority;
    if (![_val isEqual:val]) {
        if ([val isKindOfClass:[NSNumber class]]) {
            //特殊处理。
            if ([val integerValue] == LAKLayoutSize.wrap) {
                _valType = MyLayoutValType_Wrap;
            } else if ([val integerValue] == LAKLayoutSize.fill) {
                _valType = MyLayoutValType_Fill;
            } else if ([val integerValue] == LAKLayoutSize.empty) {
                _valType = MyLayoutValType_Nil;
                val = nil;
            } else {
                _valType = MyLayoutValType_Number;
            }
        } else if ([val isMemberOfClass:[LAKLayoutSize class]]) {
            //我们支持尺寸等于自己的情况，用来支持那些尺寸包裹内容但又想扩展尺寸的场景，为了不造成循环引用这里做特殊处理
            //当尺寸等于自己时，我们只记录_dimeValType，而把值设置为nil
            if (val == self) {
#if DEBUG
                NSLog(@"不建议这样设置，请使用LAKLayoutSize.wrap代替！");
#endif
                _valType = MyLayoutValType_Wrap;
                val = @(LAKLayoutSize.wrap);
            } else {
                _valType = MyLayoutValType_LayoutSize;
            }
        } else if ([val isKindOfClass:[UIView class]]) {
            UIView *viewVal = (UIView *)val;
            _valType = MyLayoutValType_LayoutSize;
            switch (_anchorType) {
                case MyLayoutAnchorType_Width:
                    val = viewVal.widthSize;
                    break;
                case MyLayoutAnchorType_Height:
                    val = viewVal.heightSize;
                    break;
                default:
                    NSAssert(0, @"oops!");
                    break;
            }
        } else if ([val isKindOfClass:[NSArray class]]) {
            _valType = MyLayoutValType_Array;
//        } else if ([val isKindOfClass:[MyLayoutMostSize class]]) {
//            _valType = MyLayoutValType_Most;
        } else {
            _valType = MyLayoutValType_Nil;
        }
        //特殊处理UILabel的高度是wrap的情况。
        if (_valType == MyLayoutValType_Wrap && _view != nil && _anchorType == MyLayoutAnchorType_Height) {
            if ([_view isKindOfClass:[UILabel class]]) {
                if (((UILabel *)_view).numberOfLines == 1) {
                    ((UILabel *)_view).numberOfLines = 0;
                }
            }
        }
        _val = val;
    }
    return self;
}

//加
- (LAKLayoutSize *)_myAdd:(CGFloat)val {
    if (_addVal != val) {
        _addVal = val;
    }
    return self;
}

//乘
- (LAKLayoutSize *)_myMultiply:(CGFloat)val {
    if (_multiVal != val) {
        _multiVal = val;
    }
    return self;
}

- (LAKLayoutSize *)_myMin:(CGFloat)val {
    if (self.lBoundVal.numberVal.doubleValue != val) {
        [self.lBoundVal _myEqualTo:@(val)];
    }
    return self;
}

- (LAKLayoutSize *)_myLBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal {
    if (sizeVal == self) {
#if DEBUG
        NSLog(@"不建议这样设置，请使用LAKLayoutSize.wrap代替！");
#endif
        sizeVal = @(LAKLayoutSize.wrap);
    }

    [[[self.lBoundVal _myEqualTo:sizeVal] _myAdd:addVal] _myMultiply:multiVal];
    return self;
}

- (LAKLayoutSize *)_myMax:(CGFloat)val {
    if (self.uBoundVal.numberVal.doubleValue != val) {
        [self.uBoundVal _myEqualTo:@(val)];
    }
    return self;
}

- (LAKLayoutSize *)_myUBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal {
    if (sizeVal == self) {
#if DEBUG
        NSLog(@"不建议这样设置，请使用LAKLayoutSize.wrap代替！");
#endif
        sizeVal = @(LAKLayoutSize.wrap);
    }
    [[[self.uBoundVal _myEqualTo:sizeVal] _myAdd:addVal] _myMultiply:multiVal];
    return self;
}

- (void)_myClear {
    _active = YES;
    _addVal = 0;
    _multiVal = 1;
    _lBoundVal = nil;
    _uBoundVal = nil;
    _val = nil;
    _shrink = 0;
    _priority = MyPriority_Normal;
    _valType = MyLayoutValType_Nil;
}

- (void)_mySetActive:(BOOL)active {
    _active = active;
    [_lBoundVal _mySetActive:active];
    [_uBoundVal _mySetActive:active];
}

- (CGFloat)measure {
    return self.isActive ? _myCGFloatFma(self.numberVal.doubleValue, _multiVal, _addVal) : 0;
}

- (CGFloat)measureWith:(CGFloat)size {
    return self.isActive ? _myCGFloatFma(size, _multiVal, _addVal) : size;
}

- (void)setNeedsLayout {
    if (_view != nil && _view.superview != nil && [_view.superview isKindOfClass:[LAKBaseLayout class]]) {
        LAKBaseLayout *layoutView = (LAKBaseLayout *)_view.superview;
        if (!layoutView.isMyLayouting) {
            [_view.superview setNeedsLayout];
        }
    }
}

+ (NSString *)dimenstrFromAnchor:(LAKLayoutSize *)anchor showView:(BOOL)showView {
    NSString *viewstr = @"";
    if (showView) {
        viewstr = [NSString stringWithFormat:@"view:%p.", anchor.view];
    }
    NSString *dimenstr = @"";

    switch (anchor.anchorType) {
        case MyLayoutAnchorType_Width:
            dimenstr = @"widthSize";
            break;
        case MyLayoutAnchorType_Height:
            dimenstr = @"heightSize";
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@%@", viewstr, dimenstr];
}
@end
