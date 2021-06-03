//
//  SaiBleCenterManager.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/27.
//  Copyright © 2018 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
typedef void(^connectSuccessBlock)(void);
typedef void(^returnDataBlock)(NSString *tokenStr);
typedef void(^returnPeripheralBlock)(CBPeripheral *peripheral,NSDictionary *advertisementData);

@interface SaiBleCenterManager : NSObject
/**
 *  搜索蓝牙时，蓝牙的名称。来判断设备类型。
 */
@property (nonatomic ,copy) NSString *peripheralsName;

@property (nonatomic ,copy) connectSuccessBlock connectBlock;
@property (nonatomic ,copy) returnDataBlock returnBlock;
@property (nonatomic ,copy) returnPeripheralBlock peripheralBlock;



singleton_h(SaiBleCenterManager)
- (void)setup;
- (void)updateValue:(NSData *)data;
- (void)readValue;
- (void)connectPeripheralWith:(CBPeripheral *)peripheral;
- (void)destructionCenter;
- (void)cancelPeripheralConnection;
@end

