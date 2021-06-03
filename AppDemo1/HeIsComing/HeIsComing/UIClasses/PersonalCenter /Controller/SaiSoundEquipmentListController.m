//
//  SaiSoundEquipmentListController.m
//  HeIsComing
//
//  Created by silk on 2020/8/7.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiSoundEquipmentListController.h"
#import "WNAddSpeakersController.h"
#import "SaiSoundEquimentListCell.h"
#import "MJExtension.h"
#import "MSLatestVersionInformationModel.h"
#import "WNMySoundEquipmentController.h"
#import "QQCorner.h"

@interface SaiSoundEquipmentListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) MSLatestVersionInformationModel *versionInformationModel;
@property (nonatomic ,strong) UILabel *noLabel;

@end

@implementation SaiSoundEquipmentListController
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
    
}
#pragma mark -  UITableViewDelegate  
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [UserInfoContext sharedContext].deviceModelAry.count;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}  
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SaiSoundEquimentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaiSoundEquimentListCell"];
    cell.soundEquipmentModel = [UserInfoContext sharedContext].deviceModelAry[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    int i = 0;
   for (WNSoundEquipmentModelV2 *model in [UserInfoContext sharedContext].deviceModelAry) {
       if (i==indexPath.row) {
           NSString *url = [NSString stringWithFormat:@"/v1/surrogate/users/%@/%@/active",[UserInfoContext sharedContext].currentUser.userId,model.deviceId];
           [QKBaseHttpClient httpType:POST andURL:url andParam:nil andSuccessBlock:^(NSURL *URL, id data) {
               NSString *code = data[@"code"];
               if (code.intValue == 200) {
                   [UserInfoContext sharedContext].currentSpeakersV2 = model;
                   [self loadDataDeviceList];
                   WNMySoundEquipmentController *soundEquipmentController = [[WNMySoundEquipmentController alloc] init];
                   [self.navigationController pushViewController:soundEquipmentController animated:YES];
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
   [tableView reloadData];
    
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
- (void)setupUI{
    
    [self sai_initTitleView:@"我的设备"];
    [self sai_initGoBackBlackButton];
    UIButton *addRightBtn = [self sai_initNavRightBtn];
    [addRightBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addRightBtn addTarget:self action:@selector(addRightBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"SaiSoundEquimentListCell" bundle:nil] forCellReuseIdentifier:@"SaiSoundEquimentListCell"];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;

    self.tableView.frame=self.view.frame;
    UIView *footView = [[UIView alloc] init];
    footView.frame = CGRectMake(0, 0, ScreenWidth, 60);
    UIButton *addButton = [[UIButton alloc] init];
    addButton.frame = CGRectMake(0, 0, 135, 50);
    
    [addButton addTarget:self action:@selector(addRightBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setBackgroundImage:[UIImage imageNamed:@"tjsb_icon_adddevice"] forState:UIControlStateNormal];
    [footView addSubview:addButton];
    addButton.centerX = footView.centerX;
    self.tableView.tableFooterView = footView;
    self.tableView.tableFooterView.hidden = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, ScreenWidth, 50);

    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGBA(102, 102, 102, 1.0);
    label.text = @"添加您的设备，让我无时无刻帮您";
    [self.view addSubview:label];
    self.noLabel = label;
}
- (void)loadDataDeviceList{
    NSString *url = [NSString stringWithFormat:@"/v1/surrogate/users/%@/bindlist",[UserInfoContext sharedContext].currentUser.userId];
    [QKBaseHttpClient httpType:GET andURL:url andParam:nil andSuccessBlock:^(NSURL *URL, id data) {
        NSString *code = data[@"code"];
        if (code.intValue == 4000) {//没有绑定的设备
            [[UserInfoContext sharedContext].deviceModelAry removeAllObjects];
            self.noLabel.hidden = NO;
            self.tableView.frame = CGRectMake(0,CGRectGetMaxY(self.noLabel.frame) , ScreenWidth, ScreenHeight);
            self.tableView.tableFooterView.hidden = NO;
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
            if ([QKUITools isBlankArray:deviceAry]) {
                self.noLabel.hidden = NO;
                self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.noLabel.frame), ScreenWidth, ScreenHeight);
            }else{
                self.noLabel.hidden = YES;
                self.tableView.frame=[UIScreen mainScreen].bounds;
            }
            [self.tableView reloadData];
            [self testingEquipment];
            self.tableView.tableFooterView.hidden = NO;
        }else{
            NSString *message = data[@"message"];
            [SaiHUDTools showError:message];
        }
        [self.tableView reloadData];
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
#pragma mark -  Setters and Getters




@end
