//
//  CoreBluetoothManager.m
//  DMRentEnterprise
//
//  Created by Jone on 01/12/2016.
//  Copyright © 2016 Jone. All rights reserved.
//

#import "CoreBluetoothManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface CoreBluetoothManager()<CBCentralManagerDelegate, CBPeripheralDelegate,CBPeripheralManagerDelegate> {
    NSMutableArray *_peripheralsList;
}

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong)CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong)CBCharacteristic *notifyCharacteristic;

@end

@implementation CoreBluetoothManager
singleton_m(CoreBluetoothManager);
//-(instancetype)init{
//    self=[super init];
//    if (self) {
//
//    }
//    return self;
//}
-(void)setUp{
    if (!self.centralManager) {
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey,
//                             @"XCYBluetoothRestore",CBCentralManagerOptionRestoreIdentifierKey,
//                             nil];
//
//    NSArray *backgroundModes = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"UIBackgroundModes"];
//    if ([backgroundModes containsObject:@"bluetooth-central"]) {
//        // The background model
//        self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:options];
//    }
//    else {
        self.centralManager=[[CBCentralManager alloc]initWithDelegate:self queue:nil];
//    }
    }
}

- (void)scanForPeripherals{
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

#pragma  mark 发送命令
-(void)getHeadsetBattery  {
    [self.peripheral writeValue:[@"POWER_QUERY" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void)getHeadsetModel  {
    [self.peripheral writeValue:[@"ANC_MODE_QUERY" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}
-(void)getVersionModel  {
    [self.peripheral writeValue:[@"VERSION_QUERY" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}
///ANC_MODE_NC
//ANC_MODE_OFF
//ANC_MODE_TT
-(void)setHeadsetModel:(NSString *)headsetModel  {
    [self.peripheral writeValue:[headsetModel dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}
-(void)getdata{}
#pragma mark - CBCentralManagerDelegate
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict{
    
}
// 在 cetral 的状态变为 CBManagerStatePoweredOn 的时候开始扫描
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBManagerStatePoweredOn) {
//        CBUUID *seriveUUID = [CBUUID UUIDWithString:@"8CE255C0-201A-11F0-AC64-0800200C9270"];
       [self.centralManager scanForPeripheralsWithServices:nil options:nil];
//        [self.centralManager scanForPeripheralsWithServices:@[seriveUUID] options:nil];
        SaiContext.bluetoothBool = YES;
    }else{
        SaiContext.bluetoothBool = NO;
       TYLog(@"%ld",(long)central.state);
    }
}
//Privacy - Bluetooth Always Usage Description
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
//    if (![QKUITools isSaiHeadsetNeedBle]) {
//        [self.centralManager stopScan];
//        return;
//    }

    if (!peripheral.name) return; // Ingore name is nil peripheral.
    TYLog(@"%@-*-%@",peripheral.name,advertisementData);

    if (![_peripheralsList containsObject:peripheral]) {
        [_peripheralsList addObject:peripheral];
        _peripherals = _peripheralsList.copy;
    }

    if ([peripheral.name isEqualToString:@"BES_BLE"]||[peripheral.name isEqualToString:@"BUDS_BLE"]) {
        self.peripheral = peripheral;
        TYLog(@"%@",peripheral.name);
        self.peripheral.delegate = self;
        [self.centralManager stopScan];
        switch (self.peripheral.state) {
            case CBPeripheralStateDisconnected:
                [self.centralManager connectPeripheral:self.peripheral options:nil];
                break;
            default:{
                [self.centralManager cancelPeripheralConnection:peripheral];
                [self.centralManager connectPeripheral:self.peripheral options:nil];
            }
                break;
        }
        // 在某个地方停止扫描并连接至周边设备
    }else if ([peripheral.name isEqualToString:@"SoundAI TA Buds  BLe"]){
        [MessageAlertView showHudMessage:@"暂不支持此设备"];
    }

}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    if ([peripheral.name isEqualToString:@"BUDS_BLE"]) {
        SaiContext.doudouerji = YES;
    }else if ([peripheral.name isEqualToString:@"BES_BLE"]){
        SaiContext.doudouerji = NO;

    }
    
    //     Client to do discover services method...
    CBUUID *seriveUUID = [CBUUID UUIDWithString:@"8CE255C0-201A-11F0-AC64-0800200C9270"];
    TYLog(@"didConnectPeripheral");

    [peripheral discoverServices:@[seriveUUID]];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    TYLog(@"连接失败时候的error ： %@",error);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    TYLog(@"%@",@"didDisconnectPeripheral");

    [self.centralManager connectPeripheral:self.peripheral options:nil];
    
}
-(void)cancelPeripheralConnection{
    if (self.peripheral != nil) {
        [self.centralManager  cancelPeripheralConnection:self.peripheral];
    }
    self.centralManager.delegate=nil;
    [self.centralManager stopScan];
    self.centralManager = nil;
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    CBCentral *central=[CBCentral new ];
    [peripheral setDesiredConnectionLatency:CBPeripheralManagerConnectionLatencyHigh forCentral:central];
}


#pragma mark - CBPeripheralDelegate

// 发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    NSArray *services = peripheral.services;
    for (CBService *service in services) {
        NSLog(@"service.UUID.UUIDString : %@",service.UUID.UUIDString);
        if ([service.UUID.UUIDString isEqualToString:@"8CE255C0-201A-11F0-AC64-0800200C9270"]) {
            CBUUID *writeUUID = [CBUUID UUIDWithString:@"8CE255C0-201A-11F0-AC64-0800200C9272"];
            
            [peripheral discoverCharacteristics:@[writeUUID] forService:service]; // 发现服务
        }
    }
   
}

// 发现特性值
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    if (!error) {
        NSArray *characteristicArray = service.characteristics;
        CBCharacteristic *writeCharacteristic = characteristicArray[0];
        self.writeCharacteristic=writeCharacteristic;
        
        // 通知使能， `YES` enable notification only, `NO` disabel notifications and indications
        [peripheral setNotifyValue:YES forCharacteristic:writeCharacteristic];

        
        [self getHeadsetModel];
        [self getHeadsetBattery];
        [self getVersionModel];
        } else {
        TYLog(@"Discover charactertics Error : %@", error);
    }
}

// 写入成功
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (!error) {
        TYLog(@"Write Success");
    } else {
        TYLog(@"WriteVale Error = %@", error);
    }
}

// 回复
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        TYLog(@"update value error: %@", error);
    } else {

        NSData *responseData = characteristic.value;

       
        
        NSString *string=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        NSArray *array = [string componentsSeparatedByString:@":"];
//        [MessageAlertView showHudMessage:string];
        if (array.count>1) {
            NSString *mark=array[0];
            NSString *value=[NSString stringWithFormat:@"%@",array[1]];
            if ([mark isEqualToString:@"ANC_MODE"]) {
                if (self.headsetModelBlock) {
                    self.headsetModelBlock(value);
                    SaiContext.anc_mode=value;
                }
            }else  if ([mark isEqualToString:@"POWER"]) {
                if (self.headsetBatteryBlock) {
                    self.headsetBatteryBlock(value);
                    SaiContext.power=value;
                }
            }else  if ([mark isEqualToString:@"ACTION"]) {
                if ([value isEqualToString:@"PLAY"]) {
                    [[SaiAzeroManager sharedAzeroManager] saiAzeroButtonPressed:ButtonTypePLAY];

                }else if ([value isEqualToString:@"PAUSE"]){
                    [[SaiAzeroManager sharedAzeroManager] saiAzeroButtonPressed:ButtonTypePAUSE];
                    
                }
                else if ([value isEqualToString:@"NEXT"]){
                    if (self.nextBlock) {
                        self.nextBlock();
                    }
                }else if ([value isEqualToString:@"PREV"]){
                    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"上一首"];
                }
            }else if ([mark isEqualToString:@"VERSION"]){
                SaiContext.version = value;
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
}




@end
