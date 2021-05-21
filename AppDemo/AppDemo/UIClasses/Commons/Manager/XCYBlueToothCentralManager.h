//
//  XCYBlueToothCentralManager.h
//  XCYBlueBox
//
//  Created by XCY on 2017/4/7.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface XCYBlueToothCentralManager : NSObject


/**
 shareInstance

 @return Returns a BLE processing class object
 */
+ (instancetype)shareInstance;


/**
 Clear BLE data
 */
- (void)clearCentralManager;


/**
Whether to display Alert after disconnection, default is YES, display, (change the status to YES during initialization)
 @param isShow YES:Prompt when disconnected， NO:No prompt when disconnected
 */
- (void)showAlertAfterDisconnected:(BOOL)isShow;

/**
 *  Gets the status of the central device
 *
 *  @param handler handler
 */
- (void)getCentralManagerCompletionHandler:(void(^)(CBManagerState state))handler;



/**
 Search equipment Peripheral

 @param serviceUUIDs ServiceUUID
 @param options options
 @param handler callback
 */
- (void)startScanForPeripheralsWithServices:(NSArray<CBUUID *> *)serviceUUIDs
                                    options:(NSDictionary<NSString *, id> *)options
                          completionHandler:(void(^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))handler;


/**
 Connect Peripheral

 @param peripheral To connect the Peripheral
 @param options options
 @param handler callback
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral
                  options:(NSDictionary<NSString *, id> *)options
       compeletionHandler:(void(^)(CBPeripheral *peripheral, NSError *error))handler;



/**
 search Service

 @param serviceUUIDs ServiceUUID
 @param peripheral Peripheral
 @param handler callback
 */
- (void)discoverServices:(NSArray<CBUUID *>* )serviceUUIDs
            inPeripheral:(CBPeripheral *)peripheral
      compeletionHandler:(void(^)(CBPeripheral *peripheral,NSError *error))handler;



/**
 search characteristics

 @param characteristicUUIDs characteristicsUUID
 @param service service
 @param peripheral peripheral
 @param handler callback
 */
- (void)discoverCharacteristics:(NSArray<CBUUID *> *)characteristicUUIDs
                     forService:(CBService *)service
                   inPeripheral:(CBPeripheral *)peripheral
             compeletionHandler:(void(^)(CBPeripheral *peripheral,CBService *service,NSError *error))handler;


/**
 *  Set the disconnect callback
 *
 *  @param disconnectedBlock disconnectedBlock
 */
- (void)setDisconnectedNotifyBlock:(void(^)(CBPeripheral *peripheral, NSError *error))disconnectedBlock;



/**
 Write data to the device

 @param peripheral device
 @param characteristicsUUID UUID
 @param value data
 @param handler callback
 */
-(void)writeToPeripheral:(CBPeripheral *)peripheral
     characteristicsUUID:(CBUUID *)characteristicsUUID
                   value:(NSData *)value
      compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *charactic, NSError *error))handler;

-(void)writeToPeripheralWithoutResponse:(CBPeripheral *)peripheral
                         characteristic:(CBUUID *)characteristicUUID
                                  value:(NSData *)value
                     compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *charactic, NSError *error))handler;


/**
 *  Subscribe to chist
 */
- (void)notifyToPeripheral:(CBPeripheral *)peripheral
            characteristic:(CBUUID *)characteristicUUID
               notifyValue:(BOOL)isNotify
        compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *chist, NSError *error))handler;

/**
 *  Set the subscription notification callback
 */
- (void)notifyCharacteristicDidUpdateValue:(void(^)(CBPeripheral *peripheral,CBCharacteristic *chist, NSError *error))updateBlock;

/**
 *  Cancel the connection peripheral
 *
 *  @param peripheral peripheral
 */
- (void)disConnectPeripheral:(CBPeripheral *)peripheral;


/**
 To suspend the search
 */
- (void)stopScan;
@end
