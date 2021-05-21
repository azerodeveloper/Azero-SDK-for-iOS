//
//  MSRuntimeInfoModel.h
//  WuNuo
//
//  Created by silk on 2019/7/17.
//  Copyright © 2019 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRuntimeInfoModel : NSObject
@property (nonatomic ,copy) NSString *firmwareVersion;
@property (nonatomic ,copy) NSString *volume;
@property (nonatomic ,copy) NSString *wifiSsid;
@property (nonatomic ,assign) BOOL wifiActive;
@property (nonatomic ,assign) BOOL bluetoothActive;
@property (nonatomic ,copy) NSString *ip;
@property (nonatomic ,copy) NSString *mac;
@property (nonatomic ,copy) NSString *deviceSN;
@property (nonatomic ,copy) NSString *imei;
@property (nonatomic ,copy) NSString *cmei;
@property (nonatomic ,copy) NSString *cuei;

@end

