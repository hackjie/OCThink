//
//  UIComponentViewController.m
//  OCThink
//
//  Created by Ryan | 沐秋 on 2020/5/25.
//  Copyright © 2020 leoli. All rights reserved.
//

#import "UIComponentViewController.h"
#import "CustomPageControl.h"

@interface UIComponentViewController ()
@property (nonatomic, strong) CustomPageControl *pageControl;
@end

@implementation UIComponentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.pageControl];
    self.pageControl.currentIndicatorImage = [UIImage imageNamed:@"pageControl_selected"];
    self.pageControl.currentIndicatorWidth = 20;
    self.pageControl.pageIndicatorImage = [UIImage imageNamed:@"pageControl_normal"];
    self.pageControl.pageIndicatorWidth = 4;
    self.pageControl.indicatorHeight = 4;
    self.pageControl.padding = 5;
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    
    UIButton *preBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, 50, 50)];
    preBtn.backgroundColor = [UIColor blackColor];
    [preBtn setTitle:@"pre" forState:UIControlStateNormal];
    [preBtn addTarget:self action:@selector(preAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preBtn];
    
    UIButton *afterBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 50, 50)];
    afterBtn.backgroundColor = [UIColor blackColor];
    [afterBtn setTitle:@"after" forState:UIControlStateNormal];
    [afterBtn addTarget:self action:@selector(afterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:afterBtn];
}

- (void)preAction
{
    self.pageControl.currentPage = self.pageControl.currentPage - 1;
}

- (void)afterAction
{
    self.pageControl.currentPage = self.pageControl.currentPage + 1;
}

#pragma mark - Getters
- (CustomPageControl *)pageControl
{
    if (!_pageControl) {
        CGRect frame = CGRectMake(0, 200, UIScreen.mainScreen.bounds.size.width, 40);
        _pageControl = [[CustomPageControl alloc] initWithFrame:frame];
//        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
//        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    }
    return _pageControl;
}
@end
