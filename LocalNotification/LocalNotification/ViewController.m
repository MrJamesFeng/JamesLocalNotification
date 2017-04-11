//
//  ViewController.m
//  LocalNotification
//
//  Created by LDY on 17/4/7.
//  Copyright © 2017年 LDY. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import <UserNotifications/UNError.h>
@interface ViewController ()<UNUserNotificationCenterDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UNUserNotificationCenter *notificationCenter;

@end

#ifndef __OPTIMIZE__
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...)
#endif

@implementation ViewController
//// In iOS 8.0 and later, your application must register for user notifications using -[UIApplication registerUserNotificationSettings:] before being able to schedule and present UILocalNotifications
//NS_CLASS_DEPRECATED_IOS(4_0, 10_0, "Use UserNotifications Framework's UNNotificationRequest") __TVOS_PROHIBITED
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self userNotification];

}
-(void)userNotification{
    UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    
    self.notificationCenter = notificationCenter;
    
    notificationCenter.delegate = self;
    [notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert|UNAuthorizationOptionCarPlay completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error=%@",error);
        }
    }];
    [notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        switch (settings.authorizationStatus) {
            case UNAuthorizationStatusNotDetermined:
                NSLog(@"UNAuthorizationStatusNotDetermined");
                break;
            case UNAuthorizationStatusDenied:
                NSLog(@"UNAuthorizationStatusDenied");
                break;
            case UNAuthorizationStatusAuthorized:
                NSLog(@"UNAuthorizationStatusAuthorized");
                break;
            default:
                break;
        }
    }];
    
    UNMutableNotificationContent *mutableNotificationContent = [[UNMutableNotificationContent alloc]init];
    mutableNotificationContent.title = [NSString localizedUserNotificationStringForKey:@"title"  arguments:@[@"notification title"]];
    mutableNotificationContent.subtitle = [NSString localizedUserNotificationStringForKey:@"subtitle" arguments:@[@"subtitle subtitle"]];
    mutableNotificationContent.badge = [NSNumber numberWithInt:1];
    mutableNotificationContent.body = [NSString localizedUserNotificationStringForKey:@"title_message_for_yan" arguments:nil];
    mutableNotificationContent.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger *timeIntervalNotificationTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:60 repeats:YES];//'time interval must be at least 60 if repeating'
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"timg-6.jpeg" ofType:nil];
    //    NSString *videoPath = [[NSBundle mainBundle]pathForResource:@"IMG_1350.mp4" ofType:nil];
        if (filePath) {
            NSError *error = nil;
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"attachment" URL:[NSURL fileURLWithPath:filePath] options:nil error:&error];
            if (error) {
                NSLog(@"Attachment error = %@",error);
            }
            if (attachment) {
                mutableNotificationContent.attachments = @[attachment];
            }
        }
//    UNNotificationActionOptionAuthenticationRequired = (1 << 0),
//    
//    // Whether this action should be indicated as destructive.
//    UNNotificationActionOptionDestructive = (1 << 1),
//    
//    // Whether this action should cause the application to launch in the foreground.
//    UNNotificationActionOptionForeground
    
    UNTextInputNotificationAction *attachmentA = [UNTextInputNotificationAction actionWithIdentifier:@"attachmentA" title:@"文本框" options:UNNotificationActionOptionAuthenticationRequired textInputButtonTitle:@"ttachmentA ttachmentA" textInputPlaceholder:@"attachmentA"];
    
    
    /*
    UNNotificationAction *attachmentA = [UNNotificationAction actionWithIdentifier:@"attachmentA" title:@"不需要解锁直接进入app" options:UNNotificationActionOptionForeground];//
     */
    UNNotificationAction *attachmentB =[UNNotificationAction actionWithIdentifier:@"attachmentB" title:@"需要解锁才能进入app" options:UNNotificationActionOptionAuthenticationRequired];//需要解锁屏幕才能进入app
    UNNotificationAction *attachmentC = [UNNotificationAction actionWithIdentifier:@"attachmentC" title:@"重要点击不进入app" options:UNNotificationActionOptionDestructive];//点击不进入app
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"category" actions:@[attachmentA,attachmentB,attachmentC] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
     
    
    mutableNotificationContent.categoryIdentifier = @"category";//关联UNNotificationCategory
    
    [notificationCenter setNotificationCategories:[NSSet setWithArray:@[category]]];
    
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"requesIdentifier" content:mutableNotificationContent trigger:timeIntervalNotificationTrigger];
    [notificationCenter addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"error = %@",error);
        }
    }];
    //获取未展示过的图标
    [notificationCenter getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = requests.count;
    }];
    // 获取展示过的通知
    [notificationCenter getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        NSLog(@"%@",notifications);
//        for (UNNotification *notification in notifications) {
//            NSLog(@"getDeliveredNotifications notification = %@",notification);
//        }
    }];
    
    //    //移除展示过的通知
//        [notificationCenter removeDeliveredNotificationsWithIdentifiers:@[@"requesIdentifier"]];
    //
    //    //移除未展示的通知
        [notificationCenter removePendingNotificationRequestsWithIdentifiers:@[@"requesIdentifier"]];
//        [notificationCenter removeAllDeliveredNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{//app在前台
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"app在前台" message:@"willPresentNotification" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
//    [alertView show];
    
    
    completionHandler(UNNotificationPresentationOptionSound);
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{//app从后台进入前台
    
    NSLog(@"－－－－>categoryIdentifier =%@  response = %@",response.notification.request.content.categoryIdentifier,response);
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"app从后台进入前台" message:@"didReceiveNotificationResponse" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
    
    [alertView show];
//    UIWindow *mianWindow = [UIApplication sharedApplication].keyWindow;
//    UIViewController *roorVC = [mianWindow rootViewController];
    [UIApplication sharedApplication];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    completionHandler();
    
}

@end
