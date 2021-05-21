//
//  SaiRightViewController.m
//  HeIsComing
//
//  Created by mike on 2020/11/2.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiRightViewController.h"
#import "WXBaseModel.h"
#import "SaiMusicTableViewCell.h"
#import "SaiNewsTableViewCell.h"
@interface SaiRightViewController ()
@property (nonatomic ,strong) UIView *headView;
@property (nonatomic ,strong) UIImageView *headImageView;
@property (nonatomic, strong)WXBaseModel *baseModel;

@end

@implementation SaiRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor=Color222B36;
    self.tableView.tableHeaderView=self.headView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [SaiNotificationCenter addObserver:self selector:@selector(dealDataSource) name:@"dealDataSource" object:nil];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
//    [[SaiAzeroManager sharedAzeroManager] saiAzeroSongListInfo:^(NSString *songListStr) {
//        [self dealDataSource:songListStr ];
//
//    }];
//    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerRenderTemplate:^(NSString *renderTemplateStr) {
//        [self dealDataSource:renderTemplateStr];
//
//    }];
}
-(void)dealDataSource{
    NSString *renderTemplateStr= [SaiAzeroManager sharedAzeroManager].songListStr;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.baseModel=[WXBaseModel modelWithJSON:renderTemplateStr];
            
            
//            TemplateTypeENUM templateTypet=[QKUITools returnTemplateFromRenderTemplateStr:self.baseModel.type];
//            switch (templateTypet) {
//                case RenderPlayerInfo:
//                case EnglishTemplate:
//                {
//                    NSString *audioItemId =self.baseModel.audioItemId ;
//                    NSString *defaultaudioItemId =         [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAudioItemId"];
//                    if ([defaultaudioItemId isEqualToString:audioItemId]||([QKUITools isBlankArray:self.baseModel.contents]&&!self.baseModel.content)) {
//                        return ;
//                    }else{
//                        [[NSUserDefaults standardUserDefaults]setValue:audioItemId forKey:@"defaultAudioItemId"];
//                        
//                    }
//                }
//                    break;
//                case ASMRRenderPlayerInfo:{
//                    NSString *audioItemId =self.baseModel.audioItemId ;
//                    NSString *defaultaudioItemId =         [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultAudioItemId"];
//                    if ([defaultaudioItemId isEqualToString:audioItemId]||([QKUITools isBlankArray:self.baseModel.contents]&&!self.baseModel.content)) {
//                        return ;
//                    }else{
//                        [[NSUserDefaults standardUserDefaults]setValue:audioItemId forKey:@"defaultAudioItemId"];
//                        
//                    }
//                }
//                    break;
//                case AlertRingtoneTemplate:{
////                    [SaiAzeroManager sharedAzeroManager].alert_token = self.baseModel.alert_token;
//                }
//                    break;
//                default:{
//                    
//                }
//                    break;
//            };
            TYLog(@"获取的球体的信息是 %@",renderTemplateStr);
            
            
            
            if ([self.baseModel.action isEqualToString:@"Display" ]) {
                [self.headImageView setImageWithURL:[NSURL URLWithString:self.baseModel.title.url] placeholder:[UIImage imageNamed:@"placeHolder"]];
                UILabel *label101=[self.view viewWithTag:101];
                label101.text=self.baseModel.title.headline;
                UILabel *label102=[self.view viewWithTag:102];
                label102.text=self.baseModel.title.notes;
                
                [self.tableView reloadData];
                
            }
            else   if ([self.baseModel.action isEqualToString:@"Replace" ]) {
                [self backAction];
//                if (self.backBlock) {
//                    self.backBlock(renderTemplateStr);
//                }
                
            }
        });
    }
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.baseModel.contents.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXBaseModelContents *baseModelContents = self.baseModel.contents[indexPath.row];
    if ([baseModelContents.provider.type isEqualToString:@"news"]) {
        return kSCRATIO(108);

    }
    return kSCRATIO(72);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerAction:@"Select" andPosition:[NSString stringWithFormat:@"%d",SaiContext.currentIndex+1] selectedPosition:[NSString stringWithFormat:@"%ld",(long)indexPath.row]  andResourceId:@"" andkeyword:@""];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXBaseModelContents *baseModelContents = self.baseModel.contents[indexPath.row];
    if ([baseModelContents.provider.type isEqualToString:@"news"]) {
        SaiNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SaiNewsTableViewCell.class)];
        if (!cell) {
            cell=[[SaiNewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(SaiNewsTableViewCell.class)];
        }
        cell.integerLabel.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        
        cell.cellTitleLabel.text=baseModelContents.title;
        WXBaseModelContentsArtSources *baseModelContentsArtSources  =  baseModelContents.art.sources.firstObject;

        [cell.newsImageView setImageWithURL:[NSURL URLWithString:baseModelContentsArtSources.url] placeholder:[UIImage imageNamed:@"placeHolder"]];
        return cell;
    }
    //填充视频数据
    SaiMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SaiMusicTableViewCell.class)];
    if (!cell) {
        cell=[[SaiMusicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(SaiMusicTableViewCell.class)];
    }
    cell.integerLabel.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    
    cell.cellTitleLabel.text=baseModelContents.title;
    cell.cellDescLabel.text=baseModelContents.provider.name;

    WXBaseModelContentsArtSources *baseModelContentsArtSources  =  baseModelContents.art.sources.firstObject;

    [cell.cellImageView setImageWithURL:[NSURL URLWithString:baseModelContentsArtSources.url] placeholder:[UIImage imageNamed:@""]];
    return cell;
}
#pragma  mark lazy
-(UIView *)headView{
    if(!_headView){
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kStatusBarHeight+kSCRATIO(156))];
        [_headView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_headView);
        }];
        
        UILabel *titeLabel=[UILabel CreatLabeltext:@"" Font:[UIFont systemFontOfSize:kSCRATIO(30)] Textcolor:UIColor.whiteColor textAlignment:0];
        titeLabel.tag=101;
        [_headView addSubview:titeLabel];
        [titeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(kSCRATIO(28)+kStatusBarHeight);
            make.left.mas_offset(kSCRATIO(15));
            make.height.mas_offset(kSCRATIO(30));
            
        }];
        UILabel *descLabel=[UILabel CreatLabeltext:@"" Font:[UIFont systemFontOfSize:kSCRATIO(18)] Textcolor:UIColor.whiteColor textAlignment:0];
        [_headView addSubview:descLabel];
        descLabel.tag=102;
        descLabel.numberOfLines=0;
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titeLabel.mas_bottom).offset(kSCRATIO(8));
            make.left.mas_offset(kSCRATIO(15));
            
        }];
        UIView *backView=[UIView new];
        backView.backgroundColor=Color222B36;
        [_headView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_headView);
            make.height.mas_offset(kSCRATIO(20));
            
        }];
        [backView layoutIfNeeded];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(kSCRATIO(20), kSCRATIO(20))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = backView.bounds;
        maskLayer.path = maskPath.CGPath;
        backView.layer.mask = maskLayer;
        
    }
    return  _headView;
}
-(UIImageView *)headImageView{
    if(!_headImageView){
        _headImageView=[UIImageView new];
        ViewContentMode(_headImageView);
    }
    return  _headImageView;
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
