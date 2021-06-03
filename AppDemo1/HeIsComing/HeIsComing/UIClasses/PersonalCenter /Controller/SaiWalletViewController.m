//
//  SaiWalletViewController.m
//  HeIsComing
//
//  Created by mike on 2020/3/30.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiWalletViewController.h"
#import "MessageAlertView.h"
#import "QQCorner.h"
#import "WXApiManager.h"
@interface SaiWalletViewController ()<UITextFieldDelegate,WXAuthDelegate>
@property (strong, nonatomic) UIButton *selectedBtn;
@property(nonatomic,strong)UILabel *amountLabel ;
@property(nonatomic,strong)UIButton *amountButton;
@property(nonatomic,strong)UILabel *warnLabel ;

@end
#pragma mark -  Life Cycle  

@implementation SaiWalletViewController
{
    UITextField *  phoneTextField;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        }else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        }
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的钱包";
    [self setNavigation];
    [self getMoneyAmount];
    UIImageView *walletImageView=[UIImageView new];
    walletImageView.userInteractionEnabled=YES;
    [self.view addSubview:walletImageView];
    walletImageView.image=[UIImage imageNamed:@"qb_img_background"];
    [walletImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(kSCRATIO(357));
        make.centerX.equalTo(self.view);
        make.top.mas_offset(kSCRATIO(7));
        make.height.mas_offset(kSCRATIO(154));
        
    }];
    UILabel *walletLabel=[UILabel CreatLabeltext:@"总金额" Font:[UIFont systemFontOfSize:kSCRATIO(15)] Textcolor:kColorFromRGBHex(0xFEFEFE) textAlignment:0];
    [walletImageView addSubview:walletLabel];
    [walletLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(33));
        make.top.mas_offset(kSCRATIO(25));
        make.height.mas_offset(kSCRATIO(14));
        
    }];
    UILabel *amountLabel=[UILabel CreatLabeltext:@"" Font:[UIFont boldSystemFontOfSize:kSCRATIO(40)] Textcolor:kColorFromRGBHex(0xFEFEFE) textAlignment:0];
    [walletImageView addSubview:amountLabel];
    self.amountLabel=amountLabel;
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(33));
        make.top.mas_offset(kSCRATIO(60));
        make.height.mas_offset(kSCRATIO(30));
    }];
    UILabel *unitLabel=[UILabel CreatLabeltext:@"(¥)" Font:[UIFont boldSystemFontOfSize:kSCRATIO(15)] Textcolor:kColorFromRGBHex(0xFEFEFE) textAlignment:0];
    [walletImageView addSubview:unitLabel];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amountLabel.mas_right).mas_offset(kSCRATIO(10));
        make.bottom.equalTo(amountLabel);
        make.height.mas_offset(kSCRATIO(15));
    }];
    UIButton *amountButton=[UIButton CreatButtontext:@"提现" image:nil Font:[UIFont boldSystemFontOfSize:kSCRATIO(15)] Textcolor:kColorFromRGBHex(0xFEFEFE)];
    [amountButton addTarget:self action:@selector(amountButtonclick) forControlEvents:UIControlEventTouchUpInside];
    self.amountButton=amountButton;
    [walletImageView addSubview:amountButton];
    [amountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(kSCRATIO(-30));
        make.centerY.equalTo(walletImageView);
        make.height.mas_offset(kSCRATIO(27));
        make.width.mas_offset(kSCRATIO(60));
        
    }];
    amountButton.enabled=NO;
    [amountButton layoutIfNeeded];
    [amountButton setBackgroundImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.toColor = kColorFromRGBHex(0xDDDDDD);
        graColor.fromColor = kColorFromRGBHex(0xDDDDDD);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:amountButton.size cornerRadius:QQRadiusMakeSame(kSCRATIO(13.5))] forState:UIControlStateDisabled];
    [amountButton setBackgroundImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.toColor = kColorFromRGBHex(0x0EAD6E);
        graColor.fromColor = kColorFromRGBHex(0x2BE1DF);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:amountButton.size cornerRadius:QQRadiusMakeSame(kSCRATIO(13.5))] forState:0];
    ViewRadius(amountButton, kSCRATIO(13.5));
    UILabel *amountMoneyLabel=[UILabel CreatLabeltext:@"金额（元）" Font:[UIFont boldSystemFontOfSize:kSCRATIO(15)] Textcolor:Color333333 textAlignment:0];
    [self.view addSubview:amountMoneyLabel];
    [amountMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(36));
        make.top.equalTo(walletImageView.mas_bottom).mas_offset(kSCRATIO(15));
        make.height.mas_offset(kSCRATIO(15));
    }];
    phoneTextField = [UITextField new];
    phoneTextField.delegate = self;
    phoneTextField.returnKeyType = UIReturnKeyDone;
    phoneTextField.font=[UIFont boldSystemFontOfSize:kSCRATIO(30)];
    
    NSMutableParagraphStyle *style = [phoneTextField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    
    //         style.minimumLineHeight = phoneTextField.font.lineHeight - (phoneTextField.font.lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) / 2.0;
    phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入金额"attributes:@{NSForegroundColorAttributeName: kColorFromRGBHex(0x999999),NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Medium" size:kSCRATIO(13)],NSParagraphStyleAttributeName : style}];
    //      phoneTextField.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    phoneTextField.textColor=Color333333;
    phoneTextField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amountMoneyLabel);
        make.right.mas_offset(-30);
        make.top.equalTo(amountMoneyLabel.mas_bottom).offset(kSCRATIO(20));
        make.height.mas_offset(30);
    }];
    [phoneTextField layoutIfNeeded];
    [phoneTextField addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    UIView *lineView=[UIView new];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(phoneTextField.mas_bottom);
        make.height.mas_offset(1);
    }];
    lineView.backgroundColor=kColorFromRGBHex(0xE0E0E0);
    UIView *mostView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,37, phoneTextField.height)];
    phoneTextField.leftView = mostView;
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    UILabel *phoneImageView=[UILabel CreatLabeltext:@"¥" Font:[UIFont boldSystemFontOfSize:kSCRATIO(30)] Textcolor:Color333333 textAlignment:0];
    [mostView addSubview:phoneImageView];
    phoneImageView.frame=CGRectMake(0, 0, 17, 21);
    phoneImageView.centerY=mostView.centerY;
    
    UILabel *warnLabel=[UILabel CreatLabeltext:@"超出可提现金额" Font:[UIFont boldSystemFontOfSize:kSCRATIO(13)] Textcolor:kColorFromRGBHex(0xFB4242) textAlignment:0];
    [self.view addSubview:warnLabel];
    self.warnLabel=warnLabel;
    warnLabel.hidden=YES;
    [warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineView.mas_bottom).mas_offset(kSCRATIO(-12));
        make.left.mas_offset(kSCRATIO(160));
    }];
    UILabel * phoneLabel =[UILabel CreatLabeltext:@"全部" Font:[UIFont fontWithName:@"PingFang-SC-Medium" size:kSCRATIO(13)] Textcolor:Color333333 textAlignment:0] ;
    [mostView addSubview:phoneLabel];
    phoneLabel.userInteractionEnabled=YES;
    phoneLabel.frame=CGRectMake(30, 0, 40, 21.5);
    [phoneLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneLabelClick)]];
    phoneTextField.rightView=phoneLabel;
    
    phoneTextField.rightViewMode=UITextFieldViewModeAlways;
    
    UIView *whiteView=[UIView new];
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(lineView.mas_bottom);
        make.height.mas_offset(kSCRATIO(130));
    }];
    NSArray *imageArray=@[@"qb_icon_weixin"];
    NSArray *titleArray=@[@"微信支付"];
    
    for (int i=0; i<1; i++) {
        UIView *payView=[UIView new];
        [whiteView addSubview:payView];
        
        [payView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(kSCRATIO(0));
            make.top.mas_offset(kSCRATIO(20)+kSCRATIO(44)*i);
            make.height.mas_offset(kSCRATIO(44));
        }];
        UIImageView *payImageView=[UIImageView new];
        payImageView.image=[UIImage imageNamed:imageArray[i]];
        [payView addSubview:payImageView];
        [payImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(kSCRATIO(30));
            make.centerY.equalTo(payView);
            
            make.width.height.mas_offset(kSCRATIO(24));
        }];
        UILabel *payLabel=[UILabel CreatLabeltext:titleArray[i] Font:[UIFont boldSystemFontOfSize:kSCRATIO(14)] Textcolor:Color333333 textAlignment:0];
        [payView addSubview:payLabel];
        [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(payImageView.mas_right).mas_offset(kSCRATIO(13));
            make.centerY.equalTo(payImageView);
            
            make.height.mas_offset(kSCRATIO(14));
        }];
        UIButton *payImageSelectedView=[UIButton new];
        ViewRadius(payImageSelectedView, kSCRATIO(11)/2);
        [payView addSubview:payImageSelectedView];
        [payImageSelectedView addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [payImageSelectedView setBackgroundImage:[UIImage imageWithColor:kColorFromRGBHex(0xEEEEEE)] forState:0];
        [payImageSelectedView setBackgroundImage:[UIImage imageWithColor:UIColor.blueColor] forState:UIControlStateSelected];
        payView.tag=i+1000;
        payImageSelectedView.tag=i+10000;
        
        [payView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedViewClick:)]];
        if (i==0) {
            payImageSelectedView.selected=YES;
            self.selectedBtn=payImageSelectedView;
        }
        [payImageSelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(kSCRATIO(-28));
            make.centerY.equalTo(payView);
            
            make.width.height.mas_offset(kSCRATIO(11));
        }];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark -  Button Callbacks

- (void)textValueChanged{
    self.amountButton.enabled=[phoneTextField.text doubleValue]>=0.3;
    self.warnLabel.hidden=[phoneTextField.text doubleValue]<=[self.amountLabel.text doubleValue];
}
-(void)getMoneyAmount{
    [QKBaseHttpClient httpType:GET andURL:@"/v1/surrogate/payment/balance" andParam:@{@"userId":SaiContext.currentUser.userId} andSuccessBlock:^(NSURL *URL, id data) {
        NSDictionary *dicData=(NSDictionary *)data;
        if ([[NSString stringWithFormat:@"%@",dicData[@"code"]]  isEqualToString:@"200"]) {
            NSString *balance=dicData[@"data"][@"balance"];
            self.amountLabel.text=[NSString stringWithFormat:@"%.2f",[balance doubleValue]/100];
        }
        
        
        
    } andFailBlock:^(NSURL *URL, NSError *error) {
    }];
}
//- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
//{
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
//
//        UMSocialUserInfoResponse *resp = result;
//
//        if (!error) {
//
//        }
//    }];
//}

-(void)withdrawWechat:(NSString *)code{
    //f28cef5c52d1508c
    
    NSString *messageId = [SaiUIUtils generateTradeNOWith:11];
    NSMutableDictionary *mutableDictionary=@{@"amount":[[NSNumber numberWithDouble:[phoneTextField.text doubleValue]*100] stringValue],@"appId":@"f28cef5c52d1508c",@"desc":@"TA来了提现",@"applyNo":[[NSNumber numberWithLong:([NSDate timeStamp].longLongValue+messageId.longLongValue)] stringValue],@"code":code}.mutableCopy;
    NSString *sign= [QKUITools signStr:mutableDictionary];
    [mutableDictionary setObject:sign forKey:@"sign"];
    [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/payment/withdraw/wechat" andParam:mutableDictionary andSuccessBlock:^(NSURL *URL, id data) {
        NSDictionary *dicData=(NSDictionary *)data;
        
        if ([[NSString stringWithFormat:@"%@",dicData[@"code"]]  isEqualToString:@"200"]) {
            [self getMoneyAmount];
            phoneTextField.text=@"";
        }else{
            [MessageAlertView showHudMessage:[NSString stringWithFormat:@"%@",dicData[@"message"]]];
            
        }
        
    } andFailBlock:^(NSURL *URL, NSError *error) {
        
    }];
}
-(void)selectedViewClick:(UITapGestureRecognizer *)sender{
    UIButton *button=(UIButton *)[self.view viewWithTag:sender.view.tag+9000];
    if (button == self.selectedBtn) {
        return;
    }
    
    self.selectedBtn.selected = NO;
    
    self.selectedBtn = button;
    
    self.selectedBtn.tag=button.tag;
    self.selectedBtn.selected = YES;
}


-(void)selectedButtonClick:(UIButton *)sender{
    
    if (sender == self.selectedBtn) {
        return;
    }
    
    self.selectedBtn.selected = NO;
    
    self.selectedBtn = sender;
    
    self.selectedBtn.tag=sender.tag;
    self.selectedBtn.selected = YES;
}
- (void)phoneLabelClick
{
    phoneTextField.text=self.amountLabel.text;
    self.amountButton.enabled=[phoneTextField.text doubleValue]>=0.3;
    self.warnLabel.hidden=[phoneTextField.text doubleValue]<=[self.amountLabel.text doubleValue];
}
- (void)amountButtonclick
{
    if ([QKUITools isBlankString:phoneTextField.text]) {
        [MessageAlertView showHudMessage:@"请输入提现金额"];
        
        return;
    }
    if ([phoneTextField.text doubleValue]>[self.amountLabel.text doubleValue]) {
        [MessageAlertView showHudMessage:@"提现金额不足"];
        
        return;
    }
    if (self.selectedBtn.tag==10000) {
        [self sendAuthRequest];
    }else{
        [MessageAlertView showHudMessage:@"暂不支持"];
    }
}
-(void)sendAuthRequest
{
    
    [[WXApiManager sharedManager] sendAuthRequestWithController:self
                                                       delegate:self];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)wxAuthSucceed:(NSString *)code {
    [self withdrawWechat:code];
    
}
@end
