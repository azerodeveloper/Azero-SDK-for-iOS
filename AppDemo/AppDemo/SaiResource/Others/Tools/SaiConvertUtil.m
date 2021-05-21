//
//  SaiConvertUtil.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2019/1/18.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "SaiConvertUtil.h"
static char encodingTable[64] = {
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
    'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
    'w','x','y','z','0','1','2','3','4','5','6','7','8','9','-','_' };
@implementation SaiConvertUtil
+ (NSData *)getHashBytes:(NSData *) data {
    NSData * hash = nil;
    
    @autoreleasepool {
        CC_SHA1_CTX ctx;
        uint8_t * hashBytes = NULL;
        
        // Malloc a buffer to hold hash.
        hashBytes = malloc( CC_SHA1_DIGEST_LENGTH * sizeof(uint8_t) );
        memset((void *)hashBytes, 0x0, CC_SHA1_DIGEST_LENGTH);
        
        // Initialize the context.
        CC_SHA1_Init(&ctx);
        // Perform the hash.
        CC_SHA1_Update(&ctx, (void *)[data bytes], [data length]);
        // Finalize the output.
        CC_SHA1_Final(hashBytes, &ctx);
        
        hash = [[NSData alloc] initWithBytes:hashBytes length:CC_SHA1_DIGEST_LENGTH];
        if (hashBytes) {
            free(hashBytes);
        }
    }
    return hash ;
}

+ (NSString*)bytes2HexString:(NSData *)data {
    if (data == nil)
        return @"";
    
    NSMutableString* hexString = [NSMutableString new] ;
    unsigned const char* pointer = [data bytes];
    NSInteger length = [data length];
    for(unsigned short i = 0 ; i < length ; i++)
    {
        [hexString appendFormat:@"%02X", *(pointer++)];
    }
    return hexString;
}

+ (NSData*)hexString2Bytes:(NSString*)hexString {
    const char *buf = [hexString UTF8String];
    NSMutableData *data = [NSMutableData data];
    if (buf)
    {
        uint32_t len = strlen(buf);
        
        char singleNumberString[3] = {'\0', '\0', '\0'};
        uint32_t singleNumber = 0;
        for(uint32_t i = 0 ; i < len; i+=2)
        {
            if ( ((i+1) < len) && isxdigit(buf[i]) && (isxdigit(buf[i+1])) )
            {
                singleNumberString[0] = buf[i];
                singleNumberString[1] = buf[i + 1];
                sscanf(singleNumberString, "%x", &singleNumber);
                uint8_t tmp = (uint8_t)(singleNumber & 0x000000FF);
                [data appendBytes:(void *)(&tmp)length:1];
            }
            else
            {
                break;
            }
        }
    }
    return data;
}

+(NSData*)longlong2Bytes:(long long)value {
    char leadingZeroBytes = 8;
    for(char i = 8; i >1 ; i--)
    {
        if(((value >> 8 * (i - 1)) & 0xFF) != 0)
        {
            leadingZeroBytes = 8-i;
            break;
        }
    }
    if(leadingZeroBytes == 8)leadingZeroBytes = 7;
    unsigned short len = 8 - leadingZeroBytes;
    return [[NSMutableData alloc] initWithBytes:&value length:len] ;
}

//+ (NSData *)dataWithBase64EncodedString:(NSString *)string {
//    NSMutableData *mutableData = nil;
//    
//    if( string ) {
//        unsigned long ixtext = 0;
//        unsigned long lentext = 0;
//        unsigned char ch = 0;
//        unsigned char inbuf[5], outbuf[4];
//        short i = 0, ixinbuf = 0;
//        short ctcharsinbuf = 0;
//        BOOL flignore = NO;
//        BOOL flendtext = NO;
//        NSData *base64Data = nil;
//        const unsigned char *base64Bytes = nil;
//        
//        // Convert the string to ASCII data.
//        base64Data = [string dataUsingEncoding:NSASCIIStringEncoding];
//        base64Bytes = [base64Data bytes];
//        mutableData = [[NSMutableData alloc] initWithCapacity:[base64Data length]];
//        lentext = [base64Data length];
//        
//        while( YES ) {
//            if( ixtext >= lentext ) break;
//            ch = base64Bytes[ixtext++];
//            flignore = NO;
//            
//            if( ( ch >= 'A' ) && ( ch <= 'Z' ) ) ch = ch - 'A';
//            else if( ( ch >= 'a' ) && ( ch <= 'z' ) ) ch = ch - 'a' + 26;
//            else if( ( ch >= '0' ) && ( ch <= '9' ) ) ch = ch - '0' + 52;
//            else if( ch == '-' ) ch = 62;
//            else if( ch == ';' ) flendtext = YES;
//            else if( ch == '_' ) ch = 63;
//            else flignore = YES;
//            
//            if( ! flignore ) {
//                ctcharsinbuf = 3;
//                BOOL flbreak = NO;
//                
//                if( flendtext ) {
//                    if( ! ixinbuf ) break;
//                    if( ( ixinbuf == 1 ) || ( ixinbuf == 2 ) ) ctcharsinbuf = 1;
//                    else ctcharsinbuf = 2;
//                    ixinbuf = 3;
//                    flbreak = YES;
//                }
//                
//                inbuf [ixinbuf++] = ch;
//                
//                if( ixinbuf == 4 ) {
//                    ixinbuf = 0;
//                    outbuf [0] = ( inbuf[0] << 2 ) | ( ( inbuf[1] & 0x30) >> 4 );
//                    outbuf [1] = ( ( inbuf[1] & 0x0F ) << 4 ) | ( ( inbuf[2] & 0x3C ) >> 2 );
//                    outbuf [2] = ( ( inbuf[2] & 0x03 ) << 6 ) | ( inbuf[3] & 0x3F );
//                    
//                    for( i = 0; i < ctcharsinbuf; i++ )
//                        [mutableData appendBytes:&outbuf[i] length:1];
//                }
//                
//                if( flbreak )  break;
//            }
//        }
//    }
//    return mutableData ;
//}

+ (NSString *)getStringWithBase64EncodedString:(NSString *)encodedString
{
    NSData *data = [NSData dataWithBase64EncodedString:encodedString];
    NSString *originalString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    return originalString;
}
#pragma mark - encode base64
+ (NSString *)getCinBase64StringFromData:(NSData *)data {
    const unsigned char    *bytes = [data bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:[data length]];
    unsigned long ixtext = 0;
    unsigned long lentext = [data length];
    long ctremaining = 0;
    unsigned char inbuf[3], outbuf[4];
    short i = 0;
    unsigned int charsonline = 0;
    short ctcopy = 0;
    unsigned long ix = 0;
    
    while( YES ) {
        ctremaining = lentext - ixtext;
        if( ctremaining <= 0 ) break;
        
        for( i = 0; i < 3; i++ ) {
            ix = ixtext + i;
            if( ix < lentext ) inbuf[i] = bytes[ix];
            else inbuf [i] = 0;
        }
        
        outbuf [0] = (inbuf [0] & 0xFC) >> 2;
        outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
        outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
        outbuf [3] = inbuf [2] & 0x3F;
        ctcopy = 4;
        
        switch( ctremaining ) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for( i = 0; i < ctcopy; i++ )
            [result appendFormat:@"%c", encodingTable[outbuf[i]]];
        
        for( i = ctcopy; i < 4; i++ )
            [result appendFormat:@"%c",';'];
        
        ixtext += 3;
        charsonline += 4;
    }
    
    return result;
}

+ (NSString *)getCinBase64StringFromString:(NSString *)data {
    return [self getCinBase64StringFromData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    
}
+ (NSString *)getCinBase64StringGBKFromString:(NSString *)data{
    return [self getCinBase64StringFromData:[data dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]];
}

+ (NSString *)getCinBase64StringFromLong:(long long)data {
    return [self getCinBase64StringFromString:[NSString stringWithFormat:@"%lld",data]];
}

+ (NSString *)getMD5StringOfString:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

+ (NSString *)getMD5StringOfData:(NSData *)data {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], (CC_LONG)[data length], result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}
+ (NSData *)getMD5:(NSData *)signKey {
    //MD5(randomCode+domain)将得到的短验加密
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendData:signKey];
    
    unsigned char pwdDomainMD5[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], (CC_LONG)[data length], pwdDomainMD5);
    NSMutableData *sign = [[NSMutableData alloc] init];
    [sign appendBytes: pwdDomainMD5 length: 16];
    return sign;
}

+ (NSString *)getStringWithBase64EncodedData:(NSData *)data{
    return  [data base64EncodedStringWithOptions:0];
}
@end
