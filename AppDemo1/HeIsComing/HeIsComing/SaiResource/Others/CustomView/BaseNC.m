//
//  BaseNC.m
//  xiaoyixiu 
//
//  Created by hanzhanbing on 16/6/13.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import "BaseNC.h"
#import "AppDelegate.h"

@interface BaseNC ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate>

@end

@implementation BaseNC

+(void)initialize{
    UINavigationBar *naviBar = [UINavigationBar appearance];
    [naviBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor blackColor], NSForegroundColorAttributeName,
    [UIFont fontWithName:@"微软雅黑" size:24], NSFontAttributeName, nil]];
   
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tabBarController.delegate=self;
    self.view.backgroundColor = UIColor.whiteColor;
    [self configNavigation];
}

- (void)configNavigation{
    self.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
    self.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return  [self.childViewControllers count] == 1 ? NO:YES;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self.viewControllers containsObject:viewController]) {
        return;
    }
    [super pushViewController:viewController animated:animated];
}


@end

