//
//  ImageViewController.m
//  OCThink
//
//  Created by leoli on 2018/9/29.
//  Copyright © 2018 leoli. All rights reserved.
//

#import "ImageViewController.h"
#import <objc/runtime.h>

// 使用私有 framework，通过运行时可以根据私有 framework 头文件实现有趣的功能
// 模拟器需要引入 framework

// 参考
// 1. https://github.com/nst/iOS-Runtime-Headers
// 2. http://www.developer.limneos.net/index.php
// 3. http://stevenygard.com

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    [self systemScan];
}

- (void)systemScan {
    NSBundle *b = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/FTServices.framework"];
    BOOL success = [b load];

    Class FTDeviceSupport = NSClassFromString(@"FTDeviceSupport");
    id si = [FTDeviceSupport valueForKey:@"sharedInstance"];

    NSLog(@"-- %@", [si valueForKey:@"deviceColor"]);
}

- (void)showAllApps {
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray *appList = [workspace performSelector:@selector(allApplications)];

    Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");

    NSLog(@"%@", appList);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
