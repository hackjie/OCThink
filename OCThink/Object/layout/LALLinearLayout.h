//
//  LALMainLayout.h
//  LAExpendLayout
//
//  Created by 李杰 on 2025/1/6.
//

#import <UIKit/UIKit.h>
#import "LALMainLayout.h"

typedef NS_ENUM(int, LALOrientationMode) {
    ORIENTATION_HORIZONTAL=0,
    ORIENTATION_VERTICAL=1
};

@interface LALLinearLayout: LALMainLayout

- (id _Nonnull)initWithOrientation:(LALOrientationMode)orientation;
- (id _Nonnull)initWithGravity:(LALOrientationMode)orientation gravity:(int)gravity;

/**
 * Should the layout be a column or a row.
 */
- (void)setOrientation:(LALOrientationMode)orientation;
/**
 * Returns the current orientation.
 */
- (LALOrientationMode)getOrientation;

/**
 * Describes how the child views are positioned. Defaults to GRAVITY TOP. If
 * this layout has a VERTICAL orientation, this controls where all the child
 * views are placed if there is extra vertical space. If this layout has a
 * HORIZONTAL orientation, this controls the alignment of the children.
 */
- (void)setLayoutGravity:(int)gravity;
- (void)setHorizontalGravity:(int)horizontalGravity;
- (void)setVerticalGravity:(int)verticalGravity;

@end

@interface LALLinearLayoutParams:LALMarginLayoutParams {
    int gravity;
}

- (id _Nonnull)initWithSource:(LALLayoutParams * _Nonnull)lp ;
- (id _Nonnull)initWithMarginSource:(LALMarginLayoutParams * _Nonnull)lp;
- (id _Nonnull)initWithWidth:(double)width height:(double)height;
- (id _Nonnull)initWithLinearSource:(LALLinearLayoutParams* _Nonnull)lp;
- (id _Nonnull)initWithSizeAndGravity:(double)width
                               height:(double)height
                              gravity:(int)gravity;

- (id _Nonnull)initWithSizeAndGravity:(double)width
                               height:(double)height
                              gravity:(int)gravity
                               weight:(double)weight;
    
@property (nonatomic) int gravity;
@property (nonatomic, assign) double weight;

@end
