//
//  UIView+TYViewController.m
//  CMBMobileBank
//
//  Created by Jason Ding on 15/11/25.
//  Copyright © 2015年 efetion. All rights reserved.
//

#import "UIView+TYViewController.h"

@implementation UIView (TYViewController)
- (UIViewController *)currentViewController {
    UIResponder *next = self.nextResponder;
    
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    } while (next != nil);
    
    return nil;
}
@end
