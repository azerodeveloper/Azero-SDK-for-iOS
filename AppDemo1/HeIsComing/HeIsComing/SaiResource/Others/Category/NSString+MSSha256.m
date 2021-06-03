//
//  NSString+MSSha256.m
//  WuNuo
//
//  Created by silk on 2019/8/27.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "NSString+MSSha256.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (MSSha256)
- (NSString *)SHA256
{
    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash;
    if (isIOS13) {
        hash = [self ConvertToNSString:out];
    }else{
        hash = [out description];
    }
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}
-(NSString *)ConvertToNSString:(NSData *)data
{
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    const unsigned char *szBuffer = [data bytes];
    for (NSInteger i=0; i < [data length]; ++i) {
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
    }
    return strTemp;
}
@end
