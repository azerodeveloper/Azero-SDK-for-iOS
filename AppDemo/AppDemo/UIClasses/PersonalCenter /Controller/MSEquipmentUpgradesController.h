//
//  MSEquipmentUpgradesController.h
//  WuNuo
//
//  Created by silk on 2019/8/2.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "SaiPersonalRootController.h"
#import "MSLatestVersionInformationModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SpeakersDeviceType) {
    SpeakersDeviceTypeMiniDot = 0,
    SpeakersDeviceTypeMiniPod,
};
@interface MSEquipmentUpgradesController : SaiPersonalRootController
@property (nonatomic ,assign) SpeakersDeviceType deviceType;

@property (nonatomic ,strong) MSLatestVersionInformationModel *versionInformationModel;

@end

NS_ASSUME_NONNULL_END
