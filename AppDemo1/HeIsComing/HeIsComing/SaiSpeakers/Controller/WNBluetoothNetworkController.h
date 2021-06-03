//
//  WNBluetoothNetworkController.h
//  WuNuo
//
//  Created by silk on 2019/5/8.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "SaiBaseRootController.h"
typedef NS_ENUM(NSInteger , SaiDeviceType) {
    SaiDeviceTypeMiniDot,
    SaiDeviceTypeMniniPodPlus
};
NS_ASSUME_NONNULL_BEGIN

@interface WNBluetoothNetworkController : SaiBaseRootController
@property (nonatomic ,assign) SaiDeviceType deviceType;

@end

NS_ASSUME_NONNULL_END
