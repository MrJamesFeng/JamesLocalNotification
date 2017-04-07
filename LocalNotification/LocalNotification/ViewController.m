//
//  ViewController.m
//  LocalNotification
//
//  Created by LDY on 17/4/7.
//  Copyright © 2017年 LDY. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
@interface ViewController ()<UNUserNotificationCenterDelegate>

@end

@implementation ViewController
//// In iOS 8.0 and later, your application must register for user notifications using -[UIApplication registerUserNotificationSettings:] before being able to schedule and present UILocalNotifications
//NS_CLASS_DEPRECATED_IOS(4_0, 10_0, "Use UserNotifications Framework's UNNotificationRequest") __TVOS_PROHIBITED
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
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

    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"requesIdentifier" content:mutableNotificationContent trigger:timeIntervalNotificationTrigger];
    [notificationCenter addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"error = %@",error);
        }
    }];
    
    // 获取展示过的通知
    [notificationCenter getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        for (UNNotification *notification in notifications) {
            NSLog(@"getDeliveredNotifications notification = %@",notification);
        }
    }];
    
    //获取未展示过的通知
    [notificationCenter getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        for (UNNotificationRequest *request in requests) {
            NSLog(@"getPendingNotificationRequests request = %@",request);
        }
    }];
    
//    //移除展示过的通知
//    [notificationCenter removeDeliveredNotificationsWithIdentifiers:@[@"requesIdentifier"]];
//    
//    //移除未展示的通知
//    [notificationCenter removePendingNotificationRequestsWithIdentifiers:@[@"requesIdentifier"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
}
@end
