//
//  SaiWalkingViewController.m
//  HeIsComing
//
//  Created by mike on 2020/3/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiWalkingViewController.h"
#import "SaiMotionView.h"
#import "CoreMotionManager.h"
#import "HealthKitManager.h"
@interface SaiWalkingViewController ()
@property(nonatomic,strong)UILabel *runnningLabel;
@property(nonatomic,strong)NSString *stepValue;
@property(nonatomic,strong)NSString *distanceValue;

@end

@implementation SaiWalkingViewController
#pragma mark - Lift Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor=kColorFromRGBHex(0x20232C);
    [self initView];
    [self getStepClickCallBack];
    [self getDistanceClickCallBack];
    blockWeakSelf;
    [super setResponseRenderTemplateStr:^(NSString * _Nonnull renderTemplateStr) {
        NSDictionary *diction=[SaiJsonConversionModel dictionaryWithJsonString:renderTemplateStr];
        TemplateTypeENUM templateTypet=[QKUITools returnTemplateFromRenderTemplateStr:diction[@"type"]];
        switch (templateTypet) {
            case WalkingTemplate:
                
            {
            }
                break;
                
                
            default:{
                [weakSelf jumpVC:YES renderTemplateStr:renderTemplateStr];
                
            }
                break;
        }
    }];
    //    [super setWalkDataBlock:^(NSString * _Nonnull type, NSString * _Nonnull content) {
    NSDictionary *dic = SaiContext.walkDiction;
    
    
    NSString *action = dic[@"action"];
    if ([action isEqualToString:@"QUERY_STEP_COUNT"]) {
        NSDictionary *walkDic=dic[@"walkFeedback"];
        NSString *walktitleString=walkDic[@"stepCount"];
        NSString *titleString=[NSString stringWithFormat:@"今日步数\n%@步",[QKUITools isBlankString:walktitleString]?@"0":walktitleString];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:titleString attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: kSCRATIO(15)],NSForegroundColorAttributeName: Color666666}];
        [string addAttributes:@{NSFontAttributeName: [[UIFont systemFontOfSize:kSCRATIO(55)]fontWithBold],NSForegroundColorAttributeName: UIColor.whiteColor} range:[titleString rangeOfString:[NSString stringWithFormat:@"%@",[QKUITools isBlankString:walktitleString]?@"0":walktitleString]]];
        weakSelf.runnningLabel.attributedText = string;
        SaiMotionView *speedView =[weakSelf.view viewWithTag:1000];
        speedView.numberLabel.text=[NSString stringWithFormat:@"%@",            [QKUITools isBlankString:walkDic[@"distance"]]?@"0":walkDic[@"distance"]
                                    ];
        SaiMotionView *speedView1 =[weakSelf.view viewWithTag:1001];
        speedView1.numberLabel.text=[NSString stringWithFormat:@"%@",            [QKUITools isBlankString:walkDic[@"calorie"]]?@"0":walkDic[@"calorie"]
                                     ];
    }
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self backAction];
    });
    
}
#pragma mark - Init Views
- (void)initView{
    UIImageView *runningImageView=[UIImageView new];
    runningImageView.image=[UIImage imageNamed:@"zl_img"];
    [self.view addSubview:runningImageView];
    [runningImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_offset(kSCRATIO(60)+kStatusBarHeight);
        make.width.height.mas_offset(kSCRATIO(309));
        
    }];
    UILabel *runnningLabel=[UILabel CreatLabeltext:@"" Font:[UIFont fontWithName:@"PingFang-SC-Medium" size:kSCRATIO(15)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    runnningLabel.numberOfLines=0;
    self.runnningLabel=runnningLabel;
    [runningImageView addSubview:runnningLabel];
    [runnningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kSCRATIO(60));
        make.centerX.equalTo(runningImageView);
        
    }];
    
    
    
    
    
    NSArray *imageArray=@[@"zl_icon_kilometre",@"zl_icon_kcal"];
    NSArray *numberArray=@[@"12'56",@"12'56"];
    
    NSArray *titleArray=@[@"公里",@"千卡"];
    
    for (int i=0; i<imageArray.count; i++) {
        SaiMotionView *speedView=[[SaiMotionView alloc]initWithFrame:CGRectMake(0, 0, KScreenW/2, kSCRATIO(120))];
        speedView.tag=i+1000;
        speedView.iconString=imageArray[i];
        speedView.numberString=numberArray[i];
        speedView.titleString=titleArray[i];
        [self.view addSubview:speedView];
        [speedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(KScreenW/2*i);
            make.width.mas_offset(KScreenW/2);
            make.top.equalTo(runningImageView.mas_bottom).offset(kSCRATIO(50));
            make.height.mas_offset(kSCRATIO(120));
            
        }];
    }
}
#pragma mark -  Button Callbacks

-(void)getStepClickCallBack{
    [[HealthKitManager sharedInstance] authorizeHealthKit:^(BOOL success, NSError *error) {
        if (success) {
            [[HealthKitManager sharedInstance] getStepCount:^(NSString *stepValue, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([QKUITools isBlankString:stepValue]) {
                        return ;
                    }
                    //                    NSString *titleString=[NSString stringWithFormat:@"今日步数\n%@步",stepValue];
                    //                    self.stepValue=stepValue;
                    //                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:titleString attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: kSCRATIO(15)],NSForegroundColorAttributeName: Color666666}];
                    //                    [string addAttributes:@{NSFontAttributeName: [[UIFont systemFontOfSize:kSCRATIO(55)]fontWithBold],NSForegroundColorAttributeName: UIColor.whiteColor} range:[titleString rangeOfString:stepValue]];
                    //                    self.runnningLabel.attributedText = string;
                    [self updata];
                });
            }];
        }else{
            [self showAlertViewAboutNotAuthorHealthKit];
        }
    }];
}
-(void)showAlertViewAboutNotAuthorHealthKit{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请授权健康权限"
                                          message:@"请在iPhone的\"设置-隐私-健康\"选项中,允许应用访问你的健康数据"
                                          preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        [self backAction];
        
    }];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)getDistanceClickCallBack{
    [[HealthKitManager sharedInstance] authorizeHealthKit:^(BOOL success, NSError * _Nonnull error) {
        if (success) {
            [[HealthKitManager sharedInstance]getDistanceCount:^(NSString * _Nonnull distanceValue, NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                      SaiMotionView *speedView =[self.view viewWithTag:1000];
                    //                     speedView.numberLabel.text=distanceValue;
                    self.distanceValue=distanceValue;
                    //                      SaiMotionView *speedView1 =[self.view viewWithTag:1001];
                    //                      speedView1.numberLabel.text=[NSString stringWithFormat:@"%.2f",[distanceValue doubleValue]*80*1.036];
                    [self updata];
                });
            }];
        }else{
            [self showAlertViewAboutNotAuthorHealthKit];
            
        }
    }];
}
-(void)updata{
    if ([QKUITools isBlankString:self.distanceValue]) {
        return;
    }
    if ([QKUITools isBlankString:self.stepValue]) {
        return;
    }
    
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerUploadWalkSensorDataWithCalorie:[NSNumber numberWithDouble:[self.distanceValue doubleValue]*80*1.036] andDistance:[NSNumber numberWithDouble:[self.distanceValue doubleValue]*1000] andStepCount:[NSNumber numberWithString:self.stepValue]];
}

@end
