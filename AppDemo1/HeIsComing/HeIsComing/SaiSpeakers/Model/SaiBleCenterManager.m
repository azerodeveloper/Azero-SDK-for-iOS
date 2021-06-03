//
//  SaiBleCenterManager.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/27.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "SaiBleCenterManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "SaiAlertView.h"

@interface SaiBleCenterManager()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (nonatomic ,strong) CBCentralManager *centerManager;
@property (nonatomic ,strong) CBCharacteristic *characteristic;
@property (nonatomic ,strong) NSTimer *timer; 
@property (nonatomic ,strong) CBPeripheral *peripheral;
@end
@implementation SaiBleCenterManager
#pragma mark ------ CustomMethods 
- (void)setup{
    if (!self.centerManager) {
        self.centerManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
}
- (void)destructionCenter{
    if (self.centerManager) {
        self.centerManager = nil;
    }
}
- (void)readValue{
    [self.peripheral readValueForCharacteristic:self.characteristic];
}
- (void)updateValue:(NSData *)data{
    if (self.characteristic != nil) {
        [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
}
#pragma mark ------ CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBManagerStateUnknown:
            break;
        case CBManagerStateResetting:
            break;
        case CBManagerStateUnsupported:
            break;
        case CBManagerStateUnauthorized:
            [SaiNotificationCenter postNotificationName:SaiBlueToothUnauthorized object:nil];
            break;
        case CBManagerStatePoweredOff:
            [SaiNotificationCenter postNotificationName:SaiBlueToothOff object:nil];
            break;
        case CBManagerStatePoweredOn:
            [SaiNotificationCenter postNotificationName:SaiBlueToothOn object:nil];
            [self.centerManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"180A"]] options:nil];//声智科技
//            [self.centerManager scanForPeripheralsWithServices:nil options:nil];//小样听听
            break;
        default:
            break;
    }
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    if (peripheral==nil||peripheral.identifier==nil) {
        return;
    }
    NSString *kCBAdvDataLocalName = advertisementData[@"kCBAdvDataLocalName"];
    TYLog(@"methods:didDiscoverPeripheral \n central:%@ \n peripheral:%@ \n advertisementData:%@ \n RSSI:%@",central,peripheral,advertisementData,RSSI);
    if ([kCBAdvDataLocalName rangeOfString:self.peripheralsName].location !=NSNotFound && kCBAdvDataLocalName != nil) {
        if (self.peripheralBlock) {
            self.peripheralBlock(peripheral,advertisementData);
        }
    }
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    TYLog(@"methods:didConnectPeripheral \n central:%@ \n peripheral:%@",central,peripheral);
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    [self.centerManager stopScan];
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    TYLog(@"methods:didFailToConnectPeripheral \n central:%@ \n peripheral:%@ \n error:%@",central,peripheral,error);
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    TYLog(@"methods:didDisconnectPeripheral \n central:%@ \n peripheral:%@ \n error:%@",central,peripheral,error);
    [SaiNotificationCenter postNotificationName:SaiDisconnectPeripheral object:nil];
}
#pragma mark ------ CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error{
    TYLog(@"methods:didDiscoverServices \n peripheral:%@ \n error:%@",peripheral,error);
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    TYLog(@"methods:didDiscoverCharacteristicsForService \n peripheral:%@ \n service:%@ \n error:%@",peripheral,service,error);
    for (CBCharacteristic *cha in service.characteristics) {
        if(cha.properties & CBCharacteristicPropertyWrite && cha.properties & CBCharacteristicPropertyRead){
            self.characteristic = cha;
        }
        [peripheral discoverDescriptorsForCharacteristic:cha];
        [peripheral readValueForCharacteristic:cha];
        if (self.connectBlock) {
            self.connectBlock();
        }
    }
    if (self.characteristic){
        [self.peripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    TYLog(@"methods:didDiscoverDescriptorsForCharacteristic \n peripheral:%@ \n characteristic:%@ \n error:%@",peripheral,characteristic,error);
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
  
    NSString *tmpStr = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    if ([tmpStr localizedStandardContainsString:@"&"]) {
        NSDictionary *dict = @{@"SaiSettingNetworkingSuccess":tmpStr};
        [SaiNotificationCenter postNotificationName:SaiSettingNetworkingSuccess object:nil userInfo:dict];
    }else if ([tmpStr isEqualToString:@"errorcode=1"]){//配网成功，获取code失败
        [SaiNotificationCenter postNotificationName:SaiFailedObtainInformation object:nil];
    }else if ([tmpStr isEqualToString:@"errorcode=2"]){//配网失败，
        [SaiNotificationCenter postNotificationName:SaiSettingNetworkingFailure object:nil];
    }
//    TYLog(@"didUpdateValueForCharacteristic的Value : %@",tmpStr);
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    TYLog(@"methods:didWriteValueForCharacteristic \n peripheral:%@ \n characteristic:%@ \n error:%@",peripheral,characteristic,error);
  
}
- (void)connectPeripheralWith:(CBPeripheral *)peripheral{
    self.peripheral = peripheral;
    [self.centerManager connectPeripheral:peripheral options:nil];
}
- (void)cancelPeripheralConnection{
    if (self.peripheral!=nil) {
        [self.centerManager cancelPeripheralConnection:self.peripheral];
    }
}

#pragma mark ------ 单例
singleton_m(SaiBleCenterManager);
@end

