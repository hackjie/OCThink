//
//  OCTools.h
//  OCThink
//
//  Created by 李杰 on 2022/7/13.
//  Copyright © 2022 leoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCTools : NSObject
/// 获取window顶部安全区高度
- (CGFloat)getWindowSafeAreaTop;

/// 获取window底部安全区高度
- (CGFloat)getWindowSafeAreaBottom;
@end

NS_ASSUME_NONNULL_END
