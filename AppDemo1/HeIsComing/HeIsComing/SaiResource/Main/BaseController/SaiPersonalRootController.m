//
//  SaiPersonalRootController.m
//  HeIsComing
//
//  Created by silk on 2020/7/25.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiPersonalRootController.h"
#import "MessageAlertView.h"

@interface SaiPersonalRootController ()

@end

@implementation SaiPersonalRootController
- (void)viewWillAppear:(BOOL)animated{  
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {  
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.navigationBar.translucent = NO;//设置导航栏为不是半透明状态
    if (@available(iOS 11.0, *)) {
          self.tableView.contentInsetAdjustmentBehavior  = UIScrollViewContentInsetAdjustmentNever;

      } else {
          // Fallback on earlier versions
//          self.automaticallyAdjustsScrollViewInsets = NO;
      }

    [[SaiAzeroManager sharedAzeroManager] saiSDKConnectionStatusChangedWithStatus:^(ConnectionStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case ConnectionStatusConnect:{
                    [MessageAlertView showHudMessage:@"与SDK服务器建立连接"];
                    [[SaiPlaySoundManager sharedPlaySoundManager] playSoundWithSource:@"alert_network_connected.mp3"];
                }
                    break;
                case ConnectionStatusPENDING:{
                    [MessageAlertView showHudMessage:@"与SDK服务器断开连接"];
                    [[SaiPlaySoundManager sharedPlaySoundManager] playSoundWithSource:@"alert_network_disconnected.mp3"];
                }
                    break;
                case ConnectionStatusDisConnect:
                    break;
                default:
                    break;
            }
        });
    }];
}
-(void)setNavigation {
    if ([[self.navigationController viewControllers] count] == 1) {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    else
    {
        UIButton *backButton = [[UIButton alloc] init];
        backButton.frame = CGRectMake(20, kStatusBarHeight+15, 11, 19);
        [backButton setImage:[UIImage imageNamed:@"dl_back"] forState:UIControlStateNormal];
        [backButton addTarget: self action: @selector(backAction) forControlEvents: UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backItem;
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName] = UIColor.blackColor ;
        self.navigationController.navigationBar.titleTextAttributes =textAttrs;
    }
}

- (void)backAction{
    if (self.presentingViewController) {
        if (self.navigationController.childViewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }else{
            [self backAnimation];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//返回动画
-(void)backAnimation{
    CATransition* animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.view.window.layer addAnimation:animation forKey:nil];
}
#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
}

/**
 *  自定义的tableView, 使用前确认tableView已经添加到view中,以及实现了对应的代理方法
 */
- (SaiTableView *)tableView{
    if (!_tableView) {
        CGRect frame = [UIScreen mainScreen].bounds;
        if (self.isGroupTableView) {
            _tableView = [[SaiTableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        }else{
            _tableView = [[SaiTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
       
    }
    return _tableView;
}
-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    //    [self jumpAnimation];
    [super presentViewController: viewControllerToPresent animated:flag completion:completion];
}

@end
