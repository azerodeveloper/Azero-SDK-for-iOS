//
//  SaiConvertUtil.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2019/1/18.
//  Copyright © 2019 soundai. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiConvertUtil : NSObject
+ (NSData *)getHashBytes:(NSData *)data;

+ (NSString *)bytes2HexString:(NSData *)data;

+ (NSData *)hexString2Bytes:(NSString*)hexString;

+ (NSData *)longlong2Bytes:(long long)value;

+ (NSString *)getCinBase64StringFromData:(NSData *)data;

+ (NSString *)getCinBase64StringFromString:(NSString *)data;  // X -> 64

+ (NSString *)getCinBase64StringGBKFromString:(NSString *)data;  // X -> 64


+ (NSString *)getCinBase64StringFromLong:(long long)data;

//+ (NSData *)dataWithBase64EncodedString:(NSString*)string;

+ (NSString *)getStringWithBase64EncodedString:(NSString *)encodedString; // 64 - > X

+ (NSString *)getStringWithBase64EncodedData:(NSData *)data;

//MD5
+ (NSString *)getMD5StringOfString:(NSString *)string;

+ (NSString *)getMD5StringOfData:(NSData *)data;

+ (NSData *)getMD5:(NSData *)signKey;
@end

NS_ASSUME_NONNULL_END
