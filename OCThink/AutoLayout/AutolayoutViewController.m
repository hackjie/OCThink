//
//  AutolayoutViewController.m
//  OCThink
//
//  Created by Ryan | 沐秋 on 2020/5/19.
//  Copyright © 2020 leoli. All rights reserved.
//

#import "AutolayoutViewController.h"

@interface AutolayoutViewController ()
@property (nonatomic, strong) UIView  *contentView;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation AutolayoutViewController

- (void)viewDidLoad {
    // https://www.jianshu.com/p/b94b28a8a642
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.contentLabel];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // UILayoutGuide https://developer.apple.com/documentation/uikit/uilayoutguide
    UILayoutGuide *guideOne = [[UILayoutGuide alloc] init];
    [self.view addLayoutGuide:guideOne];
    [guideOne.widthAnchor constraintEqualToConstant:20].active = YES;
    
    [self.contentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20].active = YES;
    [self.contentView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100].active = YES;
    [self.contentView.heightAnchor constraintEqualToConstant:100].active = YES;
    [self.contentView.widthAnchor constraintEqualToConstant:100].active = YES;
    
    [self.contentView.trailingAnchor constraintEqualToAnchor:guideOne.leadingAnchor].active = YES;
    [self.contentLabel.leadingAnchor constraintEqualToAnchor:guideOne.trailingAnchor].active = YES;
    [self.contentLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.contentLabel.widthAnchor constraintEqualToConstant:100].active = YES;
    [self.contentLabel.heightAnchor constraintEqualToConstant:100].active = YES;
    
    // UILayoutSupport protocol
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor redColor];
    }
    return _contentView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor blueColor];
    }
    return _contentLabel;
}
@end
