//
//  PlayerScrollView.h
//  OCThink
//
//  Created by Ryan | 沐秋 on 2020/12/30.
//  Copyright © 2020 leoli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PlayerScrollView;
@protocol PlayerScrollViewDelegate <NSObject>

- (void)playerScrollView:(PlayerScrollView *)playerScrollView currentPlayerIndex:(NSInteger)index;
@end

@interface PlayerScrollView : UIScrollView

@property (nonatomic, assign) NSInteger index;

//@property (nonatomic, strong) KSYMoviePlayerController *upPlayer, *middlePlayer, *downPlayer;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)updateForvideoItemArray:(NSMutableArray *)videoItemArray withCurrentIndex:(NSInteger) index;

@property (nonatomic, weak) id<PlayerScrollViewDelegate> playerDelegate;

@end

NS_ASSUME_NONNULL_END
