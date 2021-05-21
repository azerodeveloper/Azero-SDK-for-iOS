//
//  XCYOTASettingDataDo.h
//  XCYBlueBox
//
//  Created by zhouaitao on 2017/8/20.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCYOTASettingDataDo : NSObject

@property (copy, nonatomic) NSData *flashOffsetData;
@property (copy, nonatomic) NSString *btAddr;
@property (copy, nonatomic) NSString *btName;
@property (copy, nonatomic) NSString *bleAddr;
@property (copy, nonatomic) NSString *bleName;

@property (assign, nonatomic) BOOL isClearData;
@property (assign, nonatomic) BOOL isBTAddrOpen;
@property (assign, nonatomic) BOOL isBTNameOpen;
@property (assign, nonatomic) BOOL isBLEAddrOpen;
@property (assign, nonatomic) BOOL isBLENameOpen;


- (void)updateFlashOffsetData:(NSData *)offsetData;

- (NSData *)getFlashOffsetData;
- (NSData *)getSwitchData;
- (NSData *)getBTAddrData;
- (NSData *)getBTNameData;
- (NSData *)getBLEAddrData;
- (NSData *)getBLENameData;


- (NSData *)getTotalSettingData;
@end
