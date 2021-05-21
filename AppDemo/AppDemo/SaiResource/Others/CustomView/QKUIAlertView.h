//
//  QKUIAlertView.h
//  Sekey
//
//  Created by silk on 2017/7/25.
//  Copyright © 2017年 silk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^cancelButtonCallback)(void);
typedef void(^otherButtonCallback)(void);
typedef void(^retryButtonCallback)(void);
typedef void(^disconnectButtonCallback)(void);
typedef void(^notCheakButtonCallback)(void);
typedef void(^logoutButtonCallback)(void);
typedef void(^continueButtonCallback)(void);
typedef void(^sureButtonCallback)(NSString *text);

typedef void(^feedbackButtonCallback)(NSString *text);


@interface QKUIAlertView : UIView 
-(void)showAlert;

/**
 * 版本更新
 */
- (void)versionUpdateWith:(NSString *)message sureTitle:(NSString *)sureTitle otherBlockCallBack:(otherButtonCallback)otherCallback;
/**
* 信息反馈
*/
- (void)informationFeedbackOtherBlockCallBack:(feedbackButtonCallback)feedbackCallback withType:(int )type;

@end
