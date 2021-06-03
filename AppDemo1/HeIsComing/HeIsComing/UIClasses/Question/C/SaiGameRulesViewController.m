//
//  SaiGameRulesViewController.m
//  HeIsComing
//
//  Created by mike on 2020/4/3.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiGameRulesViewController.h"
#import "SaiGameRulesTableViewCell.h"
#import "SaiGameRulesModel.h"
@interface SaiGameRulesViewController ()
//@property(nonatomic,strong)NSArray  *sectionArray;
//@property(nonatomic,strong)NSArray  *cellArray;
@property(nonatomic,strong)SaiGameRulesModel *saiGameRulesModel ;

@end

@implementation SaiGameRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,KScreenW,KScreenH);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)kColorFromRGBHex(0x4780F1).CGColor,(__bridge id)kColorFromRGBHex(0x3735C4).CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [self.view.layer addSublayer:gl];
    [self initNavigation];
    [self initView];
    
    blockWeakSelf;
    [super setResponseRenderTemplateStr:^(NSString * _Nonnull renderTemplateStr) {
        //        [super jumpVC:YES renderTemplateStr:renderTemplateStr];
        [weakSelf jumpVC:YES renderTemplateStr:renderTemplateStr];
        
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ttsPlayComplete) name:SaiTtsPlayComplete object:nil];
    
    
}
- (void)ttsPlayComplete{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self backAction];
    });
    
}
#pragma mark - Life Cycle
-(void)initNavigation{
    UILabel *navigationTitleLabel=[UILabel CreatLabeltext:@"您已报名成功" Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(17)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:navigationTitleLabel];
    [navigationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_offset(kStatusBarHeight+kSCRATIO(15));
        
    }];
    //    UIButton *rightButton=[UIButton new];
    //    [rightButton setImage:[UIImage imageNamed:@"dt_icon_share"] forState:0];
    //    [self.view addSubview:rightButton];
    //    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(navigationTitleLabel);
    //        make.right.mas_offset(-kSCRATIO(15));
    //        make.width.height.mas_offset(kSCRATIO(19));
    //
    //    }];
}
-(void)initView{
    self.saiGameRulesModel=[SaiGameRulesModel modelWithJson:[SaiAzeroManager sharedAzeroManager].renderTemplateStr];
    //    self.sectionArray=@[@"活动规则",@"抽奖规则"];
    //    self.cellArray=@[@[@"语音实时直播答题节目，答对 12 题即可瓜分现金奖励；",@"答题时间为每周六20:00-23:00，20点、21点、22点各一期，共3期；",@"每期活动共 12 题，每题4 个答案选项，从中选出你认为正确的唯一选项；",@"每道题的答题时间为10秒钟，回答错误或者超时未回答的用户将被淘汰。"],@[@"答对 12 题瓜分奖金，如果超过一个人答对所有题目，奖金由所有获胜者投票选择平分或随机分配；",@"随机分配时，非中奖用户也可获得1元奖金；",@"随机分配方案分暂定为生日随机、日期随机、星座随机、手机号随机",@"生日随机：随机抽取3位答题最快生日寿星，其他非寿星每人获得1元，剩余部分3人按50%、30%、20%分配",@"日期随机：随机一个日期，抽取生日距离日期最近的且答题最快的3位，其他非此用户每人获得1元，剩余部分3人按50%、30%、20%分配；",@"星座随机：随机一个星座，其他非此星座每人获得1元，剩余部中奖星座平分；",@"手机号随机：随机一个手机号，其他非此用户每人获得1元，剩余部中奖手机号独享。"]];
    UIView *whiteView=[UIView new];
    whiteView.backgroundColor=UIColor.whiteColor;
    [self.view addSubview:whiteView];
    ViewRadius(whiteView, kSCRATIO(6));
    UIImageView *imageView=[UIImageView new];
    imageView.image=[UIImage imageNamed:@"yd_img_logo"];
    
    [self.view addSubview:imageView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(17));
        make.right.mas_offset(kSCRATIO(-17));
        make.top.mas_offset(kSCRATIO(80)+kStatusBarHeight);
        make.bottom.mas_offset(kSCRATIO(-27)-BOTTOM_HEIGHT);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(37));
        make.width.mas_offset(kSCRATIO(49));
        make.centerY.equalTo(whiteView.mas_top);
        make.height.mas_offset(kSCRATIO(70));
    }];
    self.isGroupTableView=YES;
    [whiteView addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[SaiGameRulesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SaiGameRulesTableViewCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//推荐该方法
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor=UIColor.whiteColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kSCRATIO(30));
        make.bottom.mas_offset(kSCRATIO(-30));
        make.left.mas_offset(kSCRATIO(20));
        make.right.mas_offset(kSCRATIO(-20));
    }];
    
}
#pragma mark -  UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.saiGameRulesModel.pageDisplay.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (section==0) {
    //        return 4;
    //    }
    //    return 7;
    SaiGameRulesModelPageDisplay  *saiGameRulesModelPageDisplay=self.saiGameRulesModel.pageDisplay[section];
    return  saiGameRulesModelPageDisplay.contents.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SaiGameRulesModelPageDisplay  *saiGameRulesModelPageDisplay=self.saiGameRulesModel.pageDisplay[indexPath.section];
    
    SaiGameRulesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SaiGameRulesTableViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor=UIColor.whiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell getTitleString:saiGameRulesModelPageDisplay.contents[indexPath.row] row:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SaiGameRulesModelPageDisplay  *saiGameRulesModelPageDisplay=self.saiGameRulesModel.pageDisplay[indexPath.section];
    
    NSString *titleString=saiGameRulesModelPageDisplay.contents[indexPath.row] ;
    CGSize size = [SaiUIUtils getSizeWithLabel:titleString withFont:[UIFont systemFontOfSize:kSCRATIO(14)] withSize:CGSizeMake(kSCRATIO(250), MAXFLOAT)];
    return size.height+kSCRATIO(13);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kSCRATIO(58);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* myView = [UIView new];
    SaiGameRulesModelPageDisplay  *saiGameRulesModelPageDisplay=self.saiGameRulesModel.pageDisplay[section];
    
    myView.backgroundColor = UIColor.whiteColor;
    UILabel *titleLabel = [UILabel CreatLabeltext:@"" Font:[UIFont fontWithName:@"PingFang-SC-Bold" size: kSCRATIO(16)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    if (self.saiGameRulesModel.pageDisplay.count && self.saiGameRulesModel.pageDisplay.count > section) {
        titleLabel.text= saiGameRulesModelPageDisplay.title;
    }
    titleLabel.backgroundColor=kColorFromRGBHex(0x3E58D9);
    ViewRadius(titleLabel, kSCRATIO(14));
    [myView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(20));
        make.width.mas_offset(kSCRATIO(90));
        make.height.mas_offset(kSCRATIO(28));
        
        make.centerY.equalTo(myView);
    }];
    return myView;
    
}



@end
