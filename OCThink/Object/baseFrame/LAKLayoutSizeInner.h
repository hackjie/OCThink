//
//  LAKLayoutSizeInner.h
//  MyLayout
//
//  Created by 李杰 on 2025/03/13.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "LAKLayoutMath.h"
#import "LAKLayoutSize.h"

//尺寸对象内部定义
@interface LAKLayoutSize ()

@property (nonatomic, weak) UIView *view;
@property (nonatomic, assign) MyLayoutAnchorType anchorType;

@property (nonatomic, assign) MyLayoutValType valType;
@property (nonatomic, strong) id val;
@property (nonatomic, readonly, strong) NSNumber *numberVal;
@property (nonatomic, readonly, strong) LAKLayoutSize *anchorVal;
@property (nonatomic, readonly, strong) NSArray *arrayVal;

@property (nonatomic, readonly, assign) BOOL wrapVal;
@property (nonatomic, readonly, assign) BOOL fillVal;

@property (nonatomic, strong) LAKLayoutSize *lBoundVal;
@property (nonatomic, strong) LAKLayoutSize *uBoundVal;

@property (nonatomic, readonly, strong) LAKLayoutSize *lBoundValInner;
@property (nonatomic, readonly, strong) LAKLayoutSize *uBoundValInner;

@property (nonatomic, assign) CGFloat addVal;
@property (nonatomic, assign) CGFloat multiVal;

//优先级，内部使用，值是0，500， 1000 分别代表低、中、高，默认是500，这个属性先内部生效。
@property (nonatomic, assign) MyPriority priority;

- (LAKLayoutSize * (^)(id val))myEqualTo;
- (LAKLayoutSize * (^)(CGFloat val))myAdd;
- (LAKLayoutSize * (^)(CGFloat val))myMultiply;
- (LAKLayoutSize * (^)(CGFloat val))myMin;
//- (LAKLayoutSize * (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myLBound;
- (LAKLayoutSize * (^)(CGFloat val))myMax;
//- (LAKLayoutSize * (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myUBound;
- (void)myClear;

- (LAKLayoutSize *)_myEqualTo:(id)val;
- (LAKLayoutSize *)_myEqualTo:(id)val priority:(NSInteger)priority;
- (LAKLayoutSize *)_myAdd:(CGFloat)val;
- (LAKLayoutSize *)_myMultiply:(CGFloat)val;
- (LAKLayoutSize *)_myMin:(CGFloat)val;
//- (LAKLayoutSize *)_myLBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal;
- (LAKLayoutSize *)_myMax:(CGFloat)val;
//- (LAKLayoutSize *)_myUBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal;
- (void)_myClear;
- (void)_mySetActive:(BOOL)active;

//只有为数值时才有意义。
@property (nonatomic, readonly, assign) CGFloat measure;

- (CGFloat)measureWith:(CGFloat)size;

@end
