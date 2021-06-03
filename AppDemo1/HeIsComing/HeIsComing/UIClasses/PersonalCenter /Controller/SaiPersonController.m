//
//  SaiPersonController.m
//  HeIsComing
//
//  Created by silk on 2020/7/18.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiPersonController.h"
#import "UIImageView+WebCache.h"
#import "SaiPersonalCollectionCell.h"
#import "SaiPersonalListModel.h"
#import "SaiWalletViewController.h"
#import "SaiPersonalDataViewController.h"
#import "WNMySoundEquipmentController.h"
#import "SaiShareView.h"
#import <UMShare/UMShare.h>
#import "MessageAlertView.h"
#import <WebKit/WebKit.h>
#import "SaiSoundEquipmentListController.h"
#import "SaiJXHomePageViewController.h"

#define BgImageViewH    155
#define IconImageViewX   20
#define IconImageViewW   50
#define NameLabelViewSpacing    10
#define RightToViewSpacing      10
#define RightToViewW     6.5
#define RightToViewH     11
#define ItemSizeW        122
#define ItemSizeH        106
@interface SaiPersonController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic ,strong) NSMutableArray *modelAry;
@property (nonatomic ,strong) UIImageView *iconImageView;
@property (nonatomic ,strong) UILabel *nameLabelView;
@property (nonatomic ,strong) UIImageView *rightToView;
@property(nonatomic,strong)WKWebView *webView;

@end

@implementation SaiPersonController
#pragma mark -  Life Cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SaiContext.currentUser = [YYTextUnarchiver  unarchiveObjectWithFile:DOCUMENT_FOLDER(@"loginedUser")];
    [self recalculateFrameAndAssignment];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
#pragma mark -  UICollectionViewDelegate
- (NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelAry.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SaiPersonalCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SaiPersonalCollectionCell" forIndexPath:indexPath];
    cell.listModel = self.modelAry[indexPath.row];
    cell.backgroundColor=[UIColor colorWithWhite:1 alpha:0.4];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SaiSoundEquipmentListController *soundEquipmentListController = [[SaiSoundEquipmentListController alloc] init];
        [self.navigationController pushViewController:soundEquipmentListController animated:YES];
    }else if (indexPath.row ==1){
        SaiWalletViewController *walletViewController = [[SaiWalletViewController alloc] init];
        [self.navigationController pushViewController:walletViewController animated:YES];
    }  
}
#pragma mark -  UITableViewDelegate  x
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
- (void)tap:(UITapGestureRecognizer *)tap{
    SaiPersonalDataViewController *personalDataViewController = [[SaiPersonalDataViewController alloc] init];
    [self.navigationController pushViewController:personalDataViewController animated:YES];
}
#pragma mark -  Notification Methods
#pragma mark -  Button Callbacks
- (void)rightBtnClickCallBack:(UIButton *)button{
    [self shareApp];
}
- (void)userAgreementBtnClickCallBack:(UIButton *)button{
    
}
- (void)privacyAgreementBtnClickCallBack:(UIButton *)button{
    
}
#pragma mark -  Private Methods
- (void)setupUI{
    [self sai_initTitleView:@"我的设备"];
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(0, 0, ScreenWidth, BgImageViewH*HScreenRatio);
    bgImageView.image = [UIImage imageNamed:@"personalBg"];
    [self.view addSubview:bgImageView];
    UIImageView *iconImageView = [[UIImageView alloc] init];
    if (IsIPhoneX) {
        iconImageView.frame = CGRectMake(IconImageViewX, (BgImageViewH*HScreenRatio-44-IconImageViewW)/2+44, IconImageViewW, IconImageViewW);
    }else{
        iconImageView.frame = CGRectMake(IconImageViewX, (BgImageViewH*HScreenRatio-20-IconImageViewW)/2+20, IconImageViewW, IconImageViewW);
    }
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:SaiContext.currentUser.pictureUrl] placeholderImage:[UIImage imageNamed:@""]];
    
    iconImageView.backgroundColor = [UIColor blackColor];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = IconImageViewW/2;
    [bgImageView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    NSString *name = SaiContext.currentUser.name;
    CGSize nameSize = [SaiUIUtils sizeLabelWithFont:[UIFont qk_PingFangSCRegularFontwithSize:15.0f] AndText:name AndWidth:MAXFLOAT];
    UILabel *nameLabelView = [[UILabel alloc] init];
    nameLabelView.frame = CGRectMake(NameLabelViewSpacing+CGRectGetMaxX(iconImageView.frame), CGRectGetMinY(iconImageView.frame), nameSize.width, IconImageViewW);
    nameLabelView.textAlignment = NSTextAlignmentLeft;
    nameLabelView.textColor = [UIColor whiteColor];
    nameLabelView.font = [UIFont qk_PingFangSCRegularFontwithSize:15.0f];
    nameLabelView.text = name;
    [bgImageView addSubview:nameLabelView];
    self.nameLabelView = nameLabelView;
    UIImageView *rightToView = [[UIImageView alloc] init];
    rightToView.frame = CGRectMake(CGRectGetMaxX(nameLabelView.frame)+RightToViewSpacing, CGRectGetMinY(iconImageView.frame), RightToViewW, RightToViewH);
    rightToView.image = [UIImage imageNamed:@"grzx_icon_next"];
    [bgImageView addSubview:rightToView];
    [rightToView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabelView);
        make.width.mas_equalTo(RightToViewW);
        make.height.mas_equalTo(RightToViewH);
        make.left.equalTo(nameLabelView.mas_right).offset(RightToViewSpacing);
    }];
    bgImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [bgImageView addGestureRecognizer:tap];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(ItemSizeW, ItemSizeH);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgImageView.frame), ScreenWidth, ScreenHeight-CGRectGetMaxY(bgImageView.frame)) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsMake(20, 40, 0, 40);
    [collectionView registerClass:[SaiPersonalCollectionCell class] forCellWithReuseIdentifier:@"SaiPersonalCollectionCell"];
    [self.view addSubview:collectionView];
    [collectionView reloadData];
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(ScreenWidth-44-20, kStatusBarHeight, 44, 44);
    [button setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [button addTarget:self action:@selector(rightBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:button];
    
    NSString *string1 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UILabel *verLabel = [UILabel CreatLabeltext:[NSString stringWithFormat:@"版本号  V%@",string1] Font:[UIFont systemFontOfSize:kSCRATIO(14)] Textcolor:RGBA(153, 153, 153, 1.0) textAlignment:NSTextAlignmentCenter];
    verLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 13.0F];
    [self.view addSubview:verLabel];
    [verLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(kSCRATIO(-60));
    }];
    
    YYLabel *agreementLabel = [[YYLabel alloc] init];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"用户协议和隐私政策"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 13.0F],NSForegroundColorAttributeName: RGBA(153, 153, 153, 1.0)}];
    [string setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 13.0F],NSForegroundColorAttributeName: RGBA(153, 153, 153, 1.0)} range:NSMakeRange(0, 4)];
    agreementLabel.textAlignment=NSTextAlignmentCenter;
    
    [string setTextHighlightRange:NSMakeRange(0, 4)color:kColorFromRGBHex(0x769BFF) backgroundColor:nil tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        
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
    [string setTextHighlightRange:NSMakeRange(5, 4)color:kColorFromRGBHex(0x769BFF) backgroundColor:nil tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
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
        make.bottom.equalTo(self.view.mas_bottom).offset(kSCRATIO(-40));
        make.centerX.equalTo(self.view);
        make.height.mas_offset(13.0F);
        
    }];
    
    //    UIButton *userAgreementBtn = [[UIButton alloc] init];
    //    [userAgreementBtn setTitle:@"用户协议" forState:UIControlStateNormal];
    //    [userAgreementBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //    userAgreementBtn.titleLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:15.0f];
    //    [userAgreementBtn addTarget:self action:@selector(userAgreementBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:userAgreementBtn];
    //    UILabel *label = [[UILabel alloc] init];
    //    label.text = @"和";
    //    label.font = [UIFont qk_PingFangSCRegularFontwithSize:15.0f];
    //    label.textColor = RGBA(153, 153, 153, 1.0);
    //    label.textAlignment = NSTextAlignmentCenter;
    //    [self.view addSubview:label];
    //    UIButton *privacyAgreementBtn = [[UIButton alloc] init];
    //    [privacyAgreementBtn setTitle:@"隐私策略" forState:UIControlStateNormal];
    //    [privacyAgreementBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //    privacyAgreementBtn.titleLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:15.0f];
    //    [privacyAgreementBtn addTarget:self action:@selector(privacyAgreementBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:privacyAgreementBtn];
    //    [label mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(self.view.mas_bottom).offset(kSCRATIO(-30));
    //        make.centerX.equalTo(self.view);
    //        make.width.equalTo(@15);
    //        make.height.equalTo(@30);
    //    }];
    //    [userAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(label.mas_left).mas_offset(@0);
    //        make.width.equalTo(@60);
    //        make.height.equalTo(@30);
    //        make.centerY.equalTo(label);
    //    }];
    //
    //    [privacyAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(label.mas_right).mas_offset(@0);
    //        make.width.equalTo(@60);
    //        make.height.equalTo(@30);
    //        make.centerY.equalTo(label);
    //    }];
}
- (void)recalculateFrameAndAssignment{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:SaiContext.currentUser.pictureUrl] placeholderImage:[UIImage imageNamed:@"headPortrait"]];
    NSString *name = SaiContext.currentUser.name;
    if (name.length == 0) {
        name = @"ta";
    }
    CGSize nameSize = [SaiUIUtils sizeLabelWithFont:[UIFont qk_PingFangSCRegularFontwithSize:15.0f] AndText:name AndWidth:MAXFLOAT];
    self.nameLabelView.frame = CGRectMake(NameLabelViewSpacing+CGRectGetMaxX(self.iconImageView.frame), CGRectGetMinY(self.iconImageView.frame), nameSize.width, IconImageViewW);
    self.nameLabelView.text = name;
    self.rightToView.frame = CGRectMake(CGRectGetMaxX(self.nameLabelView.frame)+RightToViewSpacing, CGRectGetMinY(self.iconImageView.frame), RightToViewW, RightToViewH);
}

- (void)shareApp{
    UIView *bgV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [[UIApplication sharedApplication].keyWindow addSubview:bgV];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [bgV removeFromSuperview];
    }];
    [bgV addGestureRecognizer:tap];
    SaiShareView *shareView = [[SaiShareView alloc] initWithFrame:CGRectMake(0, KScreenH, KScreenW, kSCRATIO(165)+BOTTOM_HEIGHT)];
    shareView.closeblock  = ^{
        [bgV removeFromSuperview];
    };
    shareView.buttonblock = ^(NSInteger index) {
        UMSocialPlatformType type = UMSocialPlatformType_UnKnown;
        NSString *title=@"TA来了";
        NSString *descr=@"一个随身携带的专属人工智能，期待与你超时空相遇";

        switch (index) {
            case 0:
            {
                type = UMSocialPlatformType_WechatSession;
            }
                break;
            case 1:
            {
                type = UMSocialPlatformType_WechatTimeLine;
            }
                break;
            case 2:
            {
                title=@"TA来了，一个随身携带的专属人工智能，期待与你超时空相遇";
                descr=@"";
                type = UMSocialPlatformType_Sina;
            }
                break;
            default:
                break;
        }
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:[UIImage imageNamed:@"icon_share"]];
        shareObject.webpageUrl = [NSString stringWithFormat:@" https://app-azero.soundai.com.cn/downloads/index.html"];
        messageObject.shareObject = shareObject;
        [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                [MessageAlertView showHudMessage:@"分享失败"];
            } else {
            }  
        }];
        [bgV removeFromSuperview];
    };
    [bgV addSubview:shareView];
    [UIView animateWithDuration:0.15 animations:^{
        shareView.bottom = KScreenH;
    }];
}
#pragma mark -  Public Methods
#pragma mark -  Setters and Getters
- (NSMutableArray *)modelAry{
    if (_modelAry == nil) {
        _modelAry = [NSMutableArray array];
        NSArray *bgImageAry = @[@"grzx_icon_mydevice",@"grzx_icon_mywallet"];
        NSArray *deviceTextAry = @[@"我的设备",@"我的钱包"];
        for (int i=0; i<2; i++) {
            SaiPersonalListModel *model = [[SaiPersonalListModel alloc] init];
            model.bgImage = bgImageAry[i];
            model.deviceText = deviceTextAry[i];
            [_modelAry addObject:model];
        }
    }
    return _modelAry;
}
-(void)getDataClick{
    blockWeakSelf;
    [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/queryUserInfo" andParam:@{@"userId":SaiContext.currentUser.userId} andSuccessBlock:^(NSURL *URL, id data) {
        NSDictionary *dataDic=(NSDictionary *)data;
        NSDictionary *paraDic = dataDic[@"data"];
        SaiContext.currentUser.birthday=paraDic[@"birthday"];
        SaiContext.currentUser.pictureUrl=paraDic[@"pictureUrl"];
        SaiContext.currentUser.sex=paraDic[@"sex"];
        SaiContext.currentUser.name=paraDic[@"name"];
        [YYTextArchiver archiveRootObject:SaiContext.currentUser toFile:DOCUMENT_FOLDER(@"loginedUser")];
        SaiContext.currentUser = [YYTextUnarchiver  unarchiveObjectWithFile:DOCUMENT_FOLDER(@"loginedUser")];
        [weakSelf recalculateFrameAndAssignment];
    } andFailBlock:^(NSURL *URL, NSError *error) {
        
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
        
   
        
    }
    return _webView;
}

@end
