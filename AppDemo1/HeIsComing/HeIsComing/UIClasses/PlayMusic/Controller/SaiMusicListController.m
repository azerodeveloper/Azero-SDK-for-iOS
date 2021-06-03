//
//  SaiMusicListController.m
//  HeIsComing
//
//  Created by silk on 2020/2/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiMusicListController.h"
#import "SaiMusicListCell.h"
#import "GKHttpManager.h"
#import "GKWYPlayerViewController.h"
#import "SaiMusicListModel.h"
#import "SaiMusicControlView.h"
#import "GKAudioPlayer.h"
#import "GKWYMusicTool.h"
#import "SaiNewsTableViewCell.h"
#import "SaiNewsDetailController.h"
#import "SaiMusicListCellFrameModel.h"
#import "NavigationTitleView.h"
#import "SaiWeatherMorringModel.h"
#import "QQCorner.h"
#import "WSLRollView.h"
#import "SaiSkillListTipsTemplateModel.h"
#import "SaiASMRCollectionViewCell.h"
#import "SaiHomePageBallModel.h"
#import "SaiASMRModel.h"
#import "HCGradientLabel.h"
#define BgImageViewH   176
#define PlayViewY      115
#define PlayViewW      375
#define PlayViewH      110
#define SongNameLabelX 20
#define PlayingViewX   30
#define PlayImageViewW 54
#define songNameLabelY 25
#define playButtonW    65
#define playButtonH    20
#define transparentImageViewY  36.5
#define transparentImageViewW  195
#define transparentImageViewH  62
#define IconImageViewW      60
#define MiddleViewX    13.5
#define WhiteViewY     189
@interface WSLRollViewHorizontalCell : WSLRollViewCell
@property (strong, nonatomic) UILabel * titleLabel;

@end

@implementation WSLRollViewHorizontalCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self ) {
        self.titleLabel =[UILabel CreatLabeltext:@"" Font:[UIFont qk_PingFangSCRegularFontwithSize:kSCRATIO(13)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
        self.backgroundColor=UIColor.clearColor;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
- (void)refreshData{
    self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
@end
@interface WSLRollViewHorizontalCell1 : WSLRollViewCell<WSLRollViewDelegate>
@property (strong, nonatomic) UILabel * topLabel;
@property(nonatomic,strong)WSLRollView * pageRollView1  ;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,assign)NSInteger integer;

@property (copy, nonatomic) void(^endblock)(NSInteger integer);
@end

@implementation WSLRollViewHorizontalCell1
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSString *text = [NSString stringWithFormat:@"hi,%@",[QKUITools isBlankString:SaiContext.currentUser.name]?SaiContext.currentUser.mobile:SaiContext.currentUser.name];
        UILabel *topLabel =[UILabel CreatLabeltext:text Font:[UIFont qk_PingFangSCRegularFontwithSize:kSCRATIO(13)] Textcolor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        self.topLabel=topLabel;
        [self.contentView addSubview:topLabel];
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.mas_offset(kSCRATIO(5));
            make.centerX.equalTo(self);
            make.top.mas_offset(kSCRATIO(5));
            make.height.mas_offset(kSCRATIO(20));
        }];
        UIView *middleView = [[UIView alloc] init];
        middleView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        [self.contentView addSubview:middleView];
        [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(self);
            make.width.mas_offset(kSCRATIO(135));
            make.height.mas_offset(kSCRATIO(0.5));
        }];
        
        [self.contentView addSubview:self.pageRollView1];
        [self.pageRollView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(kSCRATIO(0));
            make.right.mas_offset(kSCRATIO(0));
            make.top.equalTo(middleView.mas_bottom);
            make.height.mas_offset(kSCRATIO(30));
        }];
    }
    return self;
}
-(WSLRollView *)pageRollView1{
    if (!_pageRollView1) {
        WSLRollView * pageRollView = [[WSLRollView alloc]initWithFrame:CGRectMake(0, 0, kSCRATIO(180), kSCRATIO(30)) scrollDirection:UICollectionViewScrollDirectionHorizontal];
        pageRollView.backgroundColor = [UIColor clearColor];
        _pageRollView1=pageRollView;
        pageRollView.scrollStyle = WSLRollViewScrollStylePage;
        pageRollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        pageRollView.interval = 3;
        pageRollView.loopEnabled = YES;
        pageRollView.delegate = self;
        pageRollView.scrollEnabled=NO;
        [pageRollView registerClass:[WSLRollViewHorizontalCell class] forCellWithReuseIdentifier:@"WSLRollViewHorizontalCell"];
        
    }
    return _pageRollView1;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray=dataArray;
    self.pageRollView1.sourceArray=dataArray.mutableCopy;
    self.pageRollView1.startingPosition=0;
    [self.pageRollView1 reloadData];
}


#pragma mark WSLRollViewDelegate
//返回自定义cell样式
-(WSLRollViewCell *)rollView:(WSLRollView *)rollView cellForItemAtIndex:(NSInteger)index{
    
    WSLRollViewHorizontalCell * cell;
    cell = (WSLRollViewHorizontalCell *)[rollView dequeueReusableCellWithReuseIdentifier:@"WSLRollViewHorizontalCell" forIndex:index];
    
    if (index<rollView.sourceArray.count) {
        cell.titleLabel.text=rollView.sourceArray[index];
    }else{
        NSInteger cellIndex=index-rollView.sourceArray.count;
        cell.titleLabel.text=rollView.sourceArray[cellIndex];
        
    }
    
    [cell refreshData];
    
    return cell;
}
- (CGSize)rollView:(WSLRollView *)rollView sizeForItemAtIndex:(NSInteger)index{
    if (rollView.scrollStyle == WSLRollViewScrollStylePage){
        //        return CGSizeMake(SCREEN_WIDTH, KRollViewHeight);
        //        return CGSizeMake((SCREEN_WIDTH - [self spaceOfItemInRollView:rollView] * 2)/2.0, KRollViewHeight);
        return CGSizeMake(kSCRATIO(180), kSCRATIO(30));
    }else{
        return CGSizeZero;
    }
}
- (void)rollView:(WSLRollView *_Nullable)rollView didRollItemToIndex:(NSInteger)currentIndex{
    if (currentIndex==rollView.sourceArray.count-1) {
        if (rollView.sourceArray.count==1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                blockWeakSelf;
                if (self.endblock) {
                    [rollView pause];
                    
                    weakSelf.endblock(weakSelf.integer);
                    
                }
            });
            
        }else{
            blockWeakSelf;
            if (self.endblock) {
                [rollView pause];
                
                weakSelf.endblock(weakSelf.integer);
                
            }
        }
        
        
        
        //                });
    }
}
@end

@interface SaiMusicListController ()<UITableViewDelegate,UITableViewDataSource,GKAudioPlayerDelegate,WSLRollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UIView  *headView;

@property (nonatomic ,strong) SaiMusicControlView *musicControlView;
@property (nonatomic ,strong) NavigationTitleView *songNameLabel;
@property (nonatomic ,strong) UILabel *singerLabel;

@property (nonatomic ,strong) UILabel *belowLabel;
@property (nonatomic ,strong) NSMutableArray *modelAry;
@property (nonatomic ,strong) GKWYMusicModel *currentModel;
@property (nonatomic ,copy) NSString *audioItemId;

@property (nonatomic ,assign) MediaType mediaType;

@property(nonatomic,strong)SaiWeatherMorringModel *saiWeatherMorringModel;

@property(nonatomic,strong)UIView *playingView  ;
@property(nonatomic,strong)UIView *weatherView;
@property(nonatomic,strong)UILabel *weakLabel ;
@property(nonatomic,strong)UILabel *dateLabel ;
@property(nonatomic,strong)UILabel *temperatureLabel ;
@property(nonatomic,strong)UILabel *weatherLabel ;
@property(nonatomic,strong)UILabel *airqualityLabel ;
@property(nonatomic,strong)UIImageView *airqualityImageView ;
@property(nonatomic,strong)SaiSkillListTipsTemplateModel *skillListTipsTemplateModel;
@property(nonatomic,strong)WSLRollView * pageRollView ;
@property(nonatomic,strong)UILabel *topLabel ;
@property(nonatomic,assign)NSInteger index;
@property (nonatomic ,assign) BOOL isClick;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)HCGradientLabel *sayLabel ;
@property(nonatomic,strong)SaiASMRModel *saiASMRModel ;

@end

@implementation SaiMusicListController
#pragma mark -  Life Cycle

+ (instancetype)sharedInstance {
    static SaiMusicListController *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[SaiMusicListController alloc]init];
    });
    return player;
}
- (void)dealloc{
    TYLog(@"SaiMusicListController ------------- dealloc");
    
    [SaiNotificationCenter removeObserver:self name:@"HelloWeatherTemplate" object:nil];
    [SaiNotificationCenter removeObserver:self name:SaiTtsPlayComplete object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.pageRollView play];
    self.isClick = NO;
    [self refreshTableView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.pageRollView pause];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    kPlayer.delegate                = self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNoti];
    [self determineMediaType:[SaiAzeroManager sharedAzeroManager].songListStr];

    switch (self.mediaType) {
        case MediaTypeEnglish:
        {
            [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"应用当前正在学英语技能中"];
            
        }
            break;
        case MediaTypeNews:
        {
            [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"应用当前正在新闻技能中"];
            
        }
            break;
            
        default:{
            [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"应用当前正在有声技能中"];
            
            //                        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"应用当前正在测试气泡技能"];
            
        }
            break;
    }
    
    
    [self setupUI];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"拉取场景tj数据"];

    if (self.mediaType==MediaTypeEnglish) {
        [self dealPlistDataWith:[SaiAzeroManager sharedAzeroManager].songListStr  ];
        return;
    }
    [self dealPlistDataWith:[SaiAzeroManager sharedAzeroManager].songListStr];
    if (![QKUITools isBlankString:[SaiAzeroManager sharedAzeroManager].helloWeatherTemplate]) {
        [self load:[SaiAzeroManager sharedAzeroManager].helloWeatherTemplate];
    }
    self.collectionView.hidden=YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(10));
        make.right.mas_offset(kSCRATIO(-10));
        make.top.mas_offset(kStatusBarHeight+kSCRATIO(20));
        make.bottom.mas_offset(kSCRATIO(-160)-BOTTOM_HEIGHT);
    }];
    self.sayLabel=[[HCGradientLabel alloc]initWithColors:@[kColorFromRGBHex(0x2BE1DF),kColorFromRGBHex(0x0EAD6E)]];
    self.sayLabel.font =[UIFont systemFontOfSize:kSCRATIO(19)];
    self.sayLabel.textAlignment=NSTextAlignmentCenter;
    
    [self.view addSubview:self.sayLabel];
    self.sayLabel.hidden=YES;
    [self.sayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-BOTTOM_HEIGHT-kSCRATIO(85));
        make.centerX.equalTo(self.view);
    }];
    
    //    [self showCollectionView];
}
- (void)showCollectionView{
    
    [UIView animateWithDuration:0 animations:^{
        self.tableView.alpha            = 0.0;
        self.headView.alpha            = 0.0;
        
        self.view.backgroundColor=UIColor.blackColor;
        
        self.collectionView.alpha            = 1.0;
    }completion:^(BOOL finished) {
        self.tableView.hidden           = YES;
        self.headView.hidden           = YES;
        self.sayLabel.hidden=NO;
        self.collectionView.hidden           = NO;
    }];
}
- (void)hiddenCollectionView{
    
    [UIView animateWithDuration:0 animations:^{
        self.tableView.alpha            = 1;
        self.headView.alpha            = 1;
        
        self.view.backgroundColor = SaiColor(245, 246, 250);
        
        self.collectionView.alpha            = 1.0;
    }completion:^(BOOL finished) {
        self.tableView.hidden           = NO;
        self.headView.hidden           = NO;
        self.sayLabel.hidden=YES;
        
        self.collectionView.hidden           = YES;
    }];
}
#pragma mark -GKAudioPlayerDelegate
- (void)gkPlayer:(GKAudioPlayer *)player statusChanged:(GKAudioPlayerState)status {
    kWYPlayerVC.playerState=status;
}

// 播放时间（单位：毫秒)、总时间（单位：毫秒）、进度（播放时间 / 总时间）
- (void)gkPlayer:(GKAudioPlayer *)player currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime progress:(float)progress{    
 
    if (progress<=1) {
           self.musicControlView.currentTime = [QKUITools timeFormattedWithMMSS:currentTime];
         self.musicControlView.progress    = progress;
    }else{
        self.musicControlView.currentTime=[QKUITools timeFormattedWithMMSS:totalTime];
        self.musicControlView.progress    = 1;

    }
}
// 播放总时间
- (void)gkPlayer:(GKAudioPlayer *)player totalTime:(NSTimeInterval)totalTime {
    self.musicControlView.totalTime = [QKUITools timeFormattedWithMMSS:totalTime];
}

// 缓冲进度改变
- (void)gkPlayer:(GKAudioPlayer *)player bufferProgress:(float)bufferProgress {
    self.musicControlView.bufferProgress = bufferProgress;
}
#pragma mark - GKSliderViewDelegate
//- (void)sliderTouchBegin:(float)value {
//    if ([self.delegate respondsToSelector:@selector(controlView:didSliderTouchBegan:)]) {
//        [self.delegate controlView:self didSliderTouchBegan:value];
//    }
//}
//
//- (void)sliderTouchEnded:(float)value {
//    if ([self.delegate respondsToSelector:@selector(controlView:didSliderTouchEnded:)]) {
//        [self.delegate controlView:self didSliderTouchEnded:value];
//    }
//}
//
//- (void)sliderTapped:(float)value {
//    if ([self.delegate respondsToSelector:@selector(controlView:didSliderTapped:)]) {
//        [self.delegate controlView:self didSliderTapped:value];
//    }
//}
//
//- (void)sliderValueChanged:(float)value {
//    if ([self.delegate respondsToSelector:@selector(controlView:didSliderValueChange:)]) {
//        [self.delegate controlView:self didSliderValueChange:value];
//    }
//}
#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
}
#pragma mark -  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelAry.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SaiMusicListCellFrameModel *frameModel=self.modelAry[indexPath.section];
    SaiMusicListModel *saiMusicListModel = frameModel.listModel;
    NSDictionary *type=saiMusicListModel.provider;
    if ([type[@"type"] isEqualToString:@"news"]) {
        SaiNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaiNewsTableViewCell"];
        if (cell == nil) {
            cell = [[SaiNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SaiNewsTableViewCell"];
            cell.backgroundColor=kColorFromRGBHex(0xF5F6FA);
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.num = indexPath.section+1;
        cell.frameModel = self.modelAry[indexPath.section];
        return cell;
        
        
    }
    SaiMusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaiMusicListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.frameModel = self.modelAry[indexPath.section];
    cell.num = indexPath.section+1;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6.0f;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SaiMusicListCellFrameModel *frameModel = self.modelAry[indexPath.section];
    SaiMusicListModel *saiMusicListModel=frameModel.listModel;
    NSDictionary *type=saiMusicListModel.provider;
      if ([type[@"type"] isEqualToString:@"news"]) {
        SaiMusicListCellFrameModel *frameModel = self.modelAry[indexPath.section];
        return frameModel.cellHeight;
    }else{
        return 55;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = SaiColor(245, 246, 250);
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isClick == NO) {
        self.isClick = YES;
        // 可能出现暴力点击
        
        switch (self.mediaType) {
            case MediaTypeNews:
                [self playNewsWith:indexPath];
                break;
            case MediaTypeMp3:
            case MediaTypeTalkShow:
                [self playMp3With:indexPath];
                if (indexPath.section == 0) {
                    kWYPlayerVC.song_name = self.currentModel.song_name;
                }
                break;
            case MediaTypeAudio:
            case MediaTypeEnglish:{
                [self playMp3With:indexPath];
            }
                break;
                
            default:
                break;
        }
    }
}
- (void)playNewsWith:(NSIndexPath *)indexPath{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterSpellOutStyle;
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString *spellOutStr = [formatter stringFromNumber:[NSNumber numberWithDouble:(indexPath.section+1)]];
    NSString *text = [NSString stringWithFormat:@"播放第%@个",spellOutStr];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:text];
}
- (void)playMp3With:(NSIndexPath *)indexPath{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterSpellOutStyle;
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString *spellOutStr = [formatter stringFromNumber:[NSNumber numberWithDouble:(indexPath.section+1)]];
    NSString *text = [NSString stringWithFormat:@"播放第%@首",spellOutStr];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:text];
    
}
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Methods
- (void)registeredSingleton{
    kPlayer.delegate                = self;
}
#pragma mark -  Button Callbacks
#pragma mark -  Private Methods
- (void)setupUI{
    //设置导航栏透明
//    [self.navigationController.navigationBar setTranslucent:true];
//    //把背景设为空
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    //处理导航栏有条线的问题
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor = SaiColor(245, 246, 250);
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_offset(kSCRATIO(265)+kStatusBarHeight);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.mas_offset(-BOTTOM_HEIGHT);
        make.top.equalTo(self.headView.mas_bottom).offset(kSCRATIO(-10));
    }];
    self.tableView.backgroundColor = SaiColor(245, 246, 250);
    [self.tableView registerNib:[UINib nibWithNibName:@"SaiMusicListCell" bundle:nil] forCellReuseIdentifier:@"SaiMusicListCell"];
    [self.tableView registerClass:[SaiNewsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SaiNewsTableViewCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
}
- (void)registerNoti{
    [SaiNotificationCenter addObserver:self selector:@selector(registeredSingleton) name:SaiRegisteredSingleton object:nil];
    [SaiNotificationCenter addObserver:self selector:@selector(helloWeatherTemplate:) name:@"HelloWeatherTemplate" object:nil];
    [SaiNotificationCenter addObserver:self selector:@selector(ttsPlayComplete) name:SaiTtsPlayComplete object:nil];
    [SaiNotificationCenter addObserver:self selector:@selector(ttsPlayComplete) name:@"SaiTtsPlayInterrupt" object:nil];

    
}
-(void)ttsPlayComplete{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.weatherView.hidden=YES;
        self.playingView.hidden=NO;        TYLog(@"------------***********************************-----------------------------------------TTS播报完成");
    });
    
}

-(void)helloWeatherTemplate:(NSNotification *)noti{
    NSString *renderTemplateStr=noti.userInfo[@"HelloWeatherTemplate"];
    [self load:renderTemplateStr];
    
}
- (void)setCurrentModel:(GKWYMusicModel *)currentModel{
    _currentModel = currentModel;
    [self.songNameLabel updateText:currentModel.song_name andTitleFont:[UIFont qk_PingFangSCRegularBoldFontwithSize:16.0f] andTitleColor:Color333333 ];
    self.singerLabel.text = [NSString stringWithFormat:@"%@-%@",currentModel.artist_name,currentModel.album_title];
    if ([QKUITools isBlankString:currentModel.album_title]) {
        self.singerLabel.text = [NSString stringWithFormat:@"%@",currentModel.artist_name];
    }
}
-(void)load:(NSString *)renderTemplateStr{
    self.saiWeatherMorringModel=[SaiWeatherMorringModel modelWithJson:renderTemplateStr];
    if ([self.saiWeatherMorringModel.type isEqualToString:@"HelloWeatherTemplate"]) {
        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"应用当前正在早上好技能中"];
        
        self.weatherView.hidden=NO;
        self.playingView.hidden=YES;
        self.weakLabel.text=self.saiWeatherMorringModel.week;
        self.weatherLabel.text=self.saiWeatherMorringModel.condition.text;
        self.dateLabel.text=self.saiWeatherMorringModel.date;
        self.temperatureLabel.text=
        [NSString stringWithFormat:@"%@°",self.saiWeatherMorringModel.condition.temperature];
        
        SaiWeatherMorringModelCurrentWeatherIconSources *saiWeatherModelWeatherForecastImageSources=        self.saiWeatherMorringModel.currentWeatherIcon.sources.firstObject;
        [self.airqualityImageView setImageURL:[NSURL URLWithString:saiWeatherModelWeatherForecastImageSources.url]];
        [self getAirQuality:self.saiWeatherMorringModel.air.quality animations:^( NSDictionary *dic) {
            
            self.airqualityLabel.text=dic[@"name"];
            
            self.airqualityLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
                graColor.toColor =[UIColor colorWithHexString:dic[@"toColor"]] ;
                graColor.fromColor = [UIColor colorWithHexString:dic[@"fromColor"]];
                graColor.type = QQGradualChangeTypeLeftToRight;
            } size:self.airqualityLabel.bounds.size cornerRadius:QQRadiusMakeSame(kSCRATIO(10))]];
        }];
        [SaiAzeroManager sharedAzeroManager].helloWeatherTemplate=nil;
    }else if ([self.saiWeatherMorringModel.type isEqualToString:@"SkillListTipsTemplate"]){
        self.skillListTipsTemplateModel=[SaiSkillListTipsTemplateModel modelWithJson:renderTemplateStr];
        if ([self.skillListTipsTemplateModel.type isEqualToString:@"SkillListTipsTemplate"]) {
            self.pageRollView.sourceArray = self.skillListTipsTemplateModel.items.mutableCopy;
            [self.pageRollView reloadData];
        }
    }
}
- (void)azeroSdkHandle{
    
    blockWeakSelf;
    
    //       self.responseRenderTemplateStr = ^(NSString * _Nonnull renderTemplateStr) {
    //           __strong __typeof(weakSelf) strongSelf = weakSelf;
    //
    //           strongSelf.skillListTipsTemplateModel=[SaiSkillListTipsTemplateModel modelWithJson:renderTemplateStr];
    //           if ([strongSelf.skillListTipsTemplateModel.type isEqualToString:@"SkillListTipsTemplate"]) {
    //               strongSelf.pageRollView.sourceArray = strongSelf.skillListTipsTemplateModel.items.mutableCopy;
    //               [strongSelf.pageRollView reloadData];
    //
    //               return ;
    //           }
    //           TemplateTypeENUM templateTypet=[QKUITools returnTemplateFromRenderTemplateStr:strongSelf.skillListTipsTemplateModel.type];
    //           switch (templateTypet) {
    //               case RenderPlayerInfo:
    //               case NewsTemplate:
    //               case EnglishTemplate:
    //               {
    //                   [strongSelf dealPlistDataWith:renderTemplateStr];
    //
    //               }
    //                   break;
    //
    //               default:{
    //                   //                [super jumpVC:YES renderTemplateStr:renderTemplateStr];
    //                   [strongSelf jumpVC:YES renderTemplateStr:renderTemplateStr];
    //
    //               }
    //                   break;
    //           }
    //
    //
    //       };
    [super setResponseRenderTemplateStr:^(NSString * _Nonnull renderTemplateStr) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (self.currentIndex!=2) {
            [strongSelf jumpVC:YES renderTemplateStr:renderTemplateStr];
            return ;
        }
        strongSelf.skillListTipsTemplateModel=[SaiSkillListTipsTemplateModel modelWithJson:renderTemplateStr];
        if ([strongSelf.skillListTipsTemplateModel.type isEqualToString:@"SkillListTipsTemplate"]) {
            strongSelf.pageRollView.sourceArray = strongSelf.skillListTipsTemplateModel.items.mutableCopy;
            [strongSelf.pageRollView reloadData];
            
            return ;
        }
        TemplateTypeENUM templateTypet=[QKUITools returnTemplateFromRenderTemplateStr:strongSelf.skillListTipsTemplateModel.type];
        switch (templateTypet) {
            case RenderPlayerInfo:
            case NewsTemplate:
            case EnglishTemplate:
            case ASMRRenderPlayerInfo:
                
            {
                [strongSelf dealPlistDataWith:renderTemplateStr];
                
            }
                break;
                
            default:{
                //                [super jumpVC:YES renderTemplateStr:renderTemplateStr];
                [strongSelf jumpVC:YES renderTemplateStr:renderTemplateStr];
                
            }
                break;
        }
        
        
    }];
    
}
-(void)getAirQuality:(NSString *)quality animations:(void (^)(NSDictionary * info))block{
    
    NSDictionary *dic=@{
        @"优":@{@"name":@"优",@"fromColor":@"46E5B0",@"toColor":@"1DBD88"},
        @"良":@{@"name":@"良",@"fromColor":@"F3CA5C",@"toColor":@"EFB212"},
        @"轻度污染":@{@"name":@"轻度",@"fromColor":@"FFA664",@"toColor":@"FB8E2D"},
        @"中度污染":@{@"name":@"中度",@"fromColor":@"FF895E",@"toColor":@"FA642D"},
        @"重度污染":@{@"name":@"高度",@"fromColor":@"FF6150",@"toColor":@"EC2C17"},
        @"严重污染":@{@"name":@"高度",@"fromColor":@"FF6150",@"toColor":@"EC2C17"},
        @"其他":@{@"name":@"暂无",@"fromColor":@"46E5B0",@"toColor":@"1DBD88"}
    };
    
    
    if (block) {
        NSDictionary *diction=dic[quality];
        block(diction);
    }
}
//处理数据
- (void)dealPlistDataWith:(NSString *)text{
    if (text.length == 0) {
        return;
    }
    SaiHomePageBallModel * ballModel=[SaiHomePageBallModel modelWithJson:text];
    if ([ballModel.type isEqualToString:@"ASMRListTemplate"]) {
        [self showCollectionView];
        
        self.saiASMRModel=[SaiASMRModel modelWithJson:text];
        self.sayLabel.text= self.saiASMRModel.prompt;
        
        [self.collectionView reloadData];
        kWYPlayerVC.is_Asmr=YES;

        return;
    }
  
    if ([ballModel.type isEqualToString:@"ASMRRenderPlayerInfo"]) {
        NSDictionary *dataDic = [SaiJsonConversionModel dictionaryWithJsonString:text];
         NSDictionary *dic = dataDic[@"content"];
        if ([QKUITools isBlankDictionary:dic]) {
            return;
        }
        [kWYPlayerVC initialData];
        //            [kWYPlayerVC setPlayerList:musicAry];
 
        [self showCollectionView];

        kWYPlayerVC.mediaType=self.mediaType;
        GKWYMusicModel *currentMusicModel = [[GKWYMusicModel alloc] init];
        currentMusicModel.song_name = dic[@"title"];
        //         currentMusicModel.artist_name = dic[@"provider"][@"name"];
        //         currentMusicModel.album_title = dic[@"provider"][@"album"];
        NSDictionary *artDic = dic[@"art"];
        NSArray *sourcesAry = artDic[@"sources"];
        NSArray *controls=dataDic[@"controls"];
        for (NSDictionary *diction in controls) {
            if ([[NSString stringWithFormat:@"%@",diction[@"name"]] isEqualToString:@"TIMER"]) {
                NSArray *menuListItems=diction[@"menuListItems"];
                kWYPlayerVC.menuListItems=menuListItems;
            }
            NSString *type = diction[@"type"];
            if ([type isEqualToString:@"TOGGLE"]) {
                NSString *name = dic[@"name"];
                if ([name isEqualToString:@"SINGLE_LOOP"]) {
                    [SaiAzeroManager sharedAzeroManager].songMode = SongCycleModeSingle;
                    kWYPlayerVC.playStyle = GKWYPlayerPlayStyleOne;
                    
                }else if ([name isEqualToString:@"SHUFFLE"]){
                    [SaiAzeroManager sharedAzeroManager].songMode = SongCycleModeRandom;
                }else if ([name isEqualToString:@"LOOP"]){
                    kWYPlayerVC.playStyle = GKWYPlayerPlayStyleLoop;
                    
                    [SaiAzeroManager sharedAzeroManager].songMode = SongCycleModeOrder;
                }
            }
        }
        NSDictionary *sourcesDic = [sourcesAry firstObject];
        currentMusicModel.pic_big = sourcesDic[@"url"];
        currentMusicModel.pic_small = sourcesDic[@"url"];
        //         currentMusicModel.lrclink = dic[@"provider"][@"lyric"];
        [kWYPlayerVC playMusicWithModel:currentMusicModel];
        //    [kWYPlayerVC playMusicWithIndex:0 isSetList:YES];
        kWYPlayerVC.isEnglish = NO;
        
        if ([self.navigationController.viewControllers containsObject:kWYPlayerVC]) {
            return;
        }
        
        kWYPlayerVC.is_Asmr=YES;
        
        [self.navigationController pushViewController:kWYPlayerVC animated:YES];
        return;
    }
    [self determineMediaType:text];
    [self hiddenCollectionView];
    
    NSMutableArray *musicAry = [NSMutableArray array];
    NSDictionary *dataDic = [SaiJsonConversionModel dictionaryWithJsonString:text];
  
    
    if ([self returndetermineMediaType:text]!=self.mediaType) {
        self.mediaType=[self returndetermineMediaType:text];
        
        switch (self.mediaType) {
            case MediaTypeEnglish:
            {
                [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"应用当前正在学英语技能中"];
                
            }
                break;
            case MediaTypeNews:
            {
                [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"应用当前正在新闻技能中"];
                
            }
                break;
                
            default:{
                [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"应用当前正在有声技能中"];
                
            }
                break;
        }
    }
#pragma mark    在播放广播的时候会有问题
    if (![dataDic containsObjectForKey:@"content"]) {
        return;
    }
    //处理slider
    [self.musicControlView.slider setValue:0.0];
    self.musicControlView.currentTime = @"00:00";
    self.musicControlView.totalTime = @"00:00";
    NSArray *dicAry = dataDic[@"contents"];
    
    [self.modelAry removeAllObjects];
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
        [self.modelAry addObject:frameModel];
        
        GKWYMusicModel *musicModel = [[GKWYMusicModel alloc] init];
        musicModel.song_name = dic[@"title"];
        musicModel.artist_name = dic[@"provider"][@"name"];
        musicModel.album_title = dic[@"provider"][@"album"];
        musicModel.pic_big = sourcesDic[@"url"];
        musicModel.pic_small = sourcesDic[@"url"];
        musicModel.lrclink = dic[@"provider"][@"lyric"];
        [musicAry addObject:musicModel];
    }
    if (musicAry.count != 0) {
        [musicAry removeObjectAtIndex:0];
    }
    NSDictionary *dic = dataDic[@"content"];
    GKWYMusicModel *currentMusicModel = [[GKWYMusicModel alloc] init];
    currentMusicModel.song_name = dic[@"title"];
    currentMusicModel.artist_name = dic[@"provider"][@"name"];
    currentMusicModel.album_title = dic[@"provider"][@"album"];
    NSDictionary *artDic = dic[@"art"];
    NSArray *sourcesAry = artDic[@"sources"];
    NSDictionary *sourcesDic = [sourcesAry firstObject];
    currentMusicModel.pic_big = sourcesDic[@"url"];
    currentMusicModel.pic_small = sourcesDic[@"url"];
    currentMusicModel.lrclink = dic[@"provider"][@"lyric"];
    self.currentModel = currentMusicModel;
    //    id showDetails=  [dic objectForKey:@"showDetails"];
    
    
    switch (self.mediaType) {
        case MediaTypeNews:{
            SaiMusicListCellFrameModel *saiMusicListCellFrameModel=self.modelAry.firstObject;
            [SaiNewsDetailController sharedInstance].newsModel=saiMusicListCellFrameModel.listModel;
            
            if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"showDetails"] ] isEqualToString:@"0"]||musicAry.count == 0) {
                
            }else{
                //跳转逻辑待定
                [self jumpNewsControllerWith:self.modelAry.firstObject];
            }
            
            
        }
            break;
        case MediaTypeMp3:
        case MediaTypeTalkShow:
        case MediaTypeEnglish:
        case MediaTypeAudio:
            [self jumpPlayerControllerWith:dataDic andMusicAry:musicAry];
            break;
        default:
            break;
    }
    if (self.modelAry.count != 0) {
        
        [self.modelAry removeObjectAtIndex:0];
        
    }
    NSInteger postion=[[NSString stringWithFormat:@"%@",dic[@"position"]] integerValue];
    if (postion<=self.modelAry.count) {
        [self.modelAry removeObjectsInRange:NSMakeRange(0, postion)];
        
    }
    [self.tableView reloadData];
}
//处理数据
- (void)refreshTableView{
    if ([SaiAzeroManager sharedAzeroManager].songListStr.length == 0) {
        return;
    }
    NSMutableArray *musicAry = [NSMutableArray array];
    NSDictionary *dataDic = [SaiJsonConversionModel dictionaryWithJsonString:[SaiAzeroManager sharedAzeroManager].songListStr];
#pragma mark    在播放广播的时候会有问题
    if (![dataDic containsObjectForKey:@"content"]) {
        return;
    }
    //处理slider
    [self.musicControlView.slider setValue:0.0];
    self.musicControlView.currentTime = @"00:00";
    self.musicControlView.totalTime = @"00:00";
    NSArray *dicAry = dataDic[@"contents"];
    
    [self.modelAry removeAllObjects];
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
        [self.modelAry addObject:frameModel];
        
        GKWYMusicModel *musicModel = [[GKWYMusicModel alloc] init];
        musicModel.song_name = dic[@"title"];
        musicModel.artist_name = dic[@"provider"][@"name"];
        musicModel.album_title = dic[@"provider"][@"album"];
        musicModel.pic_big = sourcesDic[@"url"];
        musicModel.pic_small = sourcesDic[@"url"];
        musicModel.lrclink = dic[@"provider"][@"lyric"];
        [musicAry addObject:musicModel];
    }
    if (musicAry.count != 0) {
        [musicAry removeObjectAtIndex:0];
    }
    NSDictionary *dic = dataDic[@"content"];
    GKWYMusicModel *currentMusicModel = [[GKWYMusicModel alloc] init];
    currentMusicModel.song_name = dic[@"title"];
    currentMusicModel.artist_name = dic[@"provider"][@"name"];
    currentMusicModel.album_title = dic[@"provider"][@"album"];
    NSDictionary *artDic = dic[@"art"];
    NSArray *sourcesAry = artDic[@"sources"];
    NSDictionary *sourcesDic = [sourcesAry firstObject];
    currentMusicModel.pic_big = sourcesDic[@"url"];
    currentMusicModel.pic_small = sourcesDic[@"url"];
    currentMusicModel.lrclink = dic[@"provider"][@"lyric"];
    self.currentModel = currentMusicModel;
    //    id showDetails=  [dic objectForKey:@"showDetails"];
    if (self.modelAry.count != 0) {
        
        [self.modelAry removeObjectAtIndex:0];
        
    }
    NSInteger postion=[[NSString stringWithFormat:@"%@",dic[@"position"]] integerValue];
    if (postion<=self.modelAry.count) {
        [self.modelAry removeObjectsInRange:NSMakeRange(0, postion)];
        
    }
    [self.tableView reloadData];
}
- (void)jumpPlayerControllerWith:(NSDictionary *)dataDic andMusicAry:(NSArray *)musicAry{
    NSDictionary *dic = dataDic[@"content"];
    GKWYMusicModel *currentMusicModel = [[GKWYMusicModel alloc] init];
    currentMusicModel.song_name = dic[@"title"];
    currentMusicModel.artist_name = dic[@"provider"][@"name"];
    currentMusicModel.album_title = dic[@"provider"][@"album"];
    NSDictionary *artDic = dic[@"art"];
    NSArray *sourcesAry = artDic[@"sources"];
    NSDictionary *sourcesDic = [sourcesAry firstObject];
    currentMusicModel.pic_big = sourcesDic[@"url"];
    currentMusicModel.pic_small = sourcesDic[@"url"];
    currentMusicModel.lrclink = dic[@"provider"][@"lyric"];
    self.currentModel = currentMusicModel;
    [kWYPlayerVC initialData];
    [kWYPlayerVC setPlayerList:musicAry];
    
    kWYPlayerVC.mediaType=self.mediaType;
    [kWYPlayerVC playMusicWithModel:currentMusicModel];
    //    [kWYPlayerVC playMusicWithIndex:0 isSetList:YES];
    kWYPlayerVC.isEnglish = self.mediaType==MediaTypeEnglish;
    if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"showDetails"] ] isEqualToString:@"0"]||musicAry.count == 0) {
        return;
    }
    if ([self.navigationController.viewControllers containsObject:kWYPlayerVC]) {
        return;
    }
    [kWYPlayerVC setTextblock:^(NSString *text) {
//                [self dealPlistDataWith:text];
    }];
    
    kWYPlayerVC.is_Asmr=NO;
    [self.navigationController pushViewController:kWYPlayerVC animated:self.mediaType!=MediaTypeEnglish];
}
- (void)jumpNewsControllerWith:(SaiMusicListCellFrameModel *)framemodel{
    
    
    if ([[self.navigationController.visibleViewController className] isEqualToString:@"SaiNewsDetailController"]) {
        return;
    }
    
    
    [self.navigationController pushViewController:[SaiNewsDetailController sharedInstance] animated:YES];
}
//- (void)dealReloadData:(NSString *)text{
//    NSDictionary *dataDic = [SaiJsonConversionModel dictionaryWithJsonString:text];
//    NSString *audioItemId = dataDic[@"audioItemId"];
//    if ([self.audioItemId isEqualToString:audioItemId]) {
//        return ;
//    }else{
//        self.audioItemId = audioItemId;
//    }
//    [self.modelAry removeAllObjects];
//    NSArray *dicAry = dataDic[@"contents"];
//    for (NSDictionary *dic in dicAry) {
//        SaiMusicListModel *model = [[SaiMusicListModel alloc] init];
//        model.title = dic[@"title"];
//        model.header = dic[@"header"];
//        model.art = dic[@"art"];
//        model.provider = dic[@"provider"];
//        NSDictionary *artDic = dic[@"art"];
//        NSArray *sourcesAry = artDic[@"sources"];
//        NSDictionary *sourcesDic = [sourcesAry firstObject];
//        model.pic_url = sourcesDic[@"url"];
//        SaiMusicListCellFrameModel *frameModel = [SaiMusicListCellFrameModel createFrameModelWithListModel:model];
//        [self.modelAry addObject:frameModel];
//    }
//    if (self.modelAry.count != 0) {
//        [self.modelAry removeObjectAtIndex:0];
//    }
//    [self.tableView reloadData];
//    NSDictionary *dic = dataDic[@"content"];
//    GKWYMusicModel *currentMusicModel = [[GKWYMusicModel alloc] init];
//    currentMusicModel.song_name = dic[@"title"];
//    currentMusicModel.artist_name = dic[@"provider"][@"name"];
//    currentMusicModel.album_title = dic[@"provider"][@"album"];
//    NSDictionary *artDic = dic[@"art"];
//    NSArray *sourcesAry = artDic[@"sources"];
//    NSDictionary *sourcesDic = [sourcesAry firstObject];
//    currentMusicModel.pic_big = sourcesDic[@"url"];
//    currentMusicModel.pic_small = sourcesDic[@"url"];
//    currentMusicModel.lrclink = dic[@"provider"][@"lyric"];
//    self.currentModel = currentMusicModel;
//}

- (void)determineMediaType:(NSString *)mediaType{
    NSDictionary *dic = [SaiJsonConversionModel dictionaryWithJsonString:mediaType];
    NSDictionary *contentDic = dic[@"content"];
    NSString *header = contentDic[@"header"];
    if ([header isEqualToString:@"新闻"]) {//新闻
        self.mediaType = MediaTypeNews;
    }else if ([header isEqualToString:@"音乐"]){//音乐列表
        self.mediaType = MediaTypeMp3;
    }else if ([header isEqualToString:@"有声"]){//有声读物
        self.mediaType = MediaTypeAudio;
    }else if ([header isEqualToString:@"脱口秀"]){//脱口秀
        self.mediaType = MediaTypeTalkShow;
    }else if ([header isEqualToString:@"小品"]){//小品
        self.mediaType = MediaTypeSketch;
    }else if ([header isEqualToString:@"英语故事"]||[header isEqualToString:@"english"]){//音乐列表
        self.mediaType = MediaTypeEnglish;
    }
    
}
- (MediaType )returndetermineMediaType:(NSString *)mediaType{
    MediaType returnMediaType=MediaTypeMp3;
    NSDictionary *dic = [SaiJsonConversionModel dictionaryWithJsonString:mediaType];
    NSDictionary *contentDic = dic[@"content"];
    NSString *header = contentDic[@"provider"][@"type"];
    if ([QKUITools isBlankString:header]) {
           header=contentDic[@"header"];
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
    if ([header isEqualToString:@"news"]) {//新闻
        returnMediaType = MediaTypeNews;
    }else if ([header isEqualToString:@"music"]){//音乐列表
        returnMediaType = MediaTypeMp3;
    }else if ([header isEqualToString:@"audio"]){//有声读物
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
#pragma mark -  Public Methods
//返回自定义cell样式
-(WSLRollViewCell *)rollView:(WSLRollView *)rollView cellForItemAtIndex:(NSInteger)index{
    
    WSLRollViewHorizontalCell1 * cell;
    if (rollView.scrollStyle == WSLRollViewScrollStylePage){
        cell = (WSLRollViewHorizontalCell1 *)[rollView dequeueReusableCellWithReuseIdentifier:@"PageRollID" forIndex:index];
    }
    if (index<rollView.sourceArray.count) {
        SaiSkillListTipsTemplateModelItems *skillListTipsTemplateModelItems = self.pageRollView.sourceArray[index];
        cell.topLabel.text=skillListTipsTemplateModelItems.title;
        
    }
    if (index==0) {
        SaiSkillListTipsTemplateModelItems *skillListTipsTemplateModelItems = self.pageRollView.sourceArray[index];
        
        
        cell.dataArray=skillListTipsTemplateModelItems.tips;
        
        [rollView pause];
    }
    cell.integer=index;
    __weak typeof(rollView) weakRollView = rollView;
    
    [cell setEndblock:^(NSInteger integer) {
        
        [weakRollView play];
        
    }];
    
    
    
    return cell;
}
- (CGSize)rollView:(WSLRollView *)rollView sizeForItemAtIndex:(NSInteger)index{
    if (rollView.scrollStyle == WSLRollViewScrollStylePage){
        return CGSizeMake(kSCRATIO(180), kSCRATIO(60));
    }else{
        return CGSizeZero;
    }
}
- (void)rollView:(WSLRollView *_Nullable)rollView didRollItemToIndex:(NSInteger)currentIndex{
    //    if (currentIndex==0) {
    //                [rollView pause];z
    //      WSLRollViewHorizontalCell1 *lRollViewCell= (WSLRollViewHorizontalCell1  *) [rollView   cellForItemAtIndexPath:currentIndex];
    //
    //        SaiSkillListTipsTemplateModelItems *skillListTipsTemplateModelItems = self.skillListTipsTemplateModel.items[currentIndex];
    //
    //        lRollViewCell.dataArray=skillListTipsTemplateModelItems.tips;
    //    }
    //    [{"title":"聊天","tips":["我很无聊","陪我聊聊天"]},{"title":"走路","tips":["我今天走了多少步"]},{"title":"计算器","tips":["5x6+12等于几","5的平方是25吗"]}]
    [rollView pause];
    
    if (currentIndex==self.pageRollView.sourceArray.count) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SaiSkillListTipsTemplateModelItems *skillListTipsTemplateModelItems = self.pageRollView.sourceArray.firstObject;
            WSLRollViewHorizontalCell1 *cell1=( WSLRollViewHorizontalCell1 *)  [rollView cellForItemAtIndexPath:0];
            cell1.dataArray=skillListTipsTemplateModelItems.tips;
        });
        
    }else{
        if (self.pageRollView.sourceArray.count<=currentIndex) {
            currentIndex=0;
        }
        SaiSkillListTipsTemplateModelItems *skillListTipsTemplateModelItems = self.pageRollView.sourceArray[currentIndex];
        WSLRollViewHorizontalCell1 *cell1=( WSLRollViewHorizontalCell1 *)  [rollView cellForItemAtIndexPath:currentIndex];
        
        cell1.dataArray=skillListTipsTemplateModelItems.tips;
        
    }
    
}
#pragma mark UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return   self.saiASMRModel.listItems.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SaiASMRCollectionViewCell *cell =(SaiASMRCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SaiASMRCollectionViewCell class]) forIndexPath:indexPath];
    SaiASMRModelListItems *saiASMRModelListItems = self.saiASMRModel.listItems[indexPath.row];
    [cell.imageView setImageURL:[NSURL URLWithString:((SaiASMRModelListItemsArtSources *)saiASMRModelListItems.image.sources.firstObject).url]];
    cell.titleLabel.text=saiASMRModelListItems.title;
    [cell.button setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1] forState:0];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isClick == NO) {
        self.isClick = YES;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = kCFNumberFormatterSpellOutStyle;
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        NSString *spellOutStr = [formatter stringFromNumber:[NSNumber numberWithDouble:(indexPath.row+1)]];
        NSString *text = [NSString stringWithFormat:@"播放第%@首",spellOutStr];
        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:text];
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  CGSizeMake(kSCRATIO(100), kSCRATIO(120));
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kSCRATIO(20), kSCRATIO(13), kSCRATIO(20), kSCRATIO(13));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kSCRATIO(10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return kSCRATIO(20);
}
#pragma mark -  Setters and Getters
-(UIView *)headView{
    if (!_headView) {
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, (kSCRATIO(225)+kStatusBarHeight))];
        UIImageView *bgImageView = [[UIImageView alloc] init];
        bgImageView.frame = CGRectMake(0, 0, ScreenWidth, 234);
        bgImageView.backgroundColor = [UIColor darkGrayColor];
        bgImageView.image = [UIImage imageNamed:@"bg_img_top1"];
        [_headView addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_offset(0);
            make.height.mas_offset(kSCRATIO(245));
        }];
        WSLRollView * pageRollView = [[WSLRollView alloc]initWithFrame:CGRectMake(0, 0, kSCRATIO(180), kSCRATIO(84))];
        UIImage *image = [UIImage imageNamed:@"yy_bj_top"];
        pageRollView.layer.contents = (id)image.CGImage;
        pageRollView.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.pageRollView=pageRollView;
        pageRollView.scrollStyle = WSLRollViewScrollStylePage;
        pageRollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        pageRollView.interval = 3;
        pageRollView.loopEnabled = YES;
        pageRollView.delegate = self;
        pageRollView.scrollEnabled=NO;
        [pageRollView registerClass:[WSLRollViewHorizontalCell1 class] forCellWithReuseIdentifier:@"PageRollID"];
        [_headView addSubview:pageRollView];
        [pageRollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(kSCRATIO(180));
            make.centerX.equalTo(_headView);
            make.top.mas_offset(kSCRATIO(10)+kStatusBarHeight);
            make.height.mas_offset(kSCRATIO(84));
        }];
        [pageRollView layoutIfNeeded];
        //        UIView *transparentView = [[UIView alloc] init];
        //        transparentView.backgroundColor = [kColorFromRGBHex(0x11115B) colorWithAlphaComponent:0.5];
        //        transparentView.layer.masksToBounds = YES;
        //        transparentView.layer.cornerRadius = 6.0f;
        //        [_headView addSubview:transparentView];
        //        [transparentView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.right.mas_offset(-20);
        //            make.top.mas_offset(kSCRATIO(45)+kStatusBarHeight);
        //            make.width.mas_offset(kSCRATIO(180));
        //            make.height.mas_offset(kSCRATIO(60));
        //        }];
        //        [transparentView layoutIfNeeded];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:pageRollView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = pageRollView.bounds;
        maskLayer.path = maskPath.CGPath;
        pageRollView.layer.mask = maskLayer;
        //        NSString *text = [NSString stringWithFormat:@"hi,%@",[QKUITools isBlankString:SaiContext.currentUser.name]?SaiContext.currentUser.mobile:SaiContext.currentUser.name];
        //        UILabel *topLabel =[UILabel CreatLabeltext:text Font:[UIFont qk_PingFangSCRegularFontwithSize:kSCRATIO(18)] Textcolor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        //        self.topLabel=topLabel;
        //        [transparentView addSubview:topLabel];
        //        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.mas_offset(kSCRATIO(5));
        //            make.centerX.equalTo(transparentView);
        //            make.height.mas_offset(kSCRATIO(20));
        //        }];
        //        UIView *middleView = [[UIView alloc] init];
        //        middleView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        //        [transparentView addSubview:middleView];
        //        [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerY.centerX.equalTo(transparentView);
        //            make.width.mas_offset(kSCRATIO(167));
        //            make.height.mas_offset(kSCRATIO(0.5));
        //        }];
        //        WSLRollView * pageRollView = [[WSLRollView alloc]initWithFrame:CGRectMake(0, 0, kSCRATIO(180), kSCRATIO(20))];
        ////        pageRollView.backgroundColor = [UIColor blackColor];
        //        self.pageRollView=pageRollView;
        //        pageRollView.scrollStyle = WSLRollViewScrollStylePage;
        //        pageRollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //        pageRollView.interval = 2;
        //        pageRollView.loopEnabled = YES;
        //        pageRollView.delegate = self;
        //        pageRollView.scrollEnabled=NO;
        //        [pageRollView registerClass:[WSLRollViewHorizontalCell class] forCellWithReuseIdentifier:@"PageRollID"];
        //
        //        [transparentView addSubview:pageRollView];
        //        [pageRollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.mas_offset(kSCRATIO(0));
        //            make.right.mas_offset(kSCRATIO(0));
        //            make.top.equalTo(middleView.mas_bottom);
        //            make.height.mas_offset(kSCRATIO(20));
        //        }];
        //        UILabel *belowLabel = [UILabel CreatLabeltext:@"当前正在播放[新闻事实]" Font:[UIFont qk_PingFangSCRegularFontwithSize:kSCRATIO(12)] Textcolor:kColorFromRGBHex(0xDAE6FF) textAlignment:NSTextAlignmentCenter];
        //        self.belowLabel=belowLabel;
        UIView *bottomView=[UIView new];
        bottomView.backgroundColor=SaiColor(245, 246, 250);
        [_headView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_headView);
            make.height.mas_offset(kSCRATIO(65));
            make.top.equalTo(_headView.mas_bottom).offset(kSCRATIO(-80));
        }];
        [bottomView layoutIfNeeded];
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:bottomView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight  cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = bottomView.bounds;
        maskLayer1.path = maskPath1.CGPath;
        bottomView.layer.mask = maskLayer1;
        UIView *playingView = [[UIView alloc] initWithFrame:CGRectMake(30, 115, ScreenWidth-PlayingViewX*2, kSCRATIO(110))];
        self.playingView=playingView;
        playingView.backgroundColor = [UIColor whiteColor];
        playingView.layer.cornerRadius = kSCRATIO(15);
        playingView.layer.shadowColor = kColorFromRGBHex(0x808080).CGColor;//shadowColor阴影颜色
        playingView.layer.shadowOffset = CGSizeMake(5,5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        playingView.layer.shadowOpacity = 0.3;//阴影透明度，默认0
        playingView.layer.shadowRadius = 4;//阴影半径，默认3
        [_headView addSubview:playingView];
        [self.playingView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            switch (self.mediaType) {
                case MediaTypeNews:{
                    
                    //跳转逻辑待定
                    [self.navigationController pushViewController:[SaiNewsDetailController sharedInstance] animated:YES];
                    
                }
                    
                    break;
                case MediaTypeMp3:
                case MediaTypeTalkShow:
                case MediaTypeEnglish:
                case MediaTypeAudio:{
                    [kWYPlayerVC setTextblock:^(NSString *text) {
//                        [self dealPlistDataWith:text];
                    }];
                    kWYPlayerVC.is_Asmr=NO;
                    
                    [self.navigationController pushViewController:kWYPlayerVC animated:self.mediaType!=MediaTypeEnglish];}
                    break;
                default:
                    break;
            }
            
        }]];
        UIButton *playButton = [[UIButton alloc] init];
        playButton.frame = CGRectMake(0, 0, playButtonW, playButtonH);
        [playButton setBackgroundImage:[UIImage imageNamed:@"xw_bg_img_play"] forState:UIControlStateNormal];
        [playButton setTitle:@"播放中" forState:UIControlStateNormal];
        playButton.titleLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:11.0f];
        playButton.userInteractionEnabled = NO;
        [playingView addSubview:playButton];
        
        self.songNameLabel =[[NavigationTitleView alloc]initWithFrame: CGRectMake(SongNameLabelX, songNameLabelY, kSCRATIO(180), 16) Text:@"" andTitleFont:nil andTitleColor:Color333333 ];
        
        [playingView addSubview:self.songNameLabel];
        
        UILabel *singerLabel = [[UILabel alloc] init];
        singerLabel.frame = CGRectMake(SongNameLabelX, CGRectGetMaxY(self.songNameLabel.frame)+5,  kSCRATIO(185), 13);
        singerLabel.textAlignment = NSTextAlignmentLeft;
        singerLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:13.0f];
        singerLabel.text = @"歌手";
        [playingView addSubview:singerLabel];
        self.singerLabel = singerLabel;
        
        
        
        UIImageView *playImageView = [[UIImageView alloc] init];
        playImageView.frame = CGRectMake(ScreenWidth-PlayingViewX*2-SongNameLabelX-PlayImageViewW, songNameLabelY, PlayImageViewW, PlayImageViewW);
        playImageView.image = [UIImage imageNamed:@"xw_icon_play"];
        [playingView addSubview:playImageView];
        
        
        self.musicControlView.frame = CGRectMake(0, CGRectGetMaxY(singerLabel.frame)+5, ScreenWidth-PlayingViewX*2, 40);
        self.musicControlView.backgroundColor = [UIColor clearColor];
        self.musicControlView.layer.masksToBounds = YES;
        self.musicControlView.layer.cornerRadius = 6;
        [self.musicControlView initialData];
        [playingView addSubview:self.musicControlView];
        
        
        
        if (self.musicControlView.superview  != nil) {
            [self.musicControlView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(0);
                make.right.mas_offset(0);
                make.height.mas_equalTo(kSCRATIO(40));
                make.top.equalTo(singerLabel.mas_bottom).offset(kSCRATIO(5));
                
            }];
        }
       
        [playingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headView);
            make.left.mas_offset(50);
            make.right.mas_offset(-50);
            make.height.mas_offset(kSCRATIO(110));
            make.top.equalTo(pageRollView.mas_bottom).offset(kSCRATIO(25));
        }];
        [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.songNameLabel.mas_top).offset(-10);
            make.width.mas_equalTo(PlayImageViewW);
            make.height.mas_equalTo(PlayImageViewW);
            make.right.mas_offset(-kSCRATIO(12));
        }];
        UIView *weatherView=[UIView new];
        weatherView.hidden=YES;
        weatherView.backgroundColor=UIColor.whiteColor;
        self.weatherView=weatherView;
        [_headView addSubview:weatherView];
        ViewRadius(weatherView, kSCRATIO(20));
        [weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(playingView);
            make.centerY.height.equalTo(playingView);
        }];
        UIView *weatherBackView=[UIView new];
        [weatherView addSubview:weatherBackView];
        weatherBackView.backgroundColor=SaiColor(245, 246, 250);
        ViewRadius(weatherBackView, kSCRATIO(5));
        [weatherBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_offset(kSCRATIO(20));
            make.bottom.right.mas_offset(kSCRATIO(-20));
            
        }];
        UILabel *realTimeLabel=[UILabel CreatLabeltext:@"实\n时" Font:[UIFont systemFontOfSize:kSCRATIO(12)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
        realTimeLabel.numberOfLines=2;
        realTimeLabel.backgroundColor=kColorFromRGBHex(0x0EAD6E);
        [weatherBackView addSubview:realTimeLabel];
        [realTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weatherBackView);
            make.width.mas_offset(kSCRATIO(20));
            make.height.mas_offset(kSCRATIO(40));
            make.left.mas_offset(kSCRATIO(10));
        }];
        ViewRadius(realTimeLabel, kSCRATIO(5));
        UILabel *weakLabel=[UILabel CreatLabeltext:@"星期一" Font:[UIFont systemFontOfSize:kSCRATIO(16)] Textcolor:UIColor.blackColor textAlignment:0];
        [weatherBackView addSubview:weakLabel];
        self.weakLabel=weakLabel;
        [weakLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(realTimeLabel.mas_top);
            make.left.equalTo(realTimeLabel.mas_right).mas_offset(kSCRATIO(5));
        }];
        UILabel *dateLabel=[UILabel CreatLabeltext:@"2020-04-27" Font:[UIFont systemFontOfSize:kSCRATIO(10)] Textcolor:UIColor.blackColor textAlignment:0];
        [weatherBackView addSubview:dateLabel];
        self.dateLabel=dateLabel;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(realTimeLabel.mas_bottom);
            make.left.equalTo(realTimeLabel.mas_right).mas_offset(kSCRATIO(5));
        }];
        UILabel *temperatureLabel=[UILabel CreatLabeltext:@"21" Font:[UIFont systemFontOfSize:kSCRATIO(30)] Textcolor:UIColor.blackColor textAlignment:0];
        self.temperatureLabel=temperatureLabel;
        
        [weatherBackView addSubview:temperatureLabel];
        [temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weatherBackView);
            make.left.equalTo(dateLabel.mas_right).mas_offset(kSCRATIO(5));
        }];
        UILabel *weatherLabel=[UILabel CreatLabeltext:@"21" Font:[UIFont systemFontOfSize:kSCRATIO(30)] Textcolor:UIColor.blackColor textAlignment:0];
        [weatherBackView addSubview:weatherLabel];
        self.weatherLabel=weatherLabel;
        [weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weatherBackView);
            make.left.equalTo(temperatureLabel.mas_right).mas_offset(kSCRATIO(5));
        }];
        UIImageView *airqualityImageView=[UIImageView new];
        [weatherBackView addSubview:airqualityImageView];
        self.airqualityImageView=airqualityImageView;
        UILabel *airqualityLabel=[UILabel CreatLabeltext:@"良" Font:[UIFont systemFontOfSize:kSCRATIO(12)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
        self.airqualityLabel=airqualityLabel;
        [weatherBackView addSubview:airqualityLabel];
        airqualityLabel.backgroundColor=kColorFromRGBHex(0xF3CA5C);
        ViewRadius(airqualityLabel, kSCRATIO(10));
        [airqualityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(kSCRATIO(-10));
            make.left.equalTo(weatherLabel.mas_right).mas_offset(kSCRATIO(5));
            make.height.mas_offset(kSCRATIO(20));
            make.width.mas_offset(kSCRATIO(40));
            make.right.mas_offset(kSCRATIO(-20));
        }];
        [airqualityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(airqualityLabel);
            make.bottom.equalTo(airqualityLabel.mas_top).mas_offset(kSCRATIO(-5));
            make.width.height.mas_offset(kSCRATIO(30));
        }];
        
    }
    return _headView;
}

- (NSMutableArray *)modelAry{
    if (_modelAry == nil) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

- (SaiMusicControlView *)musicControlView{
    if (_musicControlView == nil) {
        _musicControlView = [SaiMusicControlView new];
    }
    return _musicControlView;
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // 注册cell、sectionHeader、sectionFooter
        [_collectionView registerClass:[SaiASMRCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SaiASMRCollectionViewCell class])];
        
    }
    return _collectionView;
}

@end


