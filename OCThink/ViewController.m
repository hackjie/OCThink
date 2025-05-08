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
#import "NavigationTestOneViewController.h"
#import "UINavigationController+Navbar.h"
#import "AutolayoutViewController.h"
#import "UIComponentViewController.h"
#import "MailViewController.h"
#import "TestNSObjectViewController.h"
#import "TestExceptions.h"
#import "OCSingleton.h"
#import "OCThink-Swift.h"
#import "PerformanceTestViewController.h"
#import <Masonry/Masonry.h>

@interface ViewController ()
@property (nonatomic, strong) UIButton *jumpBtn;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) TestNSObjectViewController *objVC;
@end

@implementation ViewController

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    //    self.navigationController.navigationBarHidden = false;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Start";
    _objVC = [[TestNSObjectViewController alloc] init];
    
  
//    NSLog(@"%f", [self getWindowSafeAreaTop]);
//    NSLog(@"%f", [self getWindowSafeAreaBottom]);

    UIButton *jumpBtn = [[UIButton alloc] init];
    jumpBtn.frame = CGRectMake(60, 120, 80, 40);
    jumpBtn.backgroundColor = [UIColor blueColor];
    [jumpBtn setTitle:@"哈哈" forState:UIControlStateNormal];
    [jumpBtn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpBtn];
    _jumpBtn = jumpBtn;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
//    
//    NSMutableArray *array = [@[@"hello://fff", @"hddhd"] mutableCopy];
//    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
//        return ![evaluatedObject containsString:@"hello:"];
//    }];
//    [array filterUsingPredicate:predicate];
//    NSLog(@"%@", array);
//    
//    [OCSingleton shareInstance];
//    
//    //sleep(2);
//    
//    [OCSingleton destoryInstance];
//    
//    
//    // less use @try catch, but sometimes can use it to debug
//    @try {
//        TestExceptions *exception = [[TestExceptions alloc] init];
//        // exception not release
//        @throw [[NSException alloc] initWithName:@"主动异常" reason:@"这是错误原因" userInfo:nil];
//    }
//    @catch (NSException *e) {
//        NSLog(@"%@",e);
//    }
//    
//    // like this eg
//    NSArray* arraytest = [[NSArray alloc] init];
//     
//    @try
//    {
//      // Attempt access to an empty array
//      NSLog(@"Object: %@", [arraytest objectAtIndex:0]);
//     
//    }
//    @catch (NSException *exception)
//    {
//      // Print exception information
//      NSLog( @"NSException caught" );
//      NSLog( @"Name: %@", exception.name);
//      NSLog( @"Reason: %@", exception.reason );
//      return;
//    }
//    @finally
//    {
//      // Cleanup, in both success and fail cases
//      NSLog( @"In finally block");
//    }
}

- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    //    self.bottomLayoutGuide.topAnchor;
    //    self.view.safeAreaLayoutGuide.layoutFrame;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //    self.bottomLayoutGuide.topAnchor;
    //    self.view.safeAreaLayoutGuide.layoutFrame;
    // safeArea 的调用时机很重要，viewDidLoad 里拿不到
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
    PerformanceTestViewController *VC = [[PerformanceTestViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
  
//  LJSegmentedViewController *vc = [[LJSegmentedViewController alloc] init];
//  [self.navigationController pushViewController:vc animated:YES];
}

// 获取window顶部安全区高度
- (CGFloat)getWindowSafeAreaTop {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.top;//44
    }
    return 0.0;
}

// 获取window底部安全区高度
- (CGFloat)getWindowSafeAreaBottom {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;//34
    }
    return 0.0;
}

@end


