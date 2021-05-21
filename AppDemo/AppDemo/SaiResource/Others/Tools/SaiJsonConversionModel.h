//
//  SaiJsonConversionModel.h
//  HeIsComing
//
//  Created by silk on 2020/3/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiJsonConversionModel : NSObject
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+ (NSString*)jsonStringCompactFormatForNSArray:(NSArray *)arrJson;
@end

NS_ASSUME_NONNULL_END
