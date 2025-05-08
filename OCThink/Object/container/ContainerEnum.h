//
//  ContainerEnum.h
//  OCThink
//
//  Created by 李杰 on 2025/2/14.
//  Copyright © 2025 leoli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define Match_Parent 99998
#define Wrap_Content 99999


typedef NS_ENUM(NSUInteger, KGravity) {
    KGravityTop,
    KGravityBottom,
    KGravityCenterHorizontal,
    KGravityCenter,
    KGravityLeft,
    KGravityRight,
    KGravityCenterVertical
};

typedef NS_ENUM(NSUInteger, KDirection) {
    KDirectionHorizontal,
    KDirectionVertical
};


@interface ContainerEnum : NSObject

@end

NS_ASSUME_NONNULL_END
