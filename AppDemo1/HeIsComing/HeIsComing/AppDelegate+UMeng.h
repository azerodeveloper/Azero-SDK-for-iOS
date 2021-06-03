//
//  AppDelegate+UMeng.h
//  EastOffice2.0
//
//  Created by pro on 2018/5/3.
//  Copyright © 2018年 EO. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate (UMeng)<UNUserNotificationCenterDelegate>
-(void)registerJPush:(UIApplication *)application options:(NSDictionary *)launchOptions;

@end

