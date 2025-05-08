//
//  ContainerEnum.m
//  OCThink
//
//  Created by 李杰 on 2025/2/14.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "ContainerEnum.h"

@implementation ContainerEnum

@end

//TODO:muqiu⚠️ 添加子view的时候会对子容器进行一次约束，子容器加到父容器里如果调用 remake 会将之前对子容器的约束拿掉了??
//TODO:muqiu⚠️ 给view设置frame 宽度、高度为 match_parent -1，wrap_content -2后，系统会自动将负值设为正值，这是个问题??
//TODO:muqiu⚠️ 当给view设置lessThanOrEqualTo后如bottom，container1先加view，container1后加到container2还是lessThanOrEqualTo，container1的bottom会以后一个为准
