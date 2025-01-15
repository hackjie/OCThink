//
//  LALMainLayout.h
//  LAExpendLayout
//
//  Created by 李杰 on 2025/1/6.
//

#import <UIKit/UIKit.h>
#import "LALLayoutUtils.h"
#import "LALGravity.h"

static double const LALMatchParent = -1;
static double const LALWrapContent = -2;

@interface LALLayoutParams :NSObject {
    double width,height;
    double extraWidth,extraHeight;
}

- (id _Nonnull)initWithSource:(LALLayoutParams* _Nonnull)lp;
- (id _Nonnull)initWithWidth:(double)width height:(double)height;

@property (nonatomic) double width;
@property (nonatomic) double height;
@property (nonatomic) double extraWidth;
@property (nonatomic) double extraHeight;

@end

@interface LALMeasureValue :NSObject {
    CGSize maxSize;
    double measuredValue;
    double maxValue;
    LALLayoutParams* lp;
    UIView* child;
}

@property (nonatomic) CGSize maxSize;
@property (nonatomic) double measuredValue;
@property (nonatomic) double maxValue;
@property (nonatomic) LALLayoutParams* _Nonnull lp;
@property (nonatomic) UIView* _Nonnull child;

@end

@protocol LALMeasureValueDelegate <NSObject>
@optional
- (double)getMeasuredHeight:(LALMeasureValue *_Nonnull)values;
- (double)getMeasuredWidth:(LALMeasureValue *_Nonnull)values;

@end


@interface LALMeasureableLayoutParams :LALLayoutParams

@property (nullable, nonatomic, weak) id <LALMeasureValueDelegate> delegate;

@end



@interface LALMarginLayoutParams :LALMeasureableLayoutParams {
    double leftMargin,topMargin,rightMargin,bottomMargin,startMargin,endMargin;
    Byte mMarginFlags;
}

- (id _Nonnull)initWithSource:(LALLayoutParams* _Nonnull)lp;
- (id _Nonnull)initWithMarginSource:(LALMarginLayoutParams* _Nonnull)lp;
- (id _Nonnull)initWithWidth:(double)width height:(double)height;

@property (nonatomic) double leftMargin;
@property (nonatomic) double topMargin;
@property (nonatomic) double rightMargin;
@property (nonatomic) double bottomMargin;
@property (nonatomic) double startMargin;
@property (nonatomic) double endMargin;
@property (nonatomic) Byte mMarginFlags;

/**
 * Sets the margins, in pixels. A call to updateConstraints needs
 * to be done so that the new margins are taken into account. Left and right margins may be
 * overridden by updateConstraints depending on layout direction.
 * Margin values should be positive.
 */
- (void)setMargins:(double)left top:(double)top right:(double)right bottom:(double)bottom;
/**
 * Check if margins are relative.
 */
- (BOOL)isMarginRelative;
/**
 * Sets the relative margins, in pixels. A call to updateConstraints
 * needs to be done so that the new relative margins are taken into account. Left and right
 * margins may be overridden by updateConstraints depending on layout direction.
 * Margin values should be positive.
 */
- (void)setMarginsRelative:(double)start top:(double)top end:(double)end bottom:(double)bottom;
/**
 * Sets the relative start margin. Margin values should be positive.
 */
- (void)setMarginStart:(double)start;
/**
 * Returns the start margin in pixels.
 */
- (double)getMarginStart;
/**
 * Sets the relative end margin. Margin values should be positive.
 */
- (void)setMarginEnd:(double)end;
/**
 * Returns the end margin in pixels.
 */
- (double)getMarginEnd;
/**
 * Set the layout direction
 */
- (void)setLayoutDirection:(LALLayoutDirection)layoutDirection ;
/**
 * Retuns the layout direction. Can be either LAYOUT_DIRECTION_LTR or LAYOUT_DIRECTION_RTL.
 */
- (LALLayoutDirection)getLayoutDirection;
/**
 * This will be called by updateConstraints. Left and Right margins
 * may be overridden depending on layout direction.
 */
- (void)resolveLayoutDirection:(LALLayoutDirection)layoutDirection;
- (BOOL)isLayoutRtl;

@end

@interface LALMainLayout :UIView {
    double paddingTop;
    double paddingRight;
    double paddingBottom;
    double paddingLeft;
    LALLayoutDirection layoutDirection;
    int gravity;
    BOOL skipLayout;
}

@property (nonatomic) double paddingTop;
@property (nonatomic) double paddingRight;
@property (nonatomic) double paddingBottom;
@property (nonatomic) double paddingLeft;
@property (nonatomic) LALLayoutDirection layoutDirection;
@property (nonatomic) int gravity;
@property (nonatomic) BOOL skipLayout;

- (BOOL)hasChildLayoutLoaded:(UIView*_Nonnull)view;
- (LALLayoutParams* _Nullable)getChildLayoutParams:( UIView* _Nonnull )view;
- (void)setChildLayoutParams:(UIView* _Nonnull)view lp:(LALLayoutParams* _Nullable)lp;
- (void)clearLayoutParams;

- (void)addSubview:(UIView * _Nonnull)view 
                lp:(LALLayoutParams* _Nullable)lp;
- (void)insertSubview:(UIView *_Nonnull)view atIndex:(NSInteger)index
                   lp:(LALLayoutParams*_Nullable)lp;
- (void)insertSubview:(UIView *_Nonnull)view 
         aboveSubview:(UIView*_Nonnull)subview
                   lp:(LALLayoutParams*_Nullable)lp;
- (void)insertSubview:(UIView *_Nonnull)view 
         belowSubview:(UIView*_Nonnull)subview
                   lp:(LALLayoutParams*_Nullable)lp;
- (void)removeSubview:(nonnull UIView*)view;

- (void)updateLayout:(double)width height:(double)height;
- (void)setPadding:(double)left top:(double)top right:(double)right bottom:(double)bottom;
- (void)setChildFrame:(UIView*_Nonnull)child
                 left:(double)left
                  top:(double)top
                width:(double)width
               height:(double)height;

@end


