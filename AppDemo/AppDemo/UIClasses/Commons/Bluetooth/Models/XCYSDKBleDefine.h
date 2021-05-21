//
//  XCYBleDefine.h
//  XCYSdkPackage
//
//  Created by XCY on 16/4/27.
//  Copyright © 2016年 XCY. All rights reserved.
//

#ifndef XCYBleDefine_h
#define XCYBleDefine_h

#import <CoreBluetooth/CoreBluetooth.h>

//中心状态
typedef void (^XCYCentralUpdateStatusResultBlock)(CBManagerState status);
//外设连接
typedef void (^XCYConnectPeripheralResultBlock)(CBPeripheral *peripheral,NSError *error);
//断开外设通知
typedef void (^XCYDisConnectedPeripheralNotifyBlock)(CBPeripheral *peripheral, NSError *error);
//发现外设
typedef void (^XCYDiscoverPeripheralsBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI);
//发现服务
typedef void (^XCYDiscoverServiceResultBlock)(CBPeripheral *peripheral,NSError *error);
//发现特征
typedef void (^XCYDiscoverCharacteristicResultBlock)(CBPeripheral *peripheral,CBService *service,NSError *error);
//发现描述
typedef void (^XCYDiscoverDescriptorsBlock)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error);

//写数据至特征值
typedef void (^XCYWriteValueForCharacteristicResultBlock)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error);

//读特征数据
typedef void (^XCYReadValueForCharacteristicResultBlock)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error);

//读特征描述
typedef void (^XCYReadValueForDescriptorResultBlock)(CBPeripheral *peripheral,CBDescriptor *descriptor,NSError *error);

//订阅特征
typedef void (^XCYSubscribeCharacteristicResultBlock)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error);







#endif /* XCYBleDefine_h */
