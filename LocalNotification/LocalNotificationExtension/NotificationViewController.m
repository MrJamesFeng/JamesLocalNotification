//
//  NotificationViewController.m
//  LocalNotificationExtension
//
//  Created by LDY on 17/4/10.
//  Copyright © 2017年 LDY. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;
@property (weak, nonatomic) IBOutlet UISlider *slider;


@property(nonatomic,strong)UIWebView *webview;


@property(nonatomic,strong) AVPlayer*play;



@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
//    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2);
    self.webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webview];
}
- (IBAction)buttonAction:(UIButton *)sender {
    NSLog(@"buttonAction");
}

- (void)didReceiveNotification:(UNNotification *)notification {//预览消息的时候调用
//    NSLog(@"didReceiveNotification notification =%@",notification);
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"timg-2.jpeg" ofType:nil];
    self.image.image = [UIImage imageWithContentsOfFile:filePath];

    self.label.text = notification.request.content.title;
    self.subtitle.text =notification.request.content.subtitle;
    self.userInfo.text = @"userInfo";
    [self.slider setValue:0.9];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
//    ViewController *vc = [[ViewController alloc]init];
//    [self presentViewController:vc animated:YES completion:nil];
    

}
-(void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion{
    NSLog(@"response=%@",response);
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"app从后台进入前台" message:@"didReceiveNotificationResponse" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        [alertView show];
    
    
    completion(UNNotificationContentExtensionResponseOptionDoNotDismiss);
}

@end
