//
//  SaiBaseRootController.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/27.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "SaiBaseRootController.h"
#import "SaiTableView.h"
#import "SaiSoundWaveView.h"
#import "NetWorkUtil.h"
#import "MessageAlertView.h"
#import "AppDelegate.h"
#import <objc/runtime.h>
@interface SaiBaseRootController ()
@property (nonatomic ,assign) BOOL isSelfVC;
@property (nonatomic ,copy) NSString *alert_token;
@end  

@implementation SaiBaseRootController
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
  
    self.upSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)];
    [self.upSwipe setDirection: UISwipeGestureRecognizerDirectionRight];
    [self.upSwipe setNumberOfTouchesRequired:1];
    
    [self.view addGestureRecognizer:self.upSwipe];
    self.navigationController.navigationBar.translucent = NO;//设置导航栏为不是半透明状态
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior  = UIScrollViewContentInsetAdjustmentNever;
        
    } 

 
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerVadStart:^{
        TYLog(@" ==================================================================================================== saiAzeroManagerVadStart");
        dispatch_async(dispatch_get_main_queue(), ^{
            [SaiSoundWaveView showHudAni];
            [SaiSoundWaveView showMessage:@""];
        });
    }];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerVadStop:^{
        TYLog(@" ==================================================================================================== saiAzeroManagerVadEnd");
        TYLog(@"--**localDetectorEventSpeechStopDetected3");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SaiSoundWaveView dismissHudAni];
            TYLog(@"--**localDetectorEventSpeechStopDetected4");
            
        });
    }];
    
//    __weak typeof(self)weakSelf = self;
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerExpress:^(NSString *type, NSString *content) {
        TYLog(@"type : %@ ,content : %@",type,content);
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (weakSelf.GetDataBlock) {
//                weakSelf.GetDataBlock(type, content);
//            }
//            NSDictionary *dic = [SaiJsonConversionModel dictionaryWithJsonString:content];
//            NSString *action = dic[@"action"];
//            if ([action isEqualToString:@"goHome"]) {
//                [weakSelf dismissViewControllerAnimated:NO completion:nil];
//            }

            if ([type isEqualToString:@"ASRText"]) {
                NSDictionary *contentDictionary=[SaiJsonConversionModel dictionaryWithJsonString:content];
                bool finished=[[NSString stringWithFormat:@"%@",contentDictionary[@"finished"]] boolValue];
                if (![QKUITools isBlankString:contentDictionary[@"text"]]) {
                    [SaiSoundWaveView showMessage:contentDictionary[@"text"]];
                    TYLog(@"显示的数据是 ----- %@",contentDictionary[@"text"]);
                }
                if (finished) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //                        [SaiSoundWaveView showMessage:@""];
                        [SaiSoundWaveView hideAllView];
                    });
                }
            }
        });
    }];
    
    
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
                    [SaiSoundWaveView hideAllView];
                }
                    break;
                case ConnectionStatusDisConnect:
                    [SaiSoundWaveView hideAllView];
                    break;
                default:
                    break;
            }
        });
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}
#pragma mark -  Button Callbacks
-(void)locationAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self backAction];
        TYLog(@"%@",@"locationAction");

               UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[self stringChangeToClass:@"SaiLocationViewController"]];
                               nav.modalPresentationStyle = UIModalPresentationFullScreen;
                             [self.navigationController presentViewController:nav animated:NO completion:nil];
    });

}
/**
 * @brief 将字符串转化为控制器.
 *
 * @param str 需要转化的字符串.
 *
 * @return 控制器(需判断是否为空).
 */
- (SaiBaseRootController*)stringChangeToClass:(NSString *)str {
    id vc = [[NSClassFromString(str) alloc]init];
    if ([vc isKindOfClass:[SaiBaseRootController class]]) {
        return (SaiBaseRootController *)vc;
    }
    return nil;
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
#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
}


-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    
    //    [self jumpAnimation];
    [super presentViewController: viewControllerToPresent animated:flag completion:completion];
}

//设置界面切换动画
/*!
 typedef enum : NSUInteger {
 Fade = 1,                   //淡入淡出
 Push,                       //推挤
 Reveal,                     //揭开
 MoveIn,                     //覆盖
 Cube,                       //立方体
 SuckEffect,                 //吮吸
 OglFlip,                    //翻转
 RippleEffect,               //波纹
 PageCurl,                   //翻页
 PageUnCurl,                 //反翻页
 CameraIrisHollowOpen,       //开镜头
 CameraIrisHollowClose,      //关镜头
 CurlDown,                   //下翻页
 CurlUp,                     //上翻页
 FlipFromLeft,               //左翻转
 FlipFromRight,              //右翻转
 
 } AnimationType;
 */
//跳转动画
-(void)jumpAnimation{
    CATransition* animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.view.window.layer addAnimation:animation forKey:nil];
    
}
-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    if ([[self.navigationController viewControllers] count] > 1) {
        [self backAnimation];
        
    }
    [super dismissViewControllerAnimated:flag completion:completion];
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

-(NSMutableArray *)datasourceArray{
    if (!_datasourceArray) {
        _datasourceArray=[NSMutableArray array];
    }
    return _datasourceArray;
}
@end
