//
//  UIView+TYViewController.h
//  CMBMobileBank
//
//  Created by Jason Ding on 15/11/25.
//  Copyright © 2015年 efetion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TYViewController)
/** 返回当前view所处的viewController，通过nextResponder方法返回，如果没有则返回superview */
- (UIViewController *)currentViewController;
@end

