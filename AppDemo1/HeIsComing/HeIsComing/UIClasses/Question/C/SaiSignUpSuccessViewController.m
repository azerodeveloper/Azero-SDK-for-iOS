//
//  SaiSignUpSuccessViewController.m
//  HeIsComing
//
//  Created by mike on 2020/6/19.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiSignUpSuccessViewController.h"
#import "SaiGameRulesModel.h"
#import "SaiGameRulesViewController.h"
@interface SaiSignUpSuccessViewController ()
@property(nonatomic,strong)SaiGameRulesModel *saiGameRulesModel ;

@end

@implementation SaiSignUpSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,KScreenW,KScreenH);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)kColorFromRGBHex(0x4780F1).CGColor,(__bridge id)kColorFromRGBHex(0x3735C4).CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [self.view.layer addSublayer:gl];
    blockWeakSelf;
    
    [super setResponseRenderTemplateStr:^(NSString * _Nonnull renderTemplateStr) {
       
        [weakSelf jumpVC:YES renderTemplateStr:renderTemplateStr];
        
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ttsPlayComplete) name:SaiTtsPlayComplete object:nil];
    self.saiGameRulesModel=[SaiGameRulesModel modelWithJson:[SaiAzeroManager sharedAzeroManager].renderTemplateStr];
    UILabel *whiteLabel=[UILabel CreatLabeltext:@"您已报名成功" Font:[UIFont systemFontOfSize:kSCRATIO(24)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:whiteLabel];
    [whiteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_offset(kSCRATIO(100));
    }];
    UILabel *timeTitleLabel=[UILabel CreatLabeltext:@"活动开始时间" Font:[UIFont systemFontOfSize:kSCRATIO(20)] Textcolor:kColorFromRGBHex(0xFED634) textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:timeTitleLabel];
    [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(whiteLabel.mas_bottom).mas_offset(kSCRATIO(150));
    }];
    UILabel *timeLabel=[UILabel CreatLabeltext:self.saiGameRulesModel.time Font:[UIFont systemFontOfSize:kSCRATIO(16)] Textcolor:kColorFromRGBHex(0xFED634) textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(timeTitleLabel.mas_bottom).mas_offset(kSCRATIO(40));
    }];
    UIButton *ruleButton=[UIButton CreatButtontext:@"查看游戏规则" image:nil Font:[UIFont systemFontOfSize:kSCRATIO(16)] Textcolor:UIColor.whiteColor];
    ViewRadius(ruleButton, kSCRATIO(3));
    [self.view addSubview:ruleButton];
    [ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(timeLabel.mas_bottom).mas_offset(kSCRATIO(150));
        make.width.mas_offset(kSCRATIO(200));
        make.height.mas_offset(kSCRATIO(50));
        
    }];
    ruleButton.backgroundColor=kColorFromRGBHex(0x24BCA7);
    [ruleButton addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)ruleClick{
    self.saiGameRulesModel=[SaiGameRulesModel modelWithJson:[SaiAzeroManager sharedAzeroManager].renderTemplateStr];

           if ([self.saiGameRulesModel.type isEqualToString:@"QuestionGameTemplate"]) {
               [self.navigationController pushViewController:[SaiGameRulesViewController new] animated:YES];
               
           }
  
}
- (void)ttsPlayComplete{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self backAction];
    });
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
