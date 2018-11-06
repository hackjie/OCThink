//
//  NavigationTestOneViewController.m
//  OCThink
//
//  Created by 李杰 on 2018/11/6.
//  Copyright © 2018年 leoli. All rights reserved.
//

#import "NavigationTestOneViewController.h"
#import "NavigationTestTwoViewController.h"

@interface NavigationTestOneViewController ()

@end

@implementation NavigationTestOneViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = true;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *jumpBtn = [[UIButton alloc] init];
    jumpBtn.frame = CGRectMake(60, 120, 80, 40);
    jumpBtn.backgroundColor = [UIColor blueColor];
    [jumpBtn setTitle:@"Two" forState:UIControlStateNormal];
    [jumpBtn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpBtn];
    
    self.title = @"Two";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)jump
{
    NavigationTestTwoViewController *VC = [[NavigationTestTwoViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
