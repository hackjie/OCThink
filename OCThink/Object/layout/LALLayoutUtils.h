//
//  LALLayoutUtils.h
//  LAExpendLayout
//
//  Created by 李杰 on 2025/1/6.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LALLayoutDirection) {
    LALLAYOUT_DIRECTION_LTR = 0x00000000,
    LALLAYOUT_DIRECTION_RTL = 0x40000000,
    LALLAYOUT_DIRECTION_UNDEFINED = -1,
};

@interface LALLayoutUtils : NSObject
+ (int)MIN_VALUE;
+ (int)MAX_VALUE;
@end

