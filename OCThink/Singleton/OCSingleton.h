//
//  OCSingleton.h
//  OCThink
//
//  Created by Ryan | 沐秋 on 2021/1/19.
//  Copyright © 2021 leoli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCSingleton : NSObject
+(instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
