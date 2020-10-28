//
//  TestNSObjectViewController.m
//  OCThink
//
//  Created by Ryan | 沐秋 on 2020/7/17.
//  Copyright © 2020 leoli. All rights reserved.
//

#import "TestNSObjectViewController.h"

@interface TestNSObjectViewController ()

@end

@implementation TestNSObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSArray *numberArray = @[@9,@5,@2,@6,@3,@7,@5];
//    // 普通排序系统自带的升序
//    NSArray *array1 = [numberArray sortedArrayUsingSelector:@selector(compare:)];
//    NSLog(@"普通排序默认升序:%@", array1);
//    
//    // 逆转数组, 翻转
//    NSArray *array2 = [numberArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        return NSOrderedDescending;
//    }];
//    NSLog(@"翻转:%@", array2);
//    
//    // 顺序输出
//    NSArray *array3 = [numberArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        return NSOrderedAscending;
//    }];
//    NSLog(@"顺序输出:%@", array3);
//    
//    // 升序排序
//    NSArray *array4 = [numberArray sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
//        NSComparisonResult result = [obj1 compare: obj2];
//        return result;
//    }];
//    NSLog(@"升序排列:%@", array4);
//    
//    // 降序排序
//    NSArray *array5 = [numberArray sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
//        NSComparisonResult result = [obj1 compare: obj2];
//        return -result;
//    }];
//    NSLog(@"降序排列:%@", array5);
    NSUUID *uuid = [NSUUID UUID];
    NSLog(@"uuid:%@", uuid);
    
}

@end
