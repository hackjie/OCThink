//
//  OCSingleton.m
//  OCThink
//
//  Created by Ryan | 沐秋 on 2021/1/19.
//  Copyright © 2021 leoli. All rights reserved.
//

#import "OCSingleton.h"

static OCSingleton *instance = nil;

@interface OCSingleton()<NSCopying,NSMutableCopying>

@end

@implementation OCSingleton
+ (instancetype)shareInstance
{
    return [[self alloc] init];
}

- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super init];
        NSLog(@"%@:----创建了",NSStringFromSelector(_cmd));
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return instance;
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return instance;
}

+ (void)destoryInstance
{
    instance = nil;
    NSLog(@"%@:----释放了",NSStringFromSelector(_cmd));
}

@end
