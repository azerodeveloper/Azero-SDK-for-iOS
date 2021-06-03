//
//  WNSetWifiController.m
//  WuNuo
//
//  Created by silk on 2019/5/8.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "WNSetWifiController.h"
#import "SaiBleCenterManager.h"
#import "WNConnectSuccessController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "MSSystemWifiSetCell.h"
#import "IQKeyboardManager.h"
#define promptLabelY   16
#define wifiImageViewX   17
#define wifiImageViewW   19
#define wifiImageViewY   58
#define wifiTfX    9
#define wifiLineViewY    25
#define rememberPwdLabelY    28
#define connectBtnY     47
#define connectBtnH     44
@interface WNSetWifiController ()<UIGestureRecognizerDelegate>
@property (nonatomic ,strong) UITextField *wifiTf;
@property (nonatomic ,strong) UITextField *pwdTf;
@property (nonatomic ,strong) UIButton *connectBtn;
@property (assign,nonatomic) NSInteger secondsCountDown;
@property (retain,nonatomic) NSTimer * countDownTimer;

@property (nonatomic ,strong) NSMutableArray *wifiSetAry;
@property (nonatomic ,strong) UIButton *rememberPwdBtn;
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UIButton *wifiRightBtn;
@property (nonatomic ,strong) UITableView *wifiTableView;

//@property (nonatomic ,strong) CLLocationManager *locationManager;


@end

@implementation WNSetWifiController  
#pragma mark -  Life Cycle
- (void)dealloc{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id info = [self fetchSSIDInfo];
    NSString *SSID = info[@"SSID"];
    self.wifiTf.text = SSID;
    for (int i=0; i<self.wifiSetAry.count; i++) {
        NSDictionary *dic = self.wifiSetAry[i];
        NSString *wifi = dic[@"wifiName"];
        if ([SSID isEqualToString:wifi]) {
            self.pwdTf.text = dic[@"wifiPwd"];
        }
    }
    if (SSID.length != 0) {
        [self.pwdTf becomeFirstResponder];
    }else{
        [self.wifiTf becomeFirstResponder];
    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SaiNotificationCenter removeObserver:self];  
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    [[IQKeyboardManager sharedManager] setEnable:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];  
    [self setupUI];
    [self registerNoti];
}
#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.wifiSetAry.count+1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MSSystemWifiSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSSystemWifiSetCell"];
        return cell;
    }else{
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        NSDictionary *dic = self.wifiSetAry[indexPath.row-1];  
        NSString *wifiName = dic[@"wifiName"];
        cell.textLabel.text = wifiName;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
//        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        if([[UIApplication sharedApplication] openURL:url]) {
//           [[UIApplication sharedApplication] openURL:url];
//        }
        [self bgViewTap:nil];
        [[[JySaiAlertView alloc] initMessageWithTitle:@"提示" message:@"请在系统“设置”中连接上将要连接的Wi-Fi" OKButtonText:@"我知道了" cancelButtonText:nil otherBlock:^{
            
        } cancelBlock:^{
            
        }] show] ;
        
    }else{
        NSDictionary *dic = self.wifiSetAry[indexPath.row-1];
        self.wifiTf.text = dic[@"wifiName"];
        self.pwdTf.text = dic[@"wifiPwd"];
        [self.bgView removeFromSuperview];
        self.wifiRightBtn.selected = NO;
//        self.connectBtn.enabled = [self isReadyUserNameAndPassword];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TYLog(@"删除");
        [self.wifiSetAry removeObjectAtIndex:indexPath.row];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        [userDefault setObject:self.wifiSetAry forKey:SaiSaveWifi];
        [userDefault synchronize];
        [self.wifiTableView reloadData];
        if (self.wifiSetAry.count == 0) {
            self.wifiRightBtn.hidden = YES;
            [self.bgView removeFromSuperview];
        }
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)checkTextFieldStateControlLogonBtn:(UITextField *)textField{
//    self.connectBtn.enabled = [self isReadyUserNameAndPassword];
}
- (BOOL)isReadyUserNameAndPassword{
    return (self.wifiTf.text.length && self.pwdTf.text.length>=8);
}
- (void)bgViewTap:(UITapGestureRecognizer *)tap{
    [self.bgView removeFromSuperview];
    self.wifiRightBtn.selected = NO;
}
#pragma mark -  Notification Methods
- (void)didBecomeActiveNoti{
    id info = [self fetchSSIDInfo];
    NSString *SSID = info[@"SSID"];
    
    self.wifiTf.text = SSID;
    BOOL isSave = NO;
    for (int i=0; i<self.wifiSetAry.count; i++) {
        NSDictionary *dic = self.wifiSetAry[i];
        NSString *wifi = dic[@"wifiName"];
        if ([SSID isEqualToString:wifi]) {
            self.pwdTf.text = dic[@"wifiPwd"];
            isSave = YES;

        }
    }
    if (isSave == NO) {
        self.pwdTf.text = @"";
    }
    if (SSID.length != 0) {
        [self.pwdTf becomeFirstResponder];
    }else{
        [self.wifiTf becomeFirstResponder];
    }
   
}
- (void)setNetworkSuccess:(NSNotification *)noti{
    self.connectBtn.enabled = YES;
//    ClientID=5cdfca8ef03ec15a952a4e20&MAC=94:E0:D6:8B:17:7C&productId=sai_minidot&Vendor=sai&Cagegory=speaker&CUEI=200030011234567
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    [XNHUD dismiss];  
    [[SaiBleCenterManager sharedSaiBleCenterManager] cancelPeripheralConnection];
    [[SaiBleCenterManager sharedSaiBleCenterManager] destructionCenter];
    NSDictionary *dict = noti.userInfo;
    NSString *str =  dict[@"SaiSettingNetworkingSuccess"];
    if ([str localizedStandardContainsString:@"&"]) {
        NSString *mac;
        NSString *productId;
        NSArray *array = [str componentsSeparatedByString:@"&"];
        for (NSString *str in array) {
            if ([str rangeOfString:@"MAC"].location != NSNotFound) {// mac地址
                NSArray *MACStrAry = [str componentsSeparatedByString:@"="];
                mac = MACStrAry[1];
            }
            if ([str rangeOfString:@"productId"].location != NSNotFound) {// productId
                NSArray *productIdStrAry = [str componentsSeparatedByString:@"="];
                productId = productIdStrAry[1];
            }
            
        }
        if (productId.length==0||mac.length==0) {
            [XNHUD showWithTitle:@"音箱返回的蓝牙数据格式有误，请重新配置网络。"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [XNHUD dismiss];
            });
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        //储存wifi名称和密码
        if (self.rememberPwdBtn.selected) {
            [self saveWifiNameAndPwd];
        }
        WNConnectSuccessController *connectSuccessController = [[WNConnectSuccessController alloc] init];
        connectSuccessController.deviceSN = mac; 
        connectSuccessController.productId = productId;
        [self.navigationController pushViewController:connectSuccessController animated:YES];
        
    }else{
        [XNHUD showWithTitle:@"音箱返回的蓝牙数据格式有误，请重新配置网络。"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [XNHUD dismiss];
        });
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}
- (void)settingNetworkingFailure:(NSNotification *)noti{
    self.connectBtn.enabled = YES;
    [_countDownTimer invalidate];
    _countDownTimer = nil;
//    [SaiHUDTools hideHUD];
    [XNHUD dismiss];

    JySaiAlertView *alertView = [[JySaiAlertView alloc] initMessageWithTitle:@"提示" message:@"Wi-Fi账号或者密码错误，请重试" OKButtonText:nil cancelButtonText:@"确定" otherBlock:^{
        
    } cancelBlock:^{

    }];
    [alertView show];
}
- (void)failedObtainInformation:(NSNotification *)noti{
    self.connectBtn.enabled = YES;
    [_countDownTimer invalidate];
    _countDownTimer = nil;
//    [SaiHUDTools hideHUD];
    [XNHUD dismiss];

    JySaiAlertView *alertView = [[JySaiAlertView alloc] initMessageWithTitle:@"提示" message:@"获取音箱设备信息失败，请重新配网。" OKButtonText:nil cancelButtonText:@"确定" otherBlock:^{
        
    } cancelBlock:^{
        [[SaiBleCenterManager sharedSaiBleCenterManager] cancelPeripheralConnection];
        [[SaiBleCenterManager sharedSaiBleCenterManager] destructionCenter];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertView show];
}
- (void)disconnectPeripheral:(NSNotification *)noti{
    self.connectBtn.enabled = YES;
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    [XNHUD dismiss];
    JySaiAlertView *alertView = [[JySaiAlertView alloc] initMessageWithTitle:@"提示" message:@"手机与音箱设备断开连接，请重试。" OKButtonText:nil cancelButtonText:@"确定" otherBlock:^{
        
    } cancelBlock:^{
        [[SaiBleCenterManager sharedSaiBleCenterManager] cancelPeripheralConnection];
        [[SaiBleCenterManager sharedSaiBleCenterManager] destructionCenter];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertView show];
}
#pragma mark -  Button Callbacks
- (void)rememberPwdBtnClickCallBack:(UIButton *)button{
    button.selected = !button.selected;
    
}
- (void)wifiRightBtnClickCallBack:(UIButton *)button{
    [self.view endEditing:YES];
    button.selected = !button.selected;
    if (button.selected == YES) {
        [self setupWifiTable];
    }
}
- (void)connectBtnClickCallBack:(UIButton *)button{
    [self.view endEditing:YES];
//    NSRange _range1 = [self.wifiTf.text rangeOfString:@" "];
//    if (_range1.location != NSNotFound) {
//        SaiAlertView *alertView = [[SaiAlertView alloc] initMessageWithTitle:@"提示" message:@"Wi-Fi名称不可以含有空格字符" OKButtonText:nil cancelButtonText:@"确定" otherBlock:^{
//
//        } cancelBlock:^{
//
//        }];
//        [alertView show];
//        return;
//    }
//    NSRange _range = [self.pwdTf.text rangeOfString:@" "];
//    if (_range.location != NSNotFound) {
//        SaiAlertView *alertView = [[SaiAlertView alloc] initMessageWithTitle:@"提示" message:@"密码不可以含有空格字符" OKButtonText:nil cancelButtonText:@"确定" otherBlock:^{
//
//        } cancelBlock:^{
//
//        }];
//        [alertView show];
//        return;
//    }
    [self addTimer];
    [XNHUD setDisposableDelayResponse:0.0 delayDismiss:MAXFLOAT];
    [XNHUD showLoadingWithTitle:@"正在配置网络，请稍后..."];
    NSMutableData *allData = [NSMutableData data];
    Byte head[] = {0x01};
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:head length:1];
    [allData appendData:data];
    [allData appendData:[@"amlogicble" dataUsingEncoding:NSUTF8StringEncoding]];
    [allData appendData:[@"wifisetup" dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *ssidData = [self.wifiTf.text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ssidLenData = [self int2Data:ssidData.length];
    NSData *pwdData = [self.pwdTf.text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *pwdLenData = [self int2Data:pwdData.length];
    NSData *userIdData = [@"0" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *userIdLenData = [self int2Data:userIdData.length];
    [allData appendData:ssidLenData];
    [allData appendData:pwdLenData];
    [allData appendData:userIdLenData];
    [allData appendData:ssidData];
    [allData appendData:pwdData];
    [allData appendData:userIdData];
    Byte end[] = {0x04};
    NSMutableData *endData = [[NSMutableData alloc] initWithBytes:end length:1];
    [allData appendData:endData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{  
        [[SaiBleCenterManager sharedSaiBleCenterManager] updateValue:allData];
    });
    button.enabled = NO;
}

- (NSData *)QKDataBaseManagerHighInFormerLowInBackWith:(NSData *)data{
    NSUInteger len = [data length];
    Byte *uuidByte = (Byte *)[data bytes];
    Byte diuuByte[len];
    for (int m=0; m<=len-1; m++) {
        diuuByte[m] =uuidByte[len - m -1] ;
    }
    NSData * diuudata = [NSMutableData dataWithBytes:diuuByte length:sizeof(diuuByte)];
    return diuudata;
}
- (void)cipherBtnClickCallBack:(UIButton *)button{
    self.pwdTf.secureTextEntry = !self.pwdTf.secureTextEntry;
    if (self.pwdTf.secureTextEntry) {
        [button setImage:[UIImage imageNamed:@"Intelligence_Eye"] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:@"Intelligence_Eye_click"] forState:UIControlStateNormal];
    }
}
#pragma mark -  Private Methods
- (void)setupWifiTable{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenHeight)];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    [self.view addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTap:)];
    tap.delegate = self;
    bgView.userInteractionEnabled = YES;
    [bgView addGestureRecognizer:tap];
    self.bgView = bgView;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width - 100,self.view.height-300 ) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.layer.cornerRadius = 5.0f;
    tableView.layer.masksToBounds = YES;
    [bgView addSubview:tableView];
    tableView.center = self.tableView.center;
    self.wifiTableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"MSSystemWifiSetCell" bundle:nil] forCellReuseIdentifier:@"MSSystemWifiSetCell"];
}
- (void)setupUI{
    [self sai_initTitleView:@"配网"];
    [self sai_initGoBackBlackButton];
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.frame = CGRectMake(0,promptLabelY, ViewWidth, 22);

    promptLabel.text = @"设置音箱的无线网络";
    promptLabel.font = [UIFont qk_PingFangSCRegularBoldFontwithSize:22.0f];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.textColor = [UIColor blackColor];
    [self.view addSubview:promptLabel];
    UIImageView *wifiImageView = [[UIImageView alloc] init];
    wifiImageView.frame = CGRectMake(wifiImageViewX, CGRectGetMaxY(promptLabel.frame)+wifiImageViewY, wifiImageViewW, wifiImageViewW);
    wifiImageView.image = [UIImage imageNamed:@"add_sey-wife-b"];
    [self.view addSubview:wifiImageView];

    UITextField *wifiTf = [[UITextField alloc] init];
    wifiTf.frame = CGRectMake(CGRectGetMaxX(wifiImageView.frame)+wifiTfX, 0, ViewWidth-wifiImageViewX-(CGRectGetMaxX(wifiImageView.frame)+wifiTfX), wifiImageViewW);
    wifiTf.centerY = wifiImageView.centerY;
    wifiTf.placeholder = @"请输入WiFi的名称";
    wifiTf.autocorrectionType = UITextAutocorrectionTypeNo; 
    wifiTf.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0];
    [wifiTf addTarget:self action:@selector(checkTextFieldStateControlLogonBtn:) forControlEvents:UIControlEventAllEditingEvents];
    [wifiTf changePlaceholderColor];
    self.wifiTf = wifiTf;
    [self.view addSubview:wifiTf];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *wifiSetAry = [userDefault objectForKey:SaiSaveWifi];
    self.wifiSetAry = [NSMutableArray arrayWithArray:wifiSetAry];
//    if (wifiSetAry.count != 0) {
    UIButton *wifiRightBtn = [[UIButton alloc] init];
    wifiRightBtn.frame = CGRectMake(0, 0, 44, 44);
    [wifiRightBtn setImage:[UIImage imageNamed:@"wifi_Selectdevice"] forState:UIControlStateNormal];
    [wifiRightBtn setImage:[UIImage imageNamed:@"wifi_Selectdevice_up"] forState:UIControlStateHighlighted];
    [wifiRightBtn setImage:[UIImage imageNamed:@"wifi_Selectdevice_up"] forState:UIControlStateSelected];
    [wifiRightBtn addTarget:self action:@selector(wifiRightBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    self.wifiTf.rightViewMode = UITextFieldViewModeAlways;
    self.wifiTf.rightView = wifiRightBtn;
    self.wifiRightBtn = wifiRightBtn;
//    }
    UIView *wifiLineView = [[UIView alloc] init];
    wifiLineView.frame = CGRectMake(wifiImageViewX, CGRectGetMaxY(wifiTf.frame)+wifiLineViewY, ViewWidth-wifiImageViewX*2, 1);
    wifiLineView.backgroundColor = SaiColor(245, 245, 245);
    [self.view addSubview:wifiLineView];
    UILabel *wifiLabel = [[UILabel alloc] init];
    wifiLabel.frame = CGRectMake(0, CGRectGetMaxY(wifiLineView.frame), ViewWidth, 30.0);
    wifiLabel.text = @"          * 当前音箱不支持5G Wi-Fi";
    wifiLabel.textAlignment = NSTextAlignmentLeft;
    wifiLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:13.0];
    wifiLabel.textColor = SaiColor(187, 187, 187) ;//
    [self.view addSubview:wifiLabel];
    UIImageView *pwdImageView = [[UIImageView alloc] init];
    pwdImageView.frame = CGRectMake(wifiImageViewX, CGRectGetMaxY(wifiLineView.frame)+wifiImageViewY, wifiImageViewW, wifiImageViewW);
    pwdImageView.image = [UIImage imageNamed:@"add_Password"];
    [self.view addSubview:pwdImageView];
    UITextField *pwdTf = [[UITextField alloc] init];
    pwdTf.frame = CGRectMake(CGRectGetMaxX(pwdImageView.frame)+wifiTfX, 0, ViewWidth-wifiImageViewX-(CGRectGetMaxX(wifiImageView.frame)+wifiTfX), wifiImageViewW);
    pwdTf.centerY = pwdImageView.centerY;
    pwdTf.placeholder = @"请输入WiFi的密码";
    pwdTf.autocorrectionType = UITextAutocorrectionTypeNo;
    pwdTf.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0];
    pwdTf.secureTextEntry = YES;
    [pwdTf addTarget:self action:@selector(checkTextFieldStateControlLogonBtn:) forControlEvents:UIControlEventAllEditingEvents];
    [pwdTf changePlaceholderColor];
    self.pwdTf = pwdTf;
    [self.view addSubview:pwdTf];
    UIButton *cipherBtn = [[UIButton alloc] init];
    cipherBtn.frame = CGRectMake(0, 0, 44, 44);
    [cipherBtn setImage:[UIImage imageNamed:@"Intelligence_Eye"] forState:UIControlStateNormal];
    [cipherBtn addTarget:self action:@selector(cipherBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    pwdTf.rightView = cipherBtn;
    pwdTf.rightViewMode = UITextFieldViewModeAlways;
    UIView *pwdLineView = [[UIView alloc] init];
    pwdLineView.frame = CGRectMake(wifiImageViewX, CGRectGetMaxY(pwdTf.frame)+wifiLineViewY, ViewWidth-wifiImageViewX*2, 1);
    pwdLineView.backgroundColor = SaiColor(245, 245, 245);
    [self.view addSubview:pwdLineView];
    UIButton *rememberPwdBtn = [[UIButton alloc] init];
    rememberPwdBtn.frame = CGRectMake(wifiImageViewX, 0, 44, 44);
    [rememberPwdBtn setImage:[UIImage imageNamed:@"wifi_btn_success_n"] forState:UIControlStateNormal];
    [rememberPwdBtn setImage:[UIImage imageNamed:@"wifi_success"] forState:UIControlStateSelected];
    [rememberPwdBtn setImage:[UIImage imageNamed:@"wifi_success"] forState:UIControlStateHighlighted];
    rememberPwdBtn.centerX = pwdImageView.centerX;
    rememberPwdBtn.selected = YES;
    [rememberPwdBtn addTarget:self action:@selector(rememberPwdBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rememberPwdBtn];
    self.rememberPwdBtn = rememberPwdBtn;
    UILabel *rememberPwdLabel = [[UILabel alloc] init];
    rememberPwdLabel.frame = CGRectMake(CGRectGetMaxX(pwdImageView.frame)+wifiTfX, CGRectGetMaxY(pwdLineView.frame)+rememberPwdLabelY, 200, 12);
    rememberPwdLabel.text = @"记住密码";
    rememberPwdLabel.textAlignment = NSTextAlignmentLeft;
    rememberPwdLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:12.0f];
    [self.view addSubview:rememberPwdLabel];
    rememberPwdBtn.centerY = rememberPwdLabel.centerY;
    UIButton *connectBtn = [[UIButton alloc] init];
    connectBtn.frame = CGRectMake(wifiImageViewX, CGRectGetMaxY(rememberPwdLabel.frame)+connectBtnY, ViewWidth-wifiImageViewX*2, connectBtnH);
    [connectBtn setTitle:@"连接网络" forState:UIControlStateNormal];
    [connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    connectBtn.titleLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0f];
    [connectBtn addTarget:self action:@selector(connectBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    connectBtn.layer.masksToBounds = YES;
    connectBtn.layer.cornerRadius = 22.0f;  
    connectBtn.enabled = YES;
    [connectBtn setBackgroundImage:[UIImage imageWithColor:Color999999] forState:UIControlStateDisabled];
    [connectBtn setBackgroundImage:[UIImage imageWithColor:SaiColor(0, 149, 231)] forState:UIControlStateNormal];
    [connectBtn setBackgroundImage:[UIImage imageWithColor:SaiColor(0, 149, 231)] forState:UIControlStateHighlighted];
    
    [self.view addSubview:connectBtn];
    self.connectBtn = connectBtn;
}
- (NSData *)int2Data:(NSUInteger )i{
    Byte b1=i & 0xff;
    Byte byte[] = {b1};
    NSData *adddata = [NSData dataWithBytes:byte length:sizeof(byte)];
    return adddata;
}
- (void)registerNoti{
    [SaiNotificationCenter addObserver:self selector:@selector(setNetworkSuccess:) name:SaiSettingNetworkingSuccess object:nil];
    [SaiNotificationCenter addObserver:self selector:@selector(settingNetworkingFailure:) name:SaiSettingNetworkingFailure object:nil];
    [SaiNotificationCenter addObserver:self selector:@selector(failedObtainInformation:) name:SaiFailedObtainInformation object:nil];
    [SaiNotificationCenter addObserver:self selector:@selector(disconnectPeripheral:) name:SaiDisconnectPeripheral object:nil];
    [SaiNotificationCenter addObserver:self selector:@selector(didBecomeActiveNoti) name:SaiDidBecomeActiveNoti object:nil];
}
//验证码计时器
- (void)addTimer{
    if (!_countDownTimer.valid) {
        _secondsCountDown = 120;
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_countDownTimer forMode:NSDefaultRunLoopMode];
    }
}
- (void)timeFireMethod{
    _secondsCountDown-=5;
    if(_secondsCountDown<=-1){
        [XNHUD dismiss];
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        JySaiAlertView *alertView = [[JySaiAlertView alloc] initMessageWithTitle:@"提示" message:@"配网超时，请稍后重试。" OKButtonText:@"好的" cancelButtonText:nil otherBlock:^{
        } cancelBlock:^{
        }];
        [alertView show];
    }
}
- (void)saveWifiNameAndPwd{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *saveedAry = [userDefault objectForKey:SaiSaveWifi];
    NSMutableArray *wifiAry = [NSMutableArray arrayWithArray:saveedAry];
    [wifiAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *wifiName = obj[@"wifiName"];
        if ([wifiName isEqualToString:self.wifiTf.text]) {
            [wifiAry removeObject:obj];
        }
    }];
    NSDictionary *wifiDic = @{@"wifiName":self.wifiTf.text,
                              @"wifiPwd":self.pwdTf.text
                              };
    [wifiAry addObject:wifiDic];
    [userDefault setObject:wifiAry forKey:SaiSaveWifi];
    [userDefault synchronize];
}

#pragma mark -  Public Methods
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;      //关闭手势
    }
    return YES;
}
- (id)fetchSSIDInfo{
    
//    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
//    CGFloat version = [phoneVersion floatValue];
//    // 如果是iOS13 未开启地理位置权限 需要提示一下
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && version >= 13) {
//      self.locationManager = [[CLLocationManager alloc] init];
//      [self.locationManager requestWhenInUseAuthorization];
//    }

//    NSString *currentSSID = @"";
//    NSArray *myArray = (__bridge_transfer id)CNCopySupportedInterfaces();

//    if (myArray ){
//
////    if (myArray != nil){
//
//        NSDictionary *myDict = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)myArray.firstObject);
//
////        NSDictionary* myDict = (__bridge NSDictionary *) CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
//        if (myDict){
////            if (myDict!=nil){ 
//
//            currentSSID=[myDict valueForKey:@"SSID"];
//        } else {
//            currentSSID=@"<<NONE>>";
//        }
//    } else {
//        currentSSID=@"<<NONE>>";
//    }
    
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
        if (info && [info count]) {
            break;
        }
    }
  
    
    return info;
}

#pragma mark -  Getters and Getters
- (NSMutableArray *)wifiSetAry{
    if (_wifiSetAry == nil) {
        _wifiSetAry = [NSMutableArray array];
    }
    return _wifiSetAry;
}


@end
