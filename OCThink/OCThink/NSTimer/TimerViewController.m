//
//  TimerViewController.m
//  OCThink
//
//  Created by leoli on 2018/8/16.
//  Copyright © 2018 leoli. All rights reserved.
//

#import "TimerViewController.h"
#import "WeakProxy.h"

@interface TimerViewController ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self proxyMethod];
}

- (void)addTimer {
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 原因：timer 无法释放的原因
// 查看 NSTimer 官方文档知道：timer 会对它的 target 进行强引用，即使传入 weak self 也不行
// 实际上 Debug Memory Graph 查看引用情况发现 target 根本没有指向并对 timer 进行强引用，
// 真正的原因是 NSRunLoop 会对运行在它之上的所有 timer 进行强引用

// 1.无用
// timer 对 target 进行了强引用，所以走不到这
- (void)dealloc {
    if (_timer) {
        [_timer invalidate];
    }
}

// 2. 可以释放
// 退出当前页面没问题，但是问题在于跳转到下一个页面我们并不希望它释放
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    [_timer invalidate];
//}

// 3. 使用 NSProxy
- (void)proxyMethod {
    // timer 持有 Proxy, proxy 持有 weak self
    // 这种方式解决了 timer 直接强持有 target 的问题
    // 但是还是要在 dealloc 调用 invalidate
    self.timer = [NSTimer timerWithTimeInterval:1 target:[WeakProxy proxyWithTarget:self] selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 4. 使用 block, 给 NSTimer 添加分类方法

- (void)timerAction:(NSTimer *)timer
{
    NSLog(@"%@", timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
