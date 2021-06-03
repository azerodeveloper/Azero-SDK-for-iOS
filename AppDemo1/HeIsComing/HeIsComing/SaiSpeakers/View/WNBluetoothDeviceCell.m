//
//  WNBluetoothDeviceCell.m
//  WuNuo
//
//  Created by silk on 2019/5/8.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "WNBluetoothDeviceCell.h"
@interface WNBluetoothDeviceCell ()
@property (weak, nonatomic) IBOutlet UILabel *BlueToothDeviceNameView;
@property (weak, nonatomic) IBOutlet UIImageView *BlueToothDeviceImageView;

@end
@implementation WNBluetoothDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPeripheral:(CBPeripheral *)peripheral{
    _peripheral = peripheral;
//    if ([peripheral.name isEqualToString:@"RockChipBle"]) {
    self.BlueToothDeviceNameView.text = peripheral.name;
//    }
}
- (void)setAdvertisementData:(NSDictionary *)advertisementData{
    _advertisementData = advertisementData;
    NSString *kCBAdvDataLocalName = advertisementData[@"kCBAdvDataLocalName"];
    if (kCBAdvDataLocalName == nil) {
        self.BlueToothDeviceNameView.text = @"小声音箱";
    }else{
        self.BlueToothDeviceNameView.text = kCBAdvDataLocalName;
    }
    
}

@end
