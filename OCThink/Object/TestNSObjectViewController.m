//
//  TestNSObjectViewController.m
//  OCThink
//
//  Created by Ryan | 沐秋 on 2020/7/17.
//  Copyright © 2020 leoli. All rights reserved.
//

#import "TestNSObjectViewController.h"
#import "OCThink-Swift.h"
#import "LALLinearLayout.h"


@interface TestNSObjectViewController ()

@end

@implementation TestNSObjectViewController {
    LALLinearLayout* items;
    LALLinearLayout* items2;
    LALLinearLayout* items3;
    LALLinearLayout* layout;
    NSInteger count;
    NSInteger count2;
    NSInteger count3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"iOS LinearLayout";
    
    [self test1];
    [self test2];
    [self test3];
    [self test4];
    [self test5];
    [self test6];
    [self test7];
    [self test8];
}

- (void)test1 {
    layout = [[LALLinearLayout alloc] initWithOrientation:ORIENTATION_HORIZONTAL];
    CGFloat layoutH = 40;
    layout.backgroundColor = UIColor.grayColor;
    layout.paddingTop = 20;
    layout.frame = CGRectMake(0, 100, self.view.bounds.size.width, 60);
    
    UILabel *label0 = [UILabel new];
    label0.text = @"label1 weight:0, label2 weight:0, label3 weight: 0";
    label0.textColor = UIColor.whiteColor;
    label0.font = [UIFont systemFontOfSize:12];
    label0.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
    [layout addSubview:label0];
    
    CGFloat childW = 50;
    UILabel *label1 = [UILabel new];
    label1.backgroundColor = UIColor.redColor;
    label1.text = @"label1";
    LALLinearLayoutParams *params1 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:0];
    [layout addSubview:label1 lp:params1];
    
    UILabel *label2 = [UILabel new];
    label2.backgroundColor = UIColor.blueColor;
    label2.text = @"label2";
    LALLinearLayoutParams *params2 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:0];
    [layout addSubview:label2 lp:params2];
    
    UILabel *label3 = [UILabel new];
    label3.backgroundColor = UIColor.greenColor;
    label3.text = @"label3";
    LALLinearLayoutParams *params3 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:0];
    [layout addSubview:label3 lp:params3];
    
    [self.view addSubview:layout];
}

- (void)test2 {
    layout = [[LALLinearLayout alloc] initWithOrientation:ORIENTATION_HORIZONTAL];
    CGFloat layoutH = 40;
    layout.backgroundColor = UIColor.grayColor;
    layout.paddingTop = 20;
    layout.frame = CGRectMake(0, 100+70, self.view.bounds.size.width, 60);
    
    UILabel *label0 = [UILabel new];
    label0.text = @"label1 weight:0, label2 weight:0, label3 weight: 1";
    label0.textColor = UIColor.whiteColor;
    label0.font = [UIFont systemFontOfSize:12];
    label0.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
    [layout addSubview:label0];
    
    CGFloat childW = 50;
    UILabel *label1 = [UILabel new];
    label1.backgroundColor = UIColor.redColor;
    label1.text = @"label1";
    LALLinearLayoutParams *params1 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:0];
    [layout addSubview:label1 lp:params1];
    
    UILabel *label2 = [UILabel new];
    label2.backgroundColor = UIColor.blueColor;
    label2.text = @"label2";
    LALLinearLayoutParams *params2 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:0];
    [layout addSubview:label2 lp:params2];
    
    UILabel *label3 = [UILabel new];
    label3.backgroundColor = UIColor.greenColor;
    label3.text = @"label3";
    LALLinearLayoutParams *params3 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label3 lp:params3];
    
    [self.view addSubview:layout];
}

- (void)test3 {
    layout = [[LALLinearLayout alloc] initWithOrientation:ORIENTATION_HORIZONTAL];
    CGFloat layoutH = 40;
    layout.backgroundColor = UIColor.grayColor;
    layout.paddingTop = 20;
    layout.frame = CGRectMake(0, 100+70*2, self.view.bounds.size.width, 60);
    
    UILabel *label0 = [UILabel new];
    label0.text = @"label1 weight:1, label2 weight:0, label3 weight: 0";
    label0.textColor = UIColor.whiteColor;
    label0.font = [UIFont systemFontOfSize:12];
    label0.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
    [layout addSubview:label0];
    
    CGFloat childW = 50;
    UILabel *label1 = [UILabel new];
    label1.backgroundColor = UIColor.redColor;
    label1.text = @"label1";
    LALLinearLayoutParams *params1 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label1 lp:params1];
    
    UILabel *label2 = [UILabel new];
    label2.backgroundColor = UIColor.blueColor;
    label2.text = @"label2";
    LALLinearLayoutParams *params2 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:0];
    [layout addSubview:label2 lp:params2];
    
    UILabel *label3 = [UILabel new];
    label3.backgroundColor = UIColor.greenColor;
    label3.text = @"label3";
    LALLinearLayoutParams *params3 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:0];
    [layout addSubview:label3 lp:params3];
    
    [self.view addSubview:layout];
}

- (void)test4 {
    layout = [[LALLinearLayout alloc] initWithOrientation:ORIENTATION_HORIZONTAL];
    CGFloat layoutH = 40;
    layout.backgroundColor = UIColor.grayColor;
    layout.paddingTop = 20;
    layout.frame = CGRectMake(0, 100+70*3, self.view.bounds.size.width, 60);
    
    UILabel *label0 = [UILabel new];
    label0.text = @"label1 weight:1, label2 weight:1, label3 weight: 1";
    label0.textColor = UIColor.whiteColor;
    label0.font = [UIFont systemFontOfSize:12];
    label0.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
    [layout addSubview:label0];
    
    CGFloat childW = 50;
    UILabel *label1 = [UILabel new];
    label1.backgroundColor = UIColor.redColor;
    label1.text = @"label1";
    LALLinearLayoutParams *params1 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label1 lp:params1];
    
    UILabel *label2 = [UILabel new];
    label2.backgroundColor = UIColor.blueColor;
    label2.text = @"label2";
    LALLinearLayoutParams *params2 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label2 lp:params2];
    
    UILabel *label3 = [UILabel new];
    label3.backgroundColor = UIColor.greenColor;
    label3.text = @"label3";
    LALLinearLayoutParams *params3 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label3 lp:params3];
    
    [self.view addSubview:layout];
}

- (void)test5 {
    layout = [[LALLinearLayout alloc] initWithOrientation:ORIENTATION_HORIZONTAL];
    CGFloat layoutH = 40;
    layout.backgroundColor = UIColor.grayColor;
    layout.paddingTop = 20;
    layout.frame = CGRectMake(0, 100+70*4, self.view.bounds.size.width, 60);
    
    UILabel *label0 = [UILabel new];
    label0.text = @"label1 match_parent, label2 weight:1, label3 weight: 1";
    label0.textColor = UIColor.whiteColor;
    label0.font = [UIFont systemFontOfSize:12];
    label0.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
    [layout addSubview:label0];
    
    CGFloat childW = 50;
    UILabel *label1 = [UILabel new];
    label1.backgroundColor = UIColor.redColor;
    label1.text = @"label1";
    LALLinearLayoutParams *params1 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:LALMatchParent height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label1 lp:params1];
    
    UILabel *label2 = [UILabel new];
    label2.backgroundColor = UIColor.blueColor;
    label2.text = @"label2";
    LALLinearLayoutParams *params2 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label2 lp:params2];
    
    UILabel *label3 = [UILabel new];
    label3.backgroundColor = UIColor.greenColor;
    label3.text = @"label3";
    LALLinearLayoutParams *params3 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label3 lp:params3];
    
    [self.view addSubview:layout];
}

- (void)test6 {
    layout = [[LALLinearLayout alloc] initWithOrientation:ORIENTATION_HORIZONTAL];
    CGFloat layoutH = 40;
    layout.backgroundColor = UIColor.grayColor;
    layout.paddingTop = 20;
    layout.frame = CGRectMake(0, 100+70*5, self.view.bounds.size.width, 60);
    
    UILabel *label0 = [UILabel new];
    label0.text = @"label1 weight:1, label2 match_parent, label3 weight: 1";
    label0.textColor = UIColor.whiteColor;
    label0.font = [UIFont systemFontOfSize:12];
    label0.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
    [layout addSubview:label0];
    
    CGFloat childW = 50;
    UILabel *label1 = [UILabel new];
    label1.backgroundColor = UIColor.redColor;
    label1.text = @"label1";
    LALLinearLayoutParams *params1 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label1 lp:params1];
    
    UILabel *label2 = [UILabel new];
    label2.backgroundColor = UIColor.blueColor;
    label2.text = @"label2";
    LALLinearLayoutParams *params2 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:LALMatchParent height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label2 lp:params2];
    
    UILabel *label3 = [UILabel new];
    label3.backgroundColor = UIColor.greenColor;
    label3.text = @"label3";
    LALLinearLayoutParams *params3 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label3 lp:params3];
    
    [self.view addSubview:layout];
}

- (void)test7 {
    layout = [[LALLinearLayout alloc] initWithOrientation:ORIENTATION_HORIZONTAL];
    CGFloat layoutH = 40;
    layout.backgroundColor = UIColor.grayColor;
    layout.paddingTop = 20;
    layout.frame = CGRectMake(0, 100+70*6, self.view.bounds.size.width, 60);
    
    UILabel *label0 = [UILabel new];
    label0.text = @"label1 weight:1, label2 weight:1, label3 match_parent";
    label0.textColor = UIColor.whiteColor;
    label0.font = [UIFont systemFontOfSize:12];
    label0.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
    [layout addSubview:label0];
    
    CGFloat childW = 50;
    UILabel *label1 = [UILabel new];
    label1.backgroundColor = UIColor.redColor;
    label1.text = @"label1";
    LALLinearLayoutParams *params1 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label1 lp:params1];
    
    UILabel *label2 = [UILabel new];
    label2.backgroundColor = UIColor.blueColor;
    label2.text = @"label2";
    LALLinearLayoutParams *params2 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label2 lp:params2];
    
    UILabel *label3 = [UILabel new];
    label3.backgroundColor = UIColor.greenColor;
    label3.text = @"label3";
    LALLinearLayoutParams *params3 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:LALMatchParent height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label3 lp:params3];
    
    [self.view addSubview:layout];
}

- (void)test8 {
    layout = [[LALLinearLayout alloc] initWithOrientation:ORIENTATION_VERTICAL];
    CGFloat layoutH = 40;
    layout.backgroundColor = UIColor.grayColor;
    layout.paddingTop = 20;
    layout.frame = CGRectMake(0, 100+70*7, self.view.bounds.size.width, 200);
    
    UILabel *label0 = [UILabel new];
    label0.text = @"label1 weight:0, label2 weight:1, label3 weight:1";
    label0.textColor = UIColor.whiteColor;
    label0.font = [UIFont systemFontOfSize:12];
    label0.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
    [layout addSubview:label0];
    
    CGFloat childW = 50;
    UILabel *label1 = [UILabel new];
    label1.backgroundColor = UIColor.redColor;
    label1.text = @"label1";
    LALLinearLayoutParams *params1 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:0];
    [layout addSubview:label1 lp:params1];
    
    UILabel *label2 = [UILabel new];
    label2.backgroundColor = UIColor.blueColor;
    label2.text = @"label2";
    LALLinearLayoutParams *params2 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label2 lp:params2];
    
    UILabel *label3 = [UILabel new];
    label3.backgroundColor = UIColor.greenColor;
    label3.text = @"label3";
    LALLinearLayoutParams *params3 = [[LALLinearLayoutParams alloc] initWithSizeAndGravity:childW height:layoutH gravity:[LALGravity NO_GRAVITY] weight:1];
    [layout addSubview:label3 lp:params3];
    
    [self.view addSubview:layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

