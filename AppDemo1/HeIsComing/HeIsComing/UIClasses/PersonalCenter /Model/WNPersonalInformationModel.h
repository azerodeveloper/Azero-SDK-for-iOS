//
//  WNPersonalInformationModel.h
//  WuNuo
//
//  Created by silk on 2019/4/5.
//  Copyright © 2019 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WNPersonalInformationModel : NSObject<NSCoding>
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *picture_url;
@property (nonatomic ,assign) int gender;
@property (nonatomic ,copy) NSString *birthday;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)personalInformationModelWithDict:(NSDictionary *)dict;


@end

NS_ASSUME_NONNULL_END
