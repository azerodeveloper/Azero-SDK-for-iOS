//
//  SaiMotionViewController.m
//  HeIsComing
//
//  Created by mike on 2020/3/26.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiMotionViewController.h"
#import <HealthKit/HealthKit.h>
#import "HealthKitManager.h"
#import "SaiMotionView.h"
#import "CoreMotionManager.h"
#import "ZXCTimer.h"

#define  kcalUnit 1.036
#define  weight 80

@interface SaiMotionViewController ()<CAAnimationDelegate>
@property (nonatomic, strong) NSTimer *animationTimer;

@property (nonatomic, assign) BOOL finishCountDown;

@property (nonatomic, strong) HKHealthStore *healthStore;

// cover
@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) UIImageView *numberImageView;

@property (nonatomic, strong) UIButton *pauseBtn;

@property (nonatomic, strong) UIButton *resumeBtn;

@property (nonatomic, strong) UIButton *stopBtn;

@property (nonatomic, strong) id timer;

//当前步数
@property (nonatomic,assign) NSInteger currentStepCount;
//当前距离
@property (nonatomic,assign) double currentDistance;

@property(nonatomic,strong)UILabel *distanceLabel ;


@end

@implementation SaiMotionViewController

#pragma mark - Lift Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor=UIColor.blackColor;
    [self initView];
    
    [self.view addSubview:self.stopBtn];
    [self.view addSubview:self.resumeBtn];
    [self.view addSubview:self.pauseBtn];
    [self.pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(kSCRATIO(-45)-BOTTOM_HEIGHT);
        make.width.mas_offset(kSCRATIO(100));
        make.height.mas_offset(kSCRATIO(120));
        make.centerX.equalTo(self.view);
    }];
    [self.stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(kSCRATIO(-45)-BOTTOM_HEIGHT);
        make.width.mas_offset(kSCRATIO(100));
        make.height.mas_offset(kSCRATIO(120));
        make.right.mas_offset(kSCRATIO(-48.5));
        
    }];
    [self.resumeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(kSCRATIO(-45)-BOTTOM_HEIGHT);
        make.width.mas_offset(kSCRATIO(100));
        make.height.mas_offset(kSCRATIO(120));
        make.left.mas_offset(kSCRATIO(48.5));
    }];
    [self initCoverView];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kIsPause"]) {
        [self pauseBtnClickCallBack];
        SaiMotionView *speedView=[self.view viewWithTag:1001];
        speedView.numberString=[QKUITools timeFormatted:SaiContext.currentTime];
    }
    blockWeakSelf;
    
    [super setGetDataBlock:^(NSString * _Nonnull type, NSString * _Nonnull content) {
        NSDictionary *dic = [SaiJsonConversionModel dictionaryWithJsonString:content];
        NSString *action = dic[@"action"];
        if ([action isEqualToString:@"pause"]) {
            
            [weakSelf pauseBtnClickCallBack];
            
        }else if ([action isEqualToString:@"finish"]){
            
            [weakSelf stopBtnClickCallBack];
        }
        else if ([action isEqualToString:@"resume"]||[action isEqualToString:@"begin"]){
            [weakSelf resumeBtnClickCallBack];
        }
        if ([dic containsObjectForKey:@"runFeedback"]) {
            NSDictionary *runDic=dic[@"runFeedback"];
            NSString *distance=runDic[@"distance"];
            weakSelf.distanceLabel.text=[QKUITools isBlankString:[NSString stringWithFormat:@"%@",runDic[@"distance"]]]?@"0":[NSString stringWithFormat:@"%.2f",[distance doubleValue]/100];
            SaiMotionView *speedView1=[weakSelf.view viewWithTag:1000];
            speedView1.numberString=[QKUITools isBlankString:[NSString stringWithFormat:@"%@",runDic[@"distribution"]]]?@"0":[NSString stringWithFormat:@"%@",runDic[@"distribution"]];
            SaiMotionView *speedView=[weakSelf.view viewWithTag:1002];
            speedView.numberString=[QKUITools isBlankString:[NSString stringWithFormat:@"%@",runDic[@"calorie"]]]?@"0":[NSString stringWithFormat:@"%@",runDic[@"calorie"]];
        }
    }];
    [super setResponseRenderTemplateStr:^(NSString * _Nonnull renderTemplateStr) {
        NSDictionary *diction=[SaiJsonConversionModel dictionaryWithJsonString:renderTemplateStr];
        TemplateTypeENUM templateTypet=[QKUITools returnTemplateFromRenderTemplateStr:diction[@"type"]];
        switch (templateTypet) {
            case RunningTemplate:
            {
            }
                break;
                
                
            default:{
                [weakSelf jumpVC:YES renderTemplateStr:renderTemplateStr];
                
            }
                break;
        }
    }];
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _number = 3;
    [[HealthKitManager sharedInstance] authorizeHealthKit:^(BOOL success, NSError *error) {
        if (success) {
            [self getCurrentStepCountAndDistanceAndKcal:60];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kIsPause"]) {
                    [_coverView removeFromSuperview];
                    _numberImageView = nil;
                    _coverView = nil;
                    [self pauseBtnClickCallBack];
                    return ;
                }
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kIsStart"]) {
                    [_coverView removeFromSuperview];
                    _numberImageView = nil;
                    _coverView = nil;
                    [self startTimer];
                    
                    return;
                }else{
                    [self initAnimationTimer];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kIsStart"];
                    
                }
            });
            
        }else{
            [self showAlertViewAboutNotAuthorHealthKit];
            
        }
    }];
    
}

#pragma mark - Init Views
- (void)initView{
    UIImageView *runningImageView=[UIImageView new];
    runningImageView.image=[UIImage imageNamed:@"pb_icon_run"];
    [self.view addSubview:runningImageView];
    [runningImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(20));
        make.top.mas_offset(kSCRATIO(3.5)+kStatusBarHeight);
        make.width.mas_offset(kSCRATIO(22));
        make.height.mas_offset(kSCRATIO(24));
        
    }];
    UILabel *runnningLabel=[UILabel CreatLabeltext:@"跑步中" Font:[UIFont fontWithName:@"PingFang-SC-Bold" size:kSCRATIO(12)] Textcolor:UIColor.whiteColor textAlignment:0];
    [self.view addSubview:runnningLabel];
    [runnningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(runningImageView.mas_right).offset(kSCRATIO(5));
        make.centerY.equalTo(runningImageView);
        make.height.mas_offset(kSCRATIO(12));
        
    }];
    NSString * currentDistanceString  =  [[NSUserDefaults standardUserDefaults]objectForKey:[QKUITools getNowyyyymmdd]];
    self.currentDistance=[currentDistanceString doubleValue];
    SaiContext.currentDistance=[NSString stringWithFormat:@"%.2f",self.currentDistance];
    
    _distanceLabel=[UILabel CreatLabeltext:@"0.0" Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(80)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_distanceLabel];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kSCRATIO(105)+kStatusBarHeight);
        make.centerX.equalTo(self.view);
        make.height.mas_offset(kSCRATIO(107));
        
    }];
    UILabel *distanceTitleLabel=[UILabel CreatLabeltext:@"距离" Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(15)] Textcolor:Color999999 textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:distanceTitleLabel];
    [distanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_distanceLabel.mas_bottom).offset(kSCRATIO(12));
        make.centerX.equalTo(self.view);
        make.height.mas_offset(kSCRATIO(14));
        
    }];
    NSArray *imageArray=@[@"pb_icon_speed",@"pb_icon_time",@"pb_icon_kcal"];
    NSArray *numberArray=@[@"--",@"00:00:00",@"0"];
    
    NSArray *titleArray=@[@"配速",@"用时",@"千卡"];
    
    for (int i=0; i<3; i++) {
        SaiMotionView *speedView=[[SaiMotionView alloc]initWithFrame:CGRectMake(0, 0, KScreenW/3, kSCRATIO(120))];
        speedView.tag=i+1000;
        speedView.iconString=imageArray[i];
        speedView.numberString=numberArray[i];
        speedView.titleString=titleArray[i];
        [self.view addSubview:speedView];
        [speedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(KScreenW/3*i);
            make.width.mas_offset(KScreenW/3);
            make.top.equalTo(distanceTitleLabel.mas_bottom).offset(kSCRATIO(86));
            make.height.mas_offset(kSCRATIO(120));
            
        }];
    }
    
}
- (void)initAnimationTimer{
    _animationTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(showCountDownAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
}
- (void)initCoverView{
    CGFloat centerX = self.view.center.x;
    CGFloat centerY = self.view.center.y;
    
    CGFloat oriCoverX = centerX - 500;
    CGFloat oriCoverY = centerY - 500;
    
    _coverView = [[UIImageView alloc] initWithFrame:CGRectMake(oriCoverX, oriCoverY, 1000, 1000)];
    _coverView.backgroundColor = SaiColor(32, 35, 44);
    _coverView.layer.cornerRadius = 500;
    _coverView.layer.masksToBounds = YES;
    [self.view addSubview:_coverView];
    
    CGFloat oriNumberX = 500 - 25;
    CGFloat oriNumberY = 500 - (self.view.frame.size.height/2) + 150;
    _numberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(oriNumberX, oriNumberY, kSCRATIO(104), kSCRATIO(150))];
    _numberImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_coverView addSubview:_numberImageView];
    [_numberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_coverView);
        make.width.mas_offset(kSCRATIO(100));
        make.height.mas_offset(kSCRATIO(100));
    }];
}
- (void)showShrinkCoverAnimation{
    CGFloat oriX = self.view.frame.size.width / 2;
    CGFloat oriY = (self.view.frame.size.height - 200) + 35 + 45;
    
    CABasicAnimation *positionAni = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAni.toValue = [NSValue valueWithCGPoint:CGPointMake(oriX, oriY)];
    positionAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *scaleAni = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform = CATransform3DMakeScale(0.09, 0.09, 1.0);
    scaleAni.toValue = [NSValue valueWithCATransform3D:transform];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.animations = @[positionAni, scaleAni];
    group.duration = 0.5;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    [_coverView.layer addAnimation:group forKey:@"shrink"];
}
#pragma mark - Animation
// 执行倒计时动画的计时器
- (void)showCountDownAnimation{
    _numberImageView.image =[UIImage imageNamed:[NSString stringWithFormat:@"pb_img_%@", [NSNumber numberWithInteger:_number]]];
    
    if (_number <= 0) {
        [_animationTimer invalidate];
        _animationTimer = nil;
    }
    _number--;
    
    CABasicAnimation *positionAni = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAni.toValue = [NSValue valueWithCGPoint:CGPointMake(500, 500)];
    positionAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *opacityAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAni.toValue = [NSNumber numberWithFloat:1.0];
    opacityAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *scaleAni = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform = CATransform3DMakeScale(2.0, 2.0, 1.0);
    scaleAni.toValue = [NSValue valueWithCATransform3D:transform];
    scaleAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *group  = [CAAnimationGroup animation];
    
    if (_number < 0) {
        group.delegate = self;
        
        _finishCountDown = YES;
    }
    group.animations = @[positionAni, opacityAni, scaleAni];
    group.duration = 0.9;
    group.fillMode = kCAFillModeRemoved;
    group.removedOnCompletion = YES;
    
    [_numberImageView.layer addAnimation:group forKey:@"countdown"];
    
    
}
#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (![anim isKindOfClass:CAAnimationGroup.class]) {
        return;
    }
    
    if (_finishCountDown) {
        _finishCountDown = NO;
        [self showShrinkCoverAnimation];
    }
    else{
        [_coverView removeFromSuperview];
        //        [self.navigationController setNavigationBarHidden:NO animated:YES];
        _numberImageView = nil;
        _coverView = nil;
        
        [self startTimer];
    }
}

#pragma mark - Method
-(void)updata{
    if ([QKUITools isBlankString:[NSString stringWithFormat:@"%f",self.currentDistance]]) {
        return;
    }
    if ([QKUITools isBlankString:[NSString stringWithFormat:@"%@",SaiContext.startTime]]) {
        return;
    }
    if ([QKUITools isBlankString:[NSString stringWithFormat:@"%d",SaiContext.currentTime]]) {
        return;
    }
//        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerUploadRunWithCalorie:[NSNumber numberWithDouble:5*80*1.036] andDistance:[NSNumber numberWithDouble:5*1000] andDuration:[NSNumber numberWithInt:SaiContext.currentTime] andStartTime:[NSNumber numberWithString:SaiContext.startTime] andEndTime:[NSNumber numberWithInt:0]];
    
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerUploadRunWithCalorie:[NSNumber numberWithDouble:self.currentDistance*80*1.036] andDistance:[NSNumber numberWithDouble:self.currentDistance*1000] andDuration:[NSNumber numberWithInt:SaiContext.currentTime] andStartTime:[NSNumber numberWithString:SaiContext.startTime] andEndTime:[NSNumber numberWithInt:0]];
    
}
-(void)startTimer{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self backAction];
        [self updata];
    });
    SaiContext.startTime=[QKUITools getNowTimeStamp];
    if (!SaiContext.timerQueueItem) {
        SaiContext.timerQueueItem= [[ZXCTimer shareInstance]addCycleTask:^{
            SaiMotionView *speedView=[self.view viewWithTag:1001];
            SaiContext.currentTime++;
            speedView.numberString=[QKUITools timeFormatted:SaiContext.currentTime];
            
        } timeInterval:1];
    }else{
        [SaiContext.timerQueueItem begin];
        [SaiContext.queueItem begin];
        SaiContext.timerQueueItem.callBack = ^{
            SaiMotionView *speedView=[self.view viewWithTag:1001];
            
            SaiContext.currentTime++;
            
            speedView.numberString=[QKUITools timeFormatted:SaiContext.currentTime];
        };
    }
    if (SaiContext.queueItem) {
        SaiContext.queueItem.callBack = ^{
            [self updata];
        };
        
    }else{
        SaiContext.queueItem =  [[ZXCTimer shareInstance]addCycleTask:^{
            [self updata];
        } timeInterval:30 runCount:-1 threadMode:ZXCBackgroundThread] ;
        
    }
    
}

- (void)pauseBtnClickCallBack{
    [SaiContext.timerQueueItem pause];
    [SaiContext.queueItem pause];
    
    [[CoreMotionManager sharedInstance] stopGetDistance];
    _resumeBtn.alpha = 1;
    _stopBtn.alpha = 1;
    
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.pauseBtn.alpha = 0;
    } completion:^(BOOL finish){
        
    }];
}
- (void)resumeBtnClickCallBack{
    
    [self startTimer];
    
    self.currentDistance=[_distanceLabel.text doubleValue];
    SaiContext.currentDistance=[NSString stringWithFormat:@"%.2f",self.currentDistance];
    [self getCurrentStepCountAndDistanceAndKcal:60];
    
    
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.pauseBtn.alpha = 1;
        self.resumeBtn.alpha = 0;
        self.stopBtn.alpha = 0;
        
    } completion:^(BOOL finish){
        
    }];
}

- (void)stopBtnClickCallBack{
    
    SaiContext.currentTime=0;
    [[ZXCTimer shareInstance]removeCycleTask:SaiContext.timerQueueItem];
    [[ZXCTimer shareInstance]removeCycleTask:SaiContext.queueItem];
    [self backAction];
}

#pragma mark - 获取步数
- (void)stepBtnClick{
    [[HealthKitManager sharedInstance] authorizeHealthKit:^(BOOL success, NSError *error) {
        if (success) {
            [[HealthKitManager sharedInstance] getStepCount:^(NSString *stepValue, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            }];
        }else{
            [self showAlertViewAboutNotAuthorHealthKit];
            
            TYLog(@"=======%@", error.domain);
        }
    }];
}
//获取距离
- (void)distanceBtnClick{
//    blockWeakSelf;
    [[HealthKitManager sharedInstance] authorizeHealthKit:^(BOOL success, NSError *error) {
        if (success) {
            [[HealthKitManager sharedInstance] getDistanceCount:^(NSString *distancepValue, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    weakSelf.distanceLabel.text=distancepValue;
                    SaiMotionView *speedView=[self.view viewWithTag:1002];
                    speedView.numberString=[NSString stringWithFormat:@"%.2f",weight*[distancepValue doubleValue]*kcalUnit];
                    self.currentDistance=[distancepValue doubleValue];
                    SaiContext.currentDistance=[NSString stringWithFormat:@"%.2f",self.currentDistance];
                    
                    
                });
            }];
            
        }else{
            [self showAlertViewAboutNotAuthorHealthKit];
            
        }
    }];
}

#pragma mark - 瞬时步数+公里+卡路里
- (void)getCurrentStepCountAndDistanceAndKcal:(double)weightValue{
    blockWeakSelf;
    [[CoreMotionManager sharedInstance] authorizeCoreMotion:^(BOOL success, NSError * _Nonnull error) {
        if(!success){
            
        }else{
            [[CoreMotionManager sharedInstance] isOpenCoreMotion:^(BOOL success) {
                if(success){
                    [[CoreMotionManager sharedInstance] getCurrentStepCountAndDistance:^(NSString * _Nonnull stepValue, NSString * _Nonnull distanceValue, NSError * _Nonnull error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            TYLog(@"%@",[NSString stringWithFormat:@"距离：%.2f公里",
                                         (self.currentDistance+[distanceValue doubleValue])/1000.0f]);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //                                weakSelf.distanceLabel.text=[NSString stringWithFormat:@"%.2f",
                                //                                                             self.currentDistance+[distanceValue doubleValue]/1000.0f];
                                [[NSUserDefaults standardUserDefaults ]setValue:[NSString stringWithFormat:@"%.2f",
                                                                                 self.currentDistance+[distanceValue doubleValue]/1000.0f] forKey:[QKUITools getNowyyyymmdd]];
                                SaiMotionView *speedView1=[self.view viewWithTag:1000];
                                if (self.currentDistance>0) {
                                    speedView1.numberString=[QKUITools timeFormattedWithMMSS:SaiContext.currentTime/self.currentDistance];
                                }
                                SaiMotionView *speedView=[self.view viewWithTag:1002];
                                speedView.numberString=[NSString stringWithFormat:@"%.2f",weight*[weakSelf.distanceLabel.text doubleValue]*kcalUnit];
                                [self updata];
                                
                                
                                
                            });
                            
                            
                        });
                        
                    }];
                }else{
                    [self showAlertViewAboutNotAuthorHealthKit];
                    TYLog(@"运动与健身关闭了");
                }
                
            }];
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
#pragma mark -  Setters and Getters
-(UIButton *)pauseBtn{
    if (!_pauseBtn) {
        _pauseBtn=[UIButton CreatButtontext:@"暂停" image:[UIImage imageNamed:@"pb_btn_stop"] Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(16)] Textcolor:  UIColor.whiteColor];
        [_pauseBtn addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [[SaiAzeroManager sharedAzeroManager]saiAzeroManagerSentTxet:@"暂停跑步"];
            
        }]];
        _pauseBtn.frame=CGRectMake(0, 0, kSCRATIO(120), kSCRATIO(100));
        [_pauseBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyle_Top imageTitleSpace:kSCRATIO(10)];
    }
    return _pauseBtn;
}
-(UIButton *)resumeBtn{
    if (!_resumeBtn) {
        _resumeBtn=[UIButton CreatButtontext:@"继续" image:[UIImage imageNamed:@"pb_btn_continue"] Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(16)] Textcolor:  UIColor.whiteColor];
        [_resumeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [[SaiAzeroManager sharedAzeroManager]saiAzeroManagerSentTxet:@"继续跑步"];
            
        }]];
        //        [_resumeBtn addTarget:self action:@selector(resumeBtnClickCallBack) forControlEvents:UIControlEventTouchUpInside];
        _resumeBtn.frame=CGRectMake(0, 0, kSCRATIO(120), kSCRATIO(100));
        [_resumeBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyle_Top imageTitleSpace:kSCRATIO(10)];
        _resumeBtn.alpha=0;
        
    }
    return _resumeBtn;
}
-(UIButton *)stopBtn{
    if (!_stopBtn) {
        _stopBtn=[UIButton CreatButtontext:@"长按结束" image:[UIImage imageNamed:@"pb_btn_end"] Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(16)] Textcolor:  UIColor.whiteColor];
        _stopBtn.frame=CGRectMake(0, 0, kSCRATIO(120), kSCRATIO(100));
        UILongPressGestureRecognizer * longPress=   [[UILongPressGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [[SaiAzeroManager sharedAzeroManager]saiAzeroManagerSentTxet:@"结束跑步"];
        }];
        longPress.minimumPressDuration=3;
        [_stopBtn addGestureRecognizer:longPress];
        [_stopBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyle_Top imageTitleSpace:kSCRATIO(10)];
        _stopBtn.alpha=0;
    }
    return _stopBtn;
}


@end
