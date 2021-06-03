//
//  SaiNewFeatureViewController.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/12/10.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "SaiNewFeatureViewController.h"
#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <lame/lame.h>
#import "SaiSoundWaveView.h"
#import "GKTimer.h"
#import "BaseNC.h"
#import "AppDelegate.h"
#import "SaiMpToPcmManager.h"
#import "MessageAlertView.h"
#import "NetWorkUtil.h"
#import "VersionUpdateAlert.h"
#import "SaiJXHomePageViewController.h"
#define PromptLabelY    165
#define PromptLabelX    40
#define PromptLabelH    22.5
#define TopLabelX       20
#define TopLabelSpaceY  50
#define TopLabelH       130
#define HeadsetImageViewSpaceY      55
#define HeadsetImageViewW      105

@interface SaiNewFeatureViewController ()
@property (nonatomic ,strong) UILabel *promptLabel;
@property (nonatomic ,strong) UILabel *topLabel;
@property (nonatomic ,strong) UIImageView *headsetImageView;
@property (nonatomic ,assign) BOOL isTimerRunning;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,strong) dispatch_queue_t timeQueue;
@end

@implementation SaiNewFeatureViewController
#pragma mark -  Life Cycle
- (void)dealloc{
    TYLog(@"SaiNewFeatureViewController走了 dealloc 方法");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NetWorkUtil sharedInstance]listening];
    [self registerNoti];
    [self setupUI];
    [[SaiMpToPcmManager sharedSaiMpToPcmManager] setup];
    [self wearingHeadphonesDeal];
}


#pragma mark -  UITableViewDelegate
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Methods
- (void)outputDeviceChanged:(NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *interuptionDict = noti.userInfo;
        NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
        switch (routeChangeReason) {
            case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
                TYLog(@"耳机插入");
                [self wearingHeadphonesDeal];
                self.headsetImageView.image = [UIImage imageNamed:@"launcher_icon_headset"];
                break;
            case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
                TYLog(@"耳机拔出");
                self.headsetImageView.image = [UIImage imageNamed:@"disConnectionHeadset"];
                break;
            case AVAudioSessionRouteChangeReasonOverride:
               TYLog(@"耳机拔出");
                self.headsetImageView.image = [UIImage imageNamed:@"disConnectionHeadset"];
               break;
            default:
                break;
        }
    });
}
- (void)recordCallback:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    NSData *data = dict[@"data"];
    dispatch_async(dispatch_get_main_queue(), ^{
        float aa0=[[NSString stringWithFormat:@"%@",dict[@"volLDB"]] floatValue];
        [SaiSoundWaveView shareHud].level=aa0;
    });
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerWriteData:data];
}
- (void)ttsPlayComplete:(NSNotification *)noti{
    dispatch_async(self.timeQueue, ^{
        [[AudioQueuePlay sharedAudioQueuePlay] resetPlay];
        [[AudioQueuePlay sharedAudioQueuePlay] audioQueueFlush];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReportTtsPlayStateFinished];
        TYLog(@"------------***********************************--当前线程%@",[NSThread currentThread]);
        TYLog(@"------------***********************************-----------------------------------------TTS播报完成");
    });  
}

#pragma mark -  Button Callbacks  
#pragma mark -  Private Methods
- (void)registerNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputDeviceChanged:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordCallback:) name:SaiRecordCallback object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ttsPlayComplete:) name:SaiTtsPlayComplete object:nil];
}
- (void)setupUI{
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(0, 0, KScreenW, KScreenH);
    bgImageView.image = [UIImage imageNamed:@"LaunchScreen2"];
    bgImageView.contentMode=UIViewContentModeScaleAspectFill;

    [self.view addSubview:bgImageView];
//    UILabel *promptLabel = [[UILabel alloc] init];
//    promptLabel.frame = CGRectMake(PromptLabelX, PromptLabelY, KScreenW-PromptLabelX*2, PromptLabelH);
//
//    SaiContext.currentUser = [YYTextUnarchiver  unarchiveObjectWithFile:DOCUMENT_FOLDER(@"loginedUser")];
////    if (SaiContext.currentUser.name.length==0||![[NSUserDefaults standardUserDefaults] boolForKey:SaikIsLogin]) {
////        promptLabel.text = @"欢迎来到TA来了";
////    }else{
////        promptLabel.text = [QKUITools isBlankString:SaiContext.currentUser.name]?@"欢迎来到TA来了":[NSString stringWithFormat:@"%@,欢迎来到TA来了",SaiContext.currentUser.name];
////    }
//    promptLabel.text = @"欢迎来到TA来了";
//    promptLabel.font = [UIFont qk_PingFangSCRegularBoldFontwithSize:PromptLabelH];
//    promptLabel.textColor = SaiColor(14, 173, 110);
//    promptLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:promptLabel];
//    self.promptLabel = promptLabel;
//    UILabel *topLabel = [[UILabel alloc] init];
//    topLabel.frame = CGRectMake(TopLabelX, CGRectGetMaxY(promptLabel.frame)+TopLabelSpaceY, KScreenW-TopLabelX*2, TopLabelH);
//    topLabel.font = [UIFont qk_PingFangSCRegularBoldFontwithSize:19.0f];
//    topLabel.textColor = [UIColor whiteColor];
//    topLabel.numberOfLines =  0;
//    topLabel.text = @"请连接耳机或车载蓝牙\r\n星球上的内容都可以对我说哦";
//    [UILabel changeLineSpaceForLabel:topLabel WithSpace:25];
//    topLabel.frame = CGRectMake(TopLabelX, CGRectGetMaxY(promptLabel.frame)+TopLabelSpaceY, KScreenW-TopLabelX*2, TopLabelH);
//    topLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:topLabel];
//    self.topLabel = topLabel;
//    UIImageView *headsetImageView = [[UIImageView alloc] init];
//    headsetImageView.frame = CGRectMake(TopLabelX,CGRectGetMaxY(topLabel.frame)+HeadsetImageViewSpaceY, HeadsetImageViewW, HeadsetImageViewW);
//    headsetImageView.image = [UIImage imageNamed:@"disConnectionHeadset"];
//    headsetImageView.centerX = self.view.centerX;
//    [self.view addSubview:headsetImageView];
//    self.headsetImageView = headsetImageView;
}
- (void)wearingHeadphonesDeal{
    __weak typeof(self) weakSelf = self;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SaikIsLogin]) {
        [[SaiAzeroManager sharedAzeroManager] setUpAzeroSDK];
        [[SaiAzeroManager sharedAzeroManager] saiSDKConnectionStatusChangedWithStatus:^(ConnectionStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status) {
                    case ConnectionStatusConnect:
                        [[SaiAzeroManager sharedAzeroManager] detectAndSetSerFile];
//                        [weakSelf statusConnectOperationIsLogin];
                        [weakSelf performSelectorOnMainThread:@selector(statusConnectOperationIsLogin) withObject:nil waitUntilDone:NO];

                        break;
                    case ConnectionStatusDisConnect:
                        [MessageAlertView showHudMessage:@"与SDK服务器断开连接,请重新启动APP"];
                        break;
                    default:
                        break;
                }
            });
        }];
    }else{
        [weakSelf performSelectorOnMainThread:@selector(jump) withObject:nil waitUntilDone:NO];
    }
}
-(void)jump{
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    BaseNC *loginNav = [[BaseNC alloc] initWithRootViewController:loginVc];
    loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:loginNav animated:YES completion:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[VersionUpdateAlert shareVersionUpdateAlert] checkAndShowWithAppID:SoundAIAppId andController:app.window.rootViewController];
}
- (void)statusConnectOperationIsLogin{
    [self playPreloadedMp3];
//    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:nil messmage:@"827record SaiNewFeatureViewController **************** [[XBEchoCancellation shared] startInput] 前"];
    [[XBEchoCancellation shared] startInput];
//    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:nil messmage:@"827record SaiNewFeatureViewController **************** [[XBEchoCancellation shared] startInput] 后"];
    SaiContext.currentUser = [YYTextUnarchiver  unarchiveObjectWithFile:DOCUMENT_FOLDER(@"loginedUser")];
//    if (SaiContext.currentUser.name.length==0||![[NSUserDefaults standardUserDefaults] boolForKey:SaikIsLogin]) {
//        self.promptLabel.text = @"欢迎来到TA来了";
//    }else{
//        self.promptLabel.text = [QKUITools isBlankString:SaiContext.currentUser.name]?@"欢迎来到TA来了":[NSString stringWithFormat:@"%@,欢迎来到TA来了",SaiContext.currentUser.name];
//    }
//    self.promptLabel.text = @"欢迎来到TA来了";
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BaseNC *loginNav = [[BaseNC alloc] initWithRootViewController:KSaiJXHomePageViewController];

    [UIApplication sharedApplication].keyWindow.rootViewController = loginNav ;
    [[VersionUpdateAlert shareVersionUpdateAlert] checkAndShowWithAppID:SoundAIAppId andController:app.window.rootViewController];
}
- (void)assignmentAzeroManagerBlockHandle{
    [[SaiAzeroManager sharedAzeroManager] saiAzeroPlayTtsStatePrepare:^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReportTtsPlayStateStart];
        });
        dispatch_async(self.timeQueue, ^{
            [[SaiMpToPcmManager sharedSaiMpToPcmManager] prepareConversionAudio];
        });
    }];
    __weak typeof(self) weakSelf = self;
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerRenderTemplate:^(NSString *renderTemplateStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            TYLog(@"获取的球体的信息是 %@",renderTemplateStr);
            NSDictionary *dic = [SaiJsonConversionModel dictionaryWithJsonString:renderTemplateStr];
            NSString *type = dic[@"type"];
            if ([type isEqualToString:@"GuideTemplate3"]) {
                NSString *content1 = dic[@"content1"];
                NSString *content2 = dic[@"content2"];
                NSString *str = [NSString stringWithFormat:@"%@\r\n你可以对我说“%@”",content1,content2];
                [weakSelf.promptLabel removeFromSuperview];
                weakSelf.topLabel.text = str;
            }else if ([type isEqualToString:@"ReadyTemplate"]){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NewFeaturesVersion];
                [[NSUserDefaults standardUserDefaults] synchronize];
//                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [UIApplication sharedApplication].keyWindow.rootViewController =KSaiJXHomePageViewController ;
            }else if ([type isEqualToString:@"GuideTemplate2"]){
                
            }
        });
    }];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerExpress:^(NSString *type, NSString *content) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dic = [SaiJsonConversionModel dictionaryWithJsonString:content];
            NSString *action = dic[@"action"];
            if ([action isEqualToString:@"goHome"]) {
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
            }
            
            if ([type isEqualToString:@"ASRText"]) {
                NSDictionary *contentDictionary=[SaiJsonConversionModel dictionaryWithJsonString:content];
                bool finished=[[NSString stringWithFormat:@"%@",contentDictionary[@"finished"]] boolValue];
                if (finished) {
                    [SaiSoundWaveView showMessage:@""];
                    [SaiSoundWaveView dismissHudAni];
                }else{
                    if (![QKUITools isBlankString:contentDictionary[@"text"]]) {
                        [SaiSoundWaveView showMessage:contentDictionary[@"text"]];
                        
                    }
                }
            }
        });
    }];
}

- (void)connectingHeadphones{
    self.topLabel.text = @"已连接，正在进行初始化，请稍候...";
    self.headsetImageView.image = [UIImage imageNamed:@"launcher_icon_headset"];
    [self wearingHeadphonesDeal];  
}
#pragma mark -  Public Methods
#pragma mark -  Setters and Getters
- (dispatch_queue_t)timeQueue
{
    if (!_timeQueue) {
        _timeQueue = dispatch_queue_create("com.timer.soundai", DISPATCH_QUEUE_CONCURRENT);
    }
    return _timeQueue;
}
- (void)playPreloadedMp3{
    //1.获得音效文件的全路径
    int x = (arc4random() % 5)+1;
    NSString *source = [NSString stringWithFormat:@"ta_welcome%d.mp3",x];
     NSURL *url=[[NSBundle mainBundle] URLForResource:source withExtension:nil];

     //2.加载音效文件，创建音效ID（SoundID,一个ID对应一个音效文件）
     SystemSoundID soundID = 0;
     AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);

     //把需要销毁的音效文件的ID传递给它既可销毁
     //AudioServicesDisposeSystemSoundID(soundID);

    // 完成播放之后执行的soundCompleteCallback函数
     AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);

     //3.播放音效文件
     //下面的两个函数都可以用来播放音效文件，第一个函数伴随有震动效果
     AudioServicesPlayAlertSound(soundID);


}
void soundCompleteCallback()
{
    TYLog(@"%@",@"播放完成");

}

@end
