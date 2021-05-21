//
//  XCYBleCentralManager.m
//  XCYSdkPackage
//
//  Created by XCY on 16/4/27.
//  Copyright © 2016年 XCY. All rights reserved.
//

#import "XCYSDKBleCentralManager.h"
#import "XCYSDKBleDefine.h"

@interface XCYSDKBleCentralManager()<CBCentralManagerDelegate,CBPeripheralDelegate>


@property (strong, nonatomic)CBCentralManager *centralManager;

@property (strong, nonatomic)NSMutableSet<CBPeripheral *> *connectedPeripherals;

@property (strong, nonatomic)NSMutableSet<CBPeripheral *> *discoverPeripherals;

@property (assign, nonatomic)CBManagerState centralManagerState;

@property (strong, nonatomic)NSTimer    *timeoutTimer;

@property (assign, nonatomic)double  timeout; // The scan timeout defaults to 15 seconds

@property (copy, nonatomic)XCYCentralUpdateStatusResultBlock centralStatusBlock;

@property (copy, nonatomic)XCYDiscoverPeripheralsBlock discoverPeripheralsBlock;

@property (copy, nonatomic)XCYConnectPeripheralResultBlock connectedResultBlock;

@property (copy, nonatomic)XCYDisConnectedPeripheralNotifyBlock disconnectedBlock;

@property (copy, nonatomic)XCYDiscoverServiceResultBlock discoverServicesBlock;

@property (copy, nonatomic)XCYDiscoverCharacteristicResultBlock discoverChisticBlock;

@property (copy, nonatomic)XCYDiscoverDescriptorsBlock          discoverDesBlock;


@property (copy, nonatomic)XCYWriteValueForCharacteristicResultBlock  writeChsticBlock;

@property (copy, nonatomic)XCYReadValueForCharacteristicResultBlock readChsticBlock;

@property (copy, nonatomic)XCYSubscribeCharacteristicResultBlock subscribeBlock;

@property (copy, nonatomic)XCYSubscribeCharacteristicResultBlock subscribeUpdateBlock;

@property (copy, nonatomic)XCYReadValueForDescriptorResultBlock readDescripBlock;


- (void)p_initCentralManager;

- (CBService *)p_findService:(CBUUID *)serviceUUID
                inPeripheral:(CBPeripheral *)peripheral
                   withError:(NSError **)error;

- (CBCharacteristic *)p_findCharacteristic:(CBUUID *)chsticUUID
                              inPeripheral:(CBPeripheral *)peripheral
                                 withError:(NSError **)error;

- (CBDescriptor *)p_findDescriptorInCharacteristic:(CBCharacteristic *)chtic
                                        descriptor:(CBUUID *)desUUID
                                         withError:(NSError **)error;


@end

@implementation XCYSDKBleCentralManager

- (void)dealloc
{

}

- (instancetype)init
{
    if (self = [super init]) {
        _centralManagerState = CBManagerStateUnknown;
        _timeout = 150;
        
    }
    return self;

}

#pragma mark - Connect peripherals/disconnect
- (void)getCentralManagerCompletionHandler:(void(^)(CBManagerState state))handler
{
     _centralStatusBlock = handler;
    
    if (!_centralManager) {
        
        [self p_initCentralManager];
        
    } else {
        // If you already know the status, notify us immediately
        if (_centralManager.state != CBManagerStateUnknown) {
            if (_centralStatusBlock) {
                _centralStatusBlock((CBManagerState)_centralManager.state);
            }
        }
    
    }
   

}


- (void)stopScan
{
    [self.centralManager stopScan];
}

- (void)startScanForPeripheralsWithServices:(nullable NSArray<CBUUID *> *)serviceUUIDs
                                    options:(nullable NSDictionary<NSString *, id> *)options
                          completionHandler:(void(^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))handler
{
    
    self.discoverPeripheralsBlock = handler;
    if (self.centralManager.state==CBManagerStatePoweredOn) {
        [self.centralManager scanForPeripheralsWithServices:serviceUUIDs options:options];

    }

    [self p_startScanTimer];
}


- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                  options:(nullable NSDictionary<NSString *, id> *)options
       compeletionHandler:(void(^)(CBPeripheral *peripheral, NSError *error))handler
{
    [self p_cancelTimer];
    self.connectedResultBlock = handler;
    
    [self.connectedPeripherals addObject:peripheral];
    
    [self.centralManager connectPeripheral:peripheral options:options];
    
    peripheral.delegate = self;
   
    [self.centralManager stopScan];
}

- (void)setDisconnectedNotifyBlock:(void(^)(CBPeripheral *peripheral, NSError *error))disconnectedBlock
{
    self.disconnectedBlock = disconnectedBlock;


}


#pragma mark - find service/chtic/des
- (void)discoverServices:(nullable NSArray<CBUUID *>* )serviceUUIDs
            inPeripheral:(nonnull CBPeripheral *)peripheral
      compeletionHandler:(void(^)(CBPeripheral *peripheral,NSError *error))handler
{
    self.discoverServicesBlock = handler;
    
    [peripheral discoverServices:serviceUUIDs];
}


- (void)discoverCharacteristics:(nullable NSArray<CBUUID *> *)characteristicUUIDs
                     forService:(nonnull CBService *)service
                   inPeripheral:(nonnull CBPeripheral *)peripheral
             compeletionHandler:(void(^)(CBPeripheral *peripheral,CBService *service,NSError *error))handler
{
    self.discoverChisticBlock = handler;
    
    [peripheral discoverCharacteristics:characteristicUUIDs forService:service];

}

- (void)disConnectPeripheral:(nonnull CBPeripheral *)peripheral
{
    [self.centralManager cancelPeripheralConnection:peripheral];
    [self.discoverPeripherals removeObject:peripheral];
    [self.connectedPeripherals removeObject:peripheral];


}


- (void)discoverDescriptorsForCharacteristic:(nonnull CBUUID *)characticUUID
                                inPeripheral:(CBPeripheral *)peripheral
                          compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *forCharactic,NSError *error))handler
{
    self.discoverDesBlock = handler;
    NSError *error;
    CBCharacteristic *targetChtic = [self p_findCharacteristic:characticUUID inPeripheral:peripheral withError:&error];
    if (error) {
        if (_discoverDesBlock) {
            _discoverDesBlock(peripheral,nil,error);
        }
        return;
    }
    
    [peripheral discoverDescriptorsForCharacteristic:targetChtic];
    

}




#pragma mark - Read/write/subscribe data
-(void)writeToPeripheralWithoutResponse:(nonnull CBPeripheral *)peripheral
                         characteristic:(nonnull CBUUID *)characteristicUUID
                                  value:(nullable NSData *)value
                     compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *charactic, NSError *error))handler
{
    self.writeChsticBlock = handler;
    NSError *error;
    CBCharacteristic *targetChtic = [self p_findCharacteristic:characteristicUUID inPeripheral:peripheral withError:&error];
    if (error) {
        if (_writeChsticBlock) {
            _writeChsticBlock(peripheral,nil,error);
        }
        return;
    }
    if (targetChtic.properties & CBCharacteristicPropertyWriteWithoutResponse) {
         [peripheral writeValue:value forCharacteristic:targetChtic type:CBCharacteristicWriteWithoutResponse];
    } else {
    
        NSError *error  = [NSError errorWithDomain:@"writeToPeripheralWithoutResponse，XCYWriteCharacterNoPermissions" code:-2 userInfo:nil];
        if (_writeChsticBlock) {
            _writeChsticBlock(peripheral,nil,error);
        }
    }
   
}

-(void)writeToPeripheral:(nonnull CBPeripheral *)peripheral
          characteristic:(nonnull CBUUID *)characteristicUUID
                   value:(nullable NSData *)value
      compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *charactic, NSError *error))handler
{
    self.writeChsticBlock = handler;
    NSError *error;
    CBCharacteristic *targetChtic = [self p_findCharacteristic:characteristicUUID inPeripheral:peripheral withError:&error];
    if (error) {
        if (_writeChsticBlock) {
            _writeChsticBlock(peripheral,nil,error);
        }
        return;
    }
    
    CBCharacteristicWriteType type = CBCharacteristicWriteWithoutResponse;
    if (targetChtic.properties & CBCharacteristicPropertyWrite) {
        
        type = CBCharacteristicWriteWithResponse;
    }
    
    [peripheral writeValue:value forCharacteristic:targetChtic type:type];
}


- (void)readToPeripheral:(nonnull CBPeripheral *)peripheral
          characteristic:(nonnull CBUUID *)characteristicUUID
      compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *charatic, NSError *error))handler
{
    self.readChsticBlock = handler;
    
    NSError *error;
    CBCharacteristic *targetChtic = [self p_findCharacteristic:characteristicUUID inPeripheral:peripheral withError:&error];
    if (error) {
        if (_readChsticBlock) {
            _readChsticBlock(peripheral,nil,error);
        }
        return;
    }
    
    
    
    if (targetChtic.properties & CBCharacteristicPropertyRead) {
        [peripheral readValueForCharacteristic:targetChtic];
    }else {
        
        NSError *error  = [NSError errorWithDomain:@"XCYReadCharacterNoPermissions" code:-2 userInfo:nil];
        if (_readChsticBlock) {
            _readChsticBlock(peripheral,nil,error);
        }
    }
    

}

- (void)readToPeripheral:(CBPeripheral *)peripheral
              descriptor:(CBUUID *)descriptorUUID
        inCharacteristic:(CBUUID *)characticUUID
      compeletionHandler:(void (^)(CBPeripheral * _Nonnull, CBDescriptor * _Nonnull, NSError * _Nonnull))handler
{
    self.readDescripBlock = handler;
    NSError *error;
    CBCharacteristic *targetChtic = [self p_findCharacteristic:characticUUID inPeripheral:peripheral withError:&error];
    if (error) {
        if (_readDescripBlock) {
            _readDescripBlock(peripheral,nil,error);
        }
        return;
    }
    
    CBDescriptor *targetDesc = [self p_findDescriptorInCharacteristic:targetChtic descriptor:descriptorUUID withError:&error];
    
    [peripheral readValueForDescriptor:targetDesc];
    
    
    

}


- (void)notifyToPeripheral:(nonnull CBPeripheral *)peripheral
            characteristic:(nonnull CBUUID *)characteristicUUID
               notifyValue:(BOOL)isNotify
        compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *ctic, NSError *error))handler
{
    self.subscribeBlock = handler;
    
    NSError *error;
    CBCharacteristic *targetChtic = [self p_findCharacteristic:characteristicUUID inPeripheral:peripheral withError:&error];
    if (error) {
        if (_subscribeBlock) {
            _subscribeBlock(peripheral,nil,error);
        }
        return;
    }
    
    
    if (targetChtic.properties & CBCharacteristicPropertyNotify) {
         [peripheral setNotifyValue:isNotify forCharacteristic:targetChtic];
    } else {
    
        NSLog(@"Properties cannot be subscribed to");
    }
}

- (void)notifyCharacteristicDidUpdateValue:(void(^)(CBPeripheral *peripheral,CBCharacteristic *chist, NSError *error))updateBlock;
{
    self.subscribeUpdateBlock = updateBlock;

}

- (void)clearCentralManager
{
    _centralManager.delegate = nil;

    // disconnect
    for (CBPeripheral *peropheral in _connectedPeripherals) {
        
        [self.centralManager cancelPeripheralConnection:peropheral];
    }
    self.centralManager = nil;
}

- (void)cancelBlock
{
    self.centralStatusBlock = nil;
}

#pragma mark - Connect the peripheral agent callback（CBCentralManagerDelegate）
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict{
    
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    CBManagerState state = (CBManagerState)central.state;
    _centralManagerState = state;
    if (state == CBManagerStatePoweredOn) {
//        commonFunction.showLog(@"centralManagerDidUpdateState:error %ld",(long)state);
        SaiContext.bluetoothBool = YES;
    }else{
        SaiContext.bluetoothBool = NO;
    }
    
    if (_centralStatusBlock) {
        _centralStatusBlock(state);
    }

}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *, id> *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@"Find equipment%@",advertisementData);
    [self.discoverPeripherals addObject:peripheral];
    if (_discoverPeripheralsBlock) {
        
         _discoverPeripheralsBlock(central,peripheral,advertisementData,RSSI);
    }

}

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    [self.connectedPeripherals addObject:peripheral];
    if (_connectedResultBlock) {
        _connectedResultBlock(peripheral,nil);
    }

}


- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                 error:(nullable NSError *)error
{
    if (_connectedResultBlock) {
        _connectedResultBlock(peripheral,error);
    }
    [self.discoverPeripherals removeObject:peripheral];
}


- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(nullable NSError *)error
{
    [self.discoverPeripherals removeObject:peripheral];
    [self.connectedPeripherals removeObject:peripheral];
    
    if (_disconnectedBlock) {
        _disconnectedBlock(peripheral,error);
    }
    
    
}

#pragma mark - Operation peripheral agent callback（CBPeripheralDelegate）
#pragma mark - Found that operation
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    if (_discoverServicesBlock) {
        _discoverServicesBlock(peripheral,error);
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
             error:(nullable NSError *)error
{
    if (_discoverChisticBlock) {
        _discoverChisticBlock(peripheral,service,error);
    }
}


- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic
             error:(nullable NSError *)error
{
    if (_discoverDesBlock) {
        _discoverDesBlock(peripheral,characteristic,error);
    }
}


#pragma mark -
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(nullable NSError *)error
{
    
    if (_subscribeUpdateBlock && (characteristic.properties & CBCharacteristicPropertyNotify)){
        _subscribeUpdateBlock(peripheral,characteristic,error);
        return;
    }
    
    if (_readChsticBlock && (characteristic.properties & CBCharacteristicPropertyRead)) {
        _readChsticBlock(peripheral,characteristic,error);
    }
    
    
}

- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForDescriptor:(CBDescriptor *)descriptor
             error:(nullable NSError *)error
{
    if (_readDescripBlock) {
        _readDescripBlock(peripheral,descriptor,error);
    }


}

- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(nullable NSError *)error
{
    if (_subscribeBlock) {
        _subscribeBlock(peripheral,nil,error);
        _subscribeBlock = nil;
    }

}

#pragma mark -
 - (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
              error:(nullable NSError *)error
{
    if (_writeChsticBlock) {
        _writeChsticBlock(peripheral,characteristic,error);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForDescriptor:(CBDescriptor *)descriptor
             error:(nullable NSError *)error
{




}

#pragma mark - Privated Method
- (void)p_initCentralManager
{
#if  __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_6_0
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey,
                             @"XCYBluetoothRestore1",CBCentralManagerOptionRestoreIdentifierKey,
                             nil];
    
#else
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey,
                             nil];
#endif
    
    NSArray *backgroundModes = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"UIBackgroundModes"];
    if ([backgroundModes containsObject:@"bluetooth-central"]) {
        // The background model
        self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:options];
    }
    else {
        // Non-background mode
        self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
}

- (CBService *)p_findService:(CBUUID *)serviceUUID
                inPeripheral:(CBPeripheral *)peripheral
                   withError:(NSError **)error
{
    CBService *findService = nil;
    if (peripheral.services.count > 0) {
        NSArray<CBService *> *services = peripheral.services;
        for (CBService *service in services) {
            if ([service.UUID.UUIDString isEqualToString:serviceUUID.UUIDString]) {
                findService = service;
                break;
            }
        }
    }
    
    if (!findService && error) {
        *error = [NSError errorWithDomain:@"XCYNotFindService" code:-1 userInfo:nil];
    }
    return findService;

}


- (CBCharacteristic *)p_findCharacteristic:(CBUUID *)chsticUUID
                              inPeripheral:(CBPeripheral *)peripheral
                                 withError:(NSError **)error
{
    CBCharacteristic *findCharactic = nil;
    if (peripheral.services.count > 0) {
        
        NSArray<CBService *> *services = peripheral.services;
        for (CBService *service in services) {
            NSArray<CBCharacteristic *> *characters = service.characteristics;
            for (CBCharacteristic *chst in characters) {
                if ([chst.UUID.UUIDString isEqualToString:chsticUUID.UUIDString]) {
                    findCharactic = chst;
                    break;
                }
            }
            
        }
    }
    
    if (!findCharactic && error) {
        *error = [NSError errorWithDomain:@"XCYNotFindCharatic" code:-2 userInfo:nil];
    }

    return findCharactic;

}

- (CBDescriptor *)p_findDescriptorInCharacteristic:(CBCharacteristic *)chtic
                                        descriptor:(CBUUID *)desUUID
                                         withError:(NSError **)error
{
    NSArray<CBDescriptor *> *descriptors = chtic.descriptors;
    CBDescriptor *findDescriptor = nil;
    if (descriptors.count > 0) {
        for (CBDescriptor *des in descriptors){
            if ([des.UUID.UUIDString isEqualToString:desUUID.UUIDString]) {
                findDescriptor = des;
                break;
            }
        
        }
    }
    
    if (!findDescriptor && error) {
        *error = [NSError errorWithDomain:@"XCYNotFindDes" code:-3 userInfo:nil];
    }

    return findDescriptor;

}

#pragma mark- Scan timeout
- (void)p_startScanTimer
{
    [self p_cancelTimer];
     self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:_timeout target:self selector:@selector(p_didTimeout) userInfo:nil repeats:NO];
}

- (void)p_cancelTimer
{
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;

}

- (void)p_didTimeout
{
    [self p_cancelTimer];
    if (_discoverPeripheralsBlock) {
        _discoverPeripheralsBlock(_centralManager,nil,nil,nil);
    }
}

#pragma mark - getter/Setter

- (NSMutableSet<CBPeripheral *> *)connectedPeripherals
{
    if (_connectedPeripherals) {
        return _connectedPeripherals;
    }
    _connectedPeripherals = [[NSMutableSet alloc]initWithCapacity:1];
    return _connectedPeripherals;
}

- (NSMutableSet<CBPeripheral *> *)discoverPeripherals
{
    if (_discoverPeripherals) {
        return _discoverPeripherals;
    }
    
    _discoverPeripherals = [[NSMutableSet alloc]initWithCapacity:1];
    return _discoverPeripherals;
}

@end
