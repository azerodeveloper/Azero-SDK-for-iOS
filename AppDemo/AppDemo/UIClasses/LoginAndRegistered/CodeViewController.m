//
//  CodeViewController.m
//  HeIsComing
//
//  Created by mike on 2020/3/24.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "CodeViewController.h"
#import "HWTFCodeView.h"         // 基础版 - 下划线
#import "RootUser.h"
#import "BaseNC.h"
#import "MessageAlertView.h"
#import "AwemeListViewController.h"
#import "AppDelegate.h"

@interface CodeViewController ()
@property (nonatomic, strong) id timer;

@end

@implementation CodeViewController
{
    __block  UIButton * codeButton;
    __block    UILabel *errorLabel;
    
}
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self countdownClickCallBack];
    
}
-(void)setupUI{
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = Color222B36;;
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(0, 0, ScreenWidth, kSCRATIO(176)+kStatusBarHeight);
    bgImageView.image = [UIImage imageNamed:@"bg_img_top1"];
    bgImageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = Color313944;;
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(15));
        make.right.mas_offset(kSCRATIO(-15));
        make.height.mas_offset(kSCRATIO(176));
        
        make.top.mas_offset(kSCRATIO(110)+kStatusBarHeight);
        
    }];
    [whiteView layoutIfNeeded];
    ViewRadius(whiteView, kSCRATIO(10));
    UILabel *loginLabel=[UILabel CreatLabeltext:@"输入验证码" Font:[UIFont systemFontOfSize:kSCRATIO(16)] Textcolor:UIColor.whiteColor textAlignment:0];
    [whiteView addSubview:loginLabel];
    [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(15));
        make.top.mas_offset(kSCRATIO(25));
        make.height.mas_offset(kSCRATIO(23));
    }];
    
    codeButton=[[UIButton alloc]init];
    [codeButton addTarget:self action:@selector(countdownClick) forControlEvents:UIControlEventTouchUpInside];
    [codeButton setTitleColor:kColorFromRGBHex(0x7B8694) forState:UIControlStateNormal];
    [codeButton setTitle:@"56秒后重发" forState:0];
    codeButton.enabled=NO;
    codeButton.titleLabel.font=[UIFont systemFontOfSize: kSCRATIO(10)];
    ViewRadius(codeButton, kSCRATIO(10));
    [whiteView addSubview:codeButton];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(loginLabel);
        make.right.mas_offset(-kSCRATIO(15));
        make.height.mas_offset(kSCRATIO(20));
        make.width.mas_offset(kSCRATIO(70));
    }];
    
    HWTFCodeView *code1View = [[HWTFCodeView alloc] initWithCount:6 margin:kSCRATIO(19)];
    [whiteView addSubview:code1View];
    [code1View setCodeBliock:^(NSString * _Nonnull code) {
        [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/loginWithCode" andParam:@{@"phone":self.phoneString,@"countryCode":self.codeString,@"verificationId":self.verificationId,@"verificationCode":code} andSuccessBlock:^(NSURL *URL, id data) {
            if ([[NSString stringWithFormat:@"%@",data[@"code"]] isEqualToString:@"200"]) {
                [SaiNotificationCenter postNotificationName:SaiLoginSuccessNoti object:nil];
                RootUser *currentUser = [[RootUser alloc] init];
                [currentUser modelSetWithJSON:data[@"data"]];
                currentUser.userId=[NSString stringWithFormat:@"%@",currentUser.userId];
                currentUser.mobile=self.phoneString;
                SaiContext.currentUser=currentUser;
                if ([YYTextArchiver archiveRootObject:currentUser toFile:DOCUMENT_FOLDER(@"loginedUser")]) {
                    [self bindClickCallBack];
                }
                SaiContext.currentUser = [YYTextUnarchiver  unarchiveObjectWithFile:DOCUMENT_FOLDER(@"loginedUser")];
                TYLog(@"%@",SaiContext.currentUser.name);
                
            }else if ([[NSString stringWithFormat:@"%@",data[@"code"]] isEqualToString:@"3003"]){
                errorLabel.hidden=NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    errorLabel.hidden=YES;
                    
                });
            }
            
            
        } andFailBlock:^(NSURL *URL, NSError *error) {
            
        }];
    }];
    [code1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(42));
        make.right.mas_offset(-kSCRATIO(42));
        make.height.mas_offset(kSCRATIO(40));
        
        make.top.equalTo(loginLabel.mas_bottom).mas_offset(kSCRATIO(15));
        
    }];
    errorLabel=[UILabel CreatLabeltext:@"未注册手机验证后自动登录" Font:[UIFont fontWithName:@"PingFang-SC-Medium" size:kSCRATIO(12)] Textcolor:kColorFromRGBHex(0x7B8694) textAlignment:0];
    [whiteView addSubview:errorLabel];  
    [errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(kSCRATIO(-15));
        make.bottom.mas_offset(kSCRATIO(-40));
    }];
}
#pragma mark -  Button Callbacks
-(void)bindClickCallBack{
    [MessageAlertView showLoading:@"正在登录，请稍候..."];
    [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/device/bind" andParam:@{@"deviceSN":SaiContext.UUID,@"productId":@"ta_v2_nochat",@"userId":SaiContext.currentUser.userId} andSuccessBlock:^(NSURL *URL, id data) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SaikIsLogin];
        [MessageAlertView dismissHud];
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:NO completion:^{
            }];
        }
        //        [self dismissViewControllerAnimated:YES completion:^{
        [[SaiAzeroManager sharedAzeroManager] setUpAzeroSDK];
        [[SaiAzeroManager sharedAzeroManager] saiSDKConnectionStatusChangedWithStatus:^(ConnectionStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status) {
                    case ConnectionStatusConnect:
                        [[SaiAzeroManager sharedAzeroManager] detectAndSetSerFile];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SaiNotificationCenter postNotificationName:@"saiHeadsetNeedBle" object:nil];

                        });
                        [self statusConnectOperationIsLogin];
                        break;
                    case ConnectionStatusDisConnect:
                        [MessageAlertView showHudMessage:@"与SDK服务器断开连接,请重新启动APP"];
                        break;
                    default:
                        break;
                }
            });
            //          }];
        }];
    } andFailBlock:^(NSURL *URL, NSError *error) {
        [MessageAlertView dismissHud];
    }];
}
- (void)statusConnectOperationIsLogin{
    [[XBEchoCancellation shared] startInput];
    SaiContext.currentUser = [YYTextUnarchiver  unarchiveObjectWithFile:DOCUMENT_FOLDER(@"loginedUser")];
    BaseNC *nav = [[BaseNC alloc] initWithRootViewController:[AwemeListViewController new]];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    

}
-(void)countdownClick{
    [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/verification" andParam:@{@"phoneNumber":self.phoneString,@"countryCode":self.codeString,@"type":@"VERIFICATION",@"sender":@"0"} andSuccessBlock:^(NSURL *URL, id data) {
        NSDictionary *json=(NSDictionary *)data;
        self.verificationId=json[@"data"][@"verificationId"];
        [self countdownClickCallBack];
        
    } andFailBlock:^(NSURL *URL, NSError *error) {
        
    }];
}
-(void)countdownClickCallBack{
    __block NSInteger second = 60;
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    
    _timer = timer;
    
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second >0) {
                codeButton.enabled=NO;
                [codeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)second] forState:UIControlStateNormal];
                if (!codeButton.isEnabled) {
                    [codeButton setBackgroundImage:[UIImage imageWithColor:Color222B36] forState:UIControlStateDisabled];
                    [codeButton setTitleColor:kColorFromRGBHex(0x7B8694) forState:UIControlStateDisabled];
                }
                second--;
            }
            else
            {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timer);
                
                [codeButton setTitle:@"重发验证码" forState:UIControlStateNormal];
                [codeButton setBackgroundImage:[UIImage imageWithColor:Color67E4FD] forState:UIControlStateNormal];
                
                [codeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                codeButton.enabled=YES;
                
            }
        });
    });
    //启动源
    dispatch_resume(timer);
    
}


@end
