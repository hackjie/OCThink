//
//  NavigationTestTwoViewController.m
//  OCThink
//
//  Created by 李杰 on 2018/11/6.
//  Copyright © 2018年 leoli. All rights reserved.
//

#import "NavigationTestTwoViewController.h"
#import "UINavigationController+Navbar.h"

@interface NavigationTestTwoViewController ()

@end

@implementation NavigationTestTwoViewController
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//
//    // 隐藏导航栏会导致侧滑手势失效问题
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Three";
    self.lj_prefersNavigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
