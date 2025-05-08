//
//  LAKLayoutPosInner.h
//  MyLayout
//
//  Created by 李杰 on 2025/03/13.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "LAKLayoutMath.h"
#import "LAKLayoutPos.h"

//布局位置内部定义
@interface LAKLayoutPos ()

@property (nonatomic, weak) UIView *view;
@property (nonatomic, assign) MyLayoutAnchorType anchorType;
@property (nonatomic, assign) MyLayoutValType valType;
@property (nonatomic, strong) id val;
@property (nonatomic, readonly, strong) NSNumber *numberVal;
@property (nonatomic, readonly, strong) LAKLayoutPos *anchorVal;
@property (nonatomic, readonly, strong) NSArray *arrayVal;
//@property (nonatomic, readonly, strong) NSNumber *mostVal;

@property (nonatomic, strong) LAKLayoutPos *lBoundVal;
@property (nonatomic, strong) LAKLayoutPos *uBoundVal;

@property (nonatomic, readonly, strong) LAKLayoutPos *lBoundValInner;
@property (nonatomic, readonly, strong) LAKLayoutPos *uBoundValInner;

@property (nonatomic, assign) CGFloat offsetVal;

- (LAKLayoutPos * (^)(id val))myEqualTo;
- (LAKLayoutPos * (^)(CGFloat val))myOffset;
- (LAKLayoutPos * (^)(CGFloat val))myMin;
- (LAKLayoutPos * (^)(id posVal, CGFloat offset))myLBound;
- (LAKLayoutPos * (^)(CGFloat val))myMax;
- (LAKLayoutPos * (^)(id posVal, CGFloat offset))myUBound;
- (void)myClear;

- (LAKLayoutPos *)_myEqualTo:(id)val;
- (LAKLayoutPos *)_myOffset:(CGFloat)val;
- (LAKLayoutPos *)_myMin:(CGFloat)val;
- (LAKLayoutPos *)_myLBound:(id)posVal offsetVal:(CGFloat)offsetVal;
- (LAKLayoutPos *)_myMax:(CGFloat)val;
- (LAKLayoutPos *)_myUBound:(id)posVal offsetVal:(CGFloat)offsetVal;
- (void)_myClear;
- (void)_mySetActive:(BOOL)active;

// minVal <= posNumVal + offsetVal <=maxVal . 注意这个只试用于相对布局。对于线性布局和框架布局来说，因为可以支持相对边距。
// 所以线性布局和框架布局不能使用这个属性。
@property (nonatomic, readonly, assign) CGFloat measure;

//获取真实的位置值
- (CGFloat)measureWith:(CGFloat)size;
- (BOOL)isRelativePos;

@end
