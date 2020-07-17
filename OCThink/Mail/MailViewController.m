//
//  MailViewController.m
//  OCThink
//
//  Created by Ryan | 沐秋 on 2020/7/6.
//  Copyright © 2020 leoli. All rights reserved.
//

#import "MailViewController.h"
#import <MessageUI/MessageUI.h>
#import "UINavigationController+Navbar.h"

@interface MailViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation MailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *jumpBtn = [[UIButton alloc] init];
    jumpBtn.frame = CGRectMake(60, 120, 80, 40);
    jumpBtn.backgroundColor = [UIColor blueColor];
    [jumpBtn setTitle:@"邮件" forState:UIControlStateNormal];
    [jumpBtn addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpBtn];
}

- (void)sendMail
{
    //判断用户是否已设置邮件账户
    if ([MFMailComposeViewController canSendMail]) {
        [self mail]; // 调用发送邮件的代码
    } else {
        //给出提示,设备未开启邮件服务
        NSString *remindTitle = @"没有开启邮件服务";
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:remindTitle message:@"" preferredStyle:UIAlertControllerStyleAlert];
        NSString *okTitle = @"OK";
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:alertVC completion:nil];
        }];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

- (void)mail
{
    // 创建邮件发送界面
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置收件人
    [mailCompose setToRecipients:@[@"916088957@qq.com"]];
    [mailCompose setSubject:@"haha"];
    mailCompose.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:mailCompose animated:YES completion:nil];
}

#pragma mark - delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled: 用户取消编辑");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: 用户保存邮件");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent: 用户点击发送");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@ : 用户尝试保存或发送邮件失败", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
