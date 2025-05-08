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
#import <Masonry/Masonry.h>
#import "TestFrameLayout.h"
#import "TestLinearLayout.h"
#import "UIView+Constraints.h"
#import "KBadgeTitleView.h"
#import "TestContainerView.h"
#import "LAKLinearLayout.h"
#import "LAKFrameLayout.h"

@interface TestNSObjectViewController ()
@property (nonatomic, strong) TestLinearLayout *containerlayout;
@property (nonatomic, strong) TestFrameLayout *flMainImgAndTag;
@property (nonatomic, strong) UIImageView *ivMain;

@property (nonatomic, strong) TestFrameLayout *tagContainer;
@property (nonatomic, strong) TestFrameLayout *tagTopBackgroundContainer;
@property (nonatomic, strong) UILabel *tvTagBenefitText;
@property (nonatomic, strong) TestFrameLayout *tagBottomBackgroundContainer;
@property (nonatomic, strong) UILabel *tvTagBenefitText2;
@property (nonatomic, strong) UIImageView *ivTagIcon;

@property (nonatomic, strong) TestLinearLayout *infoLayout;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *title2Label;

@property (nonatomic, strong) TestLinearLayout *tagLayout;
@property (nonatomic, strong) UILabel *tagTitleLabel;


@property (nonatomic, strong) KBadgeTitleView *badgeTitleView;

@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, strong) TestContainerView *testContainerView;
@end

@implementation TestNSObjectViewController
//- (void)loadView {
//    LAKLinearLayout *horzLayout = [LAKLinearLayout linearLayoutWithOrientation:LAKOrientation_Vert];
//    horzLayout.backgroundColor = [UIColor blueColor];
//    self.view = horzLayout;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"iOS LinearLayout";
    
    [self testBadgeTitleView];
    
    //创建水平布局视图。
//    LAKFrameLayout *horzLayout = [LAKFrameLayout new];
//    horzLayout.backgroundColor = [UIColor redColor];
//    horzLayout.frame = CGRectMake(0, 100, 390, 200);
//    horzLayout.myWidth = 390;
//    [self.view addSubview:horzLayout];
//    
//    LAKLinearLayout *linearLayout = [[LAKLinearLayout alloc] initWithOrientation:LAKOrientation_Horz];
//    linearLayout.myWidth = 370;
//    UILabel *label1 = [UILabel new];
//    label1.text = @"hellohellohellohello";
//    label1.backgroundColor = [UIColor grayColor];
//    label1.myLeft = 20;
//    label1.myWidth = LAKLayoutSize.wrap;
//    label1.widthSize.max(50);
//    label1.myHeight = LAKLayoutSize.wrap;
//    [linearLayout addSubview:label1];
//    
//    
//    UILabel *label2 = [UILabel new];
//    label2.text = @"hello";
//    label2.backgroundColor = [UIColor blueColor];
//    label2.myLeft = 10;
//    label2.weight = 1.0;
//    label2.myHeight = LAKLayoutSize.wrap;
//    [linearLayout addSubview:label2];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        label1.visibility = LAKVisibility_Gone;
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        label1.visibility = LAKVisibility_Visible;
//    });
//    
//    [horzLayout addSubview:linearLayout];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context
{
//    CGRect rcOld = [change[NSKeyValueChangeOldKey] CGRectValue];
//    CGRect rcNew = [change[NSKeyValueChangeNewKey] CGRectValue];
//    
//    NSLog(@"%@.%@", NSStringFromCGRect(rcOld), NSStringFromCGRect(rcNew));
    NSString *rcNew = change[NSKeyValueChangeNewKey];
    NSLog(@"%@", rcNew);
}


- (void)testBadgeTitleView {
    
    self.badgeTitleView = [[KBadgeTitleView alloc] init];
    [self.view addSubview:self.badgeTitleView];
    
    [self.badgeTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(100);
        make.width.mas_equalTo(150);
    }];
    [self.badgeTitleView test];
    
    CGFloat height = self.badgeTitleView.intrinsicContentSize.height;
    NSLog(@"badge view height: %@", @(height));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

