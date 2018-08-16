//
//  TimerViewController.m
//  OCThink
//
//  Created by leoli on 2018/8/16.
//  Copyright © 2018 leoli. All rights reserved.
//

#import "TimerViewController.h"

@interface TimerViewController ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction:(NSTimer *)timer
{
    NSLog(@"%@", timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
