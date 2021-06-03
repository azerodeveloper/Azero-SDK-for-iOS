//
//  SaiAlertView.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/12/10.
//  Copyright © 2018 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^cancelButtonCallBack)(void);
typedef void(^otherButtonCallBack)(void);
NS_ASSUME_NONNULL_BEGIN
@interface JySaiAlertView : UIAlertView
/**
 *  自定义便捷提示框,创建完毕之后,调用实例的show方法,显示alertView
 *
 *  @param title          提示框标题
 *  @param otherCallback  点击确认后的回调block
 *  @param cancelCallBack 点击取消后的回调block
 *
 *  @return 返回TMAlertView 实例
 */
- (instancetype)initMessageWithTitle:(NSString* __nullable)title otherBlock:(otherButtonCallBack)otherCallback cancelBlock:(cancelButtonCallBack)cancelCallBack;
/**
 *  自定义便捷提示框,创建完毕之后,调用实例的show方法,显示alertView
 *
 *  @param title          提示框标题
 *  @param okText         确认按钮的文字
 *  @param otherCallback  点击确认后的回调block
 *  @param cancelCallBack 点击取消后的回调block
 *
 *  @return 返回TMAlertView 实例
 */
- (instancetype)initMessageWithTitle:(NSString*)title OKButtonText:(NSString *)okText otherBlock:(otherButtonCallBack)otherCallback cancelBlock:(cancelButtonCallBack)cancelCallBack;
/**
 *  定义确认 和 取消按钮的文字
 */
-(instancetype)initMessageWithTitle:(NSString * __nullable)title message:(NSString* __nullable)message OKButtonText:(NSString * __nullable)okText cancelButtonText:(NSString * __nullable)cancelText otherBlock:(otherButtonCallBack)otherCallback cancelBlock:(cancelButtonCallBack)cancelCallBack;


@end
NS_ASSUME_NONNULL_END
