//
//  SaiQuestionViewController.m
//  HeIsComing
//
//  Created by mike on 2020/3/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiQuestionViewController.h"
#import "SaiQuestionView.h"
#import "PTTestTopicModel.h"
#import "SaiQuestionModel.h"
#import "SaiGameRulesViewController.h"
#import "QQCorner.h"
#import "SaiWalletViewController.h"
#import "SaiAvPlayerManager.h"
@interface SaiQuestionViewController ()
@property (nonatomic, strong) SaiQuestionView *testView;
@property(nonatomic,strong)UILabel *cirlcrLabel ;
@property (nonatomic, strong) id timer;
@property(nonatomic,strong)UIImageView *circleImageView ;
@property(nonatomic,strong) SaiQuestionModel * questionModel ;
@property(nonatomic,strong)UILabel *joinGameNumberLabel ;
@property(nonatomic,strong)UILabel *joinGameCurrentNumberLabel ;
@property(nonatomic,strong)UIImageView *stateImageView ;
@property(nonatomic,strong)UIView *failureView;
@property(nonatomic,strong)UIView *failureEndView;

@property(nonatomic,strong)UIView *successView;

@property(nonatomic,strong)UILabel *leftView ;

@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *moneyLabel ;
@property(nonatomic,assign)BOOL isFailure;
@property(nonatomic,strong)NSString *submitAnswer;
@property(nonatomic,assign)BOOL isGameHelp;

@end

@implementation SaiQuestionViewController
#pragma mark - Lift Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"答题环节";
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,KScreenW,KScreenH);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:55/255.0 green:53/255.0 blue:196/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:71/255.0 green:128/255.0 blue:241/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    
    [self.view.layer addSublayer:gl];
    [self initNavigation];
    [self initView];
    [self initTestView];
    [self initData:[SaiAzeroManager sharedAzeroManager].renderTemplateStr];
    
    blockWeakSelf;
    [super setResponseRenderTemplateStr:^(NSString * _Nonnull renderTemplateStr) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        NSDictionary *diction=[SaiJsonConversionModel dictionaryWithJsonString:renderTemplateStr];
        TemplateTypeENUM templateTypet=[QKUITools returnTemplateFromRenderTemplateStr:diction[@"type"]];
        strongSelf.questionModel=[SaiQuestionModel modelWithJSON:[SaiJsonConversionModel dictionaryWithJsonString:renderTemplateStr]];
        if ([self.questionModel.scene isEqualToString:@"gameHelp"]&&[self.questionModel.type isEqualToString:@"QuestionGameTemplate"]) {
            [SaiAzeroManager sharedAzeroManager].renderTemplateStr=renderTemplateStr;
            _isGameHelp=YES;
            [strongSelf.navigationController pushViewController:[SaiGameRulesViewController new] animated:YES];
            
            return ;
        }
        switch (templateTypet) {
            case QuestionGameTemplate:
            {
                [strongSelf initData:renderTemplateStr];
                
            }
                break;
                
            default:{
                [weakSelf jumpVC:YES renderTemplateStr:renderTemplateStr];
                
            }
                break;
        }
        
        
    }];
    
    
    [super setGetDataBlock:^(NSString * _Nonnull type, NSString * _Nonnull content) {
        NSDictionary *dic = [SaiJsonConversionModel dictionaryWithJsonString:content];
        NSString *action = dic[@"answer"];
        if ([action isEqualToString:@"answer"]&&[dic[@"value"] isEqualToString:@"OFF"]) {
            [[SaiAzeroManager sharedAzeroManager]saiAzeroManagerSwitchMode:ModeAnswer andValue:YES];
        }
    }];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kPlayer.isAnswerModel=YES;
    [SaiAvPlayerManager sharedAvPlayerManager].isAnswerModel = YES;
    _isGameHelp=NO;
    [kPlayer pause];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroButtonPressed:ButtonTypePAUSE];
    [[SaiAzeroManager sharedAzeroManager]saiAzeroManagerSwitchMode:ModeAnswer andValue:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    kPlayer.isAnswerModel=NO;
    [SaiAvPlayerManager sharedAvPlayerManager].isAnswerModel = NO;
    if (!_isGameHelp) {
        NSDictionary *diction=@{
            @"type": @"answerGameEnd"
        };
        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerAnswerQuestion:diction];
    }
    [[SaiAzeroManager sharedAzeroManager]saiAzeroManagerSwitchMode:ModeAnswer andValue:NO];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSwitchMode:ModeHeadset andValue:YES];

}
#pragma mark - Init Views
-(void)initNavigation{
    self.backView=[UIView new];
    [self.view addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UILabel *navigationTitleLabel=[UILabel CreatLabeltext:@"答题环节" Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(17)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    [self.backView addSubview:navigationTitleLabel];
    [navigationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.mas_offset(kStatusBarHeight+kSCRATIO(15));
        
    }];
//    UIButton *rightButton=[UIButton new];
//    [rightButton setImage:[UIImage imageNamed:@"dt_icon_share"] forState:0];
//    [self.view addSubview:rightButton];
//    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(navigationTitleLabel);
//        make.right.mas_offset(-kSCRATIO(15));
//        make.width.height.mas_offset(kSCRATIO(19));
//    }];
}
-(void)initView{
    
    UILabel *leftView=[UILabel CreatLabeltext:@"正在观战中" Font:[UIFont systemFontOfSize:kSCRATIO(18)] Textcolor:UIColor.whiteColor textAlignment:0];
    self.leftView=leftView;
    leftView.hidden=YES;
    leftView.backgroundColor=kColorFromRGBHex(0xFD1900);
    [self.backView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_offset(kStatusBarHeight+kSCRATIO(50));
        make.width.mas_offset(kSCRATIO(100));
        make.height.mas_offset(kSCRATIO(32));
        
    }];
    [leftView layoutIfNeeded];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:leftView.bounds byRoundingCorners:  UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(kSCRATIO(16), kSCRATIO(16))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = leftView.bounds;
    maskLayer.path = maskPath.CGPath;
    leftView.layer.mask = maskLayer;
    UIImageView *helpImageView=[UIImageView new];
    helpImageView.userInteractionEnabled=YES;
    [helpImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        NSDictionary *diction=@{
            @"type": @"answerGameHelp"
        };
        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerAnswerQuestion:diction];
        
    }]];
    helpImageView.image=[UIImage imageNamed:@"dt_btn_help"];
    [self.backView addSubview:helpImageView];
    [helpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_offset(kStatusBarHeight+kSCRATIO(95));
        make.width.mas_offset(kSCRATIO(38));
        make.height.mas_offset(kSCRATIO(23));
        
    }];
    UILabel *joinGameNumberLabel=[UILabel CreatLabeltext:@"参赛人数" Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(12)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentRight];
    self.joinGameNumberLabel=joinGameNumberLabel;
    [self.backView addSubview:joinGameNumberLabel];
    [joinGameNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-kSCRATIO(15));
        make.top.mas_offset(kStatusBarHeight+kSCRATIO(75));
        make.height.mas_offset(kSCRATIO(15));
        
    }];
    UILabel *joinGameCurrentNumberLabel=[UILabel CreatLabeltext:@"当前人数" Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(12)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentRight];
    self.joinGameCurrentNumberLabel=joinGameCurrentNumberLabel;
    
    [self.backView addSubview:joinGameCurrentNumberLabel];
    [joinGameCurrentNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-kSCRATIO(15));
        make.top.equalTo(joinGameNumberLabel.mas_bottom).offset(kSCRATIO(10));
        make.height.mas_offset(kSCRATIO(15));
        
    }];
}
-(void)initTestView{
    [self.backView addSubview:self.testView];
    [self.testView setAnswerblock:^(NSString * _Nonnull answer) {
        
        if (![QKUITools isBlankString:answer]) {
            
            NSString *choiceS = [NSString stringWithFormat:@"%C",(unichar)([answer intValue]+65 )];
            
            NSDictionary *diction=@{
                @"type": @"answerGameSend",
                @"value": choiceS
                
            };
            [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerAnswerQuestion:diction];
            
        }
        //           NSDictionary *dictionary1=@{@"totalBonus":@300,@"speechLastTime":@18770,@"joinPeopleAmount":@26,@"voteEnum":@[@{@"content":@"平分",@"option":@"1"},@{@"content":@"随机",@"option":@"2"}],@"remainPeopleAmount":@16,@"type":@"QuestionGameTemplate",@"prologue":@"请闯关成功同学投票是否平分奖金",@"scene":@"vote",@"startVotingTime":@"2020-04-29 17:09:03"};
        //                         [self initData:[SaiJsonConversionModel dictionaryToJson:dictionary1]];
        
        
    }];
    blockWeakSelf;
    [self.testView setAnimationEndblock:^{
        [weakSelf countdownClickCallBack];
    }];
    
    
    [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.width.mas_offset(kSCRATIO(320));
        make.height.mas_offset(kSCRATIO(390));
        make.top.mas_offset(kSCRATIO(160)+kStatusBarHeight);
        
    }];
    [self.view addSubview:self.failureView];
    self.failureView.hidden=YES;
    [self.failureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        
    }];
    [self.view addSubview:self.failureEndView];
    self.failureEndView.hidden=YES;
    [self.failureEndView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        
    }];
    
    [self.view addSubview:self.successView];
    self.successView.hidden=YES;
    [self.successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        
    }];
    UIImageView *logoImageView=[UIImageView new];
    [self.backView addSubview:logoImageView];
    logoImageView.image=[UIImage imageNamed:@"dt_img_logo"];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.testView);
        make.centerY.equalTo(self.testView.mas_top);
        make.width.mas_offset(kSCRATIO(48));
        make.height.mas_offset(kSCRATIO(69));
        
    }];
    UIImageView *stateImageView=[UIImageView new];
    self.stateImageView=stateImageView;
    [self.backView addSubview:stateImageView];
    stateImageView.image=[UIImage imageNamed:@"dt_img_hear"];
    [stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoImageView.mas_right).offset(kSCRATIO(4));
        make.top.mas_offset(kSCRATIO(125)+kStatusBarHeight);
        make.width.mas_offset(kSCRATIO(67));
        make.height.mas_offset(kSCRATIO(33));
        
    }];
    UIImageView *circleImageView=[UIImageView new];
    [self.backView addSubview:circleImageView];
    self.circleImageView=circleImageView;
    circleImageView.image=[UIImage imageNamed:@"dt_bj_countdown"];
    [circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.testView);
        make.centerY.equalTo(self.testView.mas_top);
        make.width.height.mas_offset(kSCRATIO(87));
    }];
    UILabel *cirlcrLabel=[UILabel CreatLabeltext:@"15" Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(30)] Textcolor:kColorFromRGBHex(0x5F6CEB) textAlignment:NSTextAlignmentCenter];
    self.cirlcrLabel=cirlcrLabel;
    [circleImageView addSubview:cirlcrLabel];
    [cirlcrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(circleImageView);
        make.width.mas_offset(kSCRATIO(32));
        make.height.mas_offset(kSCRATIO(23));
        
    }];
    
}
#pragma mark -  Button Callbacks

-(void)initData:(NSString *)songListStr{
    if ([QKUITools isBlankString:songListStr]) {
        return;
    }
    self.questionModel=[SaiQuestionModel modelWithJSON:[SaiJsonConversionModel dictionaryWithJsonString:songListStr]];
    self.leftView.hidden=!self.isFailure;
    if ([self.questionModel.scene isEqualToString:@"sendQuestion"]) {
        self.submitAnswer=@"";
        self.testView.model=self.questionModel;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"参赛人数%@",self.questionModel.joinPeopleAmount]attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: kSCRATIO(12)],NSForegroundColorAttributeName: UIColor.whiteColor}];
        [string setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: kSCRATIO(16)],NSForegroundColorAttributeName: UIColor.whiteColor} range:NSMakeRange(4, string.length-4)];
        if (self.backView.hidden) {
            _failureView.hidden=YES;
            self.backView.hidden=NO;
        }
        
        [self.circleImageView setImage:[UIImage imageNamed:@"dt_bj_countdown"]];
        self.cirlcrLabel.hidden=NO;
        
        
        
        
        self.joinGameNumberLabel.attributedText = string;
        NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前人数%@",self.questionModel.remainPeopleAmount]attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: kSCRATIO(12)],NSForegroundColorAttributeName: UIColor.whiteColor}];
        [string1 setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: kSCRATIO(16)],NSForegroundColorAttributeName: UIColor.whiteColor} range:NSMakeRange(4, string1.length-4)];
        
        self.joinGameNumberLabel.attributedText = string;
        self.joinGameCurrentNumberLabel.attributedText=string1;
        self.stateImageView.image=[UIImage imageNamed:@"dt_img_hear"];
        
    }else if ([self.questionModel.scene isEqualToString:@"answerQuestion"]){
     
        if (self.questionModel.submitAnswer) {
            self.testView.choiceView.haveSelectChoice=@[self.questionModel.submitAnswer];
        }
        self.submitAnswer=self.questionModel.submitAnswer;
        
        
    }else if ([self.questionModel.scene isEqualToString:@"questionResult"]){
        if (_timer) {
            dispatch_source_cancel(_timer);
        }
        if ([QKUITools isBlankString:self.submitAnswer]) {
            
            if (![QKUITools isBlankString:self.questionModel.correctAnswer]) {
                self.testView.choiceView.correctChoice=@[self.questionModel.correctAnswer];
            }
            self.cirlcrLabel.hidden=YES;
            [self.circleImageView setImage:[UIImage imageNamed:@"dt_icon_overtime"]];
            self.cirlcrLabel.hidden=YES;
            self.stateImageView.image=[UIImage imageNamed:@"dt_icon_overtime1"];
            if (!self.isFailure) {
                _failureView.hidden=NO;
                self.backView.hidden=YES;
                self.isFailure=true;
            }
            
        }else if ([self.submitAnswer isEqualToString:self.questionModel.correctAnswer]) {
            if (![QKUITools isBlankString:self.questionModel.correctAnswer]) {
                self.testView.choiceView.correctChoice=@[self.questionModel.correctAnswer];
            }
            [self.circleImageView setImage:[UIImage imageNamed:@"dt_icon_correct"]];
            self.cirlcrLabel.hidden=YES;
            self.stateImageView.image=[UIImage imageNamed:@"dt_icon_correct1"];
            
        }else{
            self.leftView.hidden=NO;
            self.testView.choiceView.correctChoice=@[self.questionModel.correctAnswer];
            
            if (![QKUITools isBlankString:self.submitAnswer]) {
                self.testView.choiceView.errorChoice=@[self.submitAnswer];
            }
            [self.circleImageView setImage:[UIImage imageNamed:@"dt_icon_error"]];
            self.cirlcrLabel.hidden=YES;
            self.stateImageView.image=[UIImage imageNamed:@"dt_icon_error1"];
            if (!self.isFailure) {
                _failureView.hidden=NO;
                self.backView.hidden=YES;
                self.isFailure=true;
            }
        }
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"参赛人数%@",self.questionModel.joinPeopleAmount]attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: kSCRATIO(12)],NSForegroundColorAttributeName: UIColor.whiteColor}];
        [string setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: kSCRATIO(16)],NSForegroundColorAttributeName: UIColor.whiteColor} range:NSMakeRange(4, string.length-4)];
        
        
        self.cirlcrLabel.text=@"15";

        
        self.joinGameNumberLabel.attributedText = string;
        NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前人数%@",self.questionModel.remainPeopleAmount]attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: kSCRATIO(12)],NSForegroundColorAttributeName: UIColor.whiteColor}];
        [string1 setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: kSCRATIO(16)],NSForegroundColorAttributeName: UIColor.whiteColor} range:NSMakeRange(4, string1.length-4)];
        
        self.joinGameNumberLabel.attributedText = string;  self.joinGameCurrentNumberLabel.attributedText=string1;
        if (self.isFailure&&[self.questionModel.questionIndex intValue]+1==[self.questionModel.totalQuestionNumber intValue]) {
            _failureEndView.hidden=NO;
            self.backView.hidden=YES;
        }
        
    }else if ([self.questionModel.scene isEqualToString:@"vote"]){
        
        
        
        NSMutableArray *mutableArray=[NSMutableArray array];
        for (SaiQuestionModelAnswersVoteItem *model in self.questionModel.voteEnum) {
            SaiQuestionModelAnswers *saiQuestionModelAnswers=[SaiQuestionModelAnswers new];
            saiQuestionModelAnswers.content=model.content;
            if (saiQuestionModelAnswers) {
                [mutableArray addObject:saiQuestionModelAnswers];
            }
        }
        self.questionModel.title=@"请闯关成功同学投票是否平分奖金";
        self.questionModel.questionIndex=[NSNumber numberWithInt:20];
        
        self.questionModel.answers=mutableArray;
        self.testView.model=self.questionModel;
        
        
    }else if ([self.questionModel.scene isEqualToString:@"submitVote"]){
        
        self.testView.choiceView.haveSelectChoice=@[[self.questionModel.vote isEqualToString:@"1"]?@"A":@"B"];
        
    }
    else if ([self.questionModel.scene isEqualToString:@"voteResult"]){
        self.successView.hidden=NO;
        self.stateImageView.hidden=YES;
        self.backView.hidden=YES;
        if (![QKUITools isBlankString:self.questionModel.ownBonus]) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",self.questionModel.ownBonus]attributes: @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kSCRATIO(25)],NSForegroundColorAttributeName: kColorFromRGBHex(0xF84836)}];
            
            self.moneyLabel.attributedText=string;
        }
        
        
    }
    else if ([self.questionModel.scene isEqualToString:@"exitGame"]){
        [self backAction];
        
    }
    
}
-(void)countdownClickCallBack{
    if (_timer) {
        dispatch_source_cancel(_timer);
        
    }
    
    __block NSInteger second = 14;
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
                self.cirlcrLabel.text=[[NSNumber numberWithInteger:second] stringValue];
                second--;
                self.cirlcrLabel.hidden=NO;
                
                [self.circleImageView setImage:[UIImage imageNamed:@"dt_bj_countdown"]];
                
            }
            else
            {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timer);
                self.cirlcrLabel.hidden=YES;
                
                [self.circleImageView setImage:[UIImage imageNamed:@"dt_icon_overtime"]];
                
            }
        });
    });
    //启动源
    dispatch_resume(timer);
    
}
#pragma mark - 懒加载
- (SaiQuestionView *)testView {
    
    if (!_testView) {
        _testView = [[SaiQuestionView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kSCRATIO(320), kSCRATIO(390))];
    }
    return _testView;
}
-(UIView *)failureView{
    
    if (!_failureView) {
        _failureView=[[UIView alloc] initWithFrame:CGRectZero];
        UILabel *titleLabel=[UILabel CreatLabeltext:@"很遗憾闯失败" Font:[UIFont boldSystemFontOfSize:kSCRATIO(28)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
        [_failureView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_failureView);
            make.height.mas_offset(kSCRATIO(27));
            make.top.mas_offset(kSCRATIO(70)+kStatusBarHeight);
            
        }];
        UIImageView *failureImageView=[UIImageView new];
        failureImageView.userInteractionEnabled=YES;
        [_failureView addSubview:failureImageView];
        [failureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_failureView);
            make.height.mas_offset(kSCRATIO(386));
            make.width.mas_offset(kSCRATIO(333));
            
            make.top.mas_offset(kSCRATIO(120)+kStatusBarHeight);
            
        }];
        failureImageView.image=[UIImage imageNamed:@"dt_img_fail"];
        UILabel *failureLabel=[UILabel CreatLabeltext:@"闯关失败" Font:[UIFont boldSystemFontOfSize:kSCRATIO(23)] Textcolor:Color333333 textAlignment:NSTextAlignmentCenter];
        [failureImageView addSubview:failureLabel];
        [failureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(failureImageView);
            make.height.mas_offset(kSCRATIO(22));
            make.top.mas_offset(kSCRATIO(70));
            
        }];
        
        UIButton *continuecButton=[UIButton CreatButtontext:@"继续查看剩余题目" image:nil Font:[UIFont boldSystemFontOfSize:kSCRATIO(18)] Textcolor:UIColor.whiteColor];
        [failureImageView addSubview:continuecButton];
        [continuecButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(failureImageView);
            make.height.mas_offset(kSCRATIO(45));
            make.top.equalTo(failureLabel.mas_bottom).offset(kSCRATIO(120));
            make.width.mas_offset(kSCRATIO(180));
            
        }];
        [continuecButton layoutIfNeeded];
        
        [continuecButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            _failureView.hidden=YES;
            self.backView.hidden=NO;
            
        }]];
        [continuecButton  setBackgroundImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.toColor = kColorFromRGBHex(0x0EAD6E);
            graColor.fromColor = kColorFromRGBHex(0x2BE1DF);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:continuecButton.bounds.size cornerRadius:QQRadiusMakeSame(kSCRATIO(22.5))] forState:0];
        UIButton *endButton=[UIButton CreatButtontext:@"结束游戏" image:nil Font:[UIFont boldSystemFontOfSize:kSCRATIO(18)] Textcolor:UIColor.whiteColor];
        [failureImageView addSubview:endButton];
        [endButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(failureImageView);
            make.height.mas_offset(kSCRATIO(45));
            make.top.equalTo(continuecButton.mas_bottom).offset(kSCRATIO(20));
            make.width.mas_offset(kSCRATIO(180));
            
        }];
        [endButton layoutIfNeeded];
        [endButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            
            [self backAction];
        }]];
        [endButton  setBackgroundImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.toColor = kColorFromRGBHex(0xD1D1D1);
            graColor.fromColor = kColorFromRGBHex(0xB9B9B9);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:endButton.bounds.size cornerRadius:QQRadiusMakeSame(kSCRATIO(22.5))] forState:0];
    }
    return _failureView;
}
-(UIView *)failureEndView{
    
    if (!_failureEndView) {
        _failureEndView=[[UIView alloc] initWithFrame:CGRectZero];
        UILabel *titleLabel=[UILabel CreatLabeltext:@"很遗憾闯失败" Font:[UIFont boldSystemFontOfSize:kSCRATIO(28)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
        [_failureEndView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_failureEndView);
            make.height.mas_offset(kSCRATIO(27));
            make.top.mas_offset(kSCRATIO(70)+kStatusBarHeight);
            
        }];
        UIImageView *failureImageView=[UIImageView new];
        failureImageView.userInteractionEnabled=YES;
        [_failureEndView addSubview:failureImageView];
        [failureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_failureEndView);
            make.height.mas_offset(kSCRATIO(386));
            make.width.mas_offset(kSCRATIO(333));
            
            make.top.mas_offset(kSCRATIO(120)+kStatusBarHeight);
            
        }];
        failureImageView.image=[UIImage imageNamed:@"dt_img_fail"];
        UILabel *failureLabel=[UILabel CreatLabeltext:@"闯关失败" Font:[UIFont boldSystemFontOfSize:kSCRATIO(23)] Textcolor:Color333333 textAlignment:NSTextAlignmentCenter];
        [failureImageView addSubview:failureLabel];
        [failureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(failureImageView);
            make.height.mas_offset(kSCRATIO(22));
            make.top.mas_offset(kSCRATIO(70));
            
        }];
        
        UIButton *endButton=[UIButton CreatButtontext:@"结束游戏" image:nil Font:[UIFont boldSystemFontOfSize:kSCRATIO(18)] Textcolor:UIColor.whiteColor];
        [failureImageView addSubview:endButton];
        [endButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(failureImageView);
            make.height.mas_offset(kSCRATIO(45));
            make.top.equalTo(failureLabel.mas_bottom).offset(kSCRATIO(120));
            make.width.mas_offset(kSCRATIO(180));
            
        }];
        [endButton layoutIfNeeded];
        [endButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            
            [self backAction];
        }]];
        [endButton  setBackgroundImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.toColor = kColorFromRGBHex(0xD1D1D1);
            graColor.fromColor = kColorFromRGBHex(0xB9B9B9);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:endButton.bounds.size cornerRadius:QQRadiusMakeSame(kSCRATIO(22.5))] forState:0];
    }
    return _failureEndView;
}
-(UIView *)successView{
    if (!_successView) {
        _successView=[[UIView alloc] initWithFrame:CGRectZero];
        UILabel *titleLabel=[UILabel CreatLabeltext:@"恭喜您闯关成功" Font:[UIFont boldSystemFontOfSize:kSCRATIO(28)] Textcolor:kColorFromRGBHex(0xFEF3AC) textAlignment:NSTextAlignmentCenter];
        [_successView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_successView);
            make.height.mas_offset(kSCRATIO(27));
            make.top.mas_offset(kSCRATIO(70)+kStatusBarHeight);
            
        }];
        UIImageView *failureImageView=[UIImageView new];
        failureImageView.userInteractionEnabled=YES;
        [_successView addSubview:failureImageView];
        [failureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_successView);
            make.height.mas_offset(kSCRATIO(386));
            make.width.mas_offset(kSCRATIO(333));
            
            make.top.mas_offset(kSCRATIO(120)+kStatusBarHeight);
            
        }];
        failureImageView.image=[UIImage imageNamed:@"dt_img_success"];
        UILabel *failureLabel=[UILabel CreatLabeltext:@"获得奖金" Font:[UIFont boldSystemFontOfSize:kSCRATIO(23)] Textcolor:kColorFromRGBHex(0xE62752) textAlignment:NSTextAlignmentCenter];
        [failureImageView addSubview:failureLabel];
        [failureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(failureImageView);
            make.height.mas_offset(kSCRATIO(22));
            make.top.mas_offset(kSCRATIO(130));
            
        }];
        UILabel *moneyLabel=[UILabel new];
        self.moneyLabel=moneyLabel;
        [failureImageView addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(failureImageView);
            make.top.equalTo(failureLabel.mas_bottom).offset(kSCRATIO(15));
            
        }];
        UIButton *continuecButton=[UIButton CreatButtontext:@"查看钱包" image:nil Font:[UIFont boldSystemFontOfSize:kSCRATIO(18)] Textcolor:UIColor.whiteColor];
        [failureImageView addSubview:continuecButton];
        [continuecButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(failureImageView);
            make.height.mas_offset(kSCRATIO(45));
            make.top.equalTo(failureLabel.mas_bottom).offset(kSCRATIO(70));
            make.width.mas_offset(kSCRATIO(180));
            
        }];
        [continuecButton layoutIfNeeded];
        [continuecButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            _successView.hidden=YES;
            self.backView.hidden=NO;
            [self dismissViewControllerAnimated:NO completion:^{

                [self presentViewController:[SaiWalletViewController new ] animated:NO completion:nil];
            }];
            
        }]];
        [continuecButton  setBackgroundImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.toColor = kColorFromRGBHex(0xE52F56);
            graColor.fromColor = kColorFromRGBHex(0xFD4877);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:continuecButton.bounds.size cornerRadius:QQRadiusMakeSame(kSCRATIO(22.5))] forState:0];
        UIButton *endButton=[UIButton CreatButtontext:@"结束游戏" image:nil Font:[UIFont boldSystemFontOfSize:kSCRATIO(18)] Textcolor:UIColor.whiteColor];
        [failureImageView addSubview:endButton];
        [endButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(failureImageView);
            make.height.mas_offset(kSCRATIO(45));
            make.top.equalTo(continuecButton.mas_bottom).offset(kSCRATIO(20));
            make.width.mas_offset(kSCRATIO(180));
            
        }];
        [endButton layoutIfNeeded];
        [endButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            
            [self backAction];
        }]];
        [endButton  setBackgroundImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.toColor = kColorFromRGBHex(0xD1D1D1);
            graColor.fromColor = kColorFromRGBHex(0xB9B9B9);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:endButton.bounds.size cornerRadius:QQRadiusMakeSame(kSCRATIO(22.5))] forState:0];
    }
    return _successView;
}

@end
