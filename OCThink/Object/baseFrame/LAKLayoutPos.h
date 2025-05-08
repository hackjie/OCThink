//
//  LAKLayoutPos.h
//  MyLayout
//
//  Created by 李杰 on 2025/03/13.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "LAKLayoutDef.h"

@class MyLayoutMostPos;

@interface LAKLayoutPos : NSObject <NSCopying>
- (void)clear;
@property (nonatomic, assign, getter=isActive) BOOL active;
@property (nonatomic, assign) CGFloat shrink;

/// 设置位置的最小边界数值
- (LAKLayoutPos * (^)(CGFloat val))min;
/// 设置位置的最大边界数值
- (LAKLayoutPos * (^)(CGFloat val))max;

@end
