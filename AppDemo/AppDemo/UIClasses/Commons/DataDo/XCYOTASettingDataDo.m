//
//  XCYOTASettingDataDo.m
//  XCYBlueBox
//
//  Created by zhouaitao on 2017/8/20.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import "XCYOTASettingDataDo.h"

@implementation XCYOTASettingDataDo

- (void)updateFlashOffsetData:(NSData *)offsetData
{
    _flashOffsetData = offsetData;
}

- (NSData *)getFlashOffsetData{

    NSData *subData = [_flashOffsetData subdataWithRange:NSMakeRange(0, 3)];
    NSMutableData *data = [NSMutableData dataWithData:subData];
    [data appendData:[@"00" dataFromHexString_xcy]];
    return data;
}
- (NSData *)getSwitchData{
    
    int switchInt = 0;
    NSNumber *switchNumber = [NSNumber numberWithBool:_isBLEAddrOpen];
    int subInt = [switchNumber intValue];
    switchInt = subInt;
    
    switchNumber = [NSNumber numberWithBool:_isBTAddrOpen];
    subInt = [switchNumber intValue];
    switchInt = (switchInt << 1) + subInt;
    
    switchNumber = [NSNumber numberWithBool:_isBLENameOpen];
    subInt = [switchNumber intValue];
    switchInt = (switchInt << 1) + subInt;
    
    switchNumber = [NSNumber numberWithBool:_isBTNameOpen];
    subInt = [switchNumber intValue];
    switchInt = (switchInt << 1) + subInt;
    
    switchNumber = [NSNumber numberWithBool:_isClearData];
    subInt = [switchNumber intValue];
    switchInt = (switchInt << 1) + subInt;
    
    NSData *data = [NSData dataWithBytes:&switchInt length:1];
    NSMutableData *paddingData = [[NSMutableData alloc] initWithLength:3];
    NSMutableData *fullData = [[NSMutableData alloc] initWithCapacity:1];
    [fullData appendData:data];
    [fullData appendData:paddingData];
    
    return fullData;
}
- (NSData *)getBTAddrData{
    
    if (!_isBTAddrOpen) {
    
        NSMutableData *defaultdata = [[NSMutableData alloc] initWithLength:6];
        return defaultdata;
    }
    
    NSData *data = [_btAddr dataFromHexString_xcy];
    NSMutableData *fullData = [[NSMutableData alloc] initWithData:data];
    NSMutableData *paddingData = [[NSMutableData alloc] initWithLength:(6-data.length)];
    [fullData appendData:paddingData];
    
    return fullData;
}
- (NSData *)getBTNameData{
    
    if (!_isBTNameOpen) {
        
        return [[NSMutableData alloc] initWithLength:32];
    }
    
    NSData *data = [_btName dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableData *fullData = [[NSMutableData alloc] initWithData:data];
    NSMutableData *paddingData = [[NSMutableData alloc] initWithLength:(32-data.length)];
    [fullData appendData:paddingData];
    
    return fullData;
    
}
- (NSData *)getBLEAddrData{
    
    if (!_isBLEAddrOpen) {
        
        NSMutableData *defaultdata = [[NSMutableData alloc] initWithLength:6];
        return defaultdata;
    }
    
    NSData *data = [_bleAddr dataFromHexString_xcy];
    NSMutableData *fullData = [[NSMutableData alloc] initWithData:data];
    NSMutableData *paddingData = [[NSMutableData alloc] initWithLength:(6-data.length)];
    [fullData appendData:paddingData];
    
    return fullData;
}
- (NSData *)getBLENameData{
    
    if (!_isBLENameOpen) {
        
        return [[NSMutableData alloc] initWithLength:32];
    }
    
    NSData *data = [_bleName dataUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableData *fullData = [[NSMutableData alloc] initWithData:data];
    NSMutableData *paddingData = [[NSMutableData alloc] initWithLength:(32-data.length)];
    [fullData appendData:paddingData];
    
    return fullData;
}

- (NSData *)getTotalSettingData{
    
    NSData *switchData = [self getSwitchData];
    NSData *offSetData = [self getFlashOffsetData];
    NSData *btAddrData = [self getBTAddrData];
    NSData *btNameData = [self getBTNameData];
    NSData *bleAddrData = [self getBLEAddrData];
    NSData *bleNameData = [self getBLENameData];
    
    NSMutableData *infoData = [[NSMutableData alloc] initWithCapacity:1];
    [infoData appendData:offSetData];
    [infoData appendData:switchData];
    [infoData appendData:btNameData];
    [infoData appendData:bleNameData];
    [infoData appendData:btAddrData];
    [infoData appendData:bleAddrData];
    
    //
    NSInteger totalLength = infoData.length + 4;
    NSData *lengthData = [NSData dataWithBytes:&totalLength length:4];
    
    NSMutableData *totalData = [[NSMutableData alloc] initWithCapacity:1];
    [totalData appendData:lengthData];
    [totalData appendData:infoData];
    
    //
    int32_t crc32 = [totalData CRC32Value_xcy];
    NSData *crc32Data = [NSData dataWithBytes:&crc32 length:4];
    
    [totalData appendData:crc32Data];

    return totalData;
}
@end
