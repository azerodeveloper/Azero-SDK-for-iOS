//
//  SaiJsonConversionModel.m
//  HeIsComing
//
//  Created by silk on 2020/3/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiJsonConversionModel.h"

@implementation SaiJsonConversionModel
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
if (jsonString == nil) {
return nil;
}

NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
NSError *err;
NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
options:NSJSONReadingMutableContainers error:&err];

if(err) {

TYLog(@"json解析失败：%@",err);
return nil;
}
return dic;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
NSError *parseError = nil;
NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)jsonStringCompactFormatForNSArray:(NSArray *)arrJson {
    if (![arrJson isKindOfClass:[NSArray class]] || ![NSJSONSerialization isValidJSONObject:arrJson]) {
        return @"";
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrJson options:0 error:nil];
    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return strJson;
}
@end
