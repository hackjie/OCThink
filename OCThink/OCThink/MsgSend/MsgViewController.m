//
//  MsgViewController.m
//  OCThink
//
//  Created by leoli on 2018/8/20.
//  Copyright © 2018 leoli. All rights reserved.
//

#import "MsgViewController.h"

// 用来验证消息发送、转发的整个过程
@interface MsgViewController ()

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    // 对象收到无法解读的方法后，会首先调用
    // sel 就是那个方法
    return YES;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    // 尚未实现的是类方法，会首先调用
    return YES;
}

@end
