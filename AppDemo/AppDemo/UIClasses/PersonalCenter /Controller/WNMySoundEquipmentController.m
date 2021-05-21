//
//  WNMySoundEquipmentController.m
//  WuNuo
//
//  Created by silk on 2019/5/20.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "WNMySoundEquipmentController.h"
#import "WNMySoundEquipmentCell.h"
#import "WNSoundEquipmentSetCell.h"
#import "WNGeneralSettingsCell.h"
#import "MJExtension.h"
#import "WNAddSpeakersController.h"
#import "WNSoundEquipmentModelV2.h"
#import "WNBluetoothNetworkController.h"
#import "MSEquipmentUpgradesController.h"
#import "MSLatestVersionInformationModel.h"
#import "MSH5ViewController.h"
#import "MSUpgradeProgressViewController.h"

#define collectionViewH     63  

@interface WNMySoundEquipmentController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic ,strong) NSMutableArray *generalModelAry;
@property (nonatomic ,strong) NSMutableArray *instructionsModelAry;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) UITextField *deviceTextField;
@property (nonatomic ,strong) MSLatestVersionInformationModel *versionInformationModel;
//@property (nonatomic ,strong) UIButton *addButton;
@property (nonatomic ,strong) UILabel *noLabel;

@end 

@implementation WNMySoundEquipmentController
#pragma mark -  Life Cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDataDeviceList];
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        }else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        }
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self registerNoti];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SaiNotificationCenter removeObserver:self];
}
#pragma mark -  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 4;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 451;
    }else{
        return 53;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WNSoundEquipmentSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WNSoundEquipmentSetCell"];
        cell.currentSpeakersV2 = [UserInfoContext sharedContext].currentSpeakersV2;
        return cell;
    }else{
        WNGeneralSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WNGeneralSettingsCell"];
        if (indexPath.section==1) {
            cell.model = self.generalModelAry[indexPath.row];
            if (indexPath.row == 2) {
                if ([self.versionInformationModel.FirmwareVersion intValue] > [[UserInfoContext sharedContext].currentSpeakersV2.runtimeInfo.firmwareVersion intValue]) {
                    cell.pointView.hidden = NO;
                }else{
                    cell.pointView.hidden = YES;
                }
            }else{
                cell.pointView.hidden = YES;
            }
        }else{
            cell.pointView.hidden = YES;
            cell.model = self.instructionsModelAry[indexPath.row];
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.1;
    }else{
        return 58;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return nil;
    }else if (section==1){
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = SaiColor(245, 245, 245);
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(20, 30, ViewWidth-20*2, 18);
        label.font = [UIFont systemFontOfSize:18.0f];
//        label.font = [UIFont qk_PingFangSCRegularBoldFontwithSize:18.0f];
        label.text = @"通用设置";
        label.textColor = [UIColor blackColor];
        [view addSubview:label];
        return view;
    }else{
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = SaiColor(245, 245, 245);
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(20, 30, ViewWidth-20*2, 18);
//        label.font = [UIFont qk_PingFangSCRegularBoldFontwithSize:18.0f];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = @"其他";
        label.textColor = [UIColor blackColor];
        [view addSubview:label];
        return view;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==1) {
        if (indexPath.row == 0) {
            WNBluetoothNetworkController *bluetoothNetworkController = [[WNBluetoothNetworkController alloc] init];
            [self.navigationController pushViewController:bluetoothNetworkController animated:YES];
        }else if (indexPath.row == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改设备名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了确认按钮");
                if (self.deviceTextField.text.length==0) {
                    return ;
                };
                NSString *url = [NSString stringWithFormat:@"/v1/surrogate/users/%@/%@/modify",[UserInfoContext sharedContext].currentUser.userId,[UserInfoContext sharedContext].currentSpeakersV2.deviceId];
                NSDictionary *param = @{@"name":self.deviceTextField.text};
                [QKBaseHttpClient httpType:POST andURL:url andParam:param andSuccessBlock:^(NSURL *URL, id data) {
                    TYLog(@"data: %@",data);
                    NSString *code = data[@"code"];
                    if (code.intValue == 200) {
                        [SaiHUDTools showSuccess:@"修改成功"];
                        [self loadDataDeviceList];
                    }else{
                        [SaiHUDTools showSuccess:@"修改失败"];
                    }
                } andFailBlock:^(NSURL *URL, NSError *error) {
                    TYLog(@"error: %@",error);
                    [SaiHUDTools showError:@"网络请求错误，请稍后重试。"];
                }];
            }];
            //2.2 取消按钮
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了取消按钮");
            }];
            //2.3 还可以添加文本框 通过 alert.textFields.firstObject 获得该文本框
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入设备名称";
                textField.clearButtonMode = UITextFieldViewModeAlways;
                [textField changePlaceholderColor];
                self.deviceTextField = textField;
            }];
            //3.将动作按钮 添加到控制器中
            [alert addAction:conform];
            [alert addAction:cancel];
            //4.显示弹框
            [self presentViewController:alert animated:YES completion:nil];  
        }else if (indexPath.row == 2){  
            if ([self.versionInformationModel.FirmwareVersion intValue] > [[UserInfoContext sharedContext].currentSpeakersV2.runtimeInfo.firmwareVersion intValue]) {
                MSEquipmentUpgradesController *equipmentUpgradesController = [[MSEquipmentUpgradesController alloc] init];
                equipmentUpgradesController.versionInformationModel = self.versionInformationModel;
                if ([[UserInfoContext sharedContext].currentSpeakersV2.productId isEqualToString:@"sai_minidot"]) {
                    equipmentUpgradesController.deviceType = SpeakersDeviceTypeMiniDot;
                }else if ([[UserInfoContext sharedContext].currentSpeakersV2.productId isEqualToString:@"sai_minipodplus"]||[[UserInfoContext sharedContext].currentSpeakersV2.productId isEqualToString:@"speaker_sai_minipod"]){
                    equipmentUpgradesController.deviceType = SpeakersDeviceTypeMiniPod;
                }
                [self.navigationController pushViewController:equipmentUpgradesController animated:YES];
            }else{
//                MSUpgradeProgressViewController *upgradeProgressViewController = [[MSUpgradeProgressViewController alloc] init];
//                [self.navigationController pushViewController:upgradeProgressViewController animated:YES];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前设备已是最新版本\n版本号 v%@",[UserInfoContext sharedContext].currentSpeakersV2.runtimeInfo.firmwareVersion] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

                }]];
                [self presentViewController:alertController animated:YES completion:^{

                }];
            }
        }else if (indexPath.row == 3){ 
            JySaiAlertView *alertView = [[JySaiAlertView alloc] initMessageWithTitle:@"提示" message:@"你确定要解绑此设备吗？" OKButtonText:@"确定" cancelButtonText:@"取消" otherBlock:^{
                if (![SaiUIUtils networkReachable]) {
                    [SaiHUDTools showError:@"网络错误,请检查网络设置"];
                    return;
                }
                NSString *url = [NSString stringWithFormat:@"/v1/surrogate/users/%@/%@/unbind",[UserInfoContext sharedContext].currentUser.userId,[UserInfoContext sharedContext].currentSpeakersV2.deviceId];
                [QKBaseHttpClient httpType:POST andURL:url andParam:nil andSuccessBlock:^(NSURL *URL, id data) {
                    NSString *code = data[@"code"];
                    NSString *message = data[@"message"];
                    if (code.intValue == 200) {
                        [[UserInfoContext sharedContext].deviceModelAry removeAllObjects];
                        [UserInfoContext sharedContext].currentSpeakersV2 = nil;
                        [SaiHUDTools showSuccess:@"解绑设备成功"];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        [SaiHUDTools showError:message];
                    }
                } andFailBlock:^(NSURL *URL, NSError *error) {
                    [SaiHUDTools showSuccess:@"网络请求错误，请稍后重试"];
                }];
            } cancelBlock:^{
            }];
            [alertView show];
        }else if (indexPath.row == 5){
            JySaiAlertView *alertView = [[JySaiAlertView alloc] initMessageWithTitle:@"提示" message:@"你确定要恢复出厂设置吗？" OKButtonText:@"确定" cancelButtonText:@"取消" otherBlock:^{
            } cancelBlock:^{
            }];
            [alertView show];
        }
    }else if (indexPath.section == 2){
        MSH5ViewController *h5ViewController = [[MSH5ViewController alloc] init];
        h5ViewController.h5Title = @"使用说明";
        h5ViewController.H5Url = DirectionsForUseUrl;
        [self.navigationController pushViewController:h5ViewController animated:YES];

    }
}
#pragma mark -  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [UserInfoContext sharedContext].deviceModelAry.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WNMySoundEquipmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WNMySoundEquipmentCell" forIndexPath:indexPath];
    cell.soundEquipmentModelV2 = [UserInfoContext sharedContext].deviceModelAry[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    int i = 0;
    for (WNSoundEquipmentModelV2 *model in [UserInfoContext sharedContext].deviceModelAry) {
        if (i==indexPath.row) {
            NSString *url = [NSString stringWithFormat:@"/v1/surrogate/users/%@/%@/active",[UserInfoContext sharedContext].currentUser.userId,model.deviceId];
            [QKBaseHttpClient httpType:POST andURL:url andParam:nil andSuccessBlock:^(NSURL *URL, id data) {
                NSString *code = data[@"code"];
                if (code.intValue == 200) {
                    [UserInfoContext sharedContext].currentSpeakersV2 = model;
                    [self loadDataDeviceList];
                }else{
                    NSString *message = data[@"message"];
                    [SaiHUDTools showError:message];
                }
            } andFailBlock:^(NSURL *URL, NSError *error) {
                [SaiHUDTools showError:@"网络请求错误，请稍后重试。"];
            }];
        }
        i = i+1;
    }
    [collectionView reloadData];
}
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Methods
#pragma mark -  Button Callbacks
- (void)addRightBtnClickCallBack:(UIButton *)button{
    WNAddSpeakersController *addSpeakersController = [[WNAddSpeakersController alloc] init];
    [self.navigationController pushViewController:addSpeakersController animated:YES];
}
#pragma mark -  Private Methods
- (void)registerNoti{
    [SaiNotificationCenter addObserver:self selector:@selector(loadDataDeviceList) name:DeviceInformationModifiedSuccessfully object:nil];
}
- (void)setupUI{
    [self sai_initTitleView:@"我的设备"];  
    [self sai_initGoBackBlackButton];
    UIButton *addRightBtn = [self sai_initNavRightBtn];
    [addRightBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addRightBtn addTarget:self action:@selector(addRightBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(12, 10, 12, 10);
    flowLayout.estimatedItemSize = CGSizeMake(116, 39);  // layout约束这边必须要用estimatedItemSize才能实现自适应,使用itemSzie无效
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, collectionViewH) collectionViewLayout:flowLayout];
//    if (Sai_iPhoneX||Sai_iPhoneXsXrMax||Sai_iPhoneXS) {
//        collectionView.frame = CGRectMake(0, 88, ViewWidth, collectionViewH);
//    }else{
//        collectionView.frame = CGRectMake(0, 64, ViewWidth, collectionViewH);
//    }
    collectionView.frame = CGRectMake(0, 0, ViewWidth, collectionViewH);

    collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 60);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerClass:[WNMySoundEquipmentCell class] forCellWithReuseIdentifier:@"WNMySoundEquipmentCell"];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(collectionView.frame), ViewWidth, ViewHeight-CGRectGetMaxY(collectionView.frame));
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"WNSoundEquipmentSetCell" bundle:nil] forCellReuseIdentifier:@"WNSoundEquipmentSetCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WNGeneralSettingsCell" bundle:nil] forCellReuseIdentifier:@"WNGeneralSettingsCell"];
   
//    UIButton *addButton = [[UIButton alloc] init];
//    if (IsIPhoneX) {
//        addButton.frame = CGRectMake(0, 88+30, 135, 40);
//    }else{
//        addButton.frame = CGRectMake(0, 64+30, 135, 40);
//    }
//    [addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
//    [addButton setTitle:@"添加" forState:UIControlStateNormal];
//    [addButton addTarget:self action:@selector(addRightBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
//    addButton.layer.masksToBounds = YES;
//    addButton.layer.cornerRadius = 3.0f;
//    addButton.backgroundColor = RGBA(14, 173, 110, 1.0);
//    [self.view addSubview:addButton];
//    addButton.centerX = self.view.centerX;
//    self.addButton = addButton;
    
    UILabel *noLabel = [[UILabel alloc] init];
    noLabel.frame = CGRectMake(0, 0, ScreenWidth, 20);
    noLabel.textAlignment = NSTextAlignmentCenter;
    noLabel.text = @"暂无设备，请点击右上角按钮添加设备";
    noLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:15.0f];
    noLabel.textColor = RGBA(153, 153, 153, 1.0);
    noLabel.center = self.view.center;
    [self.view addSubview:noLabel];
    self.noLabel = noLabel;
    if ([UserInfoContext sharedContext].deviceModelAry.count == 0) {
        noLabel.hidden = NO;
        self.collectionView.hidden = YES;
        self.tableView.hidden = YES;
    }else{
       noLabel.hidden = YES;
       self.collectionView.hidden = NO;
       self.tableView.hidden = NO;
    }
}
- (void)loadDataDeviceList{  
    NSString *url = [NSString stringWithFormat:@"/v1/surrogate/users/%@/bindlist",[UserInfoContext sharedContext].currentUser.userId];
    [QKBaseHttpClient httpType:GET andURL:url andParam:nil andSuccessBlock:^(NSURL *URL, id data) {
        NSString *code = data[@"code"];
        if (code.intValue == 4000) {//没有绑定的设备
            [[UserInfoContext sharedContext].deviceModelAry removeAllObjects];
            if ([UserInfoContext sharedContext].deviceModelAry.count == 0) {
                self.noLabel.hidden = NO;
                self.collectionView.hidden = YES;
                self.tableView.hidden = YES;
            }else{
               self.noLabel.hidden = YES;
               self.collectionView.hidden = NO;
               self.tableView.hidden = NO;
            }
        }else if (code.intValue == 200){
            NSArray *dicAry =  data[@"data"];
            NSMutableArray *deviceAry = [NSMutableArray array];
            for (NSDictionary *dic in dicAry) {
                WNSoundEquipmentModelV2 *soundEquipmentModel = [WNSoundEquipmentModelV2 mj_objectWithKeyValues:dic];
                if (soundEquipmentModel.active||(![soundEquipmentModel.productId isEqualToString:@"phone_display_test"])) {
                    [UserInfoContext sharedContext].currentSpeakersV2 = soundEquipmentModel;
                }
                if (![soundEquipmentModel.productId isEqualToString:@"phone_display_test"]) {
                    [deviceAry addObject:soundEquipmentModel];
                }
            }
            [UserInfoContext sharedContext].deviceModelAry = deviceAry;
            [self.collectionView reloadData];
            [self testingEquipment];
        }else{
            NSString *message = data[@"message"];
            [SaiHUDTools showError:message];
        }
        [self.tableView reloadData];
        if ([UserInfoContext sharedContext].deviceModelAry.count == 0) {
            self.noLabel.hidden = NO;
            self.collectionView.hidden = YES;
            self.tableView.hidden = YES;
        }else{
           self.noLabel.hidden = YES;
           self.collectionView.hidden = NO;
           self.tableView.hidden = NO;
        }
    } andFailBlock:^(NSURL *URL, NSError *error) {
        [SaiHUDTools showError:@"网络请求错误，请稍后重试。"];
    }];
}
- (void)testingEquipment{  
    if ([[UserInfoContext sharedContext].currentSpeakersV2.productId isEqualToString:@"sai_minidot"]) {
        [QKBaseHttpClient httpType:GET andURL:obtainLatestVersionMinidotUrl andParam:nil andSuccessBlock:^(NSURL *URL, id data) {
            NSString *code = data[@"code"];
            if (code.intValue == 200) {
                NSArray *dicAry = data[@"data"];
                NSString *firmwareVersion = [UserInfoContext sharedContext].currentSpeakersV2.runtimeInfo.firmwareVersion;
                for (int i=0; i<dicAry.count; i++) {
                    NSDictionary *dic = dicAry[i];
                    MSLatestVersionInformationModel *model = [MSLatestVersionInformationModel mj_objectWithKeyValues:dic];
                    if ([model.FirmwareVersion intValue]>=[firmwareVersion intValue]) {
                        if ([model.FirmwareVersion intValue]==[firmwareVersion intValue]&&i==(dicAry.count-1)) {
                            self.versionInformationModel = model;
                            break;
                        }
                        if ([model.FirmwareVersion intValue]>[firmwareVersion intValue]) {
                            self.versionInformationModel = model;
                            break;
                        }
                    }
                }
                [self.tableView reloadData];
            }
            TYLog(@"data%@",data);
        } andFailBlock:^(NSURL *URL, NSError *error) {
            TYLog(@"error%@",error);
        }];
    }else if ([[UserInfoContext sharedContext].currentSpeakersV2.productId isEqualToString:@"sai_minipodplus"]||[[UserInfoContext sharedContext].currentSpeakersV2.productId isEqualToString:@"speaker_sai_minipod"]){
        [QKBaseHttpClient httpType:GET andURL:obtainLatestVersionMinipodUrl andParam:nil andSuccessBlock:^(NSURL *URL, id data) {
            NSString *code = data[@"code"];
            if (code.intValue == 200) {
                NSArray *dicAry = data[@"data"];
                NSString *firmwareVersion = [UserInfoContext sharedContext].currentSpeakersV2.runtimeInfo.firmwareVersion;
                for (int i=0; i<dicAry.count; i++) {
                    NSDictionary *dic = dicAry[i];
                    MSLatestVersionInformationModel *model = [MSLatestVersionInformationModel mj_objectWithKeyValues:dic];
                    if ([model.AzeroVersion isEqualToString:firmwareVersion]) {
                        self.versionInformationModel = model;
                        break;
                    }
                }
                [self.tableView reloadData];
            }
            TYLog(@"data%@",data);
        } andFailBlock:^(NSURL *URL, NSError *error) {
            TYLog(@"error%@",error);
        }];
    }
}

#pragma mark -  Public Methods
#pragma mark -  Getters and Getters
- (NSMutableArray *)generalModelAry{  
    if (_generalModelAry == nil) {
        _generalModelAry = [NSMutableArray array];
//        NSArray *titleAry = @[@"WIFI设置",@"蓝牙设置",@"修改设备名称",@"设备升级",@"解除绑定",@"恢复出厂设备"];
        NSArray *titleAry = @[@"Wi-Fi设置",@"修改设备名称",@"设备升级",@"解除绑定"];
        for (int i=0; i<4; i++) {
            WNChooseTimeModel *model = [[WNChooseTimeModel alloc] init];
            model.selectTime = titleAry[i];
            [_generalModelAry addObject:model];
        }
    }
    return _generalModelAry;
}
- (NSMutableArray *)instructionsModelAry{
    if (_instructionsModelAry == nil) {
        _instructionsModelAry = [NSMutableArray array];
        WNChooseTimeModel *model = [[WNChooseTimeModel alloc] init];
        model.selectTime = @"使用说明";
        [_instructionsModelAry addObject:model];
    }
    return _instructionsModelAry;
}

@end
