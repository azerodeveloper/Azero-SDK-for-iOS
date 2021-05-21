//
//  XCYOTABusiness.m
//  XCYBlueBox
//
//  Created by XCY on 2017/4/24.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import "XCYOTABusiness.h"
#import "XCYBlueToothCentralManager.h"

@interface XCYOTABusiness ()


@property (strong, nonatomic) XCYBlueToothCentralManager *centralManager;

@end

@implementation XCYOTABusiness

- (void)showAlertAfterDisconnected:(BOOL)isNeedShow
{
    [self.centralManager showAlertAfterDisconnected:isNeedShow];
}

- (void)stopScanPeriperal
{
    [self.centralManager stopScan];
}

- (void)startScanPeripheralWithManufacture:(NSString *)aManufacture
                        complectionHandler:(void(^)(CBPeripheral *peripheral))complectionHandler
{
    __weak __typeof(self)weakSelf = self;
    [self.centralManager startScanForPeripheralsWithServices:nil options:nil completionHandler:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        if (!peripheral) {
            return ;
        }
        
        NSData *manufacturerData = [advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey];
        NSString *dataStr = [NSString stringFromData_cmbc:manufacturerData];
        dataStr = [dataStr uppercaseString];
        if ([dataStr rangeOfString:aManufacture].location == NSNotFound) {
            
            return;
        }
       
        //找到Peripheral后停止扫描
        [weakSelf.centralManager stopScan];
        
        if (complectionHandler) {
            complectionHandler(peripheral);
        }
        
    }];
}

- (void)connectPeripheral:(CBPeripheral *)aPeripheral
       complectionHandler:(void(^)(XCYOTAPeripheralType curPeripheralType, BOOL isConnected))compHandler
{
    __weak __typeof(self)weakSelf = self;
    if (!aPeripheral) {
        if (compHandler) {
            compHandler(XCYOTAPeripheralType_None, NO);
        }
        
        return;
    }
    
    [self.centralManager connectPeripheral:aPeripheral options:nil compeletionHandler:^(CBPeripheral *peripheral, NSError *error) {
       
        if (error || !peripheral) {
            if (compHandler) {
                compHandler(XCYOTAPeripheralType_None, NO);
            }
            
            return ;
        }
        
        
        [weakSelf p_discoverService:peripheral complectionHandler:compHandler];
        
    }];
    
}

- (void)disConnectPeripheral:(CBPeripheral *)aPeripheral
                 notifyBlock:(void(^)(CBPeripheral *peripheral, NSError *error))finishBlock
{
    //已断开连接
    if (aPeripheral.state == CBPeripheralStateDisconnected) {
        
        if (finishBlock) {
            finishBlock(aPeripheral, nil);
        }
        
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    [self.centralManager setDisconnectedNotifyBlock:^(CBPeripheral *peripheral, NSError *error) {
        
        [weakSelf.centralManager setDisconnectedNotifyBlock:nil];
        
        if (finishBlock) {
            finishBlock(peripheral, error);
        }
    }];
    [self.centralManager disConnectPeripheral:aPeripheral];
}

- (void)notifyToOTAPeripheral:(CBPeripheral *)peripheral
           compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *chist, NSError *error))handler
{
    CBUUID *characteristicsuuid = [self p_getOTACharacteristicsUUID];
    [self.centralManager notifyToPeripheral:peripheral
                             characteristic:characteristicsuuid
                                notifyValue:YES
                         compeletionHandler:handler];
}

- (void)writeToPeripheral:(CBPeripheral *)aPeripheral
        curPeripheralType:(XCYOTAPeripheralType)aType
                valueData:(NSData *)valueData
       complectionHandler:(void(^)(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error))finishHandler
{
    if (aType == XCYOTAPeripheralType_OTA) {
        
        [self p_writeToOTAPeripheral:aPeripheral valueData:valueData complectionHandler:finishHandler];
    }
    else if (aType == XCYOTAPeripheralType_Origin)
    {
        [self p_writeToOriginPeripheral:aPeripheral valueData:valueData complectionHandler:finishHandler];
    }
}

- (void)writeToPeripheralWithoutNotify:(CBPeripheral *)aPeripheral
                             valueData:(NSData *)valueData
                    complectionHandler:(void (^)(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error))finishHandler
{
    CBUUID *characteristicsuuid = [self p_getOTACharacteristicsUUID];
    [self.centralManager writeToPeripheral:aPeripheral
                       characteristicsUUID:characteristicsuuid
                                     value:valueData
                        compeletionHandler:^(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error) {
                        
                                
            if (finishHandler) {
                finishHandler(peripheral, charactic, error);
            }
    }];
}

- (void)p_writeToOTAPeripheral:(CBPeripheral *)aPeripheral valueData:(NSData *)aValueData complectionHandler:(void(^)(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error))finishHandler
{
    [self.centralManager notifyCharacteristicDidUpdateValue:^(CBPeripheral *peripheral, CBCharacteristic *chist, NSError *error) {
        
        if (finishHandler) {
            finishHandler(peripheral, chist, error);
        }
        
    }];

    [self p_sendSubOTAData:aValueData peripheral:aPeripheral complectionHandler:finishHandler];
}


- (void)p_sendSubOTAData:(NSData *)subData
              peripheral:(CBPeripheral *)aPeripheral
      complectionHandler:(void(^)(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error))finishHandler
{
    //characteristics的UUID
    CBUUID *characteristicsuuid = [self p_getOTACharacteristicsUUID];
    [self.centralManager writeToPeripheral:aPeripheral
                       characteristicsUUID:characteristicsuuid
                                     value:subData
                        compeletionHandler:^(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error) {
                            
        if (error) {
            
            if (finishHandler) {
                finishHandler(peripheral, charactic, error);
            }
            
            return ;
        }
    }];
}

- (void)p_writeToOriginPeripheral:(CBPeripheral *)aPeripheral valueData:(NSData *)aValueData complectionHandler:(void(^)(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error))finishHandler
{
    
    CBUUID *uuid = [self p_getOriginCharacteristicsUUID];
    [self.centralManager writeToPeripheral:aPeripheral characteristicsUUID:uuid value:aValueData compeletionHandler:^(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error) {
        
        if (finishHandler) {
            finishHandler(peripheral,charactic,error);
        }
    }];

}

- (void)setDisconnectedNotifyBlock:(void(^)(CBPeripheral *peripheral, NSError *error))disconnectedBlock
{
    __weak __typeof(self)weakSelf = self;
    [self.centralManager setDisconnectedNotifyBlock:^(CBPeripheral *peripheral, NSError *error) {
    
        [weakSelf.centralManager setDisconnectedNotifyBlock:nil];
        if (disconnectedBlock) {
            disconnectedBlock(peripheral,error);
        }
        
    }];
}

#pragma mark - private
- (void)p_discoverService:(CBPeripheral *)aPeripheral
       complectionHandler:(void(^)(XCYOTAPeripheralType curPeripheralType, BOOL isConnected))compHandler
{
    
    __weak __typeof(self)weakSelf = self;
    if (!aPeripheral) {
        if (compHandler) {
            compHandler(XCYOTAPeripheralType_None, NO);
        }
        
        return;
    }
    
    [self.centralManager discoverServices:nil inPeripheral:aPeripheral compeletionHandler:^(CBPeripheral *peripheral, NSError *error) {
        
        if (error || !peripheral) {
            if (compHandler) {
                compHandler(XCYOTAPeripheralType_None, NO);
            }
            
            return ;
        }
        
        
        NSArray<CBService *> *services = peripheral.services;
        for (CBService *service in services) {
            
            CBUUID *curServiceUUID = service.UUID;
            CBUUID *otaServiceUUID = [weakSelf p_getOTAServicesUUID];
            XCYOTAPeripheralType peripheralType = XCYOTAPeripheralType_Origin;
            
            CBUUID *characteristicsUUID = [weakSelf p_getOriginCharacteristicsUUID];
            if ([curServiceUUID.UUIDString isEqualToString:otaServiceUUID.UUIDString]) {
                
                characteristicsUUID  = [weakSelf p_getOTACharacteristicsUUID];
                peripheralType = XCYOTAPeripheralType_OTA;
                
                
                NSArray *uuids = [NSArray arrayWithObjects:characteristicsUUID, nil];
                [weakSelf.centralManager discoverCharacteristics:uuids forService:service inPeripheral:peripheral compeletionHandler:^(CBPeripheral * _Nonnull peripheral, CBService * _Nonnull service, NSError * _Nonnull error) {
                    
                    
                    if (error || !peripheral) {
                        if (compHandler) {
                            compHandler(XCYOTAPeripheralType_None, NO);
                        }
                        
                        return ;
                    }
                    
                    if (compHandler) {
                        compHandler(peripheralType, YES);
                    }
                }];
            }
            
        }
        
    }];
}


- (CBUUID *)p_getOriginServicesUUID
{
    //Service的UUID
    NSString *dataStr = @"01000100000010008000009078563412";
    NSData *serviceuuidData = [dataStr dataFromHexString_xcy];
    CBUUID *serviceuuid = [CBUUID UUIDWithData:serviceuuidData];
    
    return serviceuuid;
}

//获取进入OTA模式的UUID
- (CBUUID *)p_getOriginCharacteristicsUUID
{
    NSString *dataStr = @"03000300000010008000009278563412";
    NSData *uuidData = [dataStr dataFromHexString_xcy];
    CBUUID *uuid = [CBUUID UUIDWithData:uuidData];
    
    return uuid;
}

//获取已经进入OTA模式，重置后的Services的UUID
- (CBUUID *)p_getOTAServicesUUID
{
    //Service的UUID
    NSString *dataStr = @"66666666666666666666666666666666";
    NSData *serviceuuidData = [dataStr dataFromHexString_xcy];
    CBUUID *serviceuuid = [CBUUID UUIDWithData:serviceuuidData];
    
    return serviceuuid;
}

//获取已经进入OTA模式，重置后的Characteristics的UUID
- (CBUUID *)p_getOTACharacteristicsUUID
{
    NSString *dataStr = @"77777777777777777777777777777777";
    NSData *uuidData = [dataStr dataFromHexString_xcy];
    CBUUID *uuid = [CBUUID UUIDWithData:uuidData];
    
    return uuid;
}

#pragma mark - getter/setter
- (XCYBlueToothCentralManager *)centralManager
{
    if (_centralManager) {
        
        return _centralManager;
    }
    _centralManager = [XCYBlueToothCentralManager shareInstance];
    return _centralManager;
}

@end
