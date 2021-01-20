//
//  ThreadSafeTool.m
//  OCThink
//
//  Created by Ryan | 沐秋 on 2021/1/20.
//  Copyright © 2021 leoli. All rights reserved.
//

#import "ThreadSafeTool.h"

void PerformBlockOnMainThread(void (^ _Nonnull block)(void))
{
    if (!block) return;
    
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

void PerformBlockSyncOnMainThread(void (^ _Nonnull block)(void))
{
    if (!block) return;
    
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

@implementation ThreadSafeTool

@end
