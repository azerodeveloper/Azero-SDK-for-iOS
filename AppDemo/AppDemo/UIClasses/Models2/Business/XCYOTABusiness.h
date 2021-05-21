//
//  XCYOTABusiness.h
//  XCYBlueBox
//
//  Created by XCY on 2017/4/24.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSInteger, XCYOTAPeripheralType)
{
    XCYOTAPeripheralType_None = 0,
    XCYOTAPeripheralType_Origin,
    XCYOTAPeripheralType_OTA
    
};

@interface XCYOTABusiness : NSObject

- (void)showAlertAfterDisconnected:(BOOL)isNeedShow;


/**
 Stop scanning device
 */
- (void)stopScanPeriperal;

- (void)startScanPeripheralWithManufacture:(NSString *)aManufacture
                        complectionHandler:(void(^)(CBPeripheral *peripheral))complectionHandler;

- (void)connectPeripheral:(CBPeripheral *)aPeripheral
       complectionHandler:(void(^)(XCYOTAPeripheralType curPeripheralType, BOOL isConnected))compHandler;


- (void)disConnectPeripheral:(CBPeripheral *)aPeripheral
                 notifyBlock:(void(^)(CBPeripheral *peripheral, NSError *error))finishBlock;


- (void)notifyToOTAPeripheral:(CBPeripheral *)peripheral
           compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *chist, NSError *error))handler;

- (void)writeToPeripheral:(CBPeripheral *)aPeripheral
        curPeripheralType:(XCYOTAPeripheralType)aType
                valueData:(NSData *)valueData
       complectionHandler:(void(^)(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error))finishHandler;


- (void)writeToPeripheralWithoutNotify:(CBPeripheral *)aPeripheral
                valueData:(NSData *)valueData
                    complectionHandler:(void (^)(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error))finishHandler;



- (void)setDisconnectedNotifyBlock:(void(^)(CBPeripheral *peripheral, NSError *error))disconnectedBlock;

@end
