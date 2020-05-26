//
//  CustomPageControl.h
//  OCThink
//
//  Created by Ryan | 沐秋 on 2020/5/25.
//  Copyright © 2020 leoli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomPageControl : UIView
@property (nonatomic, strong) UIImage   *currentIndicatorImage;
@property (nonatomic, strong) UIImage   *pageIndicatorImage;
@property (nonatomic, assign) CGFloat   currentIndicatorWidth;
@property (nonatomic, assign) CGFloat   pageIndicatorWidth;
@property (nonatomic, assign) CGFloat   indicatorHeight;
@property (nonatomic, assign) CGFloat   padding;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;
@end

NS_ASSUME_NONNULL_END
