//
//  ThreadSafeTool.h
//  OCThink
//
//  Created by Ryan | 沐秋 on 2021/1/20.
//  Copyright © 2021 leoli. All rights reserved.
//

#import <Foundation/Foundation.h>

void PerformBlockOnMainThread(void (^ _Nonnull block)(void));
void PerformBlockSyncOnMainThread(void (^ _Nonnull block)(void));

NS_ASSUME_NONNULL_BEGIN

@interface ThreadSafeTool : NSObject

@end

NS_ASSUME_NONNULL_END
