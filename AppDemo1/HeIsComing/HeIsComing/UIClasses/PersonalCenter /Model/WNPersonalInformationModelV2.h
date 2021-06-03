//
//  WNPersonalInformationModelV2.h
//  WuNuo
//
//  Created by silk on 2019/7/5.
//  Copyright © 2019 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WNPersonalInformationModelV2 : NSObject
@property (nonatomic ,copy) NSString *birthday;
@property (nonatomic ,copy) NSString *phoneNumber;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *pictureUrl;
@property (nonatomic ,copy) NSString *sex;
@property (nonatomic ,copy) NSString *userId;
@end

NS_ASSUME_NONNULL_END
