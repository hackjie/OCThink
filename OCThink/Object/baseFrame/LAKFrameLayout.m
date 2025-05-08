//
//  LAKFrameLayout.m
//  MyLayout
//
//  Created by 李杰 on 2025/03/14.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "LAKFrameLayout.h"
#import "LAKLayoutInner.h"

@implementation LAKFrameLayout

#pragma mark-- Override Methods

- (CGSize)calcLayoutSize:(CGSize)size subviewEngines:(NSMutableArray<LAKLayoutEngine *> *)subviewEngines context:(MyLayoutContext *)context {
    [super calcLayoutSize:size subviewEngines:subviewEngines context:context];

    LAKFrameLayoutTraits *layoutTraits = (LAKFrameLayoutTraits *)context->layoutViewEngine.currentSizeClass;
    context->paddingTop = layoutTraits.myLayoutPaddingTop;
    context->paddingBottom = layoutTraits.myLayoutPaddingBottom;
    context->paddingLeading = layoutTraits.myLayoutPaddingLeading;
    context->paddingTrailing = layoutTraits.myLayoutPaddingTrailing;
    context->vertGravity = MYVERTGRAVITY(layoutTraits.gravity);
    context->horzGravity = [LAKViewTraits convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(layoutTraits.gravity)];
    if (context->subviewEngines == nil) {
        context->subviewEngines = [layoutTraits filterEngines:subviewEngines];
    }
 
    CGSize maxWrapSize = CGSizeMake(context->paddingLeading + context->paddingTrailing, context->paddingTop + context->paddingBottom);
    CGSize *pMaxWrapSize = &maxWrapSize;
    if (!layoutTraits.heightSizeInner.wrapVal && !layoutTraits.widthSizeInner.wrapVal) {
        pMaxWrapSize = NULL;
    }
    for (LAKLayoutEngine *subviewEngine in context->subviewEngines) {
        
        [self myAdjustSizeSettingOfSubviewEngine:subviewEngine withContext:context];
        //计算自己的位置和高宽
        [self myCalcRectOfSubviewEngine:subviewEngine pMaxWrapSize:pMaxWrapSize withContext:context];
    }
    if (layoutTraits.widthSizeInner.wrapVal) {
        context->selfSize.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:maxWrapSize.width subviewSize: context->selfSize selfLayoutSize:self.superview.bounds.size];
    }
    if (layoutTraits.heightSizeInner.wrapVal) {
        context->selfSize.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:maxWrapSize.height subviewSize: context->selfSize selfLayoutSize:self.superview.bounds.size];
    }
    //如果布局视图具有包裹属性这里要调整那些依赖父视图宽度和高度的子视图的位置和尺寸。
    if ((layoutTraits.widthSizeInner.wrapVal && context->horzGravity != LAKGravity_Horz_Fill) || (layoutTraits.heightSizeInner.wrapVal && context->vertGravity != LAKGravity_Vert_Fill)) {
        for (LAKLayoutEngine *subviewEngine in context->subviewEngines) {
            LAKViewTraits *subviewTraits = subviewEngine.currentSizeClass;

            //只有子视图的尺寸或者位置依赖父视图的情况下才需要重新计算位置和尺寸。
            if ((subviewTraits.trailingPosInner.val != nil) ||
                (subviewTraits.bottomPosInner.val != nil) ||
                (subviewTraits.centerXPosInner.val != nil) ||
                (subviewTraits.centerYPosInner.val != nil) ||
                (subviewTraits.widthSizeInner.anchorVal.view == self) ||
                (subviewTraits.heightSizeInner.anchorVal.view == self) ||
                subviewTraits.widthSizeInner.fillVal ||
                subviewTraits.heightSizeInner.fillVal) {
                [self myCalcRectOfSubviewEngine:subviewEngine pMaxWrapSize:NULL withContext:context];
            }
        }
    }
    return [self myAdjustLayoutViewSizeWithContext:context];
}

- (id)createSizeClassInstance {
    return [LAKFrameLayoutTraits new];
}

@end
