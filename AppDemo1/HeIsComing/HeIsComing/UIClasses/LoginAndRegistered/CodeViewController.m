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
#import "SaiJXHomePageViewController.h"
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
    //设置导航栏透明
//    [self.navigationController.navigationBar setTranslucent:true];
    //把背景设为空
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    //处理导航栏有条线的问题
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
      self.navigationItem.hidesBackButton = YES;
          self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = SaiColor(245, 246, 250);
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(0, 0, ScreenWidth, 290+kStatusBarHeight);
    bgImageView.image = [UIImage imageNamed:@"bg_img_top1"];
    bgImageView.contentMode=UIViewContentModeScaleAspectFill;

    [self.view addSubview:bgImageView];
//    UIImageView *logoImageView=[UIImageView new];
//    [bgImageView addSubview:logoImageView];
//    logoImageView.image=[UIImage imageNamed:@"dl_img_logo"];
//    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_offset(75);
//        make.centerX.equalTo(bgImageView);
//        make.top.mas_offset(98+kStatusBarHeight);
//    }];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_offset(0);
        make.top.mas_offset(120+kStatusBarHeight);
        make.width.mas_offset(KScreenW);
    }];
    [whiteView layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:whiteView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = whiteView.bounds;
    maskLayer.path = maskPath.CGPath;
    whiteView.layer.mask = maskLayer;
    UILabel *loginLabel=[UILabel CreatLabeltext:@"输入验证码" Font:[UIFont boldSystemFontOfSize:kSCRATIO(17)] Textcolor:kColorFromRGBHex(0x333333) textAlignment:0];
    [whiteView addSubview:loginLabel];
    [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(30);
        make.top.mas_offset(32);
        make.height.mas_offset(16);
    }];
    UILabel *phoneLabel=[UILabel CreatLabeltext:[NSString stringWithFormat:@"验证码已发送至%@ %@",self.codeString,self.phoneString] Font:[UIFont fontWithName:@"PingFang-SC-Medium" size:12] Textcolor:Color999999 textAlignment:0];
    [whiteView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(30);
        make.top.equalTo(loginLabel.mas_bottom).offset(15);
        make.height.mas_offset(12);
    }];
    codeButton=[[UIButton alloc]init];
    [codeButton addTarget:self action:@selector(countdownClick) forControlEvents:UIControlEventTouchUpInside];
    [codeButton setTitleColor:Color666666 forState:UIControlStateNormal];
    [codeButton setTitle:@"56秒后重发" forState:0];
    codeButton.enabled=NO;
    codeButton.titleLabel.font=[UIFont systemFontOfSize: 12];
    ViewRadius(codeButton, 15);
    [whiteView addSubview:codeButton];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(22);
        make.right.mas_offset(-28);
        make.height.mas_offset(29);
        make.width.mas_offset(82);
    }];
    
    HWTFCodeView *code1View = [[HWTFCodeView alloc] initWithCount:6 margin:26];
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
        make.left.mas_offset(32);
        make.right.mas_offset(-32);
        make.height.mas_offset(40);
        make.top.equalTo(phoneLabel.mas_bottom).mas_offset(20);
        
    }];  
    errorLabel=[UILabel CreatLabeltext:@"验证码错误，请重新输入" Font:[UIFont fontWithName:@"PingFang-SC-Medium" size:14] Textcolor:kColorFromRGBHex(0xFB4242) textAlignment:0];
    errorLabel.hidden=YES;
    [whiteView addSubview:errorLabel];
    [errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(32);
        make.height.mas_offset(15);
        make.top.equalTo(code1View.mas_bottom).offset(17);
    }];
}
#pragma mark -  Button Callbacks
-(void)bindClickCallBack{
    [MessageAlertView showLoading:@"正在登录，请稍候..."];
    [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/device/bind" andParam:@{@"deviceSN":SaiContext.UUID,@"productId":@"phone_display_nochat",@"userId":SaiContext.currentUser.userId} andSuccessBlock:^(NSURL *URL, id data) {
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
//    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:nil messmage:@"827record CodeViewController **************** [[XBEchoCancellation shared] startInput] 前"];
    [[XBEchoCancellation shared] startInput];
//    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:nil messmage:@"827record CodeViewController **************** [[XBEchoCancellation shared] startInput] 后"];
    SaiContext.currentUser = [YYTextUnarchiver  unarchiveObjectWithFile:DOCUMENT_FOLDER(@"loginedUser")];
    BaseNC *nav = [[BaseNC alloc] initWithRootViewController:KSaiJXHomePageViewController];
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
                    [codeButton setBackgroundImage:[UIImage imageNamed:@"dl_btn_resendvc"] forState:UIControlStateDisabled];
                    [codeButton setTitleColor:Color999999 forState:UIControlStateDisabled];
                }
                second--;
            }
            else
            {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timer);
                
                [codeButton setTitle:@"重发验证码" forState:UIControlStateNormal];
                [codeButton setBackgroundImage:[UIImage imageNamed:@"dl_highlight_btn_vc"] forState:UIControlStateNormal];
                
                [codeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                codeButton.enabled=YES;
                
            }
        });
    });
    //启动源
    dispatch_resume(timer);
    
}


@end
