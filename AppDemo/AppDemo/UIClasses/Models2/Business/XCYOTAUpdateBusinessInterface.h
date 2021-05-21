//
//  XCYOTAUpdateBusinessInterface.h
//  XCYBlueBox
//
//  Created by zhouaitao on 2017/7/18.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "XCYOTAUpdateEventDelegate.h"

@protocol XCYOTAUpdateBusinessInterface <NSObject>
@required

- (void)setViewDelegate:(id<XCYOTAUpdateEventDelegate>)aDelegate;
- (void)initResource;
- (void)setSecondLap:(BOOL)flag;
- (void)max_disConnectPeripheral;
- (void)setOTASettgingData:(NSData *)aData;
- (void)setTotalSendData:(NSData *)totalData;
- (void)setMaxBreakPointLength:(NSUInteger)length;
- (void)setMaxSendDataLength:(NSUInteger)aMax;
- (void)setMaxCurrentVersionType:(NSUInteger)currentVersionType;
- (void)setUpdatePeripheral:(CBPeripheral *)aPeripheral;

- (void)otaUpdateStart;
@end
