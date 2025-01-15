//
//  LALGravity.m
//  LAExpendLayout
//
//  Created by 李杰 on 2025/1/6.
//

#import <Foundation/Foundation.h>
#import "LALGravity.h"

@implementation LALGravity

+ (int)NO_GRAVITY {
    return 0x0000;
}

+ (int)AXIS_SPECIFIED {
    return 0x0001;
}

+ (int)AXIS_PULL_BEFORE {
    return 0x0002;
}

+ (int)AXIS_PULL_AFTER {
    return 0x0004;
}

+ (int)AXIS_CLIP {
    return 0x0008;
}

+ (int)AXIS_X_SHIFT {
    return 0;
}

+ (int)AXIS_Y_SHIFT {
    return 4;
}

+ (int)TOP {
    return ([LALGravity AXIS_PULL_BEFORE ]|[LALGravity AXIS_SPECIFIED])<<[LALGravity AXIS_Y_SHIFT];
}

+ (int)BOTTOM {
    return ([LALGravity AXIS_PULL_AFTER]|[LALGravity AXIS_SPECIFIED])<<[LALGravity AXIS_Y_SHIFT];
}

+ (int)LEFT {
    return ([LALGravity AXIS_PULL_BEFORE]|[LALGravity AXIS_SPECIFIED])<<[LALGravity AXIS_X_SHIFT];
}

+ (int)RIGHT {
    return ([LALGravity AXIS_PULL_AFTER]|[LALGravity AXIS_SPECIFIED])<<[LALGravity AXIS_X_SHIFT];
}

+ (int)CENTER_VERTICAL {
    return [LALGravity AXIS_SPECIFIED]<<[LALGravity AXIS_Y_SHIFT];
}

+ (int)FILL_VERTICAL {
    return [LALGravity TOP] | [LALGravity BOTTOM];
}

+ (int)CENTER_HORIZONTAL {
    return [LALGravity AXIS_SPECIFIED]<<[LALGravity AXIS_X_SHIFT];
}

+ (int)FILL_HORIZONTAL {
    return [LALGravity LEFT] | [LALGravity RIGHT];
}

+ (int)CENTER {
    return [LALGravity CENTER_VERTICAL]|[LALGravity CENTER_HORIZONTAL];
}

+ (int)FILL {
    return [LALGravity FILL_VERTICAL] | [LALGravity FILL_HORIZONTAL];
}

+ (int)CLIP_VERTICAL {
    return [LALGravity AXIS_CLIP]<<[LALGravity AXIS_Y_SHIFT];
}

+ (int)CLIP_HORIZONTAL {
    return [LALGravity AXIS_CLIP]<<[LALGravity AXIS_X_SHIFT];
}

+ (int)RELATIVE_LAYOUT_DIRECTION {
    return 0x00800000;
}

+ (int)HORIZONTAL_GRAVITY_MASK {
    return ([LALGravity AXIS_SPECIFIED] | [LALGravity AXIS_PULL_BEFORE] | [LALGravity AXIS_PULL_AFTER]) << [LALGravity AXIS_X_SHIFT];
}

+ (int)VERTICAL_GRAVITY_MASK {
    return ([LALGravity AXIS_SPECIFIED] | [LALGravity AXIS_PULL_BEFORE] | [LALGravity AXIS_PULL_AFTER]) << [LALGravity AXIS_Y_SHIFT];
}

+ (int)START {
    return [LALGravity RELATIVE_LAYOUT_DIRECTION] | [LALGravity LEFT];
}

+ (int)END {
    return [LALGravity RELATIVE_LAYOUT_DIRECTION] | [LALGravity RIGHT];
}

+ (int)RELATIVE_HORIZONTAL_GRAVITY_MASK {
    return [LALGravity START] | [LALGravity END];
}

+ (int)getAbsoluteGravity:(int)gravity direction:(LALLayoutDirection)layoutDirection {
    if (layoutDirection == LALLAYOUT_DIRECTION_UNDEFINED) return gravity;
    int result = gravity;
    // If layout is script specific and gravity is horizontal relative (START or END)
    if ((result & [LALGravity RELATIVE_LAYOUT_DIRECTION]) > 0) {
        if ((result & [LALGravity START]) == [LALGravity START]) {
            // Remove the START bit
            result &= ~[LALGravity START];
            if (layoutDirection == LALLAYOUT_DIRECTION_RTL) {
                // Set the RIGHT bit
                result |= [LALGravity RIGHT];
            } else {
                // Set the LEFT bit
                result |= [LALGravity LEFT];
            }
        } else if ((result & [LALGravity END]) == [LALGravity END]) {
            // Remove the END bit
            result &= ~[LALGravity END];
            if (layoutDirection == LALLAYOUT_DIRECTION_RTL) {
                // Set the LEFT bit
                result |= [LALGravity LEFT];
            } else {
                // Set the RIGHT bit
                result |= [LALGravity RIGHT];
            }
        }
        // Don't need the script specific bit any more, so remove it as we are converting to
        // absolute values (LEFT or RIGHT)
        result &= ~[LALGravity RELATIVE_LAYOUT_DIRECTION];
    }
    return result;
}

@end

