//
//  AppDelegate.m
//  test000
//
//  Created by silk on 2020/2/19.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+UMeng.h"
#import "IQKeyboardManager.h"
#import "GKHttpManager.h"
#import "BaseNC.h"
#import "QKKeyChain.h"
#import "SaiHomePageViewController.h"
#import "SaiNewFeatureViewController.h"
#import "WXApiManager.h"  
#import "WXApi.h"
#import "GKVolumeView.h"
#import "VersionUpdateAlert.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()  

@end
@implementation AppDelegate  
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
//    [[SaiAzeroManager sharedAzeroManager] systemCurrentVolume];
    [WXApi registerApp:@"wxc7e52b2b431a7842" universalLink:@"https://www.soundai.com/"];
    [self registerJPush:application options:launchOptions];
    [AMapServices sharedServices].apiKey = @"a02cdc6fe0cd89b1224c57f5f883315b";
    NSString * currentDeviceUUIDStr =[[NSString alloc]initWithData:[QKKeyChain getCertificateWith:@"UUID"] encoding:NSUTF8StringEncoding];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""]){
       NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
       currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
       currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
       currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
       [QKKeyChain saveCertificate:@"UUID" data:[currentDeviceUUIDStr dataUsingEncoding:NSUTF8StringEncoding]];
       SaiContext.UUID=currentDeviceUUIDStr;
    }else{
       SaiContext.UUID=currentDeviceUUIDStr;
    }
  
    [self newFeatureVersionJudgment];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    //开启一个后台标示任务
    UIApplication *app = [UIApplication sharedApplication];
    self.taskIdentifiery = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:self.taskIdentifiery];
        //标示一个后台任务请求
         self.taskIdentifiery = 0;//UIBackgroundTaskInvalid;
    }];

    //开启一个线程队列
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [app endBackgroundTask:self.taskIdentifiery];
        self.taskIdentifiery = UIBackgroundTaskInvalid;
    });
//    [[XYRecorder sharedRecorder] saveVoiceData];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SaikIsLogin]) {
//        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:nil messmage:@"827record AppDelegate **************** [[XBEchoCancellation shared] startInput] 前"];
        [[XBEchoCancellation shared] startInput];
//        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:nil messmage:@"827record AppDelegate **************** [[XBEchoCancellation shared] startInput] 后"];
        [SaiNotificationCenter postNotificationName:SaiApplicationWillEnterForeground object:nil];
    }
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiWARN tag:[QKUITools getNowyyyymmddmmss] messmage:@"applicationDidReceiveMemoryWarning"];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    return [WXApi handleOpenUniversalLink:userActivity delegate:[WXApiManager sharedManager]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[XBEchoCancellation shared] saveVoiceData];
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiWARN tag:[QKUITools getNowyyyymmddmmss] messmage:@"applicationWillTerminate"];
    [[SaiAzeroManager sharedAzeroManager] saiLogoutAzeroSDK];
    
}  

- (void)newFeatureVersionJudgment{
    SaiNewFeatureViewController *NewFeatureViewController = [[SaiNewFeatureViewController alloc] init];
    self.window.rootViewController = NewFeatureViewController;
}

#pragma mark - getters
-(SaiHomePageViewController *)homePageViewController{
    if (!_homePageViewController) {
        _homePageViewController=[SaiHomePageViewController new];
        
    }
    return _homePageViewController;
}


@end

