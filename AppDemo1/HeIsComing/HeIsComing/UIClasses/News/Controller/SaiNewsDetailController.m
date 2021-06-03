//
//  SaiNewsDetailController.m
//  HeIsComing
//
//  Created by silk on 2020/4/7.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiNewsDetailController.h"
#import "UIImageView+WebCache.h"
#import "SaiMusicListCellFrameModel.h"

#define TitleViewX  24
#define TitleViewH  24
#define TitleViewY  20
#define AuthorLabelSpaceY  30
#define AuthorLabelH   14
#define IconImageViewY  24

@interface SaiNewsDetailController ()
@property (nonatomic ,strong) UILabel *titleView;
@property (nonatomic ,strong) UILabel *authorLabel;
@property (nonatomic ,strong) UIImageView *iconImageView;

@end

@implementation SaiNewsDetailController
#pragma mark -  Life Cycle

+ (instancetype)sharedInstance {
    static SaiNewsDetailController *playerVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerVC = [SaiNewsDetailController new];
    });
    return playerVC;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self azeroSdkHandle];
    [self setNeedsStatusBarAppearanceUpdate];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
#pragma mark -  UITableViewDelegate
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Methods
#pragma mark -  Button Callbacks
#pragma mark -  Private Methods
- (void)setupUI{
    //    [self sai_initTitleView:@"新闻详情"];
    //    [self sai_initGoBackBlackButton];
    UILabel *titleView = [[UILabel alloc] init];
    titleView.font = [UIFont qk_PingFangSCRegularBoldFontwithSize:24.0f];
    titleView.text = self.newsModel.title;
    titleView.textColor = SaiColor(31, 31, 31);
    titleView.numberOfLines = 0;
    self.titleView = titleView;
    CGSize size = [SaiUIUtils getSizeWithLabel:titleView.text withFont:[UIFont qk_PingFangSCRegularBoldFontwithSize:24.0f] withSize:CGSizeMake(ScreenWidth-TitleViewX*2, CGFLOAT_MAX)];
    titleView.frame = CGRectMake(TitleViewX, TitleViewY+64, ScreenWidth-TitleViewX*2, size.height+5);
    [self.view addSubview:titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(TitleViewX);
        make.right.mas_offset(-TitleViewX);
        make.top.mas_offset(TitleViewY+kStatusBarHeight);
    }];
    UILabel *authorLabel = [[UILabel alloc] init];
    authorLabel.frame = CGRectMake(TitleViewX, CGRectGetMaxY(titleView.frame)+AuthorLabelSpaceY, KScreenW-TitleViewX*2, AuthorLabelH);
    authorLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:14.0f];
    authorLabel.text = self.newsModel.provider[@"name"];
    authorLabel.textAlignment = NSTextAlignmentLeft;
    authorLabel.textColor = SaiColor(51, 51, 51);
    self.authorLabel = authorLabel;
    [self.view addSubview:authorLabel];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(TitleViewX);
        make.right.mas_offset(-TitleViewX);
        make.top.equalTo(self.titleView.mas_bottom).mas_offset(AuthorLabelSpaceY);
        make.height.mas_offset(AuthorLabelH);
    }];
    UIImageView *iconImageView = [[UIImageView alloc] init];
    NSString *iconStr = [self.newsModel.art[@"sources"] firstObject][@"url"];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:iconStr]];
    iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    iconImageView.clipsToBounds=YES;
    iconImageView.centerX = self.view.centerX;
    [self.view addSubview:iconImageView];
    self.iconImageView = iconImageView;
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_offset(kSCRATIO(345));
        make.top.equalTo(self.authorLabel.mas_bottom).mas_offset(IconImageViewY);
        make.height.mas_offset(kSCRATIO(230));
    }];
}
-(void)setNewsModel:(SaiMusicListModel *)newsModel{
    _newsModel=newsModel;
    self.titleView.text=newsModel.title;
    self.authorLabel.text = newsModel.provider[@"name"];
    NSString *iconStr = [self.newsModel.art[@"sources"] firstObject][@"url"];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconStr]];
}

- (void)azeroSdkHandle{
    blockWeakSelf;
    [super setResponseRenderTemplateStr:^(NSString * _Nonnull renderTemplateStr) {
        
        
        NSDictionary *diction=[SaiJsonConversionModel dictionaryWithJsonString:renderTemplateStr];
        TemplateTypeENUM templateTypet=[QKUITools returnTemplateFromRenderTemplateStr:diction[@"type"]];
        
        switch (templateTypet) {
            case NewsTemplate:
                
            {
                NSMutableArray *modelAry=[NSMutableArray array];
                NSDictionary *dataDic = [SaiJsonConversionModel dictionaryWithJsonString:renderTemplateStr];
                NSArray *dicAry = dataDic[@"contents"];
                
                for (NSDictionary *dic in dicAry) {
                    SaiMusicListModel *model = [[SaiMusicListModel alloc] init];
                    model.title = dic[@"title"];
                    model.header = dic[@"header"];
                    model.art = dic[@"art"];
                    model.provider = dic[@"provider"];
                    NSDictionary *artDic = dic[@"art"];
                    NSArray *sourcesAry = artDic[@"sources"];
                    NSDictionary *sourcesDic = [sourcesAry firstObject];
                    model.pic_url = sourcesDic[@"url"];
                    SaiMusicListCellFrameModel *frameModel = [SaiMusicListCellFrameModel createFrameModelWithListModel:model];
                    [modelAry addObject:frameModel];
                    
                }
                SaiMusicListCellFrameModel *saiMusicListCellFrameModel=modelAry.firstObject;
                weakSelf.newsModel=saiMusicListCellFrameModel.listModel;
            }
                break;
            case  RenderPlayerInfo  :{
                if (MediaTypeNews==[self returndetermineMediaType:renderTemplateStr]) {
                    NSMutableArray *modelAry=[NSMutableArray array];
                    NSDictionary *dataDic = [SaiJsonConversionModel dictionaryWithJsonString:renderTemplateStr];
                    NSDictionary *dic = dataDic[@"content"];
                    
                    SaiMusicListModel *model = [[SaiMusicListModel alloc] init];
                    model.title = dic[@"title"];
                    model.header = dic[@"header"];
                    model.art = dic[@"art"];
                    model.provider = dic[@"provider"];
                    NSDictionary *artDic = dic[@"art"];
                    NSArray *sourcesAry = artDic[@"sources"];
                    NSDictionary *sourcesDic = [sourcesAry firstObject];
                    model.pic_url = sourcesDic[@"url"];
                    SaiMusicListCellFrameModel *frameModel = [SaiMusicListCellFrameModel createFrameModelWithListModel:model];
                    [modelAry addObject:frameModel];
                    
                    SaiMusicListCellFrameModel *saiMusicListCellFrameModel=modelAry.firstObject;
                    weakSelf.newsModel=saiMusicListCellFrameModel.listModel;
                    
                }else{
                    [weakSelf jumpVC:YES renderTemplateStr:renderTemplateStr];
                    
                }
            }
                break;
            default:{
                [weakSelf jumpVC:YES renderTemplateStr:renderTemplateStr];
                
            }
                break;
        }
        
        
    }];
    
}
- (MediaType )returndetermineMediaType:(NSString *)mediaType{
    MediaType returnMediaType=MediaTypeMp3;
    NSDictionary *dic = [SaiJsonConversionModel dictionaryWithJsonString:mediaType];
    NSDictionary *contentDic = dic[@"content"];
    NSString *header = contentDic[@"header"];
    if ([header isEqualToString:@"新闻"]) {//新闻
        returnMediaType = MediaTypeNews;
    }else if ([header isEqualToString:@"音乐"]){//音乐列表
        returnMediaType = MediaTypeMp3;
    }else if ([header isEqualToString:@"有声"]){//有声读物
        returnMediaType = MediaTypeAudio;
    }else if ([header isEqualToString:@"脱口秀"]){//脱口秀
        returnMediaType = MediaTypeTalkShow;
    }else if ([header isEqualToString:@"小品"]){//小品
        returnMediaType = MediaTypeSketch;
    }else if ([header isEqualToString:@"英语故事"]||[header isEqualToString:@"english"]){//音乐列表
        returnMediaType = MediaTypeEnglish;
    }
    return returnMediaType;
}

//处理数据
- (void)dealPlistDataWith:(NSString *)text{
    NSDictionary *dataDic = [SaiJsonConversionModel dictionaryWithJsonString:text];
    NSArray *dicAry = dataDic[@"contents"];
    if (dicAry.count == 0) {
        return;
    }
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic in dicAry) {
        SaiMusicListModel *model = [[SaiMusicListModel alloc] init];
        model.title = dic[@"title"];
        model.header = dic[@"header"];
        model.art = dic[@"art"];
        model.provider = dic[@"provider"];
        NSDictionary *artDic = dic[@"art"];
        NSArray *sourcesAry = artDic[@"sources"];
        NSDictionary *sourcesDic = [sourcesAry firstObject];
        model.pic_url = sourcesDic[@"url"];
        SaiMusicListCellFrameModel *frameModel = [SaiMusicListCellFrameModel createFrameModelWithListModel:model];
        [modelArray addObject:frameModel];
    }
    self.newsModel = modelArray[0];
}

#pragma mark -  Public Methods
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
