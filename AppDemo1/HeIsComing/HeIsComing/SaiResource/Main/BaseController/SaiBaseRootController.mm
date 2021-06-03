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
#import "GKCategory.h"
#import "AppDelegate.h"
#import "SaiHomePageBallModel.h"
#import "SaiJXHomePageViewController.h"
#import "SaiMusicListController.h"
#import "SaiASMRModel.h"
#import <objc/runtime.h>
#import "GKWYPlayerViewController.h"
#import "SaiRunAlertView.h"
@interface SaiBaseRootController ()
@property(nonatomic,strong)SaiHomePageBallModel *ballModel;
@property (nonatomic ,assign) BOOL isSelfVC;
@property (nonatomic ,copy) NSString *alert_token;
//@property (nonatomic ,strong) ZXCCyclesQueueItem *headsetItem;
//@property (nonatomic ,strong) ZXCCyclesQueueItem *translateItem;
@end  

@implementation SaiBaseRootController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏透明
    //    [self.navigationController.navigationBar setTranslucent:true];
    //    //把背景设为空
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //处理导航栏有条线的问题
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
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
            //            [SaiSoundWaveView showMessage:@""];
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
    //    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerExpress:^(NSString *type, NSString *content) {
    //        TYLog(@"type : %@ ,content : %@",type,content);
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            if (weakSelf.GetDataBlock) {
    //                weakSelf.GetDataBlock(type, content);
    //            }
    //            NSDictionary *dic = [SaiJsonConversionModel dictionaryWithJsonString:content];
    //            NSString *action = dic[@"action"];
    //            if ([action isEqualToString:@"goHome"]) {
    //                [weakSelf dismissViewControllerAnimated:NO completion:nil];
    //            }
    //
    //            if ([type isEqualToString:@"ASRText"]) {
    //                NSDictionary *contentDictionary=[SaiJsonConversionModel dictionaryWithJsonString:content];
    //                bool finished=[[NSString stringWithFormat:@"%@",contentDictionary[@"finished"]] boolValue];
    //                if (![QKUITools isBlankString:contentDictionary[@"text"]]) {
    //                    [SaiSoundWaveView showMessage:contentDictionary[@"text"]];
    //                    TYLog(@"显示的数据是 ----- %@",contentDictionary[@"text"]);
    //                }
    //                if (finished) {
    //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                        //                        [SaiSoundWaveView showMessage:@""];
    //                        [SaiSoundWaveView dismissHud];
    //                    });
    //                }
    //            }
    //        });
    //    }];
    
    
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
    
//    [SaiNotificationCenter addObserver:self selector:@selector(headsetModeSuccess:) name:SaiSetHeadsetModeSuccess object:nil];
//    [SaiNotificationCenter addObserver:self selector:@selector(translateModeSuccess:) name:SaiSetTranslateModeSuccess object:nil];


}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    blockWeakSelf;
    [[SaiAzeroManager sharedAzeroManager] setLocationblock:^(NSString *text) {
        
        NSDictionary *dic = [SaiJsonConversionModel dictionaryWithJsonString:text];
        
        if ([dic containsObjectForKey:@"points"]&&![SaiAzeroManager sharedAzeroManager].isNavigation) {

            [self locationAction];

        }
       }];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerExpress:^(NSString *type, NSString *content) {
        TYLog(@"&&&&&&type : %@ ,content : %@",type,content);
        TYLog(@"hello - saiAzeroManagerExpress ： handleExpressDirectiveFor 内容：%@  %@",type,content);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dic = [SaiJsonConversionModel dictionaryWithJsonString:content];
            NSString *action = dic[@"action"];
            
            if ([action isEqualToString:@"pause"]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kIsPause"];
                
                
            }else if ([action isEqualToString:@"finish"]){
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kIsPause"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kIsStart"];
                [[ZXCTimer shareInstance]removeCycleTask:SaiContext.timerQueueItem];
                [[ZXCTimer shareInstance]removeCycleTask:SaiContext.queueItem];
                NSDictionary *runFeedback=dic[@"runFeedback"];
                
                if (SaiContext.timerQueueItem) {
                    
                    
                    UIView *bgV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    bgV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                    bgV.backgroundColor = UIColor.redColor;
                    
                    [[[UIApplication sharedApplication].delegate window] addSubview:bgV];
                    //                      UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
                    //                          [bgV removeFromSuperview];
                    //                      }];
                    //                      [bgV addGestureRecognizer:tap];
                    if ([QKUITools isBlankDictionary:runFeedback]) {
                        return ;
                    }
                    
                    SaiRunAlertView *shareView = [[SaiRunAlertView alloc] initAlertView: [NSString stringWithFormat:@"%@",runFeedback[@"distance"]]  time: [NSString stringWithFormat:@"%d",SaiContext.currentTime]  calories:[NSString stringWithFormat:@"%@",runFeedback[@"calorie"]]];
                    [shareView setBackblock:^{
                        [bgV removeFromSuperview];
                    }];
                    [bgV addSubview:shareView];
                    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(bgV);
                    }];
                }
                SaiContext.currentTime=0;
                
                SaiContext.timerQueueItem=nil;
                SaiContext.queueItem=nil;
            }
            else if ([action isEqualToString:@"resume"]||[action isEqualToString:@"begin"]){
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kIsPause"];
            }
            else if ([action isEqualToString:@"QUERY_STEP_COUNT"]){
                
                SaiContext.walkDiction=dic;
                
            }
            if (weakSelf.GetDataBlock) {
                weakSelf.GetDataBlock(type, content);
            }
            
            if ([action isEqualToString:@"goHome"]) {
                kWYPlayerVC.isNotSendBack=YES;
                [self backAction];
                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"]) {
                    [[SaiHomePageViewController sharedInstance] removeView];
                }
                [KSaiJXHomePageViewController switchIndex:1];
                [[SaiHomePageViewController sharedInstance]assignmentAzeroManagerBlockHandle];
                
            }
            if ([action isEqualToString:@"Exit"]) {
                switch ([SaiAzeroManager sharedAzeroManager].loctionModeType) {
                    case ModeTranslate:
                        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSwitchMode:ModeHeadset andValue:YES];
                        break;
                    default:
                        break;
                }
                [self backAction];
                [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"拉取场景tj数据"];
                
                [[SaiHomePageViewController sharedInstance]assignmentAzeroManagerBlockHandle];
                
                [[SaiAzeroManager sharedAzeroManager] saiAzeroButtonPressed:ButtonTypePAUSE];
                [KSaiJXHomePageViewController switchIndex:1];
                
                
            }
            if ([type isEqualToString:@"ASRText"]) {
                [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerRemoveAlert:[SaiAzeroManager sharedAzeroManager].alert_token];
                NSDictionary *contentDictionary=[SaiJsonConversionModel dictionaryWithJsonString:content];
                
                bool finished=[[NSString stringWithFormat:@"%@",contentDictionary[@"finished"]] boolValue];
                if (![QKUITools isBlankString:contentDictionary[@"text"]]) {
                    [SaiSoundWaveView showMessage:contentDictionary[@"text"]];
                }
                if (finished) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SaiSoundWaveView showMessage:@""];
                    });
                }
            }
            if ([type isEqualToString:@"LocaleMode"]) {
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiERROR tag:nil messmage:[NSString stringWithFormat:@"saiAzeroManagerSwitchMode:ModeHeadset ***************************** %@",dic]];
                NSString *mode = dic[@"mode"];
                NSString *value = dic[@"value"];
                if ([mode isEqualToString:@"headset"]) {
                    if ([value isEqualToString:@"ON"]) {
                        [SaiAzeroManager sharedAzeroManager].loctionModeType = ModeHeadset;
//                        [SaiNotificationCenter postNotificationName:SaiSetHeadsetModeSuccess object:nil];
                    }
                }else if ([mode isEqualToString:@"translate"]){
                    if ([value isEqualToString:@"ON"]) {
                        [SaiAzeroManager sharedAzeroManager].loctionModeType = ModeTranslate;
//                        [SaiNotificationCenter postNotificationName:SaiSetTranslateModeSuccess object:nil];
                    }
                }
            }
        });
    }];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroSongListInfo:^(NSString *songListStr) {
        TYLog(@"hello - saiAzeroSongListInfo ： renderPlayerInfo 内容：%@",songListStr);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *diction=[SaiJsonConversionModel dictionaryWithJsonString:songListStr];
            NSArray *array = diction[@"controls"];
            NSDictionary *dic = array[0];
            NSString *type = dic[@"type"];
            if ([type isEqualToString:@"TOGGLE"]) {
                NSString *name = dic[@"name"];
                if ([name isEqualToString:@"SINGLE_LOOP"]) {
                    [SaiAzeroManager sharedAzeroManager].songMode = SongCycleModeSingle;
                }else if ([name isEqualToString:@"SHUFFLE"]){
                    [SaiAzeroManager sharedAzeroManager].songMode = SongCycleModeRandom;
                }else if ([name isEqualToString:@"LOOP"]){
                    [SaiAzeroManager sharedAzeroManager].songMode = SongCycleModeOrder;
                }
            }
            
            
            
            TemplateTypeENUM templateTypet=[QKUITools returnTemplateFromRenderTemplateStr:diction[@"type"]];
            switch (templateTypet) {
                case RenderPlayerInfo:
                case EnglishTemplate:{
                    NSString *audioItemId = diction[@"audioItemId"];
                    NSString *defaultaudioItemId =         [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAudioItemId"];
                    
                    
                    if ([defaultaudioItemId isEqualToString:audioItemId]||([QKUITools isBlankArray:diction[@"contents"]]&&![diction containsObjectForKey:@"content"])) {
                        return ;
                    }else{
                        [[NSUserDefaults standardUserDefaults]setValue:audioItemId forKey:@"defaultAudioItemId"];
                        
                    }
                }
                    break;
                case ASMRRenderPlayerInfo:{
                    NSString *audioItemId = diction[@"audioItemId"];
                    NSString *defaultaudioItemId =         [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAudioItemId"];
                    if ([defaultaudioItemId isEqualToString:audioItemId]||([QKUITools isBlankArray:diction[@"contents"]]&&![diction containsObjectForKey:@"content"])) {
                        return ;
                    }else{
                        [[NSUserDefaults standardUserDefaults]setValue:audioItemId forKey:@"defaultAudioItemId"];
                        
                    }
                }
                    break;
                default:{
                    
                }
                    break;
            };
            TYLog(@"获取的球体的信息是 %@",songListStr);
            [SaiAzeroManager sharedAzeroManager].songListStr=songListStr;
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"]&&![[NSString stringWithFormat:@"%@",diction[@"type"] ]isEqualToString:@"SphereTemplate"]&&![[NSString stringWithFormat:@"%@",diction[@"type"] ]isEqualToString:@"LauncherTemplate1"]) {
                [[SaiHomePageViewController sharedInstance].titleLabel setText:@"可以对我说“返回首页”"];
            }
            if (weakSelf.responseRenderTemplateStr) {
                weakSelf.responseRenderTemplateStr(songListStr);
            }
        });
    }];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerRenderTemplate:^(NSString *renderTemplateStr) {
        TYLog(@"hello - saiAzeroManagerRenderTemplate ： renderTemplate 内容： %@",renderTemplateStr);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *diction=[SaiJsonConversionModel dictionaryWithJsonString:renderTemplateStr];
            if ([diction[@"type"] isEqualToString:@"HelloWeatherTemplate"]) {
                [SaiAzeroManager sharedAzeroManager].helloWeatherTemplate=renderTemplateStr;
                [SaiNotificationCenter postNotificationName:@"HelloWeatherTemplate" object:nil userInfo:@{@"HelloWeatherTemplate":renderTemplateStr}];
                return ;
            }else if ([diction[@"type"] isEqualToString:@"SkillListTipsTemplate"]) {
                [SaiNotificationCenter postNotificationName:@"HelloWeatherTemplate" object:nil userInfo:@{@"HelloWeatherTemplate":renderTemplateStr}];
                return ;
                
            }else if([diction[@"type"] isEqualToString:@"ToastTemplate"]){
                [MessageAlertView showHudMessage:diction[@"toast"]];
                return;
            }else if ([diction[@"type"] isEqualToString:@"TranslateTemplate"]){
                if ([diction[@"value"] isEqualToString:@"start"]) {
//                    __block int i = 0;
//                    ZXCCyclesQueueItem *item = [[ZXCTimer shareInstance] addCycleTask:^{
                        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSwitchMode:ModeTranslate andValue:YES];
//                        i++;
//                    } timeInterval:1 runCount:5 threadMode:ZXCBackgroundThread];
//                    weakSelf.translateItem = item;
                }else if ([diction[@"value"] isEqualToString:@"end"]){
//                    __block int i = 0;
//                    ZXCCyclesQueueItem *item = [[ZXCTimer shareInstance] addCycleTask:^{
                        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSwitchMode:ModeHeadset andValue:YES];
//                        i++;
//                    } timeInterval:1 runCount:5 threadMode:ZXCBackgroundThread];
//                    weakSelf.headsetItem = item;
                }
                return;

            }
            
            
            TemplateTypeENUM templateTypet=[QKUITools returnTemplateFromRenderTemplateStr:diction[@"type"]];
            switch (templateTypet) {
                case RenderPlayerInfo:
                case EnglishTemplate:
                {
                    NSString *audioItemId = diction[@"audioItemId"];
                    NSString *defaultaudioItemId =         [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAudioItemId"];
                    if ([defaultaudioItemId isEqualToString:audioItemId]||([QKUITools isBlankArray:diction[@"contents"]]&&![diction containsObjectForKey:@"content"])) {
                        return ;
                    }else{
                        [[NSUserDefaults standardUserDefaults]setValue:audioItemId forKey:@"defaultAudioItemId"];
                        
                    }
                }
                    break;
                case ASMRRenderPlayerInfo:{
                    NSString *audioItemId = diction[@"audioItemId"];
                    NSString *defaultaudioItemId =         [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAudioItemId"];
                    if ([defaultaudioItemId isEqualToString:audioItemId]||([QKUITools isBlankArray:diction[@"contents"]]&&![diction containsObjectForKey:@"content"])) {
                        return ;
                    }else{
                        [[NSUserDefaults standardUserDefaults]setValue:audioItemId forKey:@"defaultAudioItemId"];
                        
                    }
                }
                    break;
                case AlertRingtoneTemplate:{
                    [SaiAzeroManager sharedAzeroManager].alert_token = diction[@"alert_token"];
                }
                    break;
                default:{
                    
                }
                    break;
            };
            TYLog(@"获取的球体的信息是 %@",renderTemplateStr);
            
            [SaiAzeroManager sharedAzeroManager].renderTemplateStr=renderTemplateStr;
            [SaiAzeroManager sharedAzeroManager].songListStr=renderTemplateStr;
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"]&&![[NSString stringWithFormat:@"%@",diction[@"type"] ]isEqualToString:@"SphereTemplate"]&&![[NSString stringWithFormat:@"%@",diction[@"type"] ]isEqualToString:@"LauncherTemplate1"]) {
                [[SaiHomePageViewController sharedInstance].titleLabel setText:@"可以对我说“返回首页”"];
            }
            if (weakSelf.responseRenderTemplateStr) {
                weakSelf.responseRenderTemplateStr(renderTemplateStr);
            }
        });
    }];
}
//- (void)headsetModeSuccess:(NSNotification *)noti{
//    [[ZXCTimer shareInstance] removeCycleTask:self.headsetItem];
//}
//- (void)translateModeSuccess:(NSNotification *)noti{
//    [[ZXCTimer shareInstance] removeCycleTask:self.translateItem];
//}

#pragma mark -  Button Callbacks
-(void)locationAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self backAction];
        TYLog(@"%@",@"locationAction");
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[self stringChangeToClass:@"SaiLocationViewController"]];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:nav animated:NO completion:nil];
    });
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self backAction];
//
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[self stringChangeToClass:@"SaiLocationViewController"]];
//                        nav.modalPresentationStyle = UIModalPresentationFullScreen;
//                      [self presentViewController:nav animated:NO completion:nil];
//        
//    });
}
- (void)jumpVC:(BOOL)isJump renderTemplateStr:(NSString *)renderTemplateStr{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[NSUserDefaults standardUserDefaults] boolForKey:SaikIsLogin]||!isJump|| [SaiAzeroManager sharedAzeroManager].isNavigation) {
            return ;
        }
        self.ballModel=[SaiHomePageBallModel modelWithJson:renderTemplateStr];
        NSDictionary *classDiction=@{@"WeatherTemplate":@"SaiWeatherViewController",
                                     @"WalkingTemplate":@"SaiWalkingViewController",
                                     @"RunningTemplate":@"SaiMotionViewController",
                                     @"QuestionGameTemplate":@"SaiQuestionViewController",
                                     @"DefaultTemplate1":@"SaiWikipediaViewController",
                                     @"BodyTemplate1":@"SaiWikipediaViewController",
                                     @"RenderPlayerInfo":@"SaiMusicListController",
                                     @"NewsTemplate":@"SaiMusicListController",
                                     @"EnglishTemplate":@"SaiMusicListController",
                                     @"ASMRListTemplate":@"SaiMusicListController",
                                     @"ASMRRenderPlayerInfo":@"SaiMusicListController"
        };
        if ([self.ballModel.type isEqualToString:@"LauncherTemplate1"]) {
            
            [[SaiMusicListController sharedInstance] dealPlistDataWith:[SaiAzeroManager sharedAzeroManager].songListStr];
            return;
        }
        if ([self.ballModel.type isEqualToString:@"SphereTemplate"]) {
            
            [[SaiHomePageViewController sharedInstance]initResponse:renderTemplateStr];
            return;
        }
        NSString *classString=classDiction[self.ballModel.type];
        
        SaiBaseRootController* vc = [self stringChangeToClass:classString];
      
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[self stringChangeToClass:@"SaiLocationViewController"]];
//                 nav.modalPresentationStyle = UIModalPresentationFullScreen;
//               [self presentViewController:nav animated:NO completion:nil];
//               
//        
//    return;
        //跳转对应的控制器
        if ([self.ballModel.type isEqualToString:@"QuestionGameTemplate"]){
            
            if ([self.ballModel.scene isEqualToString:@"join"]) {
                if ([self.ballModel.isFirst boolValue]) {
                    if ([[[self visibleViewControllerIfExist]className] isEqualToString:[vc className]]) {
                        return ;
                    }
                    [self backAction];
                    
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[self stringChangeToClass:@"SaiGameRulesViewController"] animated:NO completion:^{
                        
                    }];
                }else{
                    if (![self.ballModel.isFirst boolValue]) {
                        if ([[[self visibleViewControllerIfExist]className] isEqualToString:[vc className]]) {
                            return ;
                        }
                        [self dismissViewControllerAnimated:NO completion:^{
                            
                        }];
                        
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[self stringChangeToClass:@"SaiSignUpSuccessViewController"]];
                        nav.modalPresentationStyle = UIModalPresentationFullScreen;
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:NO completion:nil];
                        
                        
                        
                    }
                    
                }
                
            }else if([self.ballModel.scene isEqualToString:@"exitgame"]){
                [[self visibleViewControllerIfExist] dismissViewControllerAnimated:NO completion:nil];
                
                
            }else if([self.ballModel.scene isEqualToString:@"sendQuestion"]){
                if ([[[self visibleViewControllerIfExist]className] isEqualToString:[vc className]]) {
                    return ;
                }
                [self dismissViewControllerAnimated:NO completion:nil];
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:NO completion:nil];
            }
            
        }else if([classString isEqualToString:@"SaiWikipediaViewController"]) {
            if ([renderTemplateStr containsString:@"baike"]||[renderTemplateStr containsString:@"cookbook"]||[renderTemplateStr containsString:@"astrology"]||[renderTemplateStr containsString:@"poem"]) {
                if ([[[self visibleViewControllerIfExist]className] isEqualToString:[vc className]]) {
                    return ;
                }
                
                if (self.ballModel.content == nil&&[self.ballModel.type isEqualToString:@"RenderPlayerInfo"]) {
                    return;
                }
                [self dismissViewControllerAnimated:NO completion:nil];
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:NO completion:nil];
            }
        }else if([classString isEqualToString:@"SaiMusicListController"]) {
            SaiASMRModel * saiASMRModel=[SaiASMRModel modelWithJson:renderTemplateStr];
            if (![saiASMRModel.visible boolValue]&&([saiASMRModel.type isEqualToString:@"ASMRListTemplate"])) {
                
                [[SaiMusicListController sharedInstance] dealPlistDataWith:[SaiAzeroManager sharedAzeroManager].songListStr];
                
                return;
            }
            [self backAction];
            
            [[SaiMusicListController sharedInstance] dealPlistDataWith:[SaiAzeroManager sharedAzeroManager].songListStr];
            
            [KSaiJXHomePageViewController switchIndex:2];
            
            //            2020-08-07 11:52:02.984134+0800 TA来了[9417:7645379] [SaiBaseRootController.mm  -[SaiBaseRootController viewWillAppear:]_block_invoke_2 in line 246--] 获取的球体的信息是 {"audioItemId":"45a70d97-135b-4555-99c9-be99c1ac68dc","controls":[{"name":"PLAY_PAUSE","type":"BUTTON","enabled":true,"selected":false}],"type":"RenderPlayerInfo"}
            
            
            
        }else if(vc) {
            if ([[[self visibleViewControllerIfExist]className] isEqualToString:[vc className]]) {
                return ;
            }
            
            if (self.ballModel.content == nil&&[self.ballModel.type isEqualToString:@"RenderPlayerInfo"]) {
                return;
            }
            
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:NO completion:nil];
            }
            
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:NO completion:nil];
        }
        
        
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
//- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
//    [super traitCollectionDidChange:previousTraitCollection];
//    // trait发生了改变
//    if (@available(iOS 13.0, *)) {
//        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
//            TYLog(@"%@",previousTraitCollection);
//            switch (previousTraitCollection.userInterfaceStyle) {
//                case UIUserInterfaceStyleDark:
//                    //正常模式
//                    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//                    break;
//                default:
//                    //深色模式
//                    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//                    [SaiNotificationCenter postNotificationName:SaiDidDarkModelNoti object:nil];
//                    break;
//            }
//        }
//    }
//}

@end
