//
//  MSLatestVersionInformationModel.h
//  WuNuo
//
//  Created by silk on 2019/7/19.
//  Copyright © 2019 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSLatestVersionInformationModel : NSObject
@property (nonatomic ,copy) NSString *AzeroVersion;
@property (nonatomic ,copy) NSString *DeviceMac;
@property (nonatomic ,copy) NSString *DeviceName;
@property (nonatomic ,copy) NSString *DeviceSn;
@property (nonatomic ,copy) NSString *FirmwareVersion;
@property (nonatomic ,copy) NSString *md5sum;
@property (nonatomic ,copy) NSString *url;
@end

NS_ASSUME_NONNULL_END
