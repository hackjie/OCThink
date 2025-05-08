//
//  TestContainerView.m
//  OCThink
//
//  Created by 李杰 on 2025/3/7.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "TestContainerView.h"

@interface TestContainerView()

@end

@implementation TestContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.redColor;
        _child = [SubTestView new];
        _child.backgroundColor = UIColor.blueColor;
        [self addSubview:_child];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    _child.frame = CGRectMake(0, 0, self.frame.size.width/2.0, self.frame.size.height/2.0);
    
    
    NSLog(@"TestContainerView-layoutSubviews:self.frame: %@, child.frame:%@", NSStringFromCGRect(self.frame), NSStringFromCGRect(_child.frame));
}

@end
