//
//  VersionUpdateAlert.m
//  Sekey
//
//  Created by silk on 2017/6/18.
//  Copyright © 2017年 silk. All rights reserved.
//

#import "VersionUpdateAlert.h"
#import "QKUIAlertView.h"
#import "LDDownloadManager.h"
#import "SaiVersionModel.h"
@interface VersionUpdateAlert ()
@property (nonatomic, copy) NSString *appID;
@property (nonatomic, strong)SaiVersionModel *versionModel;
@end

@implementation VersionUpdateAlert
+ (instancetype)shareVersionUpdateAlert{ 
    static VersionUpdateAlert *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VersionUpdateAlert alloc] init];
    });
    return instance;
}

- (void)checkAndShowWithAppID:(NSString *)appID andController:(UIViewController *)VC{

    [QKBaseHttpClient updateHttpType:GET andURL:@"https://app-azero.soundai.com.cn/downloads/version.json" andParam:nil andSuccessBlock:^(NSURL *URL, id data) {
        NSString * code = data[@"code"];
        if ([code intValue] ==200) {
            SaiVersionModel *versionModel=[SaiVersionModel modelWithJson:data];
            self.versionModel=versionModel;
            NSString *newVersion = data[@"ios_current_version"];
            NSString *releaseNotes = data[@"ios_update"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString* appCurrentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *versionString = [userDefaults objectForKey:@"appCurrentVersion"];
            if (versionString == nil) {
                [userDefaults setObject:appCurrentVersion forKey:@"appCurrentVersion"];
            }
            //当版本更新后重置interCount
            if (![[userDefaults objectForKey:@"appCurrentVersion"] isEqualToString:appCurrentVersion]) {
                [userDefaults setObject:@"0" forKey:@"interCount"];
                [userDefaults setObject:appCurrentVersion forKey:@"appCurrentVersion"];
            }
            if ([newVersion compare:appCurrentVersion] == NSOrderedDescending) {
                NSNumber *interCount = [userDefaults objectForKey:@"interCount"];
                if ([releaseNotes rangeOfString:@"\n\n\n"].location != NSNotFound) {
                    NSArray *ary = [releaseNotes componentsSeparatedByString:@"\n\n\n"];
                    releaseNotes = ary[0];
                }
                if (interCount == nil||[interCount intValue]<=2) {
                    NSString *text = [NSString stringWithFormat:@"当前版本: V%@\n最新版本: V%@\n新版特性: \n%@",appCurrentVersion,newVersion,releaseNotes];
                    [self alertShowWithAppID:appID andController:VC withReleaseNotes:text];
                }else if (([interCount integerValue]-2)%(self.interCount ? self.interCount : 6) == 0) {
                    NSString *text = [NSString stringWithFormat:@"当前版本: V%@\n最新版本: V%@\n新版特性: \n%@",appCurrentVersion,newVersion,releaseNotes];
                    [self alertShowWithAppID:appID andController:VC withReleaseNotes:text];
                }
                NSInteger integerInterCount = [interCount integerValue];
                integerInterCount++;
                NSNumber *numberInterCount = [NSNumber numberWithInteger:integerInterCount];
                [userDefaults setObject:numberInterCount forKey:@"interCount"];
            }
            SaiVersionModelCurrent_img_version *versionModelCurrent_img_version=versionModel.current_img_version.firstObject;
            SaiContext.currentVersion=                [[NSUserDefaults standardUserDefaults] objectForKey:@"currentVersion"];
            if ([QKUITools isBlankString:SaiContext.currentVersion]) {
                SaiContext.currentVersion=@"";
            }

            if ([SaiContext.currentVersion compare:versionModelCurrent_img_version.SoundAI_TA_pro] == NSOrderedAscending) {
                [self downLoad];

            }

            
        }
        
    } andFailBlock:^(NSURL *URL, NSError *error) {
        TYLog(@"error:%@",error);
    }];

}
-(void)downLoad{
    [[LDDownloadManager sharedInstance]deleteFileWithUrl:otaUrl];
    
    
    [[LDDownloadManager sharedInstance]download:otaUrl progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {

        } state:^(FileDownloadState state) {

        } completionHandler:^(NSString * _Nonnull filePath, NSError * _Nonnull error) {
            if (!error) {
                SaiVersionModelCurrent_img_version *versionModelCurrent_img_version=self.versionModel.current_img_version.firstObject;
                [[NSUserDefaults standardUserDefaults]setValue:versionModelCurrent_img_version.SoundAI_TA_pro forKey:@"currentVersion"];


                SaiContext.currentVersion=versionModelCurrent_img_version.SoundAI_TA_pro;
            }
        }];
    
}

//弹出的alertView
- (void)alertShowWithAppID:(NSString *)appID andController:(UIViewController *)VC withReleaseNotes:(NSString *)releaseNotes{
    QKUIAlertView *alertView = [[QKUIAlertView alloc] init];
    [alertView versionUpdateWith:releaseNotes sureTitle:@"立即更新" otherBlockCallBack:^{
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",self.appID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }];
    [alertView showAlert];
    self.appID = appID;
}
-(void)XMClickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",self.appID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}
//打开appStore
- (void)openAppaleShopWithAppID:(NSString *)appID{

}
- (id)transformedValue:(NSString *)value
{
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",nil];
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%4.1f %@",convertedValue/2, [tokens objectAtIndex:multiplyFactor]];
}

@end
