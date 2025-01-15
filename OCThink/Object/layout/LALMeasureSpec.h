//
//  LALMeasureSpec.h
//  LAExpendLayout
//
//  Created by 李杰 on 2025/1/6.
//

#import <UIKit/UIKit.h>
#import "LALMainLayout.h"

@interface LALMeasureSpec : NSObject

+ (double)getMeasuredHeight:(UIView *)child
                  params:(LALLayoutParams *)lp
                     max:(double)max
                   width:(double)width
                  height:(double)height;
+ (double)getMeasuredWidth:(UIView *)child
                 params:(LALLayoutParams *)lp
                    max:(double)max
                  width:(double)width
                 height:(double)height;

@end

