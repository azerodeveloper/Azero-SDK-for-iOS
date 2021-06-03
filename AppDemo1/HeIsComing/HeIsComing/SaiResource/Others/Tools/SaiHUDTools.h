//
//  SaiHUDTools.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/12/10.
//  Copyright © 2018 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SaiProgressHUDMaskType) {
    SaiProgressHUDMaskTypeNone = 1,  // allow user interactions while HUD is displayed
    SaiProgressHUDMaskTypeClear,     // don't allow user interactions
    SaiProgressHUDMaskTypeBlack,     // default mask type, don't allow user interactions and dim the UI in the back of the HUD, as on iOS 7 and above
    SaiProgressHUDMaskTypeGradient   // don't allow user interactions and dim the UI with a a-la UIAlertView background gradient, as on iOS 6
};
@interface SaiHUDTools : NSObject

/**
 *  当前默认是: TYProgressHUDMaskTypeBlack
 */
+ (void)setDefaultMaskType:(SaiProgressHUDMaskType)type;

/**
 *  显示提示文字
 *
 *  @param msg 文字
 */
+ (void)showMessage:(NSString *)msg;

/**
 *  关闭提示
 */
+ (void)hideHUD;

/**
 *  显示成功
 */
+ (void)showSuccess:(NSString *)msg;

/**
 *  显示失败
 */
+ (void)showError:(NSString *)msg;



@end

NS_ASSUME_NONNULL_END
