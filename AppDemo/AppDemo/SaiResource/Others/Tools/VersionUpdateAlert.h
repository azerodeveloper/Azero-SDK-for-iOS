//
//  VersionUpdateAlert.h
//  Sekey
//
//  Created by silk on 2017/6/18.
//  Copyright © 2017年 silk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionUpdateAlert : NSObject

// 间隔多少次使用，再次出现弹框提醒，默认20
@property (nonatomic, assign) NSInteger interCount;
+ (instancetype)shareVersionUpdateAlert;

/**
 * appID:appleID
 * VC:alertView需要一个控制器引出，一般为设为rootViewController的那个控制器
 */
- (void)checkAndShowWithAppID:(NSString *)appID andController:(UIViewController *)VC;
@end
