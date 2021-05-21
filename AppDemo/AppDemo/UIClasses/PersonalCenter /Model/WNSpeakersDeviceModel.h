//
//  WNSpeakersDeviceModel.h
//  WuNuo
//
//  Created by silk on 2019/4/9.
//  Copyright © 2019 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface WNSpeakersDeviceModel : NSObject
@property (nonatomic ,copy) NSString *device_type;
@property (nonatomic ,copy) NSString *device_code;
@property (nonatomic ,copy) NSString *device_name;
@property (nonatomic ,copy) NSString *time_bound;
@property (nonatomic ,assign) BOOL active;

////是否选中
//@property (nonatomic ,assign) BOOL isChoose;

@end

