//
//  LoginViewController.m
//  HeIsComing
//
//  Created by mike on 2020/3/24.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "LoginViewController.h"
#import "CodeViewController.h"
#import "CodeModel.h"
#import <WebKit/WebKit.h>

@interface LoginViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)WKWebView *webView;

@end

@implementation LoginViewController
{
    UIButton *  codeButton;
    __block   UITextField *   phoneTextField;
    __block    UILabel *phoneLabel;
    
}
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}
-(void)setupUI{
    
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
    
    SaiContext.currentUser = nil;
           [YYTextArchiver archiveRootObject:SaiContext.currentUser toFile:DOCUMENT_FOLDER(@"loginedUser")];
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.mas_offset(120+kStatusBarHeight);
        
    }];
    [whiteView layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:whiteView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = whiteView.bounds;
    maskLayer.path = maskPath.CGPath;
    whiteView.layer.mask = maskLayer;
    UILabel *loginLabel=[UILabel CreatLabeltext:@"手机号登录" Font:[UIFont fontWithName:@"PingFang-SC-Bold" size:17] Textcolor:kColorFromRGBHex(0x333333) textAlignment:0];
    loginLabel.text=@"手机号登录";
    [whiteView addSubview:loginLabel];
    [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(30);
        make.top.mas_offset(32);
        make.height.mas_offset(16);
    }];
    
    phoneTextField = [UITextField new];
    phoneTextField.delegate = self;
    phoneTextField.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    phoneTextField.returnKeyType = UIReturnKeyDone;
    NSMutableParagraphStyle *style = [phoneTextField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    
    style.minimumLineHeight = phoneTextField.font.lineHeight - (phoneTextField.font.lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) / 2.0;
    phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号"attributes:@{NSForegroundColorAttributeName: kColorFromRGBHex(0x999999),NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Medium" size:14],NSParagraphStyleAttributeName : style}];
    phoneTextField.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    phoneTextField.textColor=Color999999;
    phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(30);
        make.right.mas_offset(-30);
        make.top.equalTo(loginLabel.mas_bottom).offset(20);
        make.height.mas_offset(40);
    }];
    [phoneTextField layoutIfNeeded];
    [phoneTextField addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    UIView *lineView=[UIView new];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(phoneTextField);
        make.top.equalTo(phoneTextField.mas_bottom);
        make.height.mas_offset(1);
    }];
    lineView.backgroundColor=Color999999;
    UIView *mostView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,75, phoneTextField.height)];
    phoneTextField.leftView = mostView;
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *phoneImageView=[UIImageView new];
    [mostView addSubview:phoneImageView];
    phoneImageView.image=[UIImage imageNamed:@"dl_icon_username"];
    phoneImageView.frame=CGRectMake(5, 0, 14, 21);
    
    phoneLabel =[UILabel CreatLabeltext:@"+86" Font:[UIFont fontWithName:@"PingFang-SC-Medium" size:14] Textcolor:kColorFromRGBHex(0x999999) textAlignment:0] ;
    [mostView addSubview:phoneLabel];
    phoneLabel.userInteractionEnabled=YES;
    phoneLabel.frame=CGRectMake(30, 0, 40, 21.5);
    phoneImageView.centerY=mostView.centerY;
    phoneLabel.centerY=mostView.centerY;
    
    UILabel *registeredLabel=[UILabel CreatLabeltext:@"未注册手机验证后自动登录" Font:[UIFont fontWithName:@"PingFang SC" size: 12] Textcolor:kColorFromRGBHex(0x999999) textAlignment:0];
    [whiteView addSubview:registeredLabel];
    [registeredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-35);
        make.top.equalTo(phoneTextField.mas_bottom).offset(15);
        make.height.mas_offset(12);
    }];
    codeButton=[[UIButton alloc]init];
    codeButton.enabled=NO;
    [codeButton setImage:[UIImage imageNamed:@"dl__disabled_btn_obtain"] forState:UIControlStateDisabled];
    [codeButton setImage:[UIImage imageNamed:@"dl_highlight_btn_obtain"] forState:UIControlStateNormal];
    [codeButton addTarget:self action:@selector(loginClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeButton];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registeredLabel.mas_bottom).offset(40);
        make.right.mas_offset(-26);
        make.left.mas_offset(26);
        make.height.mas_offset(58);
    }];
    YYLabel *agreementLabel = [[YYLabel alloc] init];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"登陆即代表同意用户协议和隐私政策"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 12],NSForegroundColorAttributeName: Color666666}];
    [string setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 12],NSForegroundColorAttributeName: kColorFromRGBHex(0x769BFF)} range:NSMakeRange(7, 4)];
    agreementLabel.textAlignment=NSTextAlignmentCenter;
    
    
    [string setTextHighlightRange:NSMakeRange(7, 4)color:kColorFromRGBHex(0x769BFF) backgroundColor:nil tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        
        UIView *bgV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [[[UIApplication sharedApplication].delegate window] addSubview:bgV];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [bgV removeFromSuperview];
        }];
        [bgV addGestureRecognizer:tap];  
        UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW*0.8, KScreenH*0.8)];
        whiteView.backgroundColor=UIColor.whiteColor;
        [bgV addSubview:whiteView];
        ViewRadius(whiteView, kSCRATIO(20));
        whiteView.center=bgV.center;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api-dev-azero.soundai.cn/v1/surrogate/page/agreement" ]];
        [self.webView loadRequest:request];
        [whiteView addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(whiteView);
        }];
        
    }];
    [string setTextHighlightRange:NSMakeRange(12, 4)color:kColorFromRGBHex(0x769BFF) backgroundColor:nil tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        UIView *bgV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [[[UIApplication sharedApplication].delegate window] addSubview:bgV];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [bgV removeFromSuperview];
        }];
        [bgV addGestureRecognizer:tap];
        UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW*0.8, KScreenH*0.8)];
        whiteView.backgroundColor=UIColor.whiteColor;
        [bgV addSubview:whiteView];
        ViewRadius(whiteView, kSCRATIO(20));
        whiteView.center=bgV.center;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api-dev-azero.soundai.cn/v1/surrogate/page/personal" ]];
        
        [self.webView loadRequest:request];
        [whiteView addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(whiteView);
        }];
        
    }];
    agreementLabel.userInteractionEnabled=YES;
    agreementLabel.attributedText = string;
    [self.view addSubview:agreementLabel];
    
    [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.height.mas_offset(12);
        make.bottom.mas_offset(-24-BOTTOM_HEIGHT);
        
    }];
    
    
}
- (WKWebView *)webView
{
    if (_webView == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.dataDetectorTypes=UIDataDetectorTypeNone;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH) configuration:config];
        _webView.scrollView.showsHorizontalScrollIndicator=NO;
        _webView.scrollView.showsVerticalScrollIndicator=NO;
        
        //        _webView.UIDelegate =
        //        f;        // 导航代理
        
    }
    return _webView;
}

#pragma mark -  Button Callbacks

- (void)textValueChanged
{
    if ([phoneLabel.text isEqualToString:@"+86"]) {
        if (phoneTextField.text.length == 11) {
            codeButton.enabled=YES;
        } else {
            codeButton.enabled=NO;
        }
    }else{
        if (phoneTextField.text.length >= 5) {
            codeButton.enabled=YES;
        } else {
            codeButton.enabled=NO;
        }
    }
    
}


-(void)loginClickCallBack:(UIButton *)sender{  
    sender.enabled=NO;  
    [self.view endEditing:YES];  
    [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/verification" andParam:@{@"phoneNumber":phoneTextField.text,@"countryCode":phoneLabel.text,@"type":@"VERIFICATION",@"sender":@"0"} andSuccessBlock:^(NSURL *URL, id data) {
        CodeModel *model=[CodeModel modelWithJSON:data];
        sender.enabled=YES;
        if (model.code==200) {
            CodeViewController *codeVC=[CodeViewController new];
            codeVC.verificationId=model.data.verificationId;
            codeVC.phoneString=phoneTextField.text;
            codeVC.codeString=phoneLabel.text;  
            [self.navigationController pushViewController:codeVC animated:YES];
        }
    } andFailBlock:^(NSURL *URL, NSError *error) {
        sender.enabled=YES;
        
    }];
}
#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == phoneTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (phoneTextField.text.length >= 11) {
            phoneTextField.text = [textField.text substringToIndex:11];
            
            return NO;
        }
        
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
