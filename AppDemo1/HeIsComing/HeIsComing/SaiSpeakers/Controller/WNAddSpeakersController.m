//
//  WNAddSpeakersController.m
//  WuNuo
//
//  Created by silk on 2019/5/7.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "WNAddSpeakersController.h"  
#import "WNSpakerDeviceCell.h"
#import "WNBluetoothNetworkController.h"
#import "MSSpakerDeviceLightCell.h"
#import "QQCorner.h"

@interface WNAddSpeakersController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation WNAddSpeakersController
#pragma mark -  Life Cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        }
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

#pragma mark -  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        WNSpakerDeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WNSpakerDeviceCell" forIndexPath:indexPath];
        return cell;
    }else{
        MSSpakerDeviceLightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSSpakerDeviceLightCell" forIndexPath:indexPath];
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    WNBluetoothNetworkController *bluetoothNetworkController = [[WNBluetoothNetworkController alloc] init];
    if (indexPath.row == 0) {
        bluetoothNetworkController.deviceType = SaiDeviceTypeMiniDot;
    }else{
        bluetoothNetworkController.deviceType = SaiDeviceTypeMniniPodPlus;
    }
    [self.navigationController pushViewController:bluetoothNetworkController animated:YES];
}
#pragma mark -  UITableViewDelegate
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Methods
#pragma mark -  Button Callbacks
- (void)leftBtnClickCallBack:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];    
}
#pragma mark -  Private Methods
- (void)setupUI{
    self.view.backgroundColor = SaiColor(245, 245, 245);
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(10, 0, 44, 44);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBBI = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIBarButtonItem *fixedSpace =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 4;
    self.navigationItem.leftBarButtonItems = @[fixedSpace,leftBBI];    
    UIImageView *bgImageView = [[UIImageView alloc] init];
//    UIImage *bgImage = [UIImage imageNamed:@"add_product_bg"];
    if (Sai_iPhoneX||Sai_iPhoneXsXrMax||Sai_iPhoneXS) {
        bgImageView.frame = CGRectMake(0, 0, ViewWidth, 105+88);
    }else{
        bgImageView.frame = CGRectMake(0, 0, ViewWidth, 105+64);
    }
    bgImageView.image=[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.toColor = kColorFromRGBHex(0x3599DF);
        graColor.fromColor = SaiColor(45, 133, 217);
        graColor.type = QQGradualChangeTypeUpToDown;
    } size:bgImageView.size cornerRadius:QQRadiusMakeSame(0)];
  
    [self.view addSubview:bgImageView];
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.frame = CGRectMake(0, 0, ViewWidth, 20);
    promptLabel.centerY = bgImageView.centerY;
    promptLabel.text = @"欢迎使用小声智能音箱";
    promptLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:20.0f];
    promptLabel.textColor = [UIColor whiteColor];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:promptLabel];
    UILabel *selectLabel = [[UILabel alloc] init];
    selectLabel.frame = CGRectMake(0, CGRectGetMaxY(promptLabel.frame)+7, ViewWidth, 12);
    selectLabel.text = @"请选择要添加的设备";
    selectLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:12.0f];
    selectLabel.textAlignment = NSTextAlignmentCenter;
    selectLabel.textColor = SaiColor(255, 196, 187);
    [bgImageView addSubview:selectLabel];
    UIView *underBgView = [[UIView alloc] init];
    underBgView.frame = CGRectMake(0, CGRectGetMaxY(bgImageView.frame)-5, ViewWidth, ViewHeight-CGRectGetMaxY(bgImageView.frame));
    underBgView.backgroundColor = SaiColor(245, 245, 245);
    underBgView.layer.masksToBounds = YES;
    underBgView.layer.cornerRadius = 5.0f;
    [self.view addSubview:underBgView];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (ViewWidth-20*2-13)/2;
    CGFloat itemHeight = 162*HScreenRatio;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    flowLayout.minimumLineSpacing = 13;
    flowLayout.minimumInteritemSpacing = 13;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 20, ViewWidth-20*2, ViewHeight-CGRectGetMaxY(bgImageView.frame)-20*2) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    [underBgView addSubview:collectionView];
    [collectionView registerNib:[UINib nibWithNibName:@"WNSpakerDeviceCell" bundle:nil] forCellWithReuseIdentifier:@"WNSpakerDeviceCell"];
    [collectionView registerNib:[UINib nibWithNibName:@"MSSpakerDeviceLightCell" bundle:nil] forCellWithReuseIdentifier:@"MSSpakerDeviceLightCell"];
}
#pragma mark -  Public Methods
#pragma mark -  Getters and Getters

@end
