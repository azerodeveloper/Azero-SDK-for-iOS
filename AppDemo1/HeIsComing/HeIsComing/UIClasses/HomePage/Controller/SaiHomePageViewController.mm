//
//  SaiHomePageViewController.m
//  HeIsComing
//
//  Created by mike on 2020/3/25.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiHomePageViewController.h"
#import "DSphereView.h"
#import "DHomeView.h"
#import "SaiAlertView.h"
#import "SaiMotionViewController.h"
#import "SaiWeatherViewController.h"
#import "SaiHomePageBallModel.h"
#import <AVFoundation/AVFoundation.h>
#import <Contacts/Contacts.h>
#import "SaiSoundWaveView.h"
#import "SaiMusicListController.h"
#import "GKWYPlayerViewController.h"
#import "NetWorkUtil.h"
#import "AppDelegate.h"
#import "SaiMpToPcmManager.h"
#import <UMPush/UMessage.h>
#import "SaiCustomaltview.h"
#import "HealthKitManager.h"
#import "CBAutoScrollLabel.h"

#define  imageWidth 25
#define  viewWidth 135

@interface SaiHomePageViewController ()<CustomaltviewDelegate>
@property (nonatomic, strong) NSMutableArray   *homeViewArray;
@property (nonatomic, strong) DSphereView      *sphereView;
@property (nonatomic, strong) SaiHomePageBallModel *ballModel ;
@property (nonatomic ,assign) BOOL isTimerRunning;
@property (nonatomic, strong) dispatch_queue_t timeQueue;
@property (nonatomic, strong) dispatch_queue_t recordQueue;
@property (nonatomic ,strong) NSMutableData *allData;
@property (nonatomic ,assign) BOOL isSelfVC;
@property (nonatomic,assign) BOOL isInterrupt;
@property (nonatomic,assign) BOOL IsSphereTemplate;
@property (nonatomic ,strong) ZXCCyclesQueueItem *item;
@property (nonatomic,strong) SaiCustomaltview *altview;
@property(nonatomic,strong)UIView  *headsetView;
@property(nonatomic,assign)BOOL  isShow;

@end

@implementation SaiHomePageViewController
#pragma mark -  Life Cycle
+ (instancetype)sharedInstance {
    static SaiHomePageViewController *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[SaiHomePageViewController alloc]init];
    });
    return player;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self assignmentAzeroManagerBlockHandle];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SaiSoundWaveView showBlue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAddressBook];
   
    
    [self setNavigation];
    [self refreshToken];
    [[NetWorkUtil sharedInstance]listening];
    [UMessage addAlias:SaiContext.currentUser.mobile type:@"UMENGTEST" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
    }];
    
    UIImageView *backgroundImageView=[UIImageView new];
    [self.view addSubview:backgroundImageView];
    backgroundImageView.image=[UIImage imageNamed:@"launcherBg"];
    backgroundImageView.contentMode=UIViewContentModeScaleAspectFill;
    
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.view.clipsToBounds=YES;
    
    self.sphereView = [[DSphereView alloc] initWithFrame:CGRectMake(kSCRATIO(30), 80, KScreenW-kSCRATIO(60), KScreenH-300-BOTTOM_HEIGHT-kStatusBarHeight)];
    [self.view addSubview:self.sphereView];
    [self.sphereView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kSCRATIO(120)+kStatusBarHeight);
        make.bottom.mas_offset(-200-BOTTOM_HEIGHT);
        make.left.mas_offset(kSCRATIO(30));
        make.right.mas_offset(kSCRATIO(-30));
    }];
    [self.view addSubview:self.headsetView];
    [self.headsetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kStatusBarHeight+kSCRATIO(70));
        make.left.mas_offset(KScreenW-kSCRATIO(imageWidth));
        make.height.mas_offset(kSCRATIO(imageWidth));
        make.width.mas_offset(kSCRATIO(viewWidth));
    }];
    [self.headsetView layoutIfNeeded];
    self.headsetView .hidden=[QKUITools isHeadsetPluggedIn];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headsetView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft  cornerRadii:CGSizeMake(kSCRATIO(viewWidth/2), kSCRATIO(viewWidth/2))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.headsetView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.headsetView.layer.mask = maskLayer;
    ;
    [self registerNoti];
    
    [self setupAzeroSdkHandle];
    
    [[SaiMpToPcmManager sharedSaiMpToPcmManager] setup];
    //设置为耳机模式，防止出现乱七八糟的回复
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"]) {
        UIView *bgV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        [window addSubview:bgV];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [bgV removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirst"];
        }];
        [bgV addGestureRecognizer:tap];
        self.bgV=bgV;
        UILabel *titleLabel=[UILabel CreatLabeltext:@"试着对我说“播放音乐“" Font:[UIFont systemFontOfSize:kSCRATIO(18)] Textcolor:kColorFromRGBHex(0x2BE1DF) textAlignment:NSTextAlignmentCenter];
        [bgV addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgV);
            make.bottom.mas_offset(-BOTTOM_HEIGHT-kSCRATIO(40));
        }];
        self.titleLabel=titleLabel;
    }
    [self requestContactAuthorAfterSystemVersion9];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"HealthKitManager"]) {
        
        [[HealthKitManager sharedInstance] authorizeHealthKit:^(BOOL success, NSError *error) {
            if (success) {
                [[ZXCTimer shareInstance] addCycleTask:^{
                    [[HealthKitManager sharedInstance] getDistanceCount:^(NSString *distancepValue, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            SaiContext.currentDistance=distancepValue;
                            [self stepValueUpdata:distancepValue];
                            
                        });
                    }];
                    ;
                } timeInterval:60 runCount:-1 threadMode:ZXCBackgroundThread];
                ;
            }
        }];
    }
    int volume =(int )[AVAudioSession sharedInstance].outputVolume;
//    int volume = [[SaiAzeroManager sharedAzeroManager] systemCurrentVolume];
       [[SaiAzeroManager sharedAzeroManager] reportSystemCurrentVolume:volume];
       
       [SaiAzeroManager sharedAzeroManager].volumeNum=volume;
       
}
-(void)stepValueUpdata:(NSString *)distancepValue{
    [[HealthKitManager sharedInstance] getStepCount:^(NSString *stepValue, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([QKUITools isBlankString:stepValue]) {
                return ;
            }
            
            [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerUploadWalkSensorDataWithCalorie:[NSNumber numberWithDouble:[distancepValue doubleValue]*80*1.036] andDistance:[NSNumber numberWithString:distancepValue] andStepCount:[NSNumber numberWithString:stepValue]];
        });
    }];
}
-(void)removeView{
    [self.bgV removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirst"];
    
}
-(void)refreshToken{
    if ([QKUITools isBlankString:SaiContext.currentUser.token]) {
        return;
    }
    [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/extendToken" andParam:@{@"token":SaiContext.currentUser.token} andSuccessBlock:^(NSURL *URL, id data) {
        
    } andFailBlock:^(NSURL *URL, NSError *error) {
        
    }];
    
}

#pragma mark -  UITableViewDelegate
#pragma mark -  CustomDelegate
#pragma mark -  Event Response

#pragma mark -  Notification Methods
- (void)saiApplicationWillEnterForeground{
    if (self.isInterrupt) {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        self.isInterrupt = NO;

    }
}
- (void)saiLogoutSuccess:(NSNotification *)noti{
    [SaiNotificationCenter removeObserver:self name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
}
- (void)saiLoginSuccess:(NSNotification *)noti{
    [SaiNotificationCenter addObserver:self selector:@selector(audioSessionRouteChange:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
}
- (void)recordCallback:(NSNotification *)noti{
//    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:nil messmage:@"827record XBEchoCancellation **************** recordCallback: 214"];
    NSDictionary *dict = noti.userInfo;
    NSData *data = dict[@"data"];
    dispatch_async((self.recordQueue), ^{
        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerWriteData:data];
    });

    dispatch_async(dispatch_get_main_queue(), ^{
        float aa0=[[NSString stringWithFormat:@"%@",dict[@"volLDB"]] floatValue];
        [SaiSoundWaveView shareHud].level=aa0;
    });
}

- (void)ttsPlayComplete:(NSNotification *)noti{
    dispatch_async(self.timeQueue, ^{
        [[AudioQueuePlay sharedAudioQueuePlay] resetPlay];
        [[AudioQueuePlay sharedAudioQueuePlay] audioQueueFlush];
        [[AudioQueuePlay sharedAudioQueuePlay] resetQueue];
        [SaiMpToPcmManager sharedSaiMpToPcmManager].isTimer = NO;
        [[SaiMpToPcmManager sharedSaiMpToPcmManager] memsetBuffer];
        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReportTtsPlayStateFinished];
    });
}
- (void)audioSessionInterruption:(NSNotification *)notify {
    NSDictionary *interuptionDict = notify.userInfo;
    NSInteger interruptionType = [interuptionDict[AVAudioSessionInterruptionTypeKey] integerValue];
    NSInteger interruptionOption = [interuptionDict[AVAudioSessionInterruptionOptionKey] integerValue];
    
    if (interruptionType == AVAudioSessionInterruptionTypeBegan) {
        // 收到播放中断的通知，暂停播放
        if (!self.isInterrupt) {
//            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:nil messmage:@"827record SaiHomePageViewController **************** [[XBEchoCancellation shared] stop] 前"];
            [[XBEchoCancellation shared] stop];
//            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:nil messmage:@"827record SaiHomePageViewController **************** [[XBEchoCancellation shared] stop] 后"];
            [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReportTtsPlayStateFinished];
            [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReportMp3PlayStateFinished];
            
            switch (kPlayer.playerState) {
                case GKAudioPlayerStatePlaying:
                    [kPlayer pause];
                    [[SaiAzeroManager sharedAzeroManager] saiAzeroButtonPressed:ButtonTypePAUSE];
                    break;
                default:
                    break;
            }
            
            
            [AudioQueuePlay sharedAudioQueuePlay].isInterrupted=YES;
            [AudioQueuePlay sharedAudioQueuePlay].stop=YES;
            [[AudioQueuePlay sharedAudioQueuePlay] immediatelyStopPlay];
            [[AudioQueuePlay sharedAudioQueuePlay] audioQueueFlush];
            [[AudioQueuePlay sharedAudioQueuePlay] resetQueue];
            [[AudioQueuePlay sharedAudioQueuePlay] resetPlay];
            [[SaiMpToPcmManager sharedSaiMpToPcmManager] stopTimer];
            [SaiMpToPcmManager sharedSaiMpToPcmManager].isTimer = NO;
            [[SaiMpToPcmManager sharedSaiMpToPcmManager] memsetBuffer];
            
            AppDelegate *appdelegate=  (AppDelegate *)[UIApplication sharedApplication].delegate;
            [[UIApplication sharedApplication]endBackgroundTask:appdelegate.taskIdentifiery];
            self.isInterrupt=YES;
            [[AVAudioSession sharedInstance] setActive:NO error:nil];
            
            
        }
        
    }else if (interruptionType == AVAudioSessionInterruptionTypeEnded){
        if (self.isInterrupt) {
            self.isInterrupt = NO;
            if (interruptionOption == AVAudioSessionInterruptionOptionShouldResume) {
                [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
//                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:nil messmage:@"827record SaiHomePageViewController **************** [[XBEchoCancellation shared] startInput] 前"];
                [[XBEchoCancellation shared] startInput];
//                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:nil messmage:@"827record SaiHomePageViewController **************** [[XBEchoCancellation shared] startInput] 后"];

            }}
    }
}
- (void)audioSessionRouteChange:(NSNotification *)notify {

    NSDictionary *interuptionDict = notify.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
        {
            TYLog(@"耳机插入");
            [[SaiAzeroManager sharedAzeroManager] detectAndSetSerFile];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.headsetView setHidden:YES];
                
            });
        }
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            //            [[XBEchoCancellation shared]stopInput];
            dispatch_async(dispatch_get_main_queue(), ^{
                _isShow=NO;
                [self.headsetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_offset(kStatusBarHeight+kSCRATIO(70));
                    make.left.mas_offset(KScreenW-kSCRATIO(imageWidth));
                    make.height.mas_offset(kSCRATIO(imageWidth));
                    make.width.mas_offset(kSCRATIO(viewWidth));
                }];
                [self.headsetView setHidden:NO];
                
            });
            TYLog(@"耳机拔出");
            //            switch (kPlayer.playerState) {
            //                case GKAudioPlayerStatePlaying:
            //                    //                    [kPlayer pause];
            //                    [[SaiAzeroManager sharedAzeroManager] saiAzeroButtonPressed:ButtonTypePAUSE];
            //                    break;
            //                default:
            //                    break;
            //            }
            
        }
            break;
        case AVAudioSessionRouteChangeReasonOverride:
        {
            //            [[XBEchoCancellation shared]stopInput];
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                [SaiSoundWaveView hideAllView];
            //                [[UIApplication sharedApplication].keyWindow addSubview:self.altview];
            //                [self.altview show];
            //            });
            //            TYLog(@"耳机拔出");
            //            switch (kPlayer.playerState) {
            //                case GKAudioPlayerStatePlaying:
            //                    //                    [kPlayer pause];
            //                    [[SaiAzeroManager sharedAzeroManager] saiAzeroButtonPressed:ButtonTypePAUSE];
            //                    break;
            //
            //                default:
            //                    break;
            //            }
            dispatch_async(dispatch_get_main_queue(), ^{
                _isShow=NO;
                [self.headsetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_offset(kStatusBarHeight+kSCRATIO(70));
                    make.left.mas_offset(KScreenW-kSCRATIO(imageWidth));
                    make.height.mas_offset(kSCRATIO(imageWidth));
                    make.width.mas_offset(kSCRATIO(viewWidth));
                }];
                [self.headsetView setHidden:NO];
                
            });
        }
            break;
        default:
            break;
    }
}
//- (void)headsetModeSuccess:(NSNotification *)noti{
//    [[ZXCTimer shareInstance] removeCycleTask:self.item];
//}

#pragma mark -  Button Callbacks
#pragma mark -  Private Methods
- (void)setupAzeroSdkHandle{
    
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"获取指南球体数据"];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"重置跑步状态"];
    
//    __block int i = 0;
//    ZXCCyclesQueueItem *item = [[ZXCTimer shareInstance] addCycleTask:^{
//        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSwitchMode:ModeGuide andValue:YES];
//        i++;
//    } timeInterval:3 runCount:5 threadMode:ZXCBackgroundThread];
//    self.item = item;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *renderTemplateStr=[[NSUserDefaults standardUserDefaults]valueForKey:@"SphereTemplate"];
        
        if (!_IsSphereTemplate&&![QKUITools isBlankString:renderTemplateStr]) {
            self.ballModel=[SaiHomePageBallModel modelWithJson:renderTemplateStr];
            [self initsphereViews];
            _IsSphereTemplate=YES;
        }
        
    });
}
- (void)assignmentAzeroManagerBlockHandle{
    blockWeakSelf;
    [[SaiAzeroManager sharedAzeroManager] saiAzeroPlayTtsStatePrepare:^{
        dispatch_async(weakSelf.timeQueue, ^{
            [[SaiMpToPcmManager sharedSaiMpToPcmManager] prepareConversionAudio];
        });
    }];
    self.responseRenderTemplateStr = ^(NSString * _Nonnull renderTemplateStr) {
        [weakSelf initResponse:renderTemplateStr];
    };
}
-(void)initResponse:(NSString *)responseRenderTemplateStr{
    self.ballModel=[SaiHomePageBallModel modelWithJson:responseRenderTemplateStr];
    if ([self.ballModel.type isEqualToString:@"SphereTemplate"]){
        if (!self.IsSphereTemplate) {
            [self initsphereViews];
            self.IsSphereTemplate=YES;
        }
        [[NSUserDefaults standardUserDefaults] setValue:responseRenderTemplateStr forKey:@"SphereTemplate"];
    }else{
        [self jumpVC:YES renderTemplateStr:responseRenderTemplateStr];
    }
}

- (void)registerNoti{
    [SaiNotificationCenter addObserver:self selector:@selector(saiLogoutSuccess:) name:SaiLogoutSuccessNoti object:nil];
    [SaiNotificationCenter addObserver:self selector:@selector(saiLoginSuccess:) name:SaiLoginSuccessNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordCallback:) name:SaiRecordCallback object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ttsPlayComplete:) name:SaiTtsPlayComplete object:nil];
        [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];

    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    TYLog(@"%@",[AVAudioSession sharedInstance].outputDataSource);

    [SaiNotificationCenter addObserver:self selector:@selector(audioSessionInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    [SaiNotificationCenter addObserver:self selector:@selector(audioSessionRouteChange:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
//    [SaiNotificationCenter addObserver:self selector:@selector(headsetModeSuccess:) name:SaiSetHeadsetModeSuccess object:nil];
    [SaiNotificationCenter addObserver:self selector:@selector(saiApplicationWillEnterForeground) name:SaiApplicationWillEnterForeground object:nil];
}


- (void)setAddressBook{
    [self requestContactAuthorAfterSystemVersion9];
    
}

#pragma mark -  Life Cycle

-(void)jumpViewController:(NSString *)renderTemplateStr{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[NSUserDefaults standardUserDefaults] boolForKey:SaikIsLogin]) {
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
                                     
                                     @"EnglishTemplate":@"SaiMusicListController"
        };
        NSString *classString=classDiction[self.ballModel.type];
        self.isSelfVC=[[[self gk_visibleViewControllerIfExist]className] isEqualToString:@"SaiHomePageViewController"];
        SaiBaseRootController* vc = [self stringChangeToClass:classString];
        //跳转对应的控制器
        if ([self.ballModel.type isEqualToString:@"QuestionGameTemplate"]){
            if ([self.ballModel.scene isEqualToString:@"join"]) {
                if ([[[self visibleViewControllerIfExist]className] isEqualToString:[vc className]]) {
                    return ;
                }
                [self dismissViewControllerAnimated:NO completion:nil];
                [self presentViewController:[self stringChangeToClass:@"SaiGameRulesViewController"] animated:NO completion:^{
                }];
            }else if([self.ballModel.scene isEqualToString:@"exitgame"]){
                if (!self.isSelfVC) {
                    [[self visibleViewControllerIfExist] dismissViewControllerAnimated:NO completion:nil];
                }
            }else if([self.ballModel.scene isEqualToString:@"sendQuestion"]){
                if ([[[self visibleViewControllerIfExist]className] isEqualToString:[vc className]]) {
                    return ;
                }
                if (!self.isSelfVC) {
                    [self dismissViewControllerAnimated:NO completion:nil];
                }
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:nav animated:NO completion:nil];
            }else {
            }
        }else if([classString isEqualToString:@"SaiWikipediaViewController"]) {
            if ([renderTemplateStr containsString:@"baike"]||[renderTemplateStr containsString:@"cookbook"]||[renderTemplateStr containsString:@"astrology"]||[renderTemplateStr containsString:@"poem"]) {
                if ([[[self visibleViewControllerIfExist]className] isEqualToString:[vc className]]) {
                    return ;
                }
                if (self.ballModel.content == nil&&[self.ballModel.type isEqualToString:@"RenderPlayerInfo"]) {
                    return;
                }
                if (!self.isSelfVC) {
                    [self dismissViewControllerAnimated:NO completion:nil];
                }
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:nav animated:NO completion:nil];
            }
        }else if(vc) {
            if ([[[self visibleViewControllerIfExist]className] isEqualToString:[vc className]]) {
                return ;
            }
            if (self.ballModel.content == nil&&[self.ballModel.type isEqualToString:@"RenderPlayerInfo"]) {
                return;
            }
            if (!self.isSelfVC) {
                [self dismissViewControllerAnimated:NO completion:nil];
            }
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:NO completion:^{
            }];
        }else if ([self.ballModel.type isEqualToString:@"SphereTemplate" ]){
            [self initsphereViews];
        }
        else {
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

#pragma 星球转动
-(void)initsphereViews{
    
    self.ballModel.items=[self.ballModel.items arrayByAddingObjectsFromArray:self.ballModel.items];
    
    for (NSInteger i = 0; i < self.ballModel.items.count; i ++) {
        DHomeView*homeView=[self initializeHomeView:i];
        
        [self.homeViewArray addObject:homeView];
        [self.sphereView addSubview:homeView];
        [homeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.sphereView);
            make.width.mas_offset( kSCRATIO(80));
            make.height.mas_offset(kSCRATIO(32));
        }];
    }
    [self.sphereView setCloudTags:self.homeViewArray];
    
}
-(DHomeView*)initializeHomeView:(NSInteger)row{
    DHomeView*homeView=[[DHomeView alloc]initWithFrame:CGRectMake(40, 0, kSCRATIO(60), kSCRATIO(32))];
    SaiHomePageBallModelItems * model=self.ballModel.items[row];
    [homeView setData:model];
    homeView.tag=row;
    [homeView setTapBlock:^(DHomeView * _Nonnull homeView) {
        UIView *bgV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [[[UIApplication sharedApplication].delegate window] addSubview:bgV];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [bgV removeFromSuperview];
        }];
        [bgV addGestureRecognizer:tap];
        SaiAlertView *shareView = [[SaiAlertView alloc] initWithFrame:CGRectMake(74, 125, 228, 320) WithDHomeModel:homeView.model];
        
        [bgV addSubview:shareView];
        shareView.center=bgV.center;
    }];
    return homeView;
}

#pragma mark -  Public Methods
#pragma mark -  Setters and Getters
- (NSMutableArray *)homeViewArray {
    if (_homeViewArray == nil) {
        _homeViewArray = [NSMutableArray array];
    }
    return _homeViewArray;
}
//懒加载创建子线程   
- (dispatch_queue_t)timeQueue
{
    if (!_timeQueue) {
        _timeQueue = dispatch_queue_create("com.timer.soundai", DISPATCH_QUEUE_CONCURRENT);
    }
    return _timeQueue;
}
- (dispatch_queue_t)recordQueue{
    if (!_recordQueue) {
        _recordQueue = dispatch_queue_create("com.record.soundai", DISPATCH_QUEUE_CONCURRENT);
    }
    return _recordQueue;
}
- (SaiCustomaltview *)altview{
    if (_altview == nil) {
        _altview = [[SaiCustomaltview alloc] init];
        _altview.frame = CGRectMake(0, 0, KScreenW, KScreenH);
        _altview.altwidth=250.0f;
        [_altview creatAltWithAltTile:@"提示" content:@"请连接耳机或车载蓝牙"];
        _altview.delegate = self;
    }
    return _altview;
}
//请求通讯录权限
#pragma mark 请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion9{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        blockWeakSelf;
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                TYLog(@"授权失败");
            }else {
                TYLog(@"成功授权");
                [weakSelf openContact];
            }
        }];
    }
    else if(status == CNAuthorizationStatusRestricted)
    {
        TYLog(@"用户拒绝");
//        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusDenied)
    {
        TYLog(@"用户拒绝");
//        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        //有通讯录权限-- 进行下一步操作
        [self openContact];
    }
}

//有通讯录权限-- 进行下一步操作
- (void)openContact{
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    BOOL begin = [[SaiAzeroManager sharedAzeroManager] saiAddContactsBegin];
    if (begin) {
        NSMutableArray *contactAry = [NSMutableArray array];
        [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            NSString *givenName = contact.givenName;
            NSString *familyName = contact.familyName;
            //拼接姓名
            
            NSArray *phoneNumbers = contact.phoneNumbers;
            
            if (phoneNumbers.count != 0) {
                CNLabeledValue  * cnphoneNumber = phoneNumbers[0];
                CNPhoneNumber *phoneNumber = cnphoneNumber.value;
                
                NSString * string = phoneNumber.stringValue;
                
                string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                if ([QKUITools isBlankString:string]&&[QKUITools isBlankString:familyName]&&[QKUITools isBlankString:givenName]) {
                    
                }else{
                    NSDictionary *dic = @{@"id": string,@"firstName":familyName,@"lastName":givenName,@"addresses":@[@{@"value":string,@"type":string,@"label":@"phone"}
                    ]};
                
                    [contactAry addObject:dic];
                    //                    BOOL success = [[SaiAzeroManager sharedAzeroManager] saiAddContact:[dic modelToJSONString]];
                    //                    TYLog(@"success = %d",success);
                }
            }
            
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[SaiAzeroManager sharedAzeroManager] saiAddContactsEnd];
            TYLog(@"查询到的联系人是什么  %@",[[SaiAzeroManager sharedAzeroManager] saiQueryContact]);
            
        });
    }
    
    
    
}
//提示没有通讯录权限
- (void)showAlertViewAboutNotAuthorAccessContact{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请授权通讯录权限"
                                          message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许应用访问你的通讯录"
                                          preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSMutableData *)allData{
    if (_allData == nil) {
        _allData = [NSMutableData data];
    }
    return _allData;
}

-(UIView *)headsetView{
    if (!_headsetView) {
        _headsetView=[[UIView alloc]initWithFrame:CGRectZero];
        _headsetView.backgroundColor=kColorFromRGBHex(0x5782F5);
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        imageView.image=[UIImage imageNamed:@"erji"];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_headsetView addSubview:imageView];
        CBAutoScrollLabel * titleLabel                  = [CBAutoScrollLabel new];
        titleLabel.textColor        = [UIColor whiteColor];
        titleLabel.font             = [UIFont boldSystemFontOfSize:kSCRATIO(12)];
        titleLabel.pauseInterval    = 1.5f;
        titleLabel.fadeLength       = 1.5f;
        titleLabel.text=@"佩戴耳机体验效果更佳哦";
        [_headsetView addSubview:titleLabel];
        UIButton *closeButton=[UIButton CreatButtontext:@"" image:[UIImage imageNamed:@"close"] Font:nil Textcolor:nil];
        [_headsetView addSubview:closeButton];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headsetView);
            make.width.left.mas_offset(kSCRATIO(10));
            make.height.mas_offset(kSCRATIO(15));
            
        }];
        
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
            make.right.mas_offset(kSCRATIO(-8));
            
            make.width.height.mas_offset(kSCRATIO(10));
            
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(closeButton.mas_left).offset(kSCRATIO(-5));
            make.width.mas_offset(kSCRATIO(81));
            make.height.mas_offset(kSCRATIO(15));
            make.centerY.equalTo(_headsetView);
        }];
        imageView.userInteractionEnabled=YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if (_isShow) {
                [UIView animateWithDuration:0.5 animations:^{
                    [_headsetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_offset(kStatusBarHeight+kSCRATIO(70));
                        make.left.mas_offset(KScreenW-kSCRATIO(imageWidth));
                        make.height.mas_offset(kSCRATIO(imageWidth));
                        make.width.mas_offset(kSCRATIO(viewWidth));
                    }];
                    [_headsetView.superview layoutIfNeeded];
                    [titleLabel pausedScroll];
                }];
                
            }else{
                [titleLabel scrollLabelIfNeeded];

                [UIView animateWithDuration:0.5 animations:^{
                    [_headsetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_offset(kStatusBarHeight+kSCRATIO(70));
                        make.left.mas_offset(KScreenW-kSCRATIO(viewWidth));
                        make.height.mas_offset(kSCRATIO(imageWidth));
                        make.width.mas_offset(kSCRATIO(viewWidth));
                    }];
                    
                    [_headsetView.superview layoutIfNeeded];
                    
                }];
                
            }
            
            _isShow=!_isShow;
            
        }]];
        [closeButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            _headsetView.hidden=YES;
        }]];
    }
    return _headsetView;
}

#pragma mark - CustomaltviewDelegate
- (void)alertview:(id)altview clickbuttonIndex:(NSInteger)index{
    if (index == 0) {
        [self.altview hide];
    }
}

@end
