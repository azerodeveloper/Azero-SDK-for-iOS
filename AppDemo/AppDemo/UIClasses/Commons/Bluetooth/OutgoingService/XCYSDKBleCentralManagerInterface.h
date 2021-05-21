//
//  XCYBleCentralManagerInterface.h
//  XCYSdkPackage
//  流程：检测中心状态->扫描外设->连接外设->发现服务->发现特征->读写数据/
//  Created by XCY on 16/4/27.
//  Copyright © 2016年 XCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XCYSDKBleCentralManagerInterface <NSObject>


@required

/**
 *  获取中心设备状态
 *
 *  @param handler handler
 */
- (void)getCentralManagerCompletionHandler:(void(^)(CBManagerState state))handler;

/**
 *  设置断开连接回调
 *
 *  @param disconnectedBlock disconnectedBlock
 */
- (void)setDisconnectedNotifyBlock:(void(^)(CBPeripheral *peripheral, NSError *error))disconnectedBlock;
                                    

/**
 *  通过配置扫描外设
 *
 *  @param serviceUUIDs 外设UUIDs
 *  @param options      选项设置
 *  @param handler handler
 */
- (void)startScanForPeripheralsWithServices:(nullable NSArray<CBUUID *> *)serviceUUIDs
                                    options:(nullable NSDictionary<NSString *, id> *)options
                                 completionHandler:(void(^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))handler;

- (void)stopScan;

/**
 *  连接外设
 *
 *  @param peripheral 外设对象
 *  @param options    选项设置
 *  @param handler handler
 */
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                  options:(nullable NSDictionary<NSString *, id> *)options
               compeletionHandler:(void(^)(CBPeripheral *peripheral, NSError *error))handler;

/**
 *  发现service
 *
 *  @param serviceUUIDs serviceUUIDs
 *  @param peripheral peripheral
 *  @param handler handler
 */
- (void)discoverServices:(nullable NSArray<CBUUID *>* )serviceUUIDs
            inPeripheral:(nonnull CBPeripheral *)peripheral
              compeletionHandler:(void(^)(CBPeripheral *peripheral,NSError *error))handler;


/**
 *  发现Character
 *
 *  @param characteristicUUIDs characteristicUUIDs
 *  @param service service
 *  @param peripheral peripheral
 *  @param handler handler
 */
- (void)discoverCharacteristics:(nullable NSArray<CBUUID *> *)characteristicUUIDs
                     forService:(nonnull CBService *)service
                   inPeripheral:(nonnull CBPeripheral *)peripheral
                     compeletionHandler:(void(^)(CBPeripheral *peripheral,CBService *service,NSError *error))handler;


/**
 *  发现秒速
 *
 *  @param characticUUID characticUUID
 *  @param peripheral peripheral
 *  @param handler handler
 */
- (void)discoverDescriptorsForCharacteristic:(nonnull CBUUID *)characticUUID
                                inPeripheral:(CBPeripheral *)peripheral
                          compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *forCharactic,NSError *error))handler;

/**
 *  连接外设
 *
 *  @param peripheral peripheral
 */
- (void)disConnectPeripheral:(nonnull CBPeripheral *)peripheral;


/**
 *  向外设chist写数据
 *
 *  @param peripheral peripheral
 *  @param characteristicUUID characteristicUUID
 *  @param value value
 *  @param handler handler
 */
-(void)writeToPeripheralWithoutResponse:(nonnull CBPeripheral *)peripheral
                         characteristic:(nonnull CBUUID *)characteristicUUID
                                  value:(nullable NSData *)value
                     compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *charactic, NSError *error))handler;


//写数据，并监听成功后的回调
-(void)writeToPeripheral:(nonnull CBPeripheral *)peripheral
          characteristic:(nonnull CBUUID *)characteristicUUID
                   value:(nullable NSData *)value
      compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *charactic, NSError *error))handler;

/**
 *  读取chist数据
 *
 *  @param peripheral peripheral
 *  @param characteristicUUID characteristicUUID
 *  @param handler handler
 */
- (void)readToPeripheral:(nonnull CBPeripheral *)peripheral
            characteristic:(nonnull CBUUID *)characteristicUUID
                compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *charactic, NSError *error))handler;


/**
 *  读取chist中descriptor数据
 *
 *  @param peripheral peripheral
 *  @param descriptorUUID descriptorUUID
 *  @param characticUUID characticUUID
 *  @param handler handler
 */
- (void)readToPeripheral:(CBPeripheral *)peripheral
              descriptor:(CBUUID *)descriptorUUID
        inCharacteristic:(CBUUID *)characticUUID
      compeletionHandler:(void (^)(CBPeripheral * _Nonnull, CBDescriptor * _Nonnull, NSError * _Nonnull))handler;


/**
 *  订阅chist
 *
 *  @param peripheral peripheral
 *  @param characteristicUUID characteristicUUID
 *  @param isNotify isNotify
 *  @param handler handler
 */
- (void)notifyToPeripheral:(nonnull CBPeripheral *)peripheral
              characteristic:(nonnull CBUUID *)characteristicUUID
               notifyValue:(BOOL)isNotify
                  compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *chist, NSError *error))handler;

/**
 *  设置订阅通知回调
 *
 *  @param updateBlock updateBlock
 */
- (void)notifyCharacteristicDidUpdateValue:(void(^)(CBPeripheral *peripheral,CBCharacteristic *chist, NSError *error))updateBlock;

/**
 释放蓝牙资源
 */
- (void)clearCentralManager;
- (void)cancelBlock;

@end

NS_ASSUME_NONNULL_END
