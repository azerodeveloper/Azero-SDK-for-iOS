//
//  WNDeviceConnectedSuccessfullyController.m
//  WuNuo
//
//  Created by silk on 2019/5/15.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "WNDeviceConnectedSuccessfullyController.h"
#define congratulationsLabelY   44.5
#define sureBtnX   20
#define sureBtnH    44
@interface WNDeviceConnectedSuccessfullyController ()

@end

@implementation WNDeviceConnectedSuccessfullyController
#pragma mark -  Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
#pragma mark -  UITableViewDelegate
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Methods
#pragma mark -  Button Callbacks
- (void)sureBtnClickCallBack:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark -  Private Methods
- (void)setupUI{
    UILabel *congratulationsLabel = [[UILabel alloc] init];
    if (Sai_iPhoneX||Sai_iPhoneXS||Sai_iPhoneXsXrMax) {
        congratulationsLabel.frame = CGRectMake(0, 88+congratulationsLabelY, ViewWidth, 22.0f);
    }else{
        congratulationsLabel.frame = CGRectMake(0, 64+congratulationsLabelY, ViewWidth, 22.0f);
    }
    congratulationsLabel.text = @"恭喜，连接成功！";
    congratulationsLabel.textAlignment = NSTextAlignmentCenter;
    congratulationsLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:22.0f];
    [self.view addSubview:congratulationsLabel];
    UILabel *tryLabel = [[UILabel alloc] init];
    tryLabel.frame = CGRectMake(0, CGRectGetMaxY(congratulationsLabel.frame)+5, ViewWidth, 17.0f);
    tryLabel.text = @"试着说禾苗";
    tryLabel.textAlignment = NSTextAlignmentCenter;
    tryLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:14.0f];
    [self.view addSubview:tryLabel];
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.frame = CGRectMake(sureBtnX, CGRectGetMaxY(tryLabel.frame)+150, ViewWidth-sureBtnX*2, sureBtnH);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = sureBtnH/2.0f;
    sureBtn.backgroundColor = SaiColor(250, 47, 44);
    sureBtn.titleLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0f];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}
#pragma mark -  Public Methods
#pragma mark -  Getters and Getters

@end
