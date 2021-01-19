//
//  PlayerScrollView.m
//  OCThink
//
//  Created by Ryan | 沐秋 on 2020/12/30.
//  Copyright © 2020 leoli. All rights reserved.
//

#import "PlayerScrollView.h"
#import "VideoModel.h"

@interface PlayerScrollView( )<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *videoItemArray;
@property (nonatomic, strong) VideoModel *item;
@property (nonatomic, strong) UIImageView *upImageView, *middleImageView, *downImageView;
@property (nonatomic, strong) VideoModel *upItem, *middleItem, *downItem;
@property (nonatomic, assign) NSInteger currentIndex, previousIndex;
@end

@implementation PlayerScrollView

#pragma mark -- lazy loading

- (NSMutableArray *)videoItemArray{
    if(!_videoItemArray){
        _videoItemArray = [NSMutableArray array];
    }
    return _videoItemArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //set scrollView
        self.contentSize = CGSizeMake(0, frame.size.height * 3);
        self.contentOffset = CGPointMake(0, frame.size.height);
        self.pagingEnabled = YES;
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        self.delegate = self;
        
        //上下滑动时的图片预览
        self.upImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, frame.size.height)];
        self.downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height*2, frame.size.width, frame.size.height)];
        
        [self addSubview:self.upImageView];
        [self addSubview:self.middleImageView];
        [self addSubview:self.downImageView];
    }
    return self;
}

- (void)updateForvideoItemArray:(NSMutableArray *)itemArray withCurrentIndex:(NSInteger)index{
    if(itemArray.count && [itemArray firstObject]){
        [self.videoItemArray removeAllObjects];
        [self.videoItemArray addObjectsFromArray:itemArray];
        self.currentIndex = index;
        self.previousIndex = index;
        
        _upItem = [[VideoModel alloc] init];
        _middleItem = (VideoModel *)_videoItemArray[_currentIndex];
        _downItem = [[VideoModel alloc] init];
        
        if (_currentIndex == 0) {
            _upItem = (VideoModel *)[_videoItemArray lastObject];
        } else {
            _upItem = (VideoModel *)_videoItemArray[_currentIndex - 1];
        }
        if (_currentIndex == _videoItemArray.count - 1) {
            _downItem = (VideoModel *)[_videoItemArray firstObject];
        } else {
            _downItem = (VideoModel *)_videoItemArray[_currentIndex + 1];
        }
        
        //load image
        [self prepareForImageView:self.upImageView withModel:_upItem];
        [self prepareForImageView:self.middleImageView withModel:_middleItem];
        [self prepareForImageView:self.downImageView withModel:_downItem];
    }
}

//预备载入内容
- (void) prepareForImageView: (UIImageView *)imageView withModel:(VideoModel *)model{
    imageView.backgroundColor = [UIColor colorWithRed:(arc4random() % 255) / 255.0f green:(arc4random() % 255) / 255.0f blue:(arc4random() % 255) / 255.0f alpha:1.0];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:model.coverImageURL]];
}

#pragma mark -- 播放器切换

//3个播放器实例切换
- (void)switchPlayer:(UIScrollView*)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    if (self.videoItemArray.count) {
        if (offset >= 2 * self.frame.size.height){
            
            scrollView.contentOffset = CGPointMake(0, self.frame.size.height);
            _currentIndex++;
            self.upImageView.image = self.middleImageView.image;
            self.middleImageView.image = self.downImageView.image;
            
            if (_currentIndex == self.videoItemArray.count - 1){
                _downItem = [self.videoItemArray firstObject];
            } else if(_currentIndex == self.videoItemArray.count){
                _downItem = self.videoItemArray[1];
                _currentIndex = 0;
            } else{
                _downItem = self.videoItemArray[_currentIndex + 1];
            }
            
            [self prepareForImageView:self.downImageView withModel:_downItem];
            
            if (_previousIndex == _currentIndex) {
                return;
            }
            
            if ([self.playerDelegate respondsToSelector:@selector(playerScrollView:currentPlayerIndex:)]) {
                [self.playerDelegate playerScrollView:self currentPlayerIndex:_currentIndex];
                _previousIndex = _currentIndex;
//                YWLog(@"当前scrollView的index: %ld",_currentIndex);
            }
        }else if (offset <= 0){
            
            scrollView.contentOffset = CGPointMake(0, self.frame.size.height);
            _currentIndex--;
            self.downImageView.image = self.middleImageView.image;
            self.middleImageView.image = self.upImageView.image;

            if (_currentIndex == 0){
                _upItem = [self.videoItemArray lastObject];
                
            } else if (_currentIndex == -1){
                _upItem = self.videoItemArray[self.videoItemArray.count - 2];
                _currentIndex = self.videoItemArray.count-1;
            } else{
                _upItem = self.videoItemArray[_currentIndex - 1];
            }
            [self prepareForImageView:self.upImageView withModel:_upItem];
            
            if (_previousIndex == _currentIndex) {
                return;
            }
            if ([self.playerDelegate respondsToSelector:@selector(playerScrollView:currentPlayerIndex:)]) {
                [self.playerDelegate playerScrollView:self currentPlayerIndex:_currentIndex];
                _previousIndex = _currentIndex;
//                YWLog(@"current index is: %ld",_currentIndex);
            }
        }
    }
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self switchPlayer:scrollView];
}

@end
