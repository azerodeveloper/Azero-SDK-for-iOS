//
//  WNBluetoothDeviceCell.h
//  WuNuo
//
//  Created by silk on 2019/5/8.
//  Copyright © 2019 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface WNBluetoothDeviceCell : UITableViewCell
@property (nonatomic ,strong) CBPeripheral *peripheral;
@property (nonatomic ,strong) NSDictionary *advertisementData;

@end

NS_ASSUME_NONNULL_END
