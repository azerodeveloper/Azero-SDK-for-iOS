//
//  QKUIAlertView.m
//  Sekey
//
//  Created by silk on 2017/7/25.
//  Copyright © 2017年 silk. All rights reserved.
//

#import "QKUIAlertView.h"
#define white_viewX   45
#define white_viewY   220
#define _title_labelX  0
#define _title_labelY  28
#define white_viewW   300
#define closeBtnW       50
#define separatorViewHeight  0.5
@interface QKUIAlertView ()<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, copy) cancelButtonCallback cancelButtonHandle;
@property (nonatomic, copy) otherButtonCallback otherButtonHandle;
@property (nonatomic, copy) retryButtonCallback retryButtonHandle;
@property (nonatomic, copy) disconnectButtonCallback disconnectButtonHandle;
@property (nonatomic, copy) notCheakButtonCallback notCheakButtonHandle;
@property (nonatomic, copy) logoutButtonCallback logoutButtonHandle;
@property (nonatomic, copy) continueButtonCallback continueButtonHandle;
@property (nonatomic, copy) sureButtonCallback sureButtonHandle;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, copy) feedbackButtonCallback feedbackButtonHandle;

@property (nonatomic ,strong) UITextView *textView;



@end
@implementation QKUIAlertView
- (void)dealloc{
    self.timer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}
-(instancetype)init{
    self=[super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return self;
}

/*
 版本更新
 */
- (void)versionUpdateWith:(NSString *)message sureTitle:(NSString *)sureTitle otherBlockCallBack:(otherButtonCallback)otherCallback{
    UIView *white_view = [[UIView alloc]init];
    white_view.backgroundColor=[UIColor whiteColor];
    white_view.layer.cornerRadius=12;
    white_view.layer.masksToBounds = YES;
    [self addSubview:white_view];

    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth - white_viewX*2, 17)];
    titlelabel.textColor = SaiColor(20, 20, 24);
    titlelabel.text = @"版本更新";
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0f];
    [white_view addSubview:titlelabel];
    
    //  body
    UILabel *bodyLabel = [[UILabel alloc]init];
    bodyLabel.numberOfLines =0;
    bodyLabel.text = message;
    bodyLabel.textColor = SaiColor(46, 46, 46);
    bodyLabel.textAlignment=NSTextAlignmentLeft;
    bodyLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:15.0f];
    [UILabel changeLineSpaceForLabel:bodyLabel WithSpace:6];
    bodyLabel.lineBreakMode = NSLineBreakByCharWrapping;  
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 6;
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    UIFont *textFont = [UIFont qk_PingFangSCRegularFontwithSize:16.0];
    NSDictionary *attributesDic = @{NSFontAttributeName:textFont,NSParagraphStyleAttributeName:paraStyle};
    CGSize maxSize = CGSizeMake(kScreenWidth - white_viewX*2-_title_labelY*2, MAXFLOAT);
    CGSize size = [message boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil].size;
    bodyLabel.frame = CGRectMake(25,CGRectGetMaxY(titlelabel.frame),kScreenWidth - white_viewX*2-25*2, size.height+30);
    [white_view addSubview:bodyLabel];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(35, CGRectGetMaxY(bodyLabel.frame)+20, kScreenWidth-white_viewX*2-35*2, 44);
    [sureButton setTitle:sureTitle forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0f];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"logonbg_red"] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    sureButton.layer.masksToBounds = YES;
    sureButton.layer.cornerRadius = sureButton.size.height/2.0f;
    [white_view addSubview:sureButton];
    white_view.frame = CGRectMake(white_viewX, 170*HScreenRatio, kScreenWidth - white_viewX*2, CGRectGetMaxY(sureButton.frame)+30);
    UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    crossBtn.frame = CGRectMake( CGRectGetMaxX(white_view.frame) - closeBtnW/2,CGRectGetMinY(white_view.frame)-closeBtnW/2 , closeBtnW, closeBtnW);
    [crossBtn setImage:[UIImage imageNamed:@"crossLocal"] forState:UIControlStateNormal];
    crossBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [crossBtn addTarget:self action:@selector(crossBtnClickCallBack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:crossBtn];
    if (otherCallback) {
        self.otherButtonHandle = otherCallback;
    }
}
//确认
-(void)sure{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf removeFromSuperview];
    } completion:^(BOOL finished) {
    }];
    if (self.otherButtonHandle) {
        self.otherButtonHandle();
    }
}
-(void)feedbackButtonsure{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf removeFromSuperview];
    } completion:^(BOOL finished) {
    }];
    if (self.feedbackButtonHandle) {
        weakSelf.feedbackButtonHandle(weakSelf.textView.text);
    }
}
- (void)crossBtnClickCallBack{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf removeFromSuperview];
    } completion:^(BOOL finished) {
    }];
}

//警告框显示
-(void)showAlert{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        UIWindow * window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:weakSelf];
    } completion:^(BOOL finished) {
    }];
}


/**
* 信息反馈
*/
- (void)informationFeedbackOtherBlockCallBack:(feedbackButtonCallback)feedbackCallback withType:(int )type{
    UIView *white_view = [[UIView alloc]init];  
    white_view.backgroundColor=[UIColor whiteColor];
    white_view.layer.cornerRadius=12;
    white_view.layer.masksToBounds = YES;
    [self addSubview:white_view];

    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth - white_viewX*2, 17)];
    titlelabel.textColor = SaiColor(20, 20, 24);
    if (type == 1) {
        titlelabel.text = @"其实你想说的是？";
    }else{
        titlelabel.text = @"问题描述";
    }
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0f];
    [white_view addSubview:titlelabel];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = SaiColor(245, 245, 245);
    textView.layer.borderWidth = 0.5;
    textView.delegate = self;
    textView.layer.borderColor = SaiColor(210, 211, 213).CGColor;
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 1.0;
    textView.frame = CGRectMake(25, CGRectGetMaxY(titlelabel.frame)+10, kScreenWidth - white_viewX*2-25*2, 150);
    [white_view addSubview:textView];
    self.textView = textView;
    
    
    // _placeholderLabel
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入您的问题或建议";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [textView addSubview:placeHolderLabel];

    // same font
    textView.font = [UIFont systemFontOfSize:13.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:13.f];

    [textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    
//    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    sureButton.frame = CGRectMake(35, CGRectGetMaxY(textView.frame)+20,( kScreenWidth-white_viewX*2-35*2), 44);
//    [sureButton setTitle:@"提交" forState:UIControlStateNormal];
//    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    sureButton.titleLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0f];
//    [sureButton setBackgroundImage:[UIImage imageNamed:@"logonbg_red"] forState:UIControlStateNormal];
//    [sureButton addTarget:self action:@selector(feedbackButtonsure) forControlEvents:UIControlEventTouchUpInside];
//    sureButton.layer.masksToBounds = YES;
//    sureButton.layer.cornerRadius = sureButton.size.height/2.0f;
//    [white_view addSubview:sureButton];
//    sureButton.enabled = NO;
//    self.sureBtn = sureButton;
//    white_view.frame = CGRectMake(white_viewX, 170*HScreenRatio, kScreenWidth - white_viewX*2, CGRectGetMaxY(sureButton.frame)+20);
//    UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    crossBtn.frame = CGRectMake( CGRectGetMaxX(white_view.frame) - closeBtnW/2,CGRectGetMinY(white_view.frame)-closeBtnW/2 , closeBtnW, closeBtnW);
//    [crossBtn setImage:[UIImage imageNamed:@"crossLocal"] forState:UIControlStateNormal];
//    crossBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [crossBtn addTarget:self action:@selector(crossBtnClickCallBack) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:crossBtn];
    
    
    UIView *horizontalLine = [[UIView alloc] init];
    horizontalLine.frame = CGRectMake(0, CGRectGetMaxY(textView.frame)+10, kScreenWidth - white_viewX*2, 0.5);
    horizontalLine.backgroundColor = SaiColor(210, 211, 213);
    [white_view addSubview:horizontalLine];
    
    UIView *verticalLine = [[UIView alloc] init];
    verticalLine.frame = CGRectMake((kScreenWidth - white_viewX*2)/2, CGRectGetMaxY(textView.frame)+10, 0.5, 44+20);
    verticalLine.backgroundColor = SaiColor(210, 211, 213);
    [white_view addSubview:verticalLine];
    
    UIButton *canecelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    canecelButton.backgroundColor = [UIColor clearColor];
    canecelButton.frame = CGRectMake(0, CGRectGetMaxY(textView.frame)+10,( kScreenWidth-white_viewX*2)/2, 44);
    [canecelButton setTitle:@"取消" forState:UIControlStateNormal];
    [canecelButton setTitleColor:SaiColor(204, 204  ,204) forState:UIControlStateNormal];
    canecelButton.titleLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0f];
//    [canecelButton setBackgroundImage:[UIImage imageNamed:@"logonbg_red"] forState:UIControlStateNormal];
    [canecelButton addTarget:self action:@selector(crossBtnClickCallBack) forControlEvents:UIControlEventTouchUpInside];
    canecelButton.layer.masksToBounds = YES;
    canecelButton.layer.cornerRadius = canecelButton.size.height/2.0f;
    [white_view addSubview:canecelButton];

    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(( kScreenWidth-white_viewX*2)/2, CGRectGetMaxY(textView.frame)+10,( kScreenWidth-white_viewX*2)/2, 44);
    sureButton.backgroundColor = [UIColor clearColor];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:SaiColor(245, 166  ,35) forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0f];
//    [sureButton setBackgroundImage:[UIImage imageNamed:@"logonbg_red"] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(feedbackButtonsure) forControlEvents:UIControlEventTouchUpInside];
    sureButton.layer.masksToBounds = YES;
    sureButton.layer.cornerRadius = sureButton.size.height/2.0f;
    [white_view addSubview:sureButton];
    white_view.frame = CGRectMake(white_viewX, 170*HScreenRatio, kScreenWidth - white_viewX*2, CGRectGetMaxY(sureButton.frame));
    
    if (feedbackCallback) {
        self.feedbackButtonHandle = feedbackCallback;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        self.sureBtn.enabled = YES;
    }else{
        self.sureBtn.enabled = NO;
    }
}
@end
