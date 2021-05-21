//
//  XCYOTADataSource.m
//  XCYBlueBox
//
//  Created by XCY on 2017/5/10.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import "XCYOTADataSource.h"

@interface XCYOTADataSource ()

@property (strong, nonatomic) NSMutableData *otaEntryData;
@property (strong, nonatomic) NSMutableData *otaBLEData;

@end

@implementation XCYOTADataSource


- (NSData *)getOtaEntryData
{
    NSString *defaut = @"05000600";
    NSData *defaultData = [defaut dataFromHexString_xcy];
    _otaEntryData = [[NSMutableData alloc] initWithData:defaultData];
    _otaBLEData = [[NSMutableData alloc] initWithCapacity:1];
    for (int i = 0; i < 5; ++i) {
        
        uint32_t otaRandom =  arc4random() % 255;
        NSData *data = [NSData dataWithBytes:&otaRandom length:1];
        [_otaBLEData appendData:data];
    }
    
    //第六个字节需要高两位为1
    uint32_t otaRandom =  arc4random() % 255;
    otaRandom |= 0xC0;
    NSData *data = [NSData dataWithBytes:&otaRandom length:1];
    [_otaBLEData appendData:data];
    
    [_otaEntryData appendData:_otaBLEData];
    
    return _otaEntryData;
}

//蓝牙地址
- (NSData *)getOTABLEData
{
    return _otaBLEData;
}

- (NSData *)getDocumentDataWithDataName:(NSString *)name
{
    if (!name) {
        
        return nil;
    }
    
    NSString *docuDir = [XCYFileUtil fileDocDir];
    NSString *dataPath = [docuDir stringByAppendingPathComponent:name];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    if (data.length < 4) {
        
        return nil;
    }
    
    //省略末尾4个字节
    NSData *subData = [data subdataWithRange:NSMakeRange(0, data.length-4)];
    
    return subData;
}

- (NSData *)getLastFourSizeDataWithDataName:(NSString *)name
{
    if (!name) {
        
        return nil;
    }
    
    NSString *docuDir = [XCYFileUtil fileDocDir];
    NSString *dataPath = [docuDir stringByAppendingPathComponent:name];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    if (data.length < 4) {
        
        return nil;
    }
    
    //省略末尾4个字节
    NSData *subData = [data subdataWithRange:NSMakeRange(data.length-4,4)];
    
    return subData;
}

- (NSData *)chocieOTATypeData:(NSData *)totalData
{
    NSString *dataStr = @"8042455354";
    NSMutableData *fullData = [[NSMutableData alloc] initWithCapacity:1];
    [fullData appendData:[dataStr dataFromHexString_xcy]];
    
    NSUInteger dataLength = totalData.length;
    NSData *lengthData = [NSData dataWithBytes:&dataLength length:4];
    [fullData appendData:lengthData];
    
    NSData *subData = [totalData subdataWithRange:NSMakeRange(0, totalData.length)];
    int32_t crc32 = [subData CRC32Value_xcy];
    NSData *crc32Data = [NSData dataWithBytes:&crc32 length:4];
    [fullData appendData:crc32Data];
    
    return fullData;
}

- (NSData *)getCurrentVersion
{
    NSString *dataStr = @"8E42455354";
    NSMutableData *fullData = [[NSMutableData alloc] initWithCapacity:1];
    [fullData appendData:[dataStr dataFromHexString_xcy]];
    
    return fullData;
}

- (NSData *)getImageSideWithIndex:(NSInteger)type
{
    NSString *dataStr = @"90";
    
    if (type == 1) {
        dataStr = [dataStr stringByAppendingString:@"11"]; // both
    } else if (type == 2) {
        dataStr = [dataStr stringByAppendingString:@"01"]; // left
    } else if (type == 3) {
        dataStr = [dataStr stringByAppendingString:@"10"]; // right
    } else if (type == 4) {
        dataStr = [dataStr stringByAppendingString:@"00"]; // stereo
    }
    
    NSMutableData *fullData = [[NSMutableData alloc] initWithCapacity:2];
    [fullData appendData:[dataStr dataFromHexString_xcy]];
    
    return fullData;
}

- (NSData *)breakcCheckPoint:(NSData *)totalData type:(NSString *)type
{
    NSString *dataStr = @"8C42455354";
    NSMutableData *fullData = [[NSMutableData alloc] initWithCapacity:1];
    [fullData appendData:[dataStr dataFromHexString_xcy]];
    
    [fullData appendData:[self p_getRandomcodeWithType:type]];
    
    NSUInteger dataLength = totalData.length;
    NSData *lengthData = [NSData dataWithBytes:&dataLength length:4];
    [fullData appendData:lengthData];
    
    
    NSMutableData *subData = [[NSMutableData alloc] initWithCapacity:1];
    [subData appendData:[self p_getRandomcodeWithType:type]];
    [subData appendData:lengthData];
    int32_t crc32 = [subData CRC32Value_xcy];
    NSData *crc32Data = [NSData dataWithBytes:&crc32 length:4];
    
    [fullData appendData:crc32Data];
    
    return fullData;
}

//获取32位random code
- (NSData *)p_getRandomcodeWithType:(NSString *)type
{
    /*
     0000000000000000
     0000000000000000000000000000000000000000000000000000000000000000
     */
    NSString *dataStr = @"0000000000000000000000000000000000000000000000000000000000000000";
    
    if (type != nil &&
        [type isEqualToString:@""] == NO) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:type]) {
            dataStr = [[NSUserDefaults standardUserDefaults] objectForKey:type];
        }
    }
    
    NSData *uuidData = [dataStr dataFromHexString_xcy];

    return uuidData;
}

- (NSData *)getImageOverWritingConfirmation
{
    NSString *dataStr = @"9242455354";
    NSMutableData *fullData = [[NSMutableData alloc] initWithCapacity:1];
    [fullData appendData:[dataStr dataFromHexString_xcy]];
    
    return fullData;
}

@end
