//
//  WNSoundEquipmentSetCell.m
//  WuNuo
//
//  Created by silk on 2019/5/21.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "WNSoundEquipmentSetCell.h"
@interface WNSoundEquipmentSetCell ()
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *wifiNameLabelView;
@property (weak, nonatomic) IBOutlet UIImageView *wifiStateView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameView;
@property (nonatomic ,strong) UITextField *deviceTextField;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;

@end

@implementation WNSoundEquipmentSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.editButton setTitleColor:SaiColor(250, 47, 44) forState:UIControlStateNormal];
    self.editButton.layer.cornerRadius = self.editButton.size.height/2.0;
    self.editButton.layer.masksToBounds = YES;
    self.editButton.layer.borderColor = [UIColor colorWithRed:250/255.0 green:47/255.0 blue:44/255.0 alpha:1.0].CGColor;
    self.editButton.layer.borderWidth = 1.0;
    self.volumeSlider.minimumTrackTintColor = SaiColor(250, 47, 44);
    self.volumeSlider.maximumValue = 100;
    self.volumeSlider.minimumValue = 0;
    self.volumeSlider.continuous = NO;
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"play_control_slider2"] forState:UIControlStateNormal];
    [self.volumeSlider addTarget:self action:@selector(voiceSliderChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
}

- (void)setHighlighted:(BOOL)highlighted{
}

- (void)setCurrentSpeakersV2:(WNSoundEquipmentModelV2 *)currentSpeakersV2{
    _currentSpeakersV2 = currentSpeakersV2;
    if (currentSpeakersV2.onlineState == 1) {
        self.wifiStateView.image = [UIImage imageNamed:@"eq_wifi_nor"];
        self.wifiNameLabelView.text = currentSpeakersV2.runtimeInfo.wifiSsid;
//        self.wifiNameLabelView.hidden = NO;
    }else{
        self.wifiStateView.image = [UIImage imageNamed:@"eq_wifi_unnor"];
        self.wifiNameLabelView.text = @"未连接";
//        self.wifiNameLabelView.hidden = YES;
    }
    self.deviceNameView.text = currentSpeakersV2.name;
    self.volumeSlider.value = [currentSpeakersV2.runtimeInfo.volume integerValue];
    if ([currentSpeakersV2.productId isEqualToString:@"sai_minidot"]) {
        self.deviceImageView.image = [UIImage imageNamed:@"product_miniPod"];
    }else if ([currentSpeakersV2.productId isEqualToString:@"sai_minipodplus"]||[currentSpeakersV2.productId isEqualToString:@"speaker_sai_minipod"]){
        self.deviceImageView.image = [UIImage imageNamed:@"SpeakerLamp"];
    }else{
        self.deviceImageView.image = [UIImage imageNamed:@"defaultSound"];
    }
}
- (IBAction)editButtonClickCallBack {
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
                [SaiNotificationCenter postNotificationName:DeviceInformationModifiedSuccessfully object:nil];
            }else{
                [SaiHUDTools showSuccess:@"修改失败"];
            }
        } andFailBlock:^(NSURL *URL, NSError *error) {
            TYLog(@"error: %@",error);
//            [SaiHUDTools showError:@"网络请求错误，请稍后重试。"];
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
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

- (void)voiceSliderChange:(UISlider *)slider{ 
    int volume = (int )slider.value;
//    if (volume%5 != 0) {
//        return;
//    }
    TYLog(@"%d",volume);
    NSDictionary *paramDic = @{@"userId":[UserInfoContext sharedContext].currentUser.userId,
                               @"deviceId":[UserInfoContext sharedContext].currentSpeakersV2.deviceId,
                               @"volume":[NSNumber numberWithInt:volume]
                               };
    [QKBaseHttpClient httpType:POST andURL:SetVolumeUrl andParam:paramDic andSuccessBlock:^(NSURL *URL, id data) {
        TYLog(@"data:%@",data);
        NSString *code = data[@"code"];
        if (code.intValue == 200) {
//            [SaiHUDTools showSuccess:@"设置音量成功"];
        }else{
            NSString *message = data[@"message"];
            [SaiHUDTools showError:message];
        }
    } andFailBlock:^(NSURL *URL, NSError *error) {
        [SaiHUDTools showError:@"网络请求错误"];
    }];
}

@end
