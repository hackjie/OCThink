//
//  ViewController.m
//  OCThink
//
//  Created by leoli on 2018/8/15.
//  Copyright © 2018 leoli. All rights reserved.
//

#import "ViewController.h"
#import "SubProxy.h"
#import "TimerViewController.h"
#import "StringViewController.h"
#import "MsgViewController.h"
#import "TextStyleViewController.h"
#import "ImageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIButton *jumpBtn = [[UIButton alloc] init];
    jumpBtn.frame = CGRectMake(60, 120, 80, 40);
    jumpBtn.backgroundColor = [UIColor blueColor];
    [jumpBtn setTitle:@"哈哈" forState:UIControlStateNormal];
    [jumpBtn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testProxy {
    NSMutableArray *array = [NSMutableArray array];
    SubProxy *proxy = [[SubProxy alloc] initWithTarget:array];
    BOOL isProxy = [proxy isKindOfClass:[SubProxy class]];

    NSLog(@"%d", isProxy);
}

- (void)jump
{
    ImageViewController *VC = [[ImageViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}


@end


