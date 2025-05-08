//
//  UIView+Constraints.h
//  OCThink
//
//  Created by 李杰 on 2025/2/14.
//  Copyright © 2025 leoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Constraints)
@property (nonatomic, strong) MASConstraint *leftConstraint;
@property (nonatomic, strong) MASConstraint *topConstraint;
@property (nonatomic, strong) MASConstraint *bottomConstraint;
@property (nonatomic, strong) MASConstraint *rightConstraint;
@property (nonatomic, strong) MASConstraint *widthConstraint;
@property (nonatomic, strong) MASConstraint *heightConstraint;
@property (nonatomic, assign) NSInteger weight;

//@property (nonatomic, assign) CGPoint frameOrigin;
//@property (nonatomic, assign) CGSize  frameSize;

@property (nonatomic, assign) CGRect visualFrame;

- (NSString *)constraints;

@end

NS_ASSUME_NONNULL_END
