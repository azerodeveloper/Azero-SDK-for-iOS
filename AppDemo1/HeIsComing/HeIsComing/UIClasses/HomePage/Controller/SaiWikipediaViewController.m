//
//  SaiWikipediaViewController.m
//  HeIsComing
//
//  Created by mike on 2020/4/2.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiWikipediaViewController.h"
#import "SaiWikipediaModel.h"
@interface SaiWikipediaViewController ()
@property(nonatomic,strong)SaiWikipediaModel *saiWikipediaModel;

@end

@implementation SaiWikipediaViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"百科";
    self.saiWikipediaModel=[SaiWikipediaModel modelWithJson:[SaiAzeroManager sharedAzeroManager].renderTemplateStr];
    [self initView];
    [self registerNoti];
    blockWeakSelf;
    [super setResponseRenderTemplateStr:^(NSString * _Nonnull renderTemplateStr) {
        NSDictionary *diction=[SaiJsonConversionModel dictionaryWithJsonString:renderTemplateStr];
               TemplateTypeENUM templateTypet=[QKUITools returnTemplateFromRenderTemplateStr:diction[@"type"]];
               switch (templateTypet) {
                   case BodyTemplate1:
                       case DefaultTemplate1:

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
-(void)initView{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,KScreenW,KScreenH);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)kColorFromRGBHex(0x7997FF).CGColor,(__bridge id)kColorFromRGBHex(0x54CEFE).CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    
    [self.view.layer addSublayer:gl];
    UIView *whiteView=[UIView new];
    whiteView.backgroundColor=UIColor.whiteColor;
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.left.right.mas_offset(0);
        make.height.mas_offset(kNavHeight);
    }];
    UILabel *navLabel=[UILabel CreatLabeltext:@"百科介绍" Font:[UIFont boldSystemFontOfSize:kSCRATIO(17)] Textcolor:UIColor.blackColor textAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:navLabel];
    [navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.bottom.mas_offset(kSCRATIO(-15));
        make.height.mas_offset(kSCRATIO(16));
    }];
    UIButton *backAction=[UIButton new];
    [backAction addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backAction setImage:[UIImage imageNamed:@"dl_back"] forState:0];
    [whiteView addSubview:backAction];
    [backAction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(navLabel);
        make.left.mas_offset(kSCRATIO(15));
        make.height.width.mas_offset(kSCRATIO(31));

    }];
    UILabel *titleLabel=  [UILabel CreatLabeltext: self.saiWikipediaModel.extField.ASRText Font:[UIFont boldSystemFontOfSize:kSCRATIO(20)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    titleLabel.numberOfLines=0;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_offset(kSCRATIO(345));
        make.top.mas_offset(kSCRATIO(20)+kNavHeight);
    }];
//    UIImageView *iconImageView=[UIImageView new];
//    [iconImageView setImageURL:[NSURL URLWithString:self.saiWikipediaModel.backgroundImage.sources.firstObject.url]];
//    [self.view addSubview:iconImageView];
//    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.height.mas_offset(kSCRATIO(175));
//        make.width.mas_offset(kSCRATIO(345));
//
//        make.top.equalTo(titleLabel.mas_bottom).offset(kSCRATIO(20));
//    }];
    UITextView *titleTextView=  [UITextView new];
    titleTextView.backgroundColor=UIColor.clearColor;
    titleTextView.text=self.saiWikipediaModel.textField;
    titleTextView.editable=NO;
    titleTextView.font=[UIFont systemFontOfSize:kSCRATIO(20)];
    titleTextView.textColor=UIColor.whiteColor;
//    CGFloat height = ceilf([titleTextView sizeThatFits:CGSizeMake(kSCRATIO(345), MAXFLOAT)].height);
    
    [[NSNotificationCenter defaultCenter] addObserver:titleTextView
                                             selector:@selector(textViewDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    [self.view addSubview:titleTextView];
 
    UIImageView *logoImageView=[UIImageView new];
    [self.view addSubview:logoImageView];
    logoImageView.contentMode=UIViewContentModeScaleAspectFit;
    
    logoImageView.image=[UIImage imageNamed:@"yd_img_logo"];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(20));
        make.bottom.mas_offset(kSCRATIO(-30)-BOTTOM_HEIGHT);
        make.width.mas_offset(kSCRATIO(138));
        make.height.mas_offset(kSCRATIO(196));
        
    }];
    [titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.view);
         make.width.mas_offset(kSCRATIO(345));
         make.bottom.equalTo(logoImageView.mas_top).offset(kSCRATIO(-10));
         make.top.equalTo(titleLabel.mas_bottom).offset(kSCRATIO(20));
     }];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)registerNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ttsPlayComplete) name:SaiTtsPlayComplete object:nil];
}

- (void)ttsPlayComplete{
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        });
    });
}


@end
