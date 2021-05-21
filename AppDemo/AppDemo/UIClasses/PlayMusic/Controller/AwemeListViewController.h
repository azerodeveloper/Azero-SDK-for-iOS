//
//  AwemeListViewController.h
//  AwemeDemo
//
//  Created by sunyazhou on 2018/10/18.
//  Copyright © 2018 sunyazhou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define StatusBarTouchBeginNotification @"StatusBarTouchBeginNotification"

NS_ASSUME_NONNULL_BEGIN

@interface AwemeListViewController : SaiBaseRootController
@property (nonatomic ,assign) BOOL guideBool;
@property (nonatomic ,copy) NSString *renderTemplateStr;

@end

NS_ASSUME_NONNULL_END
