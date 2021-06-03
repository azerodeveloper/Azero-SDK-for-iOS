//
//  WNConnectSuccessController.m
//  WuNuo
//
//  Created by silk on 2019/5/8.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "WNConnectSuccessController.h"
#import "WNDeviceConnectedSuccessfullyController.h"
#define nameTfX   100
#define sureBtnX   44

@interface WNConnectSuccessController ()
@property (nonatomic ,strong) UITextField *nameTf;

@end

@implementation WNConnectSuccessController
#pragma mark -  Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *connectSuccessLabel = [[UILabel alloc] init];
    if (Sai_iPhoneXS||Sai_iPhoneXsXrMax||Sai_iPhoneX) {
        connectSuccessLabel.frame = CGRectMake(0, 88+78.5, ViewWidth, 22);
    }else{
        connectSuccessLabel.frame = CGRectMake(0, 64+54.5, ViewWidth, 22);
    }
    connectSuccessLabel.text = @"连接成功!";
    connectSuccessLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:22.0f];
    connectSuccessLabel.textColor = [UIColor blackColor];
    connectSuccessLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:connectSuccessLabel];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(0, CGRectGetMaxY(connectSuccessLabel.frame)+10, ViewWidth, 17.0f);
    nameLabel.text = @"给音箱取个名字吧!";
    nameLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0f];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    UITextField *nameTf = [[UITextField alloc] init];
    nameTf.frame = CGRectMake(nameTfX, CGRectGetMaxY(nameLabel.frame)+79, ViewWidth-nameTfX*2, 19);
    nameTf.placeholder = @"请输入音箱的名称";
    nameTf.font = [UIFont qk_PingFangSCRegularFontwithSize:16.0];
    nameTf.autocorrectionType = UITextAutocorrectionTypeNo;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"请输入音箱的名称" attributes:@{NSForegroundColorAttributeName:SaiColor(163.0, 163.0, 163.0),NSFontAttributeName:[UIFont qk_PingFangSCRegularFontwithSize:17.0], NSParagraphStyleAttributeName:style}];
    nameTf.attributedPlaceholder = attri;
    nameTf.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0f];
    [nameTf changePlaceholderColor];
    [self.view addSubview:nameTf];
    self.nameTf = nameTf;
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(nameTfX, CGRectGetMaxY(nameTf.frame)+5, ViewWidth-nameTfX*2, 1);
    lineView.backgroundColor = SaiColor(245, 245, 245);
    [self.view addSubview:lineView];
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.frame = CGRectMake(sureBtnX, CGRectGetMaxY(lineView.frame)+60, ViewWidth-sureBtnX*2, 44);
    sureBtn.backgroundColor = [UIColor redColor];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0f];
    [sureBtn addTarget:self action:@selector(sureBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 22.0f;
    [self.view addSubview:sureBtn];
    UIButton *skipBtn = [[UIButton alloc] init];
    skipBtn.frame = CGRectMake(sureBtnX, CGRectGetMaxY(sureBtn.frame)+15, ViewWidth-sureBtnX*2, 44);
    skipBtn.backgroundColor = SaiColor(221, 221, 221);
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    skipBtn.titleLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0f];
    [skipBtn addTarget:self action:@selector(skipBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    skipBtn.layer.masksToBounds = YES;
    skipBtn.layer.cornerRadius = 22.0f;
    [self.view addSubview:skipBtn];
}
#pragma mark -  UITableViewDelegate
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
#pragma mark -  Notification Methods
#pragma mark -  Button Callbacks
- (void)sureBtnClickCallBack:(UIButton *)button{
    [self.view endEditing:YES];
    if (![QKUITools networkReachable]) {
        [SaiHUDTools showError:@"网络错误,请检查网络设置"];
        return;
    }
    if (self.nameTf.text.length==0) {
        JySaiAlertView *alertView = [[JySaiAlertView alloc] initMessageWithTitle:@"提示" message:@"音箱的名称不可以为空" OKButtonText:nil cancelButtonText:@"确定" otherBlock:^{
            
        } cancelBlock:^{
           
        }];
        [alertView show];
        return;
    }
    NSRange _range = [self.nameTf.text rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        JySaiAlertView *alertView = [[JySaiAlertView alloc] initMessageWithTitle:@"提示" message:@"音箱的名称不可以含有空格字符" OKButtonText:nil cancelButtonText:@"确定" otherBlock:^{
            
        } cancelBlock:^{
            
        }];
        [alertView show];
        return;
    }
    //绑定设备
    
    NSDictionary *paramDic;
    paramDic = @{
                 @"userId":[UserInfoContext sharedContext].currentUser.userId,
                 @"deviceSN":self.deviceSN,
                 @"productId":self.productId,
                 @"name":self.nameTf.text
                 };
    [QKBaseHttpClient httpType:POST andURL:UserBindDeviceUrl andParam:paramDic andSuccessBlock:^(NSURL *URL, id data) {
        TYLog(@"data: %@",data);
        NSString *code = data[@"code"];
        if (code.intValue == 200) {
            [SaiHUDTools showSuccess:@"设置成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NSString *message = data[@"message"];
            [SaiHUDTools showError:message];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } andFailBlock:^(NSURL *URL, NSError *error) {
        TYLog(@"data: %@",error);
        [SaiHUDTools showError:@"网络请求失败，请稍后重试"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
- (void)skipBtnClickCallBack:(UIButton *)button{
    if (![QKUITools networkReachable]) {
        [SaiHUDTools showError:@"网络错误,请检查网络设置"];
        return;
    }
    //绑定设备
    NSDictionary *paramDic;
    NSString *name ;
    if ([self.productId isEqualToString:@"sai_minidot"]) {
        name = @"小声音箱Mini";
    }else if ([self.productId isEqualToString:@"sai_minipodplus"]||[self.productId isEqualToString:@"speaker_sai_minipod"]){
        name = @"小声AI音箱灯";
    }else{
        name = @"AI音箱";
    }
    paramDic = @{
                 @"userId":[UserInfoContext sharedContext].currentUser.userId,
                 @"deviceSN":self.deviceSN,
                 @"productId":self.productId,
                 @"name":name
                 };
    [QKBaseHttpClient httpType:POST andURL:UserBindDeviceUrl andParam:paramDic andSuccessBlock:^(NSURL *URL, id data) {
        TYLog(@"data: %@",data);
        NSString *code = data[@"code"];
        if (code.intValue == 200) {
            [SaiHUDTools showSuccess:@"设置成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NSString *message = data[@"message"];
            [SaiHUDTools showError:message];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } andFailBlock:^(NSURL *URL, NSError *error) {
        TYLog(@"data: %@",error);
        [SaiHUDTools showError:@"网络请求失败，请稍后重试"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
#pragma mark -  Private Methods
#pragma mark -  Public Methods
#pragma mark -  Getters and Getters




@end
