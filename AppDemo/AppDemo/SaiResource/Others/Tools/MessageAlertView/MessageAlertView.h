//
//  MessageAlertView.h
//  xiaoyixiu
//
//  Created by 柯南 on 16/6/12.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BackVwColor  [UIColor colorWithWhite:0.0 alpha:0.5]
#define SUCCESSIMAGE		[UIImage imageNamed:@"AlertSuccess"]
#define ERRORIMAGE			[UIImage imageNamed:@"AlertFailure"]
#define SHOWHUDTIME 3.0  //2秒后自动隐藏
@interface MessageAlertView : UIView

+(void)dismissHud;
+(MessageAlertView *)shareHud;

/**
 *  显示一个转圈的视图,并显示一个加载信息,不传message则显示加载中
 *
 *  @param message 提示信息
 */
+(void)showLoading:(NSString *)message;

/**
 *  显示成功提示框
 *
 *  @param messgae 成功信息
 */
+(void)showSuccessMessage:(NSString *)messgae;

/**
 *  显示提示框
 *
 *  @param messgae 信息
 */
+(void)showHudMessage:(NSString *)messgae;

@end
