//
//  MSUpgradeProgressViewController.m
//  SoundAi
//
//  Created by silk on 2019/10/24.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "MSUpgradeProgressViewController.h"  
#import "CustomProgress.h"
@interface MSUpgradeProgressViewController ()

{
    CustomProgress *custompro;
    NSTimer *timer;
    int present;
}
@property (nonatomic ,strong) UILabel *promptLabel;

@end

@implementation MSUpgradeProgressViewController
#pragma mark -  Life Cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerNoti];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SaiNotificationCenter removeObserver:self];
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//    NSDictionary *paramDic = @{
//               @"userId":[WNUserLoginModel sharedWNUserLoginModel].userId,
//               @"productId":@"sai_minidot",
//               @"deviceSN":[WNPersonalDataModel sharedWNPersonalDataModel].currentSpeakersV2.runtimeInfo.deviceSN,
//               @"category":@"ota",
//               @"messageId":[NSString stringWithFormat:@"%@%@",[WNUserLoginModel sharedWNUserLoginModel].userId,[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000]],
//               @"params":@{
//                       @"domain":@"upgrade",
//                       @"operation":@"check",
//                       @"version":@"2.0.9",
//                       @"url":@"https://ota.soundai.cn/yg/minidot/update-2019082912.img",
//                       @"md5":@"a41cb5539fd96fd572428d649eb86123"
//               }
//                                          };
//           [QKBaseHttpClient httpType:POST andURL:updateFirmwareUrl andParam:paramDic andSuccessBlock:^(NSURL *URL, id data) {
//               TYLog(@"固件升级：%@",data);
//                       //发送订阅 OTA 通知
//               NSDictionary *dic = @{
//                   @"upgrade":[NSString stringWithFormat:@"azero/things/%@%@/task/notify",[WNPersonalDataModel sharedWNPersonalDataModel].currentSpeakersV2.productId,[WNPersonalDataModel sharedWNPersonalDataModel].currentSpeakersV2.runtimeInfo.deviceSN],
//                   @"progress":[NSString stringWithFormat:@"azero/things/%@%@/task/report",[WNPersonalDataModel sharedWNPersonalDataModel].currentSpeakersV2.productId,[WNPersonalDataModel sharedWNPersonalDataModel].currentSpeakersV2.runtimeInfo.deviceSN],
//                   @"version":@"2.0.9",
//                   @"url":@"https://ota.soundai.cn/yg/minidot/update-2019082912.img",
//                   @"md5":@"a41cb5539fd96fd572428d649eb86123",
//                   @"operation":@"trig"
//               };
//               [SaiNotificationCenter postNotificationName:SaiOTAUpgradeNoti object:nil userInfo:dic];
//               
//           } andFailBlock:^(NSURL *URL, NSError *error) {
//               TYLog(@"固件升级：%@",error);
//           }];
//    
//
//}
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
        
    }
    int stepValue = step.intValue;
    if (stepValue == -1) {//ota failed
        [SaiNotificationCenter postNotificationName:SaiOTAUpgradeCompleteNoti object:nil];
    }else if (stepValue == -2){// download failed
        [SaiNotificationCenter postNotificationName:SaiOTAUpgradeCompleteNoti object:nil];
    }else if (stepValue == -3){// md5 check failed
        [SaiNotificationCenter postNotificationName:SaiOTAUpgradeCompleteNoti object:nil];
    }else if (stepValue == -4){// write fialed
        [SaiNotificationCenter postNotificationName:SaiOTAUpgradeCompleteNoti object:nil];
    }else{//进度
        if (stepValue == 100) {//升级完成
            [SaiNotificationCenter postNotificationName:SaiOTAUpgradeCompleteNoti object:nil];
        }else{
            if (step.intValue<=100) {
                  [custompro setPresent:step.intValue];
              }
        }
    }
}
#pragma mark -  Button Callbacks
#pragma mark -  Private Methods
- (void)setupUI{
    [self sai_initTitleView:@"设备升级"];
    [self sai_initGoBackBlackButton];
    self.view.backgroundColor = SaiColor(251, 251, 251);
//    [self wr_setNavBarBackgroundAlpha:1.0];
//    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    custompro = [[CustomProgress alloc] initWithFrame:CGRectMake(10, 300, self.view.frame.size.width-20, 8)];
    custompro.centerY = self.view.centerY - 100;
    custompro.maxValue = 100;
    //设置背景色
    custompro.bgimg.backgroundColor = SaiColor(230, 230, 230);
    custompro.leftimg.backgroundColor = [UIColor redColor];
    //也可以设置图片
//    custompro.leftimg.image = [UIImage imageNamed:@"leftimg"];
//    custompro.bgimg.image = [UIImage imageNamed:@"bgimg"];
    //可以更改lab字体颜色
    custompro.presentlab.textColor = [UIColor redColor];
    [self.view addSubview:custompro];
    
    timer =[NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(timer)
                                           userInfo:nil
                                            repeats:YES];
    
    
    UIButton *button = [[UIButton alloc] init];  
    button.frame = CGRectMake(0, 0, 100, 44);
//    button.backgroundColor = []
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.frame = CGRectMake(0, CGRectGetMaxY(custompro.frame), ViewWidth, 12);
    promptLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:12.0f];
    promptLabel.textColor = SaiColor(153, 153, 153);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.text = @"正在下载升级包...";
    [self.view addSubview:promptLabel];
    self.promptLabel = promptLabel;
}
-(void)timer
{
    present++;
    if (present<=100) {
      
        [custompro setPresent:present];
  
    }else
    {

        [timer invalidate];
        timer = nil;
        present = 0;
        custompro.presentlab.text = @"";
        //[self addcontrol];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)registerNoti{
    [SaiNotificationCenter addObserver:self selector:@selector(otaUpgradeProgressNoti:) name:SaiOTAUpgradeProgressNoti object:nil];
}
#pragma mark -  Public Methods
#pragma mark -  Setters and Getters




@end
