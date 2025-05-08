//
//  PerformanceTestViewController.m
//  OCThink
//
//  Created by 李杰 on 2025/5/8.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "PerformanceTestViewController.h"
#import "PerformanceObj.h"

@interface PerformanceTestViewController ()

@end

@implementation PerformanceTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self test];
    [self test1];
}

//方法调用性能排序
// 直接方法调用
// @selector()
// NSStringFromString()

- (void)test {
    NSInteger iterations = 100000;
    
    // NSSelectorFromString
    CFAbsoluteTime dynamicStart = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < iterations; i++) {
        SEL selector = NSSelectorFromString(@"printString");
        [PerformanceObj performSelector:selector];
    }
    CFAbsoluteTime dynamicEnd = CFAbsoluteTimeGetCurrent();
    NSLog(@"动态方法耗时: %f", (dynamicEnd - dynamicStart)*1000);
    
    // 直接方法
    CFAbsoluteTime directStart = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < iterations; i++) {
        [PerformanceObj printString];
    }
    CFAbsoluteTime directEnd = CFAbsoluteTimeGetCurrent();
    NSLog(@"直接方法耗时: %f", (directEnd - directStart)*1000);
}

- (void)test1 {
    NSInteger iterations = 100000;
    
    // 直接方法
    CFAbsoluteTime directStart = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < iterations; i++) {
        [PerformanceObj printString];
    }
    CFAbsoluteTime directEnd = CFAbsoluteTimeGetCurrent();
    NSLog(@"直接方法耗时: %f", (directEnd - directStart)*1000);
    
    // NSSelectorFromString
    CFAbsoluteTime dynamicStart = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < iterations; i++) {
        SEL selector = NSSelectorFromString(@"printString");
        [PerformanceObj performSelector:selector];
    }
    CFAbsoluteTime dynamicEnd = CFAbsoluteTimeGetCurrent();
    NSLog(@"动态方法耗时: %f", (dynamicEnd - dynamicStart)*1000);
}

- (void)testMethod {
    NSString *hello = @"hello";
    NSString *world = @"world";
    NSString *word = [NSString stringWithFormat:@"%@ %@", hello, world];
}

@end
