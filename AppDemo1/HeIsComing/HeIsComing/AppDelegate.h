//
//  AppDelegate.h
//  test000
//
//  Created by silk on 2020/2/19.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaiHomePageViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIButton  *playBtn;
@property(nonatomic,strong)SaiHomePageViewController *homePageViewController;
@property(nonatomic,assign)UIBackgroundTaskIdentifier taskIdentifiery ;

@end
