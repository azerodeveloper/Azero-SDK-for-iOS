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
#import "WXApi.h"
#import "GKVolumeView.h"
#import "VersionUpdateAlert.h"
#import "SaiNewFeatureViewController.h"
//#import <AMapFoundationKit/AMapFoundationKit.h>
@interface AppDelegate ()  

@end
@implementation AppDelegate  
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)newFeatureVersionJudgment{
    SaiNewFeatureViewController *NewFeatureViewController = [[SaiNewFeatureViewController alloc] init];
    self.window.rootViewController = NewFeatureViewController;
}



@end

