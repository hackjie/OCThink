//
//  TestContainerView.h
//  OCThink
//
//  Created by 李杰 on 2025/3/7.
//  Copyright © 2025 leoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubTestView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestContainerView : UIView
@property (nonatomic, strong) SubTestView *child;
@end

NS_ASSUME_NONNULL_END
