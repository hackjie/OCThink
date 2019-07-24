//
//  WeakStrongViewController.m
//  OCThink
//
//  Created by 李杰 on 2019/7/24.
//  Copyright © 2019 leoli. All rights reserved.
//


/// https://github.com/jspahrsummers/libextobjc
/// http://www.saitjr.com/ios/ios-libextobjc-1.html
/// https://github.com/ibireme/YYKit/blob/4e1bd1cfcdb3331244b219cbd37cc9b1ccb62b7a/YYKit/Base/YYKitMacro.h
/// RAC 中也定义了 @weakify 和 @strongify

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof(object) weak##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof(object) weak##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} {} __typeof(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} {} __typeof(object) object = block##_##object;
        #endif
    #endif
#endif

#import "WeakStrongViewController.h"

@interface WeakStrongViewController ()

@end

@implementation WeakStrongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#pragma mark - 一般的 weak 和 strong
//    __weak __typeof(self)weakSelf = self;
//    [self performBlock:^{
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf doSomething];
//    }];
    
#pragma mark - 使用宏定义 YYKitMacros、libextobjc、RAC
/// libextobjc 中的允许同时声明多个参数

/// @weakify 和 @strongify 的使用和注意⚠️
    
/// 1、使用这两个宏 @weakify 和 @strongify 单层 block 一定要成对出现，因为 @strongify 是引用了 @weakify
/// 定义的变量，不使用 @strongify 的话，@weakify 定义的变量就没有意义了
    
/// 2、如果因为循环引用在 block 里只使用 @weakify定义的 weak_self 也是可以的，但是如果 self 提前释放，
/// block 里关于 weak_self 的代码就不会执行了。

/// 3、多层 block 调用的话，需要最外层一个 @weakify 就够了，其他每个嵌套的 block 都要重新
/// @strongify(self)，因为每个 @strongify(self) 声明的变量都有作用域
    
}


@end
