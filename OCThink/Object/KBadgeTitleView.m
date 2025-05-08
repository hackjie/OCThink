//
//  KBadgeTitleView.m
//  OCThink
//
//  Created by 李杰 on 2025/2/18.
//  Copyright © 2025 leoli. All rights reserved.
//

#import "KBadgeTitleView.h"
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>

@interface KBadgeTitleView()
@property (nonatomic, strong) UILabel *containerLabel;
@property (nonatomic, strong) NSTextAttachment *imageAttachment;

@end

@implementation KBadgeTitleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.containerLabel = [UILabel new];
        self.containerLabel.numberOfLines = 0;
        
        
        self.imageAttachment = [[NSTextAttachment alloc] init];
        
        [self addSubview:self.containerLabel];
        [self.containerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.backgroundColor = UIColor.redColor;
    }
    return self;
}

- (void)test {
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSURL *url = [[NSURL alloc] initWithString:@"https://img.lazcdn.com/us/lazgcp/f330ffed-ef69-4952-9d6e-a5ff24641993_ALL-92-52.png#width=92&height=52"];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {

    }];
    self.imageAttachment.image = [UIImage imageNamed:@"test1"];
    
    
    // 设置图片大小
    self.imageAttachment.bounds = CGRectMake(0, 0, 23, 13);
    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:self.imageAttachment];
    
    
    [attriStr insertAttributedString:stringImage atIndex:0];
    
    
    NSAttributedString *testStr = [[NSAttributedString alloc] initWithString:@"hello hello hello hello hello world"];
    [attriStr appendAttributedString:testStr];
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    NSLog(@"haha %@, %@", @(self.containerLabel.font.lineHeight), @(self.containerLabel.font.pointSize));
    //[style setLineSpacing: 3-(self.containerLabel.font.lineHeight - self.containerLabel.font.pointSize)];
    [style setLineSpacing: 3];
    [style setLineHeightMultiple:1];
    
    NSDictionary *dict = @{
        NSParagraphStyleAttributeName:style,
        NSFontAttributeName: self.containerLabel.font
    };
    
    [attriStr addAttributes:dict range:NSMakeRange(0, attriStr.string.length)];
    
    
    self.containerLabel.attributedText = attriStr;
    
    
    self.containerLabel.textColor = [UIColor blueColor];
}



@end
