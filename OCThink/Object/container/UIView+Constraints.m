//
//  UIView+Constraints.m
//  OCThink
//
//  Created by 李杰 on 2025/2/14.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "UIView+Constraints.h"
#import <objc/runtime.h>

static const char LeftConstraint;
static const char TopConstraint;
static const char RightConstraint;
static const char BottomConstraint;
static const char WidthConstraint;
static const char HeightConstraint;
static const char VisualFrame;
static const char WeightKey;

//static const char FrameOriginal;
//static const char FrameSize;


@implementation UIView (Constraints)

- (void)setLeftConstraint:(MASConstraint *)leftConstraint {
    objc_setAssociatedObject(self, &LeftConstraint, leftConstraint, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (MASConstraint *)leftConstraint {
    return objc_getAssociatedObject(self,  &LeftConstraint);
}

- (void)setTopConstraint:(MASConstraint *)topConstraint {
    objc_setAssociatedObject(self, &TopConstraint, topConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MASConstraint *)topConstraint {
    return objc_getAssociatedObject(self,  &TopConstraint);
}

- (void)setRightConstraint:(MASConstraint *)rightConstraint {
    objc_setAssociatedObject(self, &RightConstraint, rightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MASConstraint *)rightConstraint {
    return objc_getAssociatedObject(self,  &RightConstraint);
}

- (void)setBottomConstraint:(MASConstraint *)bottomConstraint {
    objc_setAssociatedObject(self, &BottomConstraint, bottomConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MASConstraint *)bottomConstraint {
    return objc_getAssociatedObject(self,  &BottomConstraint);
}

- (void)setWidthConstraint:(MASConstraint *)widthConstraint {
    objc_setAssociatedObject(self, &WidthConstraint, widthConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MASConstraint *)widthConstraint {
    return objc_getAssociatedObject(self,  &WidthConstraint);
}

- (void)setHeightConstraint:(MASConstraint *)heightConstraint {
    objc_setAssociatedObject(self, &HeightConstraint, heightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MASConstraint *)heightConstraint {
    return objc_getAssociatedObject(self,  &HeightConstraint);
}


- (void)setVisualFrame:(CGRect)visualFrame {
    objc_setAssociatedObject(self, &VisualFrame, [NSValue valueWithCGRect:visualFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)visualFrame {
    return [objc_getAssociatedObject(self, &VisualFrame) CGRectValue];
}

- (void)setWeight:(NSInteger)weight {
    objc_setAssociatedObject(self, &WeightKey, @(weight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)weight {
    return [objc_getAssociatedObject(self, &WeightKey) integerValue];
}

@end
