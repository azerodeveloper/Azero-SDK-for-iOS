//
//  SaiNavigationController.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/28.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "SaiNavigationController.h"

@interface SaiNavigationController ()

@end

@implementation SaiNavigationController
//+ (void)initialize{
//    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
//    [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor sai_NavgationBarColor]];
//}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = (id)self;
    //    self.navigationBarHidden = YES;
    self.navigationBar.translucent = YES;//透明
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.childViewControllers.count == 1) {
        return NO;
    }
    return YES;
}


@end
