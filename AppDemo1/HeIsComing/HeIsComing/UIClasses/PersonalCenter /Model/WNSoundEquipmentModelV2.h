//
//  WNSoundEquipmentModelV2.h
//  WuNuo
//
//  Created by silk on 2019/6/29.
//  Copyright © 2019 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSRuntimeInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WNSoundEquipmentModelV2 : NSObject
@property (nonatomic ,assign) BOOL active;
@property (nonatomic ,copy) NSString *deviceId;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *userId;
@property (nonatomic ,copy) NSString *productId;
@property (nonatomic ,assign) long long createdTime;
@property (nonatomic ,assign) long long activeTime;
@property (nonatomic ,strong) MSRuntimeInfoModel *runtimeInfo;
@property (nonatomic ,assign) int onlineState;

@end

NS_ASSUME_NONNULL_END
