//
//  PerformanceObj.m
//  OCThink
//
//  Created by 李杰 on 2025/5/8.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "PerformanceObj.h"

@implementation PerformanceObj
+ (void)printString {
    NSString *hello = @"hello";
    NSString *world = @"world";
    NSString *word = [NSString stringWithFormat:@"%@ %@", hello, world];
}
@end
