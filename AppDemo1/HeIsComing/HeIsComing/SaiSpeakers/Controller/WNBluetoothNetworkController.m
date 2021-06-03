//
//  WNBluetoothNetworkController.m
//  WuNuo
//
//  Created by silk on 2019/5/8.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "WNBluetoothNetworkController.h"
#import "SaiBleCenterManager.h"
#import "WNBluetoothDeviceCell.h"
#import "WNSetWifiController.h"
#import <CoreLocation/CoreLocation.h>  

#define linkDeviceLabelX    12
@interface WNBluetoothNetworkController ()  
@property (nonatomic ,strong) NSMutableArray *peripheralModelAry;
@property (nonatomic ,strong) NSMutableArray *advertisementDataAry;
@property (nonatomic ,strong) CLLocationManager *locationManager;

@end

@implementation WNBluetoothNetworkController
#pragma mark -  Life Cycle
- (void)dealloc{
    NSLog(@"蓝牙设备dealloc");
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self registerNoti];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self blueTooth];
    [self setupUI];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    CGFloat version = [phoneVersion floatValue];
    // 如果是iOS13 未开启地理位置权限 需要提示一下
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && version >= 13) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestWhenInUseAuthorization];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [XNHUD dismiss];
}
#pragma mark -  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.advertisementDataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WNBluetoothDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WNBluetoothDeviceCell"];
    cell.advertisementData = self.advertisementDataAry[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[SaiBleCenterManager sharedSaiBleCenterManager] connectPeripheralWith:self.peripheralModelAry[indexPath.row]];
    WNSetWifiController *setWifiController = [[WNSetWifiController alloc] init];
    [self.navigationController pushViewController:setWifiController animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Methods
- (void)blueToothOn:(NSNotification *)noti{
    [XNHUD setDisposableDelayResponse:0.30f delayDismiss:MAXFLOAT];
    [XNHUD showLoadingWithTitle:@"正在搜索音箱设备，请稍后..."];
}
- (void)blueToothOff:(NSNotification *)noti{
    [self.peripheralModelAry removeAllObjects];
    [self.tableView reloadData];
    [XNHUD dismiss];
}
- (void)blueToothUnauthorized:(NSNotification *)noti{
    [self.peripheralModelAry removeAllObjects];
    [self.tableView reloadData];
    [XNHUD dismiss];
    //    SaiAlertView *alertView = [[SaiAlertView alloc] initMessageWithTitle:@"提示" message:@"手机蓝牙未授权，请在系统设置中授权此应用吧" OKButtonText:@"好的" cancelButtonText:@"取消" otherBlock:^{
    //        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    //        if ([[UIApplication sharedApplication] canOpenURL:url]) {
    //            [[UIApplication sharedApplication] openURL:url];
    //        }
    //    } cancelBlock:^{
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }];
    //    [alertView show];
}
#pragma mark -  Button Callbacks
- (void)leftBtnClickCallBack:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    //    [[SaiBleCenterManager sharedSaiBleCenterManager] cancelPeripheralConnection];
    //    [[SaiBleCenterManager sharedSaiBleCenterManager] destructionCenter];
}
- (void)didMoveToParentViewController:(UIViewController*)parent
{
    [super didMoveToParentViewController:parent];
    
    
    if(!parent){
        [[SaiBleCenterManager sharedSaiBleCenterManager] cancelPeripheralConnection];
        [[SaiBleCenterManager sharedSaiBleCenterManager] destructionCenter];
    }
}
#pragma mark -  Private Methods
- (void)setupUI{
    self.title = @"设备列表";
    //    [self sai_initTitleView:@"设备列表"];
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 44, 44);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:SaiColor(51, 51, 51) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBBI = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIBarButtonItem *fixedSpace =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 4;
    self.navigationItem.leftBarButtonItems = @[fixedSpace,leftBBI];
    self.view.backgroundColor = SaiColor(245, 245, 245);
    UILabel *connectionPrompt = [[UILabel alloc] init];
    NSString *promptText;
    switch (self.deviceType) {
        case SaiDeviceTypeMiniDot:
            promptText = @"1、请长按播放键(⦿)使音箱进入配网模式\n2、当出现两个设备或两个以上设备时，请查看设备码，确保您想要连接的设备。";
            break;
        case SaiDeviceTypeMniniPodPlus:
            promptText = @"1、请长按灯光键使音箱进入配网模式\n2、当出现两个设备或两个以上设备时，请查看设备码，确保您想要连接的设备。";
            break;
        default:
            break;
    }
    
    CGSize size = [SaiUIUtils getSizeWithLabel:promptText withFont:[UIFont qk_PingFangSCRegularFontwithSize:12.0f] withSize:CGSizeMake(ViewWidth-linkDeviceLabelX*2, CGFLOAT_MAX)];
    if (Sai_iPhoneX||Sai_iPhoneXS||Sai_iPhoneXsXrMax) {
        connectionPrompt.frame = CGRectMake(linkDeviceLabelX, 5, ViewWidth-linkDeviceLabelX*2, size.height);
    }else{
        connectionPrompt.frame = CGRectMake(linkDeviceLabelX, 5, ViewWidth-linkDeviceLabelX*2, size.height);
    }
    connectionPrompt.numberOfLines = 0;
    connectionPrompt.text = promptText;
    connectionPrompt.font = [UIFont qk_PingFangSCRegularFontwithSize:12.0f];
    connectionPrompt.textAlignment = NSTextAlignmentLeft;
    connectionPrompt.textColor = SaiColor(153, 153, 153);
    [self.view addSubview:connectionPrompt];
    CGSize size1 = [SaiUIUtils getSizeWithLabel:@"可连接的设备" withFont:[UIFont qk_PingFangSCRegularFontwithSize:12.0f] withSize:CGSizeMake(ViewWidth-linkDeviceLabelX*2, CGFLOAT_MAX)];
    
    UILabel *linkDeviceLabel = [[UILabel alloc] init];
    linkDeviceLabel.frame = CGRectMake(linkDeviceLabelX, CGRectGetMaxY(connectionPrompt.frame)+25, ViewWidth-linkDeviceLabelX*2, size1.height);
    linkDeviceLabel.text = @"可连接的设备";
    linkDeviceLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:12.0f];
    linkDeviceLabel.textAlignment = NSTextAlignmentLeft;
    linkDeviceLabel.textColor = [UIColor blackColor];
    [self.view addSubview:linkDeviceLabel];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(linkDeviceLabel.frame)+10, ViewWidth, ViewHeight-CGRectGetMaxY(linkDeviceLabel.frame)-10);
    self.tableView.backgroundColor = SaiColor(245, 245, 245);
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"WNBluetoothDeviceCell" bundle:nil] forCellReuseIdentifier:@"WNBluetoothDeviceCell"];
}
- (void)blueTooth{
    SaiBleCenterManager *centerManager = [SaiBleCenterManager sharedSaiBleCenterManager];
    switch (self.deviceType) {
        case SaiDeviceTypeMiniDot:
            centerManager.peripheralsName = @"小声音箱";
            break;
        case SaiDeviceTypeMniniPodPlus:
            centerManager.peripheralsName = @"小声AI音箱灯";
            break;
        default:
            break;
    }
    [centerManager setup];
    blockWeakSelf;
    centerManager.peripheralBlock = ^(CBPeripheral *peripheral, NSDictionary *advertisementData) {
        if (weakSelf.peripheralModelAry.count != 0) {
            if (![weakSelf.peripheralModelAry containsObject:peripheral]) {
                [weakSelf.peripheralModelAry addObject:peripheral];
                [weakSelf.advertisementDataAry addObject:advertisementData];
                [XNHUD dismiss];
            }
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf.peripheralModelAry addObject:peripheral];
            [weakSelf.advertisementDataAry addObject:advertisementData];
            [weakSelf.tableView reloadData];
            [XNHUD dismiss];
        }
        if (weakSelf.peripheralModelAry.count >=2) {
            
        }
    };
}
- (void)registerNoti{
    [SaiNotificationCenter addObserver:self selector:@selector(blueToothOn:) name:SaiBlueToothOn object:nil];
    [SaiNotificationCenter addObserver:self selector:@selector(blueToothOff:) name:SaiBlueToothOff object:nil];
    [SaiNotificationCenter addObserver:self selector:@selector(blueToothUnauthorized:) name:SaiBlueToothUnauthorized object:nil];
}
#pragma mark -  Public Methods
#pragma mark -  Getters and Getters
- (NSMutableArray *)peripheralModelAry{
    if (_peripheralModelAry == nil) {
        _peripheralModelAry = [NSMutableArray array];
    }
    return _peripheralModelAry;
}
- (NSMutableArray *)advertisementDataAry{
    if (_advertisementDataAry == nil) {
        _advertisementDataAry = [NSMutableArray array];
    }
    return _advertisementDataAry;
}
@end
