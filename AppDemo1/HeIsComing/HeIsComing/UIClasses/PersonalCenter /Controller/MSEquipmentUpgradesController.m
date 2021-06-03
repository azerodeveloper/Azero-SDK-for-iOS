//
//  MSEquipmentUpgradesController.m
//  WuNuo
//
//  Created by silk on 2019/8/2.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "MSEquipmentUpgradesController.h"
#import "CustomProgress.h"

#define updateFirwareLabelY     100
#define newVersionY             20
#define currentVersionY          47
#define upgradeImmediatelyY       83
#define upgradeImmediatelyButtonX       20
@interface MSEquipmentUpgradesController ()
@property (nonatomic ,strong) UIButton *sureButton;
@property (nonatomic ,strong) CustomProgress *custompro;
@property (nonatomic ,strong) UILabel *promptLabel;

@end

@implementation MSEquipmentUpgradesController
#pragma mark -  Life Cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self registerNoti];
    [self getUpdateProgress];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SaiNotificationCenter postNotificationName:SaiOTAUpgradeCompleteNoti object:nil];
    [SaiNotificationCenter removeObserver:self];  
}
#pragma mark -  UITableViewDelegate
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Methods
- (void)otaUpgradeProgressNoti:(NSNotification *)noti{  
    NSDictionary *dict = noti.userInfo;
    NSDictionary *params = dict[@"params"];
    NSString *step = params[@"step"];
    NSString *desc = params[@"desc"];
    if ([desc isEqualToString:@"off"]) { //没有在升级
        [SaiNotificationCenter postNotificationName:SaiOTAUpgradeCompleteNoti object:nil];
    }else{ //升级中
        self.sureButton.hidden = YES;
        self.custompro.hidden = NO;
        self.promptLabel.hidden = NO;
    }
    int stepValue = step.intValue;
    if (stepValue == -1) {//ota failed
        [SaiNotificationCenter postNotificationName:SaiOTAUpgradeCompleteNoti object:nil];
        self.promptLabel.text = @"升级失败，请稍后重试";
    }else if (stepValue == -2){// download failed
        [SaiNotificationCenter postNotificationName:SaiOTAUpgradeCompleteNoti object:nil];
        self.promptLabel.text = @"升级失败，请稍后重试";
    }else if (stepValue == -3){// md5 check failed
        [SaiNotificationCenter postNotificationName:SaiOTAUpgradeCompleteNoti object:nil];
        self.promptLabel.text = @"升级失败，请稍后重试";
    }else if (stepValue == -4){// write fialed
        [SaiNotificationCenter postNotificationName:SaiOTAUpgradeCompleteNoti object:nil];
        self.promptLabel.text = @"升级失败，请稍后重试";
    }else{//进度
        if (stepValue == 100) {//升级完成
            [SaiNotificationCenter postNotificationName:SaiOTAUpgradeCompleteNoti object:nil];
            [self.custompro setPresent:stepValue];
            self.promptLabel.text = @"升级完成";
            TYLog(@"固件已升级完成 %@",[NSData data]);
            JySaiAlertView *alertView = [[JySaiAlertView alloc] initMessageWithTitle:@"提示" message:@"固件已经升级完成" OKButtonText:@"确定" cancelButtonText:nil otherBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } cancelBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertView show];
        }else{
            if (stepValue<=100) {
                  [self.custompro setPresent:stepValue];
              }
        }
    }
}
#pragma mark -  Button Callbacks
- (void)loginButtonClickCallBack:(UIButton *)button{
    if (![QKUITools networkReachable]) {
        [SaiHUDTools showError:@"网络错误,请检查网络设置"]; 
        return;
    }
    JySaiAlertView *alertView = [[JySaiAlertView alloc] initMessageWithTitle:@"提示" message:@"发送设备升级指令" OKButtonText:@"确定" cancelButtonText:@"取消" otherBlock:^{
        switch (self.deviceType) {
            case SpeakersDeviceTypeMiniDot:
                [self upgradeMiniDot];
                break;
            case SpeakersDeviceTypeMiniPod:
                [self upgradeMiniPod];
                break;
            default:
                
                break;
        }
        
        
    } cancelBlock:^{
    }];
    [alertView show];
}
#pragma mark -  Private Methods
- (void)setupUI{
    [self sai_initTitleView:@"设备升级"]; 
    [self sai_initGoBackBlackButton];
    UILabel *updateFirwareLabel = [[UILabel alloc] init];
    if (Sai_iPhoneX||Sai_iPhoneXS||Sai_iPhoneXsXrMax) {
        updateFirwareLabel.frame = CGRectMake(0, 88+updateFirwareLabelY, ViewWidth, 20);
    }else{
        updateFirwareLabel.frame = CGRectMake(0, 64+updateFirwareLabelY, ViewWidth, 20);
    }
    updateFirwareLabel.text = @"发现新固件";
    updateFirwareLabel.textAlignment = NSTextAlignmentCenter;
    updateFirwareLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:20];
    [self.view addSubview:updateFirwareLabel];
    UILabel *newVersionLabel = [[UILabel alloc] init];
    newVersionLabel.frame = CGRectMake(0, CGRectGetMaxY(updateFirwareLabel.frame)+newVersionY, ViewWidth, 17.0f);
    newVersionLabel.textAlignment = NSTextAlignmentCenter;
    newVersionLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0f];
    newVersionLabel.text = self.versionInformationModel.FirmwareVersion;
    [self.view addSubview:newVersionLabel];
    UILabel *currentVersionLabel = [[UILabel alloc] init];
    currentVersionLabel.frame = CGRectMake(0, CGRectGetMaxY(newVersionLabel.frame)+currentVersionY, ViewWidth, 17.0f);
    currentVersionLabel.textAlignment = NSTextAlignmentCenter;
    currentVersionLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0f];
    currentVersionLabel.text = [NSString stringWithFormat:@"当前版本：%@",[UserInfoContext sharedContext].currentSpeakersV2.runtimeInfo.firmwareVersion];
    currentVersionLabel.textColor = SaiColor(153, 153, 153);
    [self.view addSubview:currentVersionLabel];
    UIButton *upgradeImmediatelyButton = [[UIButton alloc] init];
    upgradeImmediatelyButton.frame = CGRectMake(upgradeImmediatelyButtonX, CGRectGetMaxY(currentVersionLabel.frame)+upgradeImmediatelyY, ViewWidth-upgradeImmediatelyButtonX*2, 44);
    [upgradeImmediatelyButton setTitle:@"立即升级" forState:UIControlStateNormal];
    [upgradeImmediatelyButton setBackgroundImage:[UIImage resizedImageWithName:@"login_bt_caertain_d"] forState:UIControlStateDisabled];
    [upgradeImmediatelyButton setBackgroundImage:[UIImage resizedImageWithName:@"logonbg_red"] forState:UIControlStateNormal];
    [upgradeImmediatelyButton setBackgroundImage:[UIImage resizedImageWithName:@"logonbg_red"] forState:UIControlStateHighlighted];
    upgradeImmediatelyButton.titleLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:18.0];
    upgradeImmediatelyButton.layer.masksToBounds = YES;
    upgradeImmediatelyButton.layer.cornerRadius = 22.0f;
    [upgradeImmediatelyButton addTarget:self action:@selector(loginButtonClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upgradeImmediatelyButton];
    self.sureButton = upgradeImmediatelyButton;
    
    CustomProgress * custompro = [[CustomProgress alloc] initWithFrame:CGRectMake(20, 300, self.view.frame.size.width-40, 10)];
    custompro.centerY = CGRectGetMaxY(currentVersionLabel.frame)+upgradeImmediatelyY;
    custompro.maxValue = 100;
    custompro.bgimg.backgroundColor = SaiColor(230, 230, 230);
    custompro.leftimg.backgroundColor =[UIColor redColor];
        //也可以设置图片
    //    custompro.leftimg.image = [UIImage imageNamed:@"leftimg"];
    //    custompro.bgimg.image = [UIImage imageNamed:@"bgimg"];
        //可以更改lab字体颜色
    custompro.presentlab.textColor = [UIColor redColor];
    [self.view addSubview:custompro];
    custompro.hidden = YES;
    self.custompro = custompro;
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.frame = CGRectMake(0, CGRectGetMaxY(custompro.frame)+11, ViewWidth, 12);
    promptLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:12.0f];
    promptLabel.textColor = SaiColor(153, 153, 153);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.text = @"正在下载升级包...";
    [self.view addSubview:promptLabel];
    promptLabel.hidden = YES;
    self.promptLabel = promptLabel;
}
- (void)upgradeMiniDot{
//    if ([[WNPersonalDataModel sharedWNPersonalDataModel].currentSpeakersV2.runtimeInfo.firmwareVersion intValue]>=[@"2019090710" intValue]) {//新版本
//        NSDictionary *paramDic = @{
//            @"userId":[WNUserLoginModel sharedWNUserLoginModel].userId,
//            @"productId":@"sai_minidot",
//            @"deviceSN":[WNPersonalDataModel sharedWNPersonalDataModel].currentSpeakersV2.runtimeInfo.deviceSN,
//            @"category":@"ota",
//            @"messageId":[NSString stringWithFormat:@"%@%@",[WNUserLoginModel sharedWNUserLoginModel].userId,[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000]],
//            @"params":@{
//                    @"domain":@"upgrade",
//                    @"operation":@"trig",
//                    @"version":self.versionInformationModel.FirmwareVersion,
//                    @"url":self.versionInformationModel.url,
//                    @"md5":self.versionInformationModel.md5sum
//            }
//                                       };
//        [QKBaseHttpClient httpType:POST andURL:updateFirmwareUrl andParam:paramDic andSuccessBlock:^(NSURL *URL, id data) {
//            self.sureButton.enabled = NO;
//            TYLog(@"固件升级：%@",data);
//                    //发送订阅 OTA 通知
//            NSDictionary *dic = @{
//                @"upgrade":[NSString stringWithFormat:@"azero/things/%@%@/task/notify",[WNPersonalDataModel sharedWNPersonalDataModel].currentSpeakersV2.productId,[WNPersonalDataModel sharedWNPersonalDataModel].currentSpeakersV2.runtimeInfo.deviceSN],
//                @"progress":[NSString stringWithFormat:@"azero/things/%@%@/task/report",[WNPersonalDataModel sharedWNPersonalDataModel].currentSpeakersV2.productId,[WNPersonalDataModel sharedWNPersonalDataModel].currentSpeakersV2.runtimeInfo.deviceSN],
//                @"version":self.versionInformationModel.FirmwareVersion,
//                @"url":self.versionInformationModel.url,
//                @"md5":self.versionInformationModel.md5sum,
//                @"operation":@"trig"
//            };
//            [SaiNotificationCenter postNotificationName:SaiOTAUpgradeNoti object:nil userInfo:dic];
//            self.sureButton.hidden = YES;
//            self.custompro.hidden = NO;
//            self.promptLabel.hidden = NO;
//        } andFailBlock:^(NSURL *URL, NSError *error) {
//            TYLog(@"固件升级：%@",error);
//        }];
//    }else{
        //发送更新固件指令到音箱端
        NSDictionary *paramDic = @{@"deviceId":[UserInfoContext sharedContext].currentSpeakersV2.deviceId,
                                   @"userId":[UserInfoContext sharedContext].currentUser.userId,
                                   @"url":self.versionInformationModel.url,
                                   @"code":self.versionInformationModel.md5sum
                                   };
        [QKBaseHttpClient httpType:POST andURL:updateFirmwareBeforeUrl andParam:paramDic andSuccessBlock:^(NSURL *URL, id data) {
            TYLog(@"data: %@",data);
            NSString *code = data[@"code"];
            if (code.intValue == 200) {
                self.sureButton.enabled = NO;
                [XNHUD showWithTitle:@"升级指令已发送"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [XNHUD dismiss];
                });
            }
        } andFailBlock:^(NSURL *URL, NSError *error) {

        }];
//    }
}
- (void)upgradeMiniPod{
    NSDictionary *paramDic = @{@"deviceId":[UserInfoContext sharedContext].currentSpeakersV2.deviceId,
                               @"userId":[UserInfoContext sharedContext].currentUser.userId,
                               @"url":self.versionInformationModel.url,
                               @"code":self.versionInformationModel.md5sum
                               };
    [QKBaseHttpClient httpType:POST andURL:updateFirmwareBeforeUrl andParam:paramDic andSuccessBlock:^(NSURL *URL, id data) {
        TYLog(@"data: %@",data);
        NSString *code = data[@"code"];
       if (code.intValue == 200) {
           self.sureButton.enabled = NO;
           [XNHUD showWithTitle:@"升级指令已发送"];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [XNHUD dismiss];
           });
       }
    } andFailBlock:^(NSURL *URL, NSError *error) {
        
    }];
}
- (void)getUpdateProgress{
    NSDictionary *dic = @{
        @"upgrade":[NSString stringWithFormat:@"azero/things/%@%@/task/notify",[UserInfoContext sharedContext].currentSpeakersV2.productId,[UserInfoContext sharedContext].currentSpeakersV2.runtimeInfo.deviceSN],
        @"progress":[NSString stringWithFormat:@"azero/things/%@%@/task/report",[UserInfoContext sharedContext].currentSpeakersV2.productId,[UserInfoContext sharedContext].currentSpeakersV2.runtimeInfo.deviceSN],
        @"version":self.versionInformationModel.FirmwareVersion,
        @"url":self.versionInformationModel.url,
        @"md5":self.versionInformationModel.md5sum,
        @"operation":@"check"
    };
    [SaiNotificationCenter postNotificationName:SaiOTAUpgradeNoti object:nil userInfo:dic];
}
#pragma mark -  Public Methods
- (void)registerNoti{
    [SaiNotificationCenter addObserver:self selector:@selector(otaUpgradeProgressNoti:) name:SaiOTAUpgradeProgressNoti object:nil];
}
#pragma mark -  Setters and Getters

@end
