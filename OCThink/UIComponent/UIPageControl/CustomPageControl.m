//
//  CustomPageControl.m
//  OCThink
//
//  Created by Ryan | 沐秋 on 2020/5/25.
//  Copyright © 2020 leoli. All rights reserved.
//

#import "CustomPageControl.h"

@interface CustomPageControl()
@property (nonatomic, strong) NSMutableArray *widthConstraints;
@end

@implementation CustomPageControl
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.padding = 0;
        self.currentIndicatorWidth = 4;
        self.pageIndicatorWidth = 4;
        self.indicatorHeight = 4;
        self.widthConstraints = [NSMutableArray array];
    }
    return self;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat totalWidth = self.frame.size.width;
    NSInteger currentPage = self.currentPage;
    CGFloat validWidth = 0;
    if (numberOfPages > 0) {
        validWidth = (numberOfPages - 1)*(self.padding + self.pageIndicatorWidth) + self.currentIndicatorWidth;
    }
    
    CGFloat leadingAndTrailing = (totalWidth - validWidth)/2;
    
    // TODO: Ryan | 李杰 test iOS 9.0
    UIButton *lastBtn = [[UIButton alloc] init];
    for (int num = 0; num < numberOfPages; num++) {
        UIButton *button = [[UIButton alloc] init];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:button];
        [button.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        [button.heightAnchor constraintEqualToConstant:self.indicatorHeight].active = YES;
        if (num == currentPage) {
            NSLayoutConstraint *widthConstraint = [button.widthAnchor constraintEqualToConstant:self.currentIndicatorWidth];
            widthConstraint.active = YES;
            [self.widthConstraints addObject:widthConstraint];
            [button setBackgroundImage:self.currentIndicatorImage forState:UIControlStateNormal];
            [button setBackgroundImage:self.currentIndicatorImage forState:UIControlStateSelected];
        } else {
            NSLayoutConstraint *widthConstraint = [button.widthAnchor constraintEqualToConstant:self.pageIndicatorWidth];
            widthConstraint.active = YES;
            [self.widthConstraints addObject:widthConstraint];
            [button setBackgroundImage:self.pageIndicatorImage forState:UIControlStateNormal];
            [button setBackgroundImage:self.pageIndicatorImage forState:UIControlStateSelected];
        }
        if (num == 0) {
            [button.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:leadingAndTrailing].active = YES;
        } else {
            UILayoutGuide *guide = [[UILayoutGuide alloc] init];
            [self addLayoutGuide:guide];
            [guide.widthAnchor constraintEqualToConstant:self.padding].active = YES;
            [lastBtn.trailingAnchor constraintEqualToAnchor:guide.leadingAnchor].active = YES;
            [button.leadingAnchor constraintEqualToAnchor:guide.trailingAnchor].active = YES;
        }
        if (num == numberOfPages - 1) {
            [button.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-leadingAndTrailing].active = YES;
        }
        
        lastBtn = button;
    }
}
 
- (void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage >= self.numberOfPages || currentPage < 0) {
        return;
    }
    _currentPage = currentPage;
 
    [self updateDotsWithCurrentPage:currentPage];
}

- (void)updateDotsWithCurrentPage:(NSInteger)currentPage
{
    __block NSInteger numOfPages = 0;
    NSMutableArray *btnArray = [NSMutableArray array];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            numOfPages = numOfPages + 1;
            [btnArray addObject:obj];
        }
    }];
    for (int num = 0; num < numOfPages; num++) {
        UIButton *button = [btnArray objectAtIndex:num];
        NSLayoutConstraint *widthConstraint = [self.widthConstraints objectAtIndex:num];
        if (num == currentPage) {
            widthConstraint.constant = self.currentIndicatorWidth;
            [button setBackgroundImage:self.currentIndicatorImage forState:UIControlStateNormal];
            [button setBackgroundImage:self.currentIndicatorImage forState:UIControlStateSelected];
        } else {
            widthConstraint.constant = self.pageIndicatorWidth;
            [button setBackgroundImage:self.pageIndicatorImage forState:UIControlStateNormal];
            [button setBackgroundImage:self.pageIndicatorImage forState:UIControlStateSelected];
        }
    }
}
@end

