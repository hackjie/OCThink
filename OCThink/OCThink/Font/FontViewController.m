//
//  FontViewController.m
//  OCThink
//
//  Created by leoli on 2018/9/3.
//  Copyright © 2018 leoli. All rights reserved.
//

#import "FontViewController.h"

@interface FontViewController ()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *oneLineLabel;
@end

@implementation FontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.oneLineLabel];

    NSString *text = @"这个世界还是那么的糟糕那么的美好，小二上酒这个世界还是那么的糟糕那么的美好，小二上酒这个世界还是那么的糟糕那么的美好，小二上酒这个世界还是那么的糟糕那么的美好，小二上酒这个世界还是那么的糟糕那么的美好，小二上酒这个世界还是那么的糟糕那么的美好，小二上酒这个世界还是那么的糟糕那么的美好，小二上酒这个世界还是那么的糟糕那么的美好，小二上酒这个世界还是那么的糟糕那么的美好，小二上酒这个世界还是那么的糟糕那么的美好，小二上酒这个世界还是那么的糟糕那么的美好，小二上酒这个世界还是那么的糟糕那么的美好，小二上酒这个世界还是那么的糟糕那么的美好，小二上酒这个世界还是那么的糟糕那么的美好，小二上酒";

    [self realLineHeightOnlyIOS:_textLabel text:text lineSpacing:10];
//    [self realLineHeightBothIOSAndAndroid:text];

    NSString *lessText = @"哈哈哈哈哈哈";
    [self realLineHeightOnlyIOS:_oneLineLabel text:lessText lineSpacing:10];
//    [self realLineHeightBothIOSAndAndroid:_oneLineLabel text:lessText lineHeight:40];
}

- (void)realLineHeightOnlyIOS:(UILabel *)label
                         text:(NSString *)text
                  lineSpacing:(CGFloat)lineSpacing {
    // 设置行间距的方式 但是这种有个问题：iOS 的 LineSpacing 一直有个 Bug，一旦中文设置了 LineSpacing，在单行情况下底部会多出 LineSpacing 的间距，多行时就没有这个问题，英文单行也没有这个问题。为了解决这个问题，
    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpacing - (label.font.lineHeight - label.font.pointSize);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)setLabel:(UILabel *)label
            text:(NSString *)text
      lineHeight:(CGFloat)lineHeight {
    // 采用直接设置行高的方式，需要调节 baselineOffset
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.minimumLineHeight = lineHeight;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGFloat baselineOffset = (lineHeight - label.font.lineHeight) / 4;
    [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
    label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)oneLineLabel {
    if (!_oneLineLabel) {
        _oneLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 430, 300, 30)];
        _oneLineLabel.textColor = [UIColor blackColor];
        _oneLineLabel.numberOfLines = 0;
        _oneLineLabel.backgroundColor = [UIColor greenColor];
    }
    return _oneLineLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 200)];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.numberOfLines = 0;
        _textLabel.backgroundColor = [UIColor greenColor];
    }
    return _textLabel;
}

@end
