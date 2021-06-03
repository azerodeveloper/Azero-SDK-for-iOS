//
//  SaiSoundEquimentListCell.m
//  HeIsComing
//
//  Created by silk on 2020/8/7.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiSoundEquimentListCell.h"
@interface SaiSoundEquimentListCell ()
@property (weak, nonatomic) IBOutlet UILabel *soundEquimentName;
@property (weak, nonatomic) IBOutlet UILabel *selectView;
@property (weak, nonatomic) IBOutlet UILabel *soundEquimentType;
@property (weak, nonatomic) IBOutlet UILabel *wifiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@end
@implementation SaiSoundEquimentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setSoundEquipmentModel:(WNSoundEquipmentModelV2 *)soundEquipmentModel{
    _soundEquipmentModel = soundEquipmentModel;
    self.soundEquimentName.text = soundEquipmentModel.name;
    if (soundEquipmentModel.active) {
        self.selectView.text = @"已连接";
    }else{
        self.selectView.text = @"未连接";
    }
    NSString *name;
    if ([soundEquipmentModel.productId isEqualToString:@"sai_minidot"]) {
        name = @"小声音箱Mini";
    }else if ([soundEquipmentModel.productId isEqualToString:@"sai_minipodplus"]||[soundEquipmentModel.productId isEqualToString:@"speaker_sai_minipod"]){
        name = @"小声AI音箱灯";
    }else{
        name = @"AI音箱";
    }
    self.soundEquimentType.text = name;
    if (soundEquipmentModel.onlineState == 1) {
        self.wifiLabel.text = soundEquipmentModel.runtimeInfo.wifiSsid;
    }else{
        self.wifiLabel.text = @"设备离线";
    }
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10.0f;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}
@end
