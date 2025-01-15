//
//  LALMainLayout.m
//  LAExpendLayout
//
//  Created by 李杰 on 2025/1/6.
//

#import <Foundation/Foundation.h>
#import "LALLinearLayout.h"
#import "LALGravity.h"
#import "LALLayoutUtils.h"
#import "LALMeasureSpec.h"

@implementation LALLinearLayout {
    LALOrientationMode mOrientation;
    double mTotalLength;
}

- (id)init {
    if (self = [super init]){
        self->mOrientation = ORIENTATION_HORIZONTAL;
        self->mTotalLength = 0;
    }
    return self;
}

- (id)initWithOrientation:(LALOrientationMode)orientation {
    if ( self = [super init] ) {
        self->mOrientation = orientation;
    }
    return self;
}

- (id)initWithGravity:(LALOrientationMode)orientation gravity:(int)gravity {
    if (self = [self initWithOrientation:orientation]) {
        [self setLayoutGravity:gravity];
    }
    return self;
}

- (void)updateLayout:(double)width height:(double)height {
    [super updateLayout:width height:height];

    //NSLog(@"--layout--updateLayout");
    if (mOrientation == ORIENTATION_VERTICAL) {
        [self layoutVertical:0 top:0 right:width bottom:height];
    } else {
        [self layoutHorizontal:0 top:0 right:width bottom:height];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize s = CGSizeMake(size.width, size.height);
    if (s.width == CGFLOAT_MAX) s.width = self.bounds.size.width;
    if (s.height == CGFLOAT_MAX) s.height = self.bounds.size.height;
    
    if (mOrientation == ORIENTATION_VERTICAL){
        [self measureVertical:size.width height:s.height];
        return CGSizeMake(size.width,mTotalLength);
    } else {
        [self measureHorizontal:size.width height:s.height];
        return CGSizeMake(mTotalLength,size.height);
    }
}

- (void)measureVertical:(double)w height:(double)height {
    double totalLength = 0;
    for (UIView *child in self.subviews) {
        if (child == nil) {
        } else if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
            LALMarginLayoutParams* lp = (LALMarginLayoutParams*)[self getChildLayoutParams:child];
            if (lp.height == -1){
                totalLength = height;
                mTotalLength = totalLength;
                break;
            }
            double childHeight = [LALMeasureSpec getMeasuredHeight:child params:lp max:height width:w height:CGFLOAT_MAX];
            totalLength = MAX(totalLength, totalLength + childHeight + lp.topMargin + lp.bottomMargin);
        }
    }
    mTotalLength = totalLength;
}

/**
 * Position the children during a layout pass if the orientation of this
 * LALLinearLayout is set to VERTICAL.
 */
- (void)layoutVertical:(double)left top:(double)top right:(double)right bottom:(double)bottom {
    double paddingLeft = self.paddingLeft;
    double childTop;
    double childLeft;
    // Where right end of child should go
    double width = right - left;
    double childRight = width - self.paddingRight;
    // Space available for child
    double childSpace = width - paddingLeft - self.paddingRight;
    int majorGravity = self.gravity & [LALGravity VERTICAL_GRAVITY_MASK ];
    int minorGravity = self.gravity & [LALGravity RELATIVE_HORIZONTAL_GRAVITY_MASK];
    // left space total weight
    double totalWeight = 0;
    
    if (majorGravity == [LALGravity BOTTOM]){
        [self measureVertical:self.bounds.size.width height:self.bounds.size.height];
        childTop = self.paddingTop + bottom - top - mTotalLength;
    } else if (majorGravity == [LALGravity CENTER_VERTICAL]) {
        [self measureVertical:self.bounds.size.width height:self.bounds.size.height];
        childTop = self.paddingTop + (bottom - top - mTotalLength) / 2;
    } else {
        childTop = self.paddingTop;
    }
    
    for (UIView *child in self.subviews) {
        if (child == nil) {
            //childTop += measureNullChild;
        } else if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
            LALLinearLayoutParams* lp = (LALLinearLayoutParams*) [self getChildLayoutParams:child];
            childTop += lp.topMargin;
            double childWidth = [LALMeasureSpec getMeasuredWidth:child params:lp max:self.bounds.size.width - lp.leftMargin - lp.rightMargin width:self.bounds.size.width height:[self MAX_HEIGHT:child]];
            double childHeight = [LALMeasureSpec getMeasuredHeight:child params:lp max:self.bounds.size.height - childTop - lp.bottomMargin width:self.bounds.size.width height:[self MAX_HEIGHT:child]];
            int gravity = lp.gravity;
            if (gravity < 0) {
                gravity = minorGravity;
            }
            if (lp.weight > 0) {
                totalWeight += lp.weight;
            } else {}
            LALLayoutDirection layoutDirection = self.layoutDirection;
            int absoluteGravity = [LALGravity getAbsoluteGravity:gravity direction:layoutDirection];
            int state = absoluteGravity & [LALGravity HORIZONTAL_GRAVITY_MASK];
            if (state == [LALGravity CENTER_HORIZONTAL]) {
                childLeft = paddingLeft + ((childSpace - childWidth) / 2) + lp.leftMargin - lp.rightMargin;
            } else if (state == [LALGravity RIGHT]) {
                childLeft = childRight - childWidth - lp.rightMargin;
            } else {
                childLeft = paddingLeft + lp.leftMargin;
            }
            [self setChildFrame:child left:childLeft top:childTop width:childWidth height:childHeight];
            childTop += childHeight + lp.bottomMargin;
            
            if ([child isKindOfClass:[LALMainLayout class]]) {
                LALMainLayout* newLayout = (LALMainLayout*) child;
                [newLayout updateConstraints];
            }
        }
    }
    
    // 根据weight重新计算高度
    CGFloat leftHeight = bottom - childTop;
    NSLog(@"--layout--layoutVertical---leftHeight:%@", @(leftHeight));
    if (totalWeight == 0 || leftHeight <= 0) {
        return;
    }
    CGFloat currentChildTop = 0;
    CGFloat totalInc = 0;
    for (UIView *child in self.subviews) {
        if (child == nil) {
            //childLeft += measureNullChild;
        } else if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
            LALLinearLayoutParams *lp = (LALLinearLayoutParams*)[self getChildLayoutParams:child];
            CGFloat childTop = child.frame.origin.y;
            currentChildTop = childTop + totalInc;
            CGFloat childLeft = child.frame.origin.x;
            CGFloat childWidth = child.frame.size.width;
            CGFloat childHeight = child.frame.size.height;
            CGFloat childIncHeight = (lp.weight/(totalWeight))*leftHeight;
            childHeight = childHeight + childIncHeight;
            [self setChildFrame:child left:childLeft top:currentChildTop width:childWidth height:childHeight];
            totalInc += childIncHeight;
        }
    }
}

- (void)measureHorizontal:(double)width height:(double)height {
    double totalLength = 0;
    for (UIView *child in self.subviews) {
        if (child == nil) {
        } else if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
            LALMarginLayoutParams* lp = (LALMarginLayoutParams*)[self getChildLayoutParams:child];
            if (lp.width==-1){
                totalLength = width;
                mTotalLength = totalLength;
                break;
            }
            
            double childWidth = [LALMeasureSpec getMeasuredWidth:child params:lp max:width width:CGFLOAT_MAX height:height];
            totalLength = MAX(totalLength, totalLength + childWidth + lp.rightMargin + lp.leftMargin);
        }
    }
    mTotalLength = totalLength;
    NSLog(@"--layout--mTotalLenght: %@", @(mTotalLength));
}

/**
 * Position the children during a layout pass if the orientation of this
 * LALLinearLayout is set to HORIZONTAL.
 */
- (void)layoutHorizontal:(double)left top:(double)top right:(double)right bottom:(double)bottom {
    //NSLog(@"--layout--layoutHorizontal---start");
    BOOL isLayoutRtl = false;
    double paddingTop = self.paddingTop;
    double childTop;
    double childLeft;
    // Where bottom of child should go
    double height = bottom - top;
    double childBottom = height - self.paddingBottom;
    // Space available for child
    double childSpace = height - paddingTop - self.paddingBottom;
    int majorGravity = self.gravity & [LALGravity RELATIVE_HORIZONTAL_GRAVITY_MASK];
    int minorGravity = self.gravity & [LALGravity VERTICAL_GRAVITY_MASK];
    // left space total weight
    double totalWeight = 0;
    
    LALLayoutDirection layoutDirection = self.layoutDirection;
    int realGravity = [LALGravity getAbsoluteGravity:majorGravity direction:layoutDirection];
    if (realGravity== [LALGravity RIGHT]){
        [self measureHorizontal:self.bounds.size.width height:self.bounds.size.height];
        childLeft = self.paddingLeft + right - left - mTotalLength;
    } else if (realGravity == [LALGravity CENTER_HORIZONTAL]){
        [self measureHorizontal:self.bounds.size.width height:self.bounds.size.height];
        childLeft = self.paddingLeft + (right - left - mTotalLength) / 2;
    } else {
        childLeft = self.paddingLeft;
    }
    int count = (int)self.subviews.count;
    int start = 0;
    int dir = 1;
    //In case of RTL, start drawing from the last child.
    if (isLayoutRtl) {
        start = count - 1;
        dir = -1;
    }
    for (int i = 0; i < count; i++) {
        //NSLog(@"--layout--for:%@", @(i));
        int childIndex = start + dir * i;
        UIView* child = self.subviews[childIndex];
        if (child == nil) {
            //childLeft += measureNullChild;
        } else if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
            LALLinearLayoutParams *lp = (LALLinearLayoutParams*)[self getChildLayoutParams:child];
            int gravity = lp.gravity;
            if (gravity < 0) {
                gravity = minorGravity;
            }
            if (lp.weight > 0) {
                totalWeight += lp.weight;
            } else {}
            
            childLeft += lp.leftMargin;
            //NSLog(@"--layout--layoutHorizontal---childLeft:%@", @(childLeft));
            double childWidth = [LALMeasureSpec getMeasuredWidth:child params:lp max:self.bounds.size.width - childLeft - lp.rightMargin width:[self MAX_WIDTH:child] height:self.bounds.size.height];
            double childHeight = [LALMeasureSpec getMeasuredHeight:child params:lp max:self.bounds.size.height - lp.topMargin - lp.bottomMargin width:[self MAX_WIDTH:child] height:self.bounds.size.height];
            
            int state = gravity & [LALGravity VERTICAL_GRAVITY_MASK];
            if (state == [LALGravity TOP]){
                childTop = paddingTop + lp.topMargin;
            } else if (state == [LALGravity CENTER_VERTICAL]) {
                childTop = paddingTop + ((childSpace - childHeight)/ 2) + lp.topMargin - lp.bottomMargin;
            } else if (state == [LALGravity BOTTOM]) {
                childTop = childBottom - childHeight - lp.bottomMargin;
            } else {
                childTop = paddingTop;
            }
            
            [self setChildFrame:child left:childLeft top:childTop width:childWidth height:childHeight];
            childLeft += childWidth + lp.rightMargin;
            //NSLog(@"--layout--childLeft:%@--%@", @(childLeft), @(childIndex));
            if ([child isKindOfClass:[LALMainLayout class]]) {
                LALMainLayout* newLayout = (LALMainLayout*) child;
                [newLayout updateConstraints];
            }
        }
    }
    //NSLog(@"--layout--layoutHorizontal---end");
    // 根据weight重新计算宽度
    CGFloat leftWidth = right - childLeft;
    NSLog(@"--layout--layoutHorizontal---leftWidth:%@", @(leftWidth));
    if (totalWeight == 0 || leftWidth <= 0) {
        return;
    }
    CGFloat currentChildLeft = 0;
    CGFloat totalInc = 0;
    for (int i = 0; i < count; i++) {
        int childIndex = start + dir * i;
        UIView* child = self.subviews[childIndex];
        if (child == nil) {
            //childLeft += measureNullChild;
        } else if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
            LALLinearLayoutParams *lp = (LALLinearLayoutParams*)[self getChildLayoutParams:child];
            CGFloat childLeft = child.frame.origin.x;
            currentChildLeft = childLeft + totalInc;
            //NSLog(@"--layout--layoutHorizontal---currentChildLeft:%@", @(currentChildLeft));
            //NSLog(@"--layout--layoutHorizontal---currentChildLeft:%@", @(childLeft));
            //NSLog(@"--layout--layoutHorizontal---totalInc:%@", @(totalInc));
            //NSLog(@"--layout--layoutHorizontal---lp.weight:%@", @(lp.weight));
            //NSLog(@"--layout--layoutHorizontal---totalWeight:%@", @(totalWeight));
            CGFloat childTop = child.frame.origin.y;
            CGFloat childWidth = child.frame.size.width;
            CGFloat childHeight = child.frame.size.height;
            CGFloat childIncWidth = (lp.weight/(totalWeight))*leftWidth;
            childWidth = childWidth + childIncWidth;
            [self setChildFrame:child left:currentChildLeft top:childTop width:childWidth height:childHeight];
            totalInc += childIncWidth;
        }
    }
}

- (double)MAX_WIDTH:(UIView*)child {
    if ([child isKindOfClass:[LALMainLayout class]]) {
        return self.bounds.size.width;
    }else{
        return CGFLOAT_MAX;
    }
}

- (double)MAX_HEIGHT:(UIView*) child {
    if ([child isKindOfClass:[LALMainLayout class]]) {
        return self.bounds.size.height;
    }else{
        return CGFLOAT_MAX;
    }
}

- (void)setOrientation:(LALOrientationMode)orientation {
    if (mOrientation != orientation) {
        mOrientation = orientation;
        [self updateConstraints];
    }
}

- (LALOrientationMode)getOrientation {
    return mOrientation;
}

- (void)setLayoutGravity:(int)gravity {
    if (self.gravity != gravity) {
        if ((gravity & [LALGravity RELATIVE_HORIZONTAL_GRAVITY_MASK]) == 0) {
            gravity |= [LALGravity START];
        }
        if ((gravity & [LALGravity VERTICAL_GRAVITY_MASK]) == 0) {
            gravity |= [LALGravity TOP];
        }
        self.gravity = gravity;
        [self updateConstraints];
    }
}

- (void)setHorizontalGravity:(int)horizontalGravity {
    int gravity = horizontalGravity & [LALGravity RELATIVE_HORIZONTAL_GRAVITY_MASK];
    if ((self.gravity & [LALGravity RELATIVE_HORIZONTAL_GRAVITY_MASK]) != gravity) {
        self.gravity = (self.gravity & ~[LALGravity RELATIVE_HORIZONTAL_GRAVITY_MASK]) | gravity;
        [self updateConstraints];
    }
}

- (void)setVerticalGravity:(int)verticalGravity {
    int gravity = verticalGravity & [LALGravity VERTICAL_GRAVITY_MASK];
    if ((self.gravity & [LALGravity VERTICAL_GRAVITY_MASK]) != gravity) {
        self.gravity = (self.gravity & ~[LALGravity VERTICAL_GRAVITY_MASK ]) | gravity;
        [self updateConstraints];
    }
}
@end

@implementation LALLinearLayoutParams

@synthesize gravity;

- (id)init {
    if (self = [super init]){
        self.gravity = -1;
    }
    return self;
}

- (id)initWithSource:(LALLayoutParams *)lp {
    return [self initWithWidth:lp.width height:lp.height];
}

- (id)initWithMarginSource:(LALMarginLayoutParams *) lp {
    if (self = [super initWithMarginSource:lp]) {
        self.gravity = -1;
    }
    return self;
}

- (id)initWithLinearSource:(LALLinearLayoutParams *)lp {
    if (self = [super initWithMarginSource:lp]) {
        self.gravity = lp.gravity;
    }
    return self;
}

- (id)initWithWidth:(double)width height:(double)height {
    if (self = [super initWithWidth:width height:height]){
        self.gravity = -1;
    }
    return self;
}

- (id)initWithSizeAndGravity:(double)width height:(double)height gravity:(int)gravity {
    if (self = [super initWithWidth:width height:height]){
        self.gravity = gravity;
    }
    return self;
}

- (id _Nonnull)initWithSizeAndGravity:(double)width
                               height:(double)height
                              gravity:(int)gravity
                               weight:(double)weight {
    if (self = [super initWithWidth:width height:height]){
        self.gravity = gravity;
        self.weight = weight;
    }
    return self;
}

@end

