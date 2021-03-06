//
//  NavigationTestOneViewController.m
//  OCThink
//
//  Created by 李杰 on 2018/11/6.
//  Copyright © 2018年 leoli. All rights reserved.
//

#import "NavigationTestOneViewController.h"
#import "NavigationTestTwoViewController.h"
#import <objc/runtime.h>
#import "UINavigationController+Navbar.h"

// 使用 viewWillAppear 和 viewWillDisappear 处理隐藏导航栏
// 但是主要会遇到3个问题：

// 1. 隐藏会导致侧滑手势失效，需要重新制定self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
// 2. tabbar 切换的时候会出现上移的问题
// 3. 连续两个隐藏导航栏，第二个侧滑回来会出现断层
@interface NavigationTestOneViewController ()

@end

@implementation NavigationTestOneViewController

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
    
    UIButton *jumpBtn = [[UIButton alloc] init];
    jumpBtn.frame = CGRectMake(60, 120, 80, 40);
    jumpBtn.backgroundColor = [UIColor blueColor];
    [jumpBtn setTitle:@"Two" forState:UIControlStateNormal];
    [jumpBtn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpBtn];
    
    self.title = @"Two";
    [self sayHello];
    [super sayHello];
    
    [self logClassMethods];
    
    self.lj_prefersNavigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
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

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(sayHello);
        SEL swizzledSelector = @selector(haha_sayHello);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

        if (success) {
            // 将方法添加到当前类
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

//- (void)sayHello {
//    NSLog(@"this hello");
//}

- (void)haha_sayHello {
    [self haha_sayHello];
    NSLog(@"haha_sayHello");
}

- (void)logClassMethods
{
    unsigned int count;
    Method *methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        NSLog(@"方法 名字 ==== %@",name);
    }
}

@end
