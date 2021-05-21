//
//  AwemeListViewController.m
//  AwemeDemo
//
//  Created by sunyazhou on 2018/10/18.
//  Copyright © 2018 sunyazhou.com. All rights reserved.
//

#import "AwemeListViewController.h" 
#import "AwemeListCell.h"
#import "SaiDigitalCharacterCell.h"
#import "SaiDigitalCharacterCell+SaiElement.h"
#import "AwemeListCell+SaiElement.h"
#import "SaiRightViewController.h"
#import "WXBaseModel.h"
#import "SaiMpToPcmManager.h"
#import <UMShare/UMShare.h>
#import "CoreBluetoothManager.h"
#import "SaiSoundWaveView.h"
#import "SaiBlueManager.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height


@interface AwemeListViewController ()<GKAudioPlayerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong)UISwipeGestureRecognizer *leftSwipe;
@property (nonatomic, strong)UITapGestureRecognizer *tapSwipe;
@property(nonatomic,assign)int currentIndex;
@property (nonatomic, strong)WXBaseModel *baseModel;
@property (nonatomic, strong) dispatch_queue_t timeQueue;
@property (nonatomic, strong) dispatch_queue_t recordQueue;
@property (nonatomic,assign) BOOL isInterrupt;
@property (nonatomic ,strong) ZXCCyclesQueueItem *translateItemON;
@property (nonatomic ,strong) ZXCCyclesQueueItem *translateItemOFF;


@property (nonatomic ,assign) BOOL isBoy;

@end

@implementation AwemeListViewController

#pragma mark -life cycle 视图的生命周期
static bool isDeal=NO;
-(BOOL )shareOnce{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isDeal=YES;
    });
    return isDeal;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentIndex = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self refreshToken];
    self.view.backgroundColor=Color222B36;
    [[SaiAzeroManager sharedAzeroManager]saiAzeroManagerSwitchMode:ModeTranslate andValue:NO];
    
    [[SaiMpToPcmManager sharedSaiMpToPcmManager] setup];
    [self registerNoti];
    [self assignmentAzeroManagerBlockHandle];
//    NSString *tag = [NSString stringWithFormat:@"Guide1%@",SaiContext.currentUser.userId];
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:tag]) {
//        [[SaiAzeroManager sharedAzeroManager]saiAzeroManagerAction:@"Guide" andPosition:@"" andResourceId:@""];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:tag];
//    }else{
    
//        [[SaiAzeroManager sharedAzeroManager]saiAzeroManagerAction:@"Launcher" andPosition:@"" andResourceId:@""];
//    }
    if (self.guideBool) {
        [self dealDataSource:self.renderTemplateStr withSkip:NO];
//        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerAction:@"Acquire" andPosition:@"2" andResourceId:@""];
    }else{
        [[SaiAzeroManager sharedAzeroManager]saiAzeroManagerAction:@"Launcher" andPosition:@"" andResourceId:@""];
    }
    
    kPlayer.delegate=self;
    
    self.leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(pushVC)];
    [self.leftSwipe setDirection: UISwipeGestureRecognizerDirectionLeft];
    [self.leftSwipe setNumberOfTouchesRequired:1];
    self.leftSwipe.cancelsTouchesInView=NO;
    self.leftSwipe.delegate=self;
    [self.view addGestureRecognizer:self.leftSwipe];

    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        [[CoreBluetoothManager sharedCoreBluetoothManager]setHeadsetModelBlock:^(NSString *headsetModel) {
            TYLog(@"%@",headsetModel);
            
            dispatch_semaphore_signal(semaphore);
            
        }];
        
        
    });
    dispatch_async(queue, ^{
        //任务2
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        [[CoreBluetoothManager sharedCoreBluetoothManager] setHeadsetBatteryBlock:^(NSString *headsetBattery) {
            TYLog(@"%@",headsetBattery);
            
            dispatch_semaphore_signal(semaphore);
            
        }];
    });
    
    
    dispatch_async(queue, ^{
        //任务3
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            SaiContext.isHeartImageOpen=YES;
            
            dispatch_semaphore_signal(semaphore);
            
        });
    });
    [[CoreBluetoothManager sharedCoreBluetoothManager] setNextBlock:^{
        self.currentIndex++;
        [self updataAcquire];
    }];
    SaiContext.isHeartImageOpen=YES;

    TYLog(@"%lu",(unsigned long)[UIDevice currentDevice].cpuCount);
    
    
    


}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[CoreBluetoothManager sharedCoreBluetoothManager]setUp];
        
    });
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerExpress:^(NSString *type, NSString *content) {
        TYLog(@"&&&&&&type : %@ ,content : %@",type,content);
        //        TYLog(@"hello - saiAzeroManagerExpress ： handleExpressDirectiveFor 内容：%@  %@",type,content);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *dic = [SaiJsonConversionModel dictionaryWithJsonString:content];
            
            if ([type isEqualToString:@"LocaleMode"]) {
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiERROR tag:nil messmage:[NSString stringWithFormat:@"saiAzeroManagerSwitchMode:ModeHeadset ***************************** %@",dic]];
                NSString *mode = dic[@"mode"];
                NSString *value = dic[@"value"];
                if ([mode isEqualToString:@"translate"]){
                    if ([value isEqualToString:@"ON"]) {
                        [[SaiAzeroManager sharedAzeroManager] saiAzeroButtonPressed:ButtonTypePAUSE];
                        [[ZXCTimer shareInstance] removeCycleTask:self.translateItemON];
                    }
                }else  if ([mode isEqualToString:@"headset"]) {
                    if ([value isEqualToString:@"ON"]) {
                        [[ZXCTimer shareInstance] removeCycleTask:self.translateItemOFF];
                        self.currentIndex++;
                        [self updataAcquire];
                    }
                }
            }
            
            if ([type isEqualToString:@"ASRText"]) {
                NSDictionary *contentDictionary=[SaiJsonConversionModel dictionaryWithJsonString:content];
                bool finished=[[NSString stringWithFormat:@"%@",contentDictionary[@"finished"]] boolValue];
                if (![QKUITools isBlankString:contentDictionary[@"text"]]) {
                    [SaiSoundWaveView showMessage:contentDictionary[@"text"]];
                    TYLog(@"显示的数据是 ----- %@",contentDictionary[@"text"]);
                }
                if (finished) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SaiSoundWaveView hideAllView];
                    });
                }
            }
        });
        
        
    }];
    
    [[SaiAzeroManager sharedAzeroManager] saiAzeroSongListInfo:^(NSString *songListStr) {
                TYLog(@"saiAzeroSongListInfo %@",songListStr);
        [self dealDataSource:songListStr withSkip:NO];
        
    }];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerRenderTemplate:^(NSString *renderTemplateStr) {
        
        [self dealDataSource:renderTemplateStr withSkip:NO];
        
    }];
    
//    [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/queryUserInfo" andParam:@{@"userId":SaiContext.currentUser.userId} andSuccessBlock:^(NSURL *URL, id data) {
//        NSDictionary *dic=(NSDictionary *)data;
//        NSString *sexStr =dic[@"data"][@"sex"];
//        if ([sexStr isEqualToString:@"男"]) {
//            self.isBoy = NO;
//        }else{
//            self.isBoy = YES;
//        }
//    } andFailBlock:^(NSURL *URL, NSError *error) {
//        
//    }];
}
-(void)dealDataSource:(NSString *)renderTemplateStr withSkip:(BOOL )skip{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        WXBaseModel *temporaryBaseModel=[WXBaseModel modelWithJSON:renderTemplateStr];
        if ([temporaryBaseModel.type isEqualToString:@"TranslateTemplate"]) {
            
            if ([temporaryBaseModel.value isEqualToString:@"start"]) {
                [kPlayer pause];
                [[SaiAzeroManager sharedAzeroManager] saiAzeroButtonPressed:ButtonTypePAUSE];
                ZXCCyclesQueueItem *item = [[ZXCTimer shareInstance] addCycleTask:^{
                    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSwitchMode:ModeTranslate andValue:YES];
                } timeInterval:1 runCount:5 threadMode:ZXCBackgroundThread];
                self.translateItemON = item;
                
            }else if ([temporaryBaseModel.value isEqualToString:@"content"]) {
                
                NSArray *dataArray = [temporaryBaseModel.content2 componentsSeparatedByString:@":"];
                
            }else {
                ZXCCyclesQueueItem *item = [[ZXCTimer shareInstance] addCycleTask:^{
                    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"退出"];
                    
                    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSwitchMode:ModeHeadset andValue:YES];
                } timeInterval:1 runCount:5 threadMode:ZXCBackgroundThread];
                self.translateItemOFF = item;
                
            }
            return;
        }
        
        if (!skip) {
            TemplateTypeENUM templateTypet=[QKUITools returnTemplateFromRenderTemplateStr:temporaryBaseModel.type];
            switch (templateTypet) {
                case RenderPlayerInfo:
                case EnglishTemplate:
                {
                    NSString *audioItemId =temporaryBaseModel.audioItemId ;
                    NSString *defaultaudioItemId =         [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAudioItemId"];
                    if ([defaultaudioItemId isEqualToString:audioItemId]||([QKUITools isBlankArray:temporaryBaseModel.contents]&&!temporaryBaseModel.content)) {
                        return ;
                    }else{
                        [[NSUserDefaults standardUserDefaults]setValue:audioItemId forKey:@"defaultAudioItemId"];
                        
                    }
                }
                    break;
                case ASMRRenderPlayerInfo:{
                    NSString *audioItemId =temporaryBaseModel.audioItemId ;
                    NSString *defaultaudioItemId =         [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAudioItemId"];
                    if ([defaultaudioItemId isEqualToString:audioItemId]||([QKUITools isBlankArray:temporaryBaseModel.contents]&&!temporaryBaseModel.content)) {
                        return ;
                    }else{
                        [[NSUserDefaults standardUserDefaults]setValue:audioItemId forKey:@"defaultAudioItemId"];
                        
                    }
                }
                    break;
                case AlertRingtoneTemplate:{
                    //                    [SaiAzeroManager sharedAzeroManager].alert_token = temporaryBaseModel.alert_token;
                }
                    break;
                default:{
                    
                }
                    break;
            };
        }
        
        TYLog(@"获取的球体的信息是 %@",renderTemplateStr);

        [SaiAzeroManager sharedAzeroManager].renderTemplateStr=renderTemplateStr;
        [SaiAzeroManager sharedAzeroManager].songListStr=renderTemplateStr;
        [SaiNotificationCenter postNotificationName:@"dealDataSource" object:nil];
        if ([QKUITools isBlankString:temporaryBaseModel.action]) {
            return;;
        }
        if (temporaryBaseModel.action) {
            [[SaiAzeroManager sharedAzeroManager]removeRetransmissionMechanism];
        }
        if ([temporaryBaseModel.action isEqualToString:@"ReportPosition" ]) {
            [[ZXCTimer shareInstance]removeCycleTask:SaiContext.cyclesQueueItem];
            if ([temporaryBaseModel.acquireTarget boolValue]) {
                SaiContext.isAcquireTarget=[temporaryBaseModel.acquireTarget boolValue];
                if (![QKUITools isBlankString:temporaryBaseModel.ttsText]) {
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
                    
                    if([cell isKindOfClass:SaiDigitalCharacterCell.class ]){
                        SaiDigitalCharacterCell * digitalCharacterCell=(SaiDigitalCharacterCell *)cell;
                        if (self.guideBool) {
                            digitalCharacterCell.isBoy = NO;
                        }else{
                            digitalCharacterCell.isBoy = self.isBoy;
                        }
                        digitalCharacterCell.desc.text=temporaryBaseModel.ttsText;
                        //                        digitalCharacterCell.descBackView.hidden=NO;
                        [digitalCharacterCell startAnimation];
                        
                    }
#pragma mark 临时修改
                    
//                    SaiContext.cyclesQueueItem =[[ZXCTimer shareInstance] addCycleTask:^{
//                        self.currentIndex++;
//                        [self updataAcquire];
//                    } timeInterval:20 runCount:1];
                }
                
            }else{
                if ([temporaryBaseModel.move boolValue]) {
                    
                    int targetPosition=[temporaryBaseModel.state.targetPosition intValue];
                    self.currentIndex=targetPosition;
//                    [self updataAcquirewithSend:YES withAcquire:@"Next"];
                    //不需要上报index
                    [UIView animateWithDuration:0.15
                                          delay:0.0
                                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                        //UITableView滑动到指定cell
                        
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    } completion:^(BOOL finished) {
                        //UITableView可以响应其他滑动手势
                        //            scrollView.panGestureRecognizer.enabled = YES;
                    }];  
                }
                if (![QKUITools isBlankString:temporaryBaseModel.ttsText]) {
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
                    
                    if([cell isKindOfClass:SaiDigitalCharacterCell.class ]){
                        SaiDigitalCharacterCell * digitalCharacterCell=(SaiDigitalCharacterCell *)cell;
                        if (self.guideBool) {
                            digitalCharacterCell.isBoy = NO;
                        }else{
                            digitalCharacterCell.isBoy = self.isBoy;
                        }
                        digitalCharacterCell.desc.text=temporaryBaseModel.ttsText;
                        //                        digitalCharacterCell.descBackView.hidden=NO;
                        [digitalCharacterCell startAnimation];
//                        SaiContext.cyclesQueueItem =[[ZXCTimer shareInstance] addCycleTask:^{
//                            self.currentIndex++;
//                            [self updataAcquire];
//                        } timeInterval:20 runCount:1];
                    }
                    
                    
                    
                    
                }
            }
            
            [self.tableView.mj_footer endRefreshing];
            
            return;
            
        }
        else if ([temporaryBaseModel.action isEqualToString:@"ReplaceAll"]) {
            self.baseModel=temporaryBaseModel;
            WXBaseModelContents *baseModelContents   = self.baseModel.contents.firstObject;
            
            self.currentIndex=[baseModelContents.position intValue];
        }
        else if ([temporaryBaseModel.action isEqualToString:@"Replace" ]) {
            
            int targetPosition=[temporaryBaseModel.state.targetPosition intValue];
            
            if (self.baseModel.contents.count>targetPosition) {
                self.baseModel.contents=[self.baseModel.contents subarrayWithRange:NSMakeRange(0, targetPosition)];
                
            }
            self.baseModel.contents= [self.baseModel.contents arrayByAddingObjectsFromArray:temporaryBaseModel.contents];
            
            
            
            
            
            [self.tableView.mj_footer endRefreshing];
            
            [self.tableView reloadData];
            
            
            if(skip){
                
                self.currentIndex ++;   //向下滑动索引递增
                [self updataAcquire];
                
            }else   if ([temporaryBaseModel.move boolValue]) {
                
                self.currentIndex=targetPosition;
                [self Send:YES withAcquire:@"Next"];
            }
            return;
        }
        
        
        [self.tableView.mj_footer endRefreshing];
        
        [self.tableView reloadData];
        
        if (self.guideBool) {
            self.currentIndex =2;
            [self updataAcquire];
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        

        
        
    });
}

-(void)pushVC{
    

    WXBaseModelContents *baseModelContents = self.baseModel.contents[self.currentIndex];
    if ([baseModelContents.provider.type isEqualToString:@"digitalCharacter"]) {
        return;
    }
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerAction:@"AcquireRelatedList" andPosition:[NSString stringWithFormat:@"%d",self.currentIndex] andResourceId:@""];
    
    SaiRightViewController *righyVC=[SaiRightViewController new];
    
    [self.navigationController pushViewController:righyVC animated:YES];
    
}

#pragma mark  setUpView

- (void)setUpView {
    
    self.tableView .delegate=self;
    self.tableView .dataSource=self;
    self.tableView.backgroundColor=Color222B36;
    self.tableView .showsVerticalScrollIndicator = NO;
    self.tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        self.tableView .contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    
    //注册cell XIB创建
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(AwemeListCell.class) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass(AwemeListCell.class)];
    [self.tableView registerClass:[SaiDigitalCharacterCell class] forCellReuseIdentifier:NSStringFromClass([SaiDigitalCharacterCell class])];
    blockWeakSelf;
    
    
    MJRefreshAutoFooter *autoFooter=[MJRefreshAutoFooter footerWithRefreshingBlock:^{
        WXBaseModelContents *frameModel = weakSelf.baseModel.contents.lastObject;
        
        
        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerAction:@"AcquireList" andPosition:[NSString stringWithFormat:@"%d",[frameModel.position intValue]+1] andResourceId:@""];
    }];
    autoFooter.triggerAutomaticallyRefreshPercent=-SCREEN_HEIGHT/22;
    self.tableView.mj_footer=autoFooter;
    [self.view addSubview:self.tableView];
    self.tableView.delaysContentTouches = NO;
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    
}




#pragma mark 初始化方法
- (void)assignmentAzeroManagerBlockHandle{
    blockWeakSelf;
    [[SaiAzeroManager sharedAzeroManager] saiAzeroPlayTtsStatePrepare:^{
        dispatch_async(weakSelf.timeQueue, ^{
            [[SaiMpToPcmManager sharedSaiMpToPcmManager] prepareConversionAudio];
            
        });
    }];
    
}
-(void)refreshToken{
    if ([QKUITools isBlankString:SaiContext.currentUser.token]) {
        return;
    }
    [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/extendToken" andParam:@{@"token":SaiContext.currentUser.token} andSuccessBlock:^(NSURL *URL, id data) {
        
    } andFailBlock:^(NSURL *URL, NSError *error) {
        
    }];
    
}
- (void)registerNoti{
    [SaiNotificationCenter addObserver:self selector:@selector(saiLogoutSuccess:) name:SaiLogoutSuccessNoti object:nil];
    [SaiNotificationCenter addObserver:self selector:@selector(saiHeadsetNeedBle) name:@"saiHeadsetNeedBle" object:nil];


    [SaiNotificationCenter addObserver:self selector:@selector(saiLoginSuccess:) name:SaiLoginSuccessNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordCallback:) name:SaiRecordCallback object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ttsPlayComplete:) name:SaiTtsPlayComplete object:nil];
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    //    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    [SaiNotificationCenter addObserver:self selector:@selector(audioSessionInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    [SaiNotificationCenter addObserver:self selector:@selector(audioSessionRouteChange:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    //    [SaiNotificationCenter addObserver:self selector:@selector(headsetModeSuccess:) name:SaiSetHeadsetModeSuccess object:nil];
    //    [SaiNotificationCenter addObserver:self selector:@selector(saiApplicationWillEnterForeground) name:SaiApplicationWillEnterForeground object:nil];
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
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        float aa0=[[NSString stringWithFormat:@"%@",dict[@"volLDB"]] floatValue];
    //        [SaiSoundWaveView shareHud].level=aa0;
    //    });
}

- (void)ttsPlayComplete:(NSNotification *)noti{
    dispatch_async(self.timeQueue, ^{
        [[AudioQueuePlay sharedAudioQueuePlay] resetPlay];
        [[AudioQueuePlay sharedAudioQueuePlay] audioQueueFlush];
        [[AudioQueuePlay sharedAudioQueuePlay] resetQueue];
        [SaiMpToPcmManager sharedSaiMpToPcmManager].isTimer = NO;
        [[SaiMpToPcmManager sharedSaiMpToPcmManager] memsetBuffer];
        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReportTtsPlayStateFinished];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (SaiContext.isAcquireTarget) {
                SaiContext.isAcquireTarget=NO;
                self.currentIndex ++;   //向下滑动索引递增
                [self updataAcquire];
            }
            if (self.guideBool) {
                [[XBEchoCancellation shared] startNeedInput];
                self.guideBool = NO;
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    [[SaiAzeroManager sharedAzeroManager]saiAzeroManagerAction:@"Launcher" andPosition:@"" andResourceId:@""];
                });
            }
            
        });
        
        
    });
}
- (void)audioSessionInterruption:(NSNotification *)notify {
    NSDictionary *interuptionDict = notify.userInfo;
    NSInteger interruptionType = [interuptionDict[AVAudioSessionInterruptionTypeKey] integerValue];
    NSInteger interruptionOption = [interuptionDict[AVAudioSessionInterruptionOptionKey] integerValue];
    
    if (interruptionType == AVAudioSessionInterruptionTypeBegan) {
        // 收到播放中断的通知，暂停播放
        if (!self.isInterrupt) {
            [[XBEchoCancellation shared] stop];
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
            
            
            self.isInterrupt=YES;
            [[AVAudioSession sharedInstance] setActive:NO error:nil];
            
            
        }
        
    }else if (interruptionType == AVAudioSessionInterruptionTypeEnded){
        if (self.isInterrupt) {
            self.isInterrupt = NO;
            if (interruptionOption == AVAudioSessionInterruptionOptionShouldResume) {
                [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
                [[XBEchoCancellation shared] startInput];
                
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
            [self saiHeadsetNeedBle];
        }
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            
            
        }
            break;
        case AVAudioSessionRouteChangeReasonOverride:
        {
            
        }
            break;
        default:
            break;
    }
}

-(void)saiHeadsetNeedBle{
//    if ([QKUITools isSaiHeadsetNeedBle]){//如果是声智的耳机,就检测做ble
//        [[CoreBluetoothManager sharedCoreBluetoothManager]setUp];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(120 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (!SaiContext.isHeartImageOpen) {
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否进行耳机升级" message:nil preferredStyle:UIAlertControllerStyleAlert];
//                [alertController addAction:[UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//
//                    NSArray *array = [SaiContext.power componentsSeparatedByString:@","];
//                    if (([[NSString stringWithFormat:@"%@",array[0] ] intValue]<3)||([[NSString stringWithFormat:@"%@",array[1] ] intValue]<3)) {
//                        [MessageAlertView showHudMessage:@"当前耳机电量较低，升级时请确保电量高于30%"];
//
//                        return;
//
//                    }
//                    [[XBEchoCancellation shared] stop];
//
//                    [[CoreBluetoothManager sharedCoreBluetoothManager]cancelPeripheralConnection];
//
//                            [[SaiBlueManager sharedSaiBlueManager]setUp];
//                            [[SaiBlueManager sharedSaiBlueManager] setVersionBlock:^(NSString * _Nonnull version) {
//                                SaiVersionUpdateViewController *versionUpdateViewController=    [SaiVersionUpdateViewController new];
//                                versionUpdateViewController.version=version;
//                                versionUpdateViewController.isHasNewVersion=[SaiContext.currentVersion compare:version] == NSOrderedDescending;
//                                [MessageAlertView dismissHud];
//
//                                [self.navigationController pushViewController:versionUpdateViewController animated:YES];
//
//                            }];
//
//
//                        }]];
//                [alertController addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:nil]];
//
//                [self presentViewController:alertController animated:YES completion:nil];
//            }
//        });
//    }
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
#pragma mark - private methods 私有方法
-(void)favorite:(BOOL) isFavorite  baseModelContents:(WXBaseModelContents * _Nonnull) baseModelContents success:(void(^)(bool isSuccsee))successBlock{
    NSString *url=isFavorite?@"/v1/surrogate/ta/favorite":@"/v1/surrogate/ta/favorite/cancel";
    [QKBaseHttpClient httpType:POST andURL:url andParam:@{@"userId":SaiContext.currentUser.userId,@"resourceId":baseModelContents.resourceId} andSuccessBlock:^(NSURL *URL, id data) {
        successBlock(YES);
    } andFailBlock:^(NSURL *URL, NSError *error) {
        successBlock(NO);
        
    }];
}





#pragma mark -
#pragma mark -ScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        //UITableView禁止响应其他滑动手势
        scrollView.panGestureRecognizer.enabled = NO;
        
        if(translatedPoint.y < -50 && self.currentIndex < (self.baseModel.contents.count - 1)) {
            SaiContext.isAcquireTarget=NO;
            
            self.currentIndex ++;   //向下滑动索引递增
            [self updataAcquirewithSend:YES withAcquire:@"Next"];
            
        }else if(translatedPoint.y > 50 && self.currentIndex > 0) {
            SaiContext.isAcquireTarget=NO;
            
            self.currentIndex --;   //向上滑动索引递减
            [self updataAcquirewithSend:YES withAcquire:@"Previous"];
        }else{
            [self updataAcquirewithSend:YES withAcquire:@"Next"];
            
        }
        
        scrollView.panGestureRecognizer.enabled = YES;
        
        
        
        
    });
}



#pragma mark - event response 所有触发的事件响应 按钮、通知、分段控件等
-(void)updataAcquire{
    [self updataAcquirewithSend:NO withAcquire:@""];
    
}
-(void)updataAcquirewithSend:(BOOL)isNotSend withAcquire:(NSString *)Acquire{
    if (SaiContext.isAcquireTarget) {
        //        SaiContext.isAcquireTarget=NO;
        return;
    }
    if (self.baseModel.contents.count<=self.currentIndex) {
        return;
    }
    if (![QKUITools isBlankString:Acquire]) {
        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerAction:@"Acquire" andPosition:[NSString stringWithFormat:@"%d",self.currentIndex] andResourceId:@"" acquireType:Acquire];
    }else{
        if (!isNotSend) {
            [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerAction:@"Acquire" andPosition:[NSString stringWithFormat:@"%d",self.currentIndex] andResourceId:@""];
        }}
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
        //UITableView滑动到指定cell
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } completion:^(BOOL finished) {
        //UITableView可以响应其他滑动手势
        //            scrollView.panGestureRecognizer.enabled = YES;
    }];
}
-(void)Send:(BOOL)isNotSend withAcquire:(NSString *)Acquire{
    if (SaiContext.isAcquireTarget) {
        //        SaiContext.isAcquireTarget=NO;
        return;
    }
    if (self.baseModel.contents.count<=self.currentIndex) {
        return;
    }
    if (![QKUITools isBlankString:Acquire]) {
//        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerAction:@"Acquire" andPosition:[NSString stringWithFormat:@"%d",self.currentIndex] andResourceId:@"" acquireType:Acquire];
        
    }else{
        if (!isNotSend) {
            [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerAction:@"Acquire" andPosition:[NSString stringWithFormat:@"%d",self.currentIndex] andResourceId:@""];
        }}
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
        //UITableView滑动到指定cell
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } completion:^(BOOL finished) {
        //UITableView可以响应其他滑动手势
        //            scrollView.panGestureRecognizer.enabled = YES;
    }];
}

- (void)applicationBecomeActive {
    //    AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:SaiContext.currentIndex inSection:0]];
    //    if(!_isCurPlayerPause) {
    //        [cell.playerView play];
    //    }
}

- (void)applicationEnterBackground {
    //    AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:SaiContext.currentIndex inSection:0]];
    //    _isCurPlayerPause = ![cell.playerView rate];
    //    [cell.playerView pause];
}

//观察currentIndex变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentIndex"]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
        if([cell isKindOfClass:SaiDigitalCharacterCell.class ]){
            SaiDigitalCharacterCell * digitalCharacterCell=(SaiDigitalCharacterCell *)cell;
            digitalCharacterCell.tableView.hidden=    SaiContext.isUpwardDynamicHeightMarqueeViewIsOpen;
            digitalCharacterCell.upwardDynamicHeightMarqueeViewButton.selected=SaiContext.isUpwardDynamicHeightMarqueeViewIsOpen;
            digitalCharacterCell.headsetImageView.hidden=    !SaiContext.isHeartImageOpen;
            if (SaiContext.bluetoothBool&&[QKUITools isSaiHeadsetNeedBle]) {
                digitalCharacterCell.headsetImageView.hidden = NO;
            }else{
                digitalCharacterCell.headsetImageView.hidden = YES;
            }
            if (self.guideBool) {
                digitalCharacterCell.isBoy = NO;
            }else{
                digitalCharacterCell.isBoy = self.isBoy;
            }

        }else{
            AwemeListCell * digitalCharacterCell=(AwemeListCell *)cell;
            digitalCharacterCell.tableView.hidden=    SaiContext.isUpwardDynamicHeightMarqueeViewIsOpen;
            digitalCharacterCell.headsetImageView.hidden=    !SaiContext.isHeartImageOpen ;
            if (SaiContext.bluetoothBool&&[QKUITools isSaiHeadsetNeedBle]) {
                digitalCharacterCell.headsetImageView.hidden = NO;
            }else{
                digitalCharacterCell.headsetImageView.hidden = YES;
            }
            
            digitalCharacterCell.upwardDynamicHeightMarqueeViewButton.selected=SaiContext.isUpwardDynamicHeightMarqueeViewIsOpen;
            
            
            
        }
        
        if ([change containsObjectForKey:@"old"]) {
            
            
            int oldInter=[[NSString stringWithFormat:@"%@",change[@"old"]] intValue];
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:oldInter inSection:0]];
            
            if([cell isKindOfClass:SaiDigitalCharacterCell.class ]){
                SaiDigitalCharacterCell * digitalCharacterCell=(SaiDigitalCharacterCell *)cell;
                if (self.guideBool) {
                    digitalCharacterCell.isBoy = NO;
                }else{
                    digitalCharacterCell.isBoy = self.isBoy;
                }
                dispatch_async(self.timeQueue, ^{
                    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReportTtsPlayStateFinished];
                    
                    [[AudioQueuePlay sharedAudioQueuePlay] resetPlay];
                    [[AudioQueuePlay sharedAudioQueuePlay] audioQueueFlush];
                    [[AudioQueuePlay sharedAudioQueuePlay] resetQueue];
                    [SaiMpToPcmManager sharedSaiMpToPcmManager].isTimer = NO;
                    [[SaiMpToPcmManager sharedSaiMpToPcmManager] memsetBuffer];
                    
                    if (digitalCharacterCell.timer) {
                        
                        dispatch_source_cancel(digitalCharacterCell.timer);
                        //                    digitalCharacterCell.timer=nil;
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                        digitalCharacterCell.descBackView.hidden=YES;
                        digitalCharacterCell.desc.text=@"";
                        //                        [digitalCharacterCell.cyclesQueueItem pause];
                        
                    });
                    
                    
                });
                //                dispatch_async(weakSelf.timeQueue, ^{
                //
                //
                //
                //                    [AudioQueuePlay sharedAudioQueuePlay].isInterrupted=YES;
                //                    [AudioQueuePlay sharedAudioQueuePlay].stop=YES;
                //                    [[AudioQueuePlay sharedAudioQueuePlay] audioQueueFlush];
                //                    [[AudioQueuePlay sharedAudioQueuePlay] resetQueue];
                //                    [[AudioQueuePlay sharedAudioQueuePlay] resetPlay];
                //                    [SaiMpToPcmManager sharedSaiMpToPcmManager].isTimer = NO;
                //                    [[SaiMpToPcmManager sharedSaiMpToPcmManager] stopTimer];
                //                    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReportTtsPlayStateFinished];
                //                    [[AudioQueuePlay sharedAudioQueuePlay] immediatelyStopPlay];
                //                    [[SaiMpToPcmManager sharedSaiMpToPcmManager] memsetBuffer];
                //                    dispatch_async(dispatch_get_main_queue(), ^{
                //
                //
                //
                //                    });
                //
                //                });
            }else{
                AwemeListCell * digitalCharacterCell=(AwemeListCell *)cell;
                //                TYLog(@"cyclesQueueItem%ld",(long)digitalCharacterCell.cyclesQueueItem.index);
                //                [[ZXCTimer shareInstance ]removeCycleTask:digitalCharacterCell.cyclesQueueItem ];
                if (digitalCharacterCell.timer) {
                    
                    dispatch_source_cancel(digitalCharacterCell.timer);
                    //                    digitalCharacterCell.timer=nil;
                    
                }
                
            }
            
        }
        //获取当前显示的cell
        
        //        __weak typeof (cell) wcell = cell;
        //        __weak typeof (self) wself = self;
        //用cell控制相关视频播放
        
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}












#pragma  mark GKAudioPlayerDelegate
- (void)gkPlayer:(GKAudioPlayer *)player statusChanged:(GKAudioPlayerState)status{
    if (self.baseModel.contents.count<=self.currentIndex) {
        return;
    }
    WXBaseModelContents *baseModelContents = self.baseModel.contents[self.currentIndex];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    
    if([cell isKindOfClass:AwemeListCell.class ]){
        AwemeListCell * digitalCharacterCell=(AwemeListCell *)cell;
        
        if ([QKUITools isBlankString:baseModelContents.provider.lyric]) {
            switch (status) {
                case GKAudioPlayerStatePlaying:
                {
                    digitalCharacterCell.playButton.selected=NO;
                }
                    break;
                case GKAudioPlayerStatePaused:{
                    digitalCharacterCell.playButton.selected=YES;
                    
                }
                    break;;
                default:
                    break;
            }
            
        }else{
            switch (status) {
                case GKAudioPlayerStatePlaying:
                {
                    digitalCharacterCell.lyricView.playButton.selected=NO;
                }
                    break;
                case GKAudioPlayerStatePaused:{
                    digitalCharacterCell.lyricView.playButton.selected=YES;
                    
                }
                    break;;
                default:
                    break;
                    
            }
        }}
}

- (void)gkPlayer:(GKAudioPlayer *)player currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime progress:(float)progress{
    if (self.baseModel.contents.count<=self.currentIndex) {
        return;
    }
    WXBaseModelContents *baseModelContents = self.baseModel.contents[self.currentIndex];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    
    if([cell isKindOfClass:AwemeListCell.class ]){
        AwemeListCell * digitalCharacterCell=(AwemeListCell *)cell;
        
        if (![QKUITools isBlankString:baseModelContents.provider.lyric]) {
            [digitalCharacterCell.lyricView scrollLyricWithCurrentTime:currentTime totalTime:totalTime];
            
        }else{
            digitalCharacterCell.circleSlider.value=progress;
            if (totalTime-currentTime>0) {
                digitalCharacterCell.progressLabel.text=[NSString stringWithFormat:@"-%@",[QKUITools timeFormattedWithMMSS:totalTime-currentTime]];
                
            }
        }
    }
    
    
}
#pragma mark  UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.baseModel.contents.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXBaseModelContents *baseModelContents = self.baseModel.contents[indexPath.row];
    if ([baseModelContents.provider.type isEqualToString:@"digitalCharacter"]) {
        
        SaiDigitalCharacterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SaiDigitalCharacterCell.class)];
        if (self.guideBool) {
            cell.isBoy = NO;
        }else{
            cell.isBoy = self.isBoy;
        }
        if (!cell) {
            cell = [[SaiDigitalCharacterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(SaiDigitalCharacterCell.class)];
            
        }
        
        cell.indexPath=indexPath.row;
        [cell setClickBlock:^(NSInteger integer, WXBaseModelContents * _Nonnull baseModelContents) {
            UMSocialPlatformType type = UMSocialPlatformType_UnKnown;
            NSString *title=@"TA来了";
            NSString *descr=@"一个随身携带的专属人工智能，期待与你超时空相遇";
            
            switch (integer) {
                case 0:
                {
                    type = UMSocialPlatformType_WechatSession;
                }
                    break;
                case 1:
                {
                    type = UMSocialPlatformType_WechatTimeLine;
                }
                    break;
                case 2:
                {
                    title=@"TA来了，一个随身携带的专属人工智能，期待与你超时空相遇";
                    descr=@"";
                    type = UMSocialPlatformType_Sina;
                }
                    break;
                default:
                    break;
            }
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:[UIImage imageNamed:@"icon_share"]];
            shareObject.webpageUrl = [NSString stringWithFormat:@" https://app-azero.soundai.com.cn/downloads/index.html"];
            messageObject.shareObject = shareObject;
            [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    [MessageAlertView showHudMessage:@"分享失败"];
                } else {
                }
            }];
        }];
        if (indexPath.row==0) {
            if (![QKUITools isBlankString:self.baseModel.ttsText]) {
                cell.desc.text=self.baseModel.ttsText;
                //                cell.descBackView.hidden=NO;
                    [cell startAnimation];
                
                self.baseModel.ttsText=@"";
                SaiContext.cyclesQueueItem =[[ZXCTimer shareInstance] addCycleTask:^{
                    self.currentIndex++;
                    [self updataAcquire];
                } timeInterval:35 runCount:1];
            }
            
        }
        __block SaiDigitalCharacterCell *strongCell = cell;
        [cell setTextClick:^(NSString * _Nonnull text, WXBaseModelContents * _Nonnull baseModelContents) {
            [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/ta/comments/resource/add" andParam:@{@"resourceId":baseModelContents.resourceId,@"userId":SaiContext.currentUser.userId,@"content":text} andSuccessBlock:^(NSURL *URL, id data) {
                WXBaseModelContentsExtCommentFirstPage *baseModelContentsExtCommentFirstPage=[WXBaseModelContentsExtCommentFirstPage modelWithJSON:data[@"data"]];
                baseModelContents.ext.comment.firstPage=[baseModelContents.ext.comment.firstPage arrayByAddingObject:baseModelContentsExtCommentFirstPage];
                baseModelContents.ext.comment.num=[NSNumber numberWithInt:([baseModelContents.ext.comment.num intValue]+1)];
                [strongCell setBaseModelContents:baseModelContents];
            } andFailBlock:^(NSURL *URL, NSError *error) {
                
            }];
            
        }];
        [cell setIsFavoriteBlock:^(BOOL isFavorite, WXBaseModelContents * _Nonnull baseModelContents) {
            [self favorite:isFavorite baseModelContents:baseModelContents success:^(bool isSuccsee) {
                int num=   [baseModelContents.ext.like.num intValue];
                
                baseModelContents.ext.like.num=[NSNumber numberWithInt:isFavorite?num+1:num-1];
                strongCell.favoriteNum.text=[baseModelContents.ext.like.num stringValue];
            }];
        }];
        cell.baseModelContents=baseModelContents;
        return cell;
    }
    //填充视频数据
    AwemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(AwemeListCell.class)];
    if (!cell) {
        cell = [[AwemeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(AwemeListCell.class)];
        
    }
    if (SaiContext.bluetoothBool&&[QKUITools isSaiHeadsetNeedBle]) {
        cell.headsetImageView.hidden = NO;
    }else{
        cell.headsetImageView.hidden = YES;
    }
    __block AwemeListCell *strongCell = cell;
    
    [cell setTextClick:^(NSString * _Nonnull text, WXBaseModelContents * _Nonnull baseModelContents) {
        [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/ta/comments/resource/add" andParam:@{@"resourceId":baseModelContents.resourceId,@"userId":SaiContext.currentUser.userId,@"content":text} andSuccessBlock:^(NSURL *URL, id data) {
            WXBaseModelContentsExtCommentFirstPage *baseModelContentsExtCommentFirstPage=[WXBaseModelContentsExtCommentFirstPage modelWithJSON:data[@"data"]];
            baseModelContents.ext.comment.firstPage=[baseModelContents.ext.comment.firstPage arrayByAddingObject:baseModelContentsExtCommentFirstPage];
            baseModelContents.ext.comment.num=[NSNumber numberWithInt:([baseModelContents.ext.comment.num intValue]+1)];
            [strongCell setBaseModelContents:baseModelContents];
        } andFailBlock:^(NSURL *URL, NSError *error) {
            
        }];
        
    }];
    [cell setClickBlock:^(NSInteger integer, WXBaseModelContents * _Nonnull baseModelContents) {
        UMSocialPlatformType type = UMSocialPlatformType_UnKnown;
        NSString *title=@"TA来了";
        NSString *descr=@"一个随身携带的专属人工智能，期待与你超时空相遇";
        
        switch (integer) {
            case 0:
            {
                type = UMSocialPlatformType_WechatSession;
            }
                break;
            case 1:
            {
                type = UMSocialPlatformType_WechatTimeLine;
            }
                break;
            case 2:
            {
                title=@"TA来了，一个随身携带的专属人工智能，期待与你超时空相遇";
                descr=@"";
                type = UMSocialPlatformType_Sina;
            }
                break;
            default:
                break;
        }
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:[UIImage imageNamed:@"icon_share"]];
        shareObject.webpageUrl = [NSString stringWithFormat:@" https://app-azero.soundai.com.cn/downloads/index.html"];
        messageObject.shareObject = shareObject;
        [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                [MessageAlertView showHudMessage:@"分享失败"];
            } else {
            }
        }];
    }];
    
    [cell setIsFavoriteBlock:^(BOOL isFavorite, WXBaseModelContents * _Nonnull baseModelContents) {
        [self favorite:isFavorite baseModelContents:baseModelContents success:^(bool isSuccsee) {
            int num=   [baseModelContents.ext.like.num intValue];
            
            baseModelContents.ext.like.num=[NSNumber numberWithInt:isFavorite?num+1:num-1];
            strongCell.favoriteNum.text=[baseModelContents.ext.like.num stringValue];
        }];
    }];
    
    cell.currentIndex = indexPath.row;
    cell.baseModelContents=baseModelContents;
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
#pragma  mark lazy

-(void)setCurrentIndex:(int)currentIndex{
    _currentIndex=currentIndex;
    SaiContext.currentIndex=currentIndex;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
