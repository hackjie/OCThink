//
//  LALMeasureSpec.m
//  LAExpendLayout
//
//  Created by 李杰 on 2025/1/6.
//


#import <Foundation/Foundation.h>
#import "LALMeasureSpec.h"

@implementation LALMeasureSpec

+ (double)getMeasuredHeight:(UIView *)child
                  params:(LALLayoutParams *)lp
                     max:(double)max
                   width:(double)width
                  height:(double)height {
    double value;
    if (lp.height == LALWrapContent){
        CGSize size = [child sizeThatFits:CGSizeMake(width,height)];
        value = size.height;
    } else if (lp.height == LALMatchParent){
        value = max;
    } else {
        value = lp.height;
    }
    
    value += lp.extraHeight;
    
    if ([lp isKindOfClass:[LALMeasureableLayoutParams class]]){
        LALMeasureableLayoutParams *m = (LALMeasureableLayoutParams *)lp;
        if (m.delegate != nil && [m.delegate respondsToSelector:@selector(getMeasuredHeight:)]){
            LALMeasureValue* mv = [LALMeasureValue new];
            mv.maxSize = CGSizeMake(width,height);
            mv.maxValue = max;
            mv.lp = lp;
            mv.child = child;
            mv.measuredValue = value;
            return [m.delegate getMeasuredHeight:mv];
        }
    }
    return value;
}

+ (double)getMeasuredWidth:(UIView *)child
                 params:(LALLayoutParams *)lp
                    max:(double)max
                  width:(double)width
                 height:(double)height {
    double value;
    if (lp.width == LALWrapContent){
        CGSize size = [child sizeThatFits:CGSizeMake(width, height)];
        value = size.width;
    } else if (lp.width == LALMatchParent){
        value = max;
    } else {
        value = lp.width;
    }
    
    value += lp.extraWidth;
    
    if ([lp isKindOfClass:[LALMeasureableLayoutParams class]]){
        LALMeasureableLayoutParams* m = (LALMeasureableLayoutParams*)lp;
        if (m.delegate!=nil && [m.delegate respondsToSelector:@selector(getMeasuredWidth:)]){
            LALMeasureValue* mv = [LALMeasureValue new];
            mv.maxSize = CGSizeMake(width, height);
            mv.maxValue = max;
            mv.lp = lp;
            mv.child = child;
            mv.measuredValue = value;
            return [m.delegate getMeasuredWidth:mv];
        }
    }
    return value;
}

@end

