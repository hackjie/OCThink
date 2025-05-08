//
//  LAKLayoutSize.h
//  MyLayout
//
//  Created by 李杰 on 2025/03/13.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "LAKLayoutDef.h"

@class MyLayoutMostSize;

@interface LAKLayoutSize : NSObject <NSCopying>

/**特殊的尺寸，表示尺寸由子视图决定或者由内容决定，也就是说尺寸自适应*/
@property (class, nonatomic, assign, readonly) NSInteger wrap;

/**特殊的尺寸，表示尺寸会填充满父视图的剩余空间。*/
@property (class, nonatomic, assign, readonly) NSInteger fill;

/**特殊的尺寸，表示清除尺寸的约束设置，等价于:equalTo(nil)*/
@property (class, nonatomic, assign, readonly) NSInteger empty;

/**特殊的尺寸，表示尺寸会均分父视图的剩余空间。目前只用在表格布局MyTableLayout */
@property (class, nonatomic, assign, readonly) NSInteger average;
- (void)clear;
@property (nonatomic, assign, getter=isActive) BOOL active;

// shrink属性和子视图的weight属性的区别是：前者在剩余空间不足时起作用，后者在有剩余空间时起作用
@property (nonatomic, assign) CGFloat shrink;
@property (nonatomic, assign, readonly) BOOL isWrap;
@property (nonatomic, assign, readonly) BOOL isFill;

/// 设置尺寸的最大边界数值
- (LAKLayoutSize * (^)(CGFloat val))max;
/// 设置尺寸的最小边界数值
- (LAKLayoutSize * (^)(CGFloat val))min;

@end
