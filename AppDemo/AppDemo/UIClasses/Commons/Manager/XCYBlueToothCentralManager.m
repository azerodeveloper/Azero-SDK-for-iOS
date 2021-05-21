//
//  XCYBlueToothCentralManager.m
//  XCYBlueBox
//
//  Created by XCY on 2017/4/7.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import "XCYBlueToothCentralManager.h"
#import "XCYSDKBleOutgoingService.h"
#import "XCYSDKBleDefine.h"
#import "NSString+XCYCoreOperation.h"


typedef void(^CMBCStartConnectBlock)(NSArray<CBPeripheral *> *peripheralList);

@interface XCYBlueToothCentralManager ()

@property (strong, nonatomic) id<XCYSDKBleCentralManagerInterface> centralManager;

@property (strong, nonatomic) NSMutableArray<CBPeripheral*> *curPeripheralList;

@property (copy, nonatomic) CMBCStartConnectBlock serviceConnectFinished;

@property (strong, nonatomic) CBPeripheral *curPeripheral;

@property (copy, nonatomic) NSString *manufacture;

@property (copy, nonatomic)XCYDisConnectedPeripheralNotifyBlock disconnectedBlock;

//判断断开连接时是否显示Alert，默认为YES
@property (assign, nonatomic) BOOL isDisconnectShowAlert;

@end

@implementation XCYBlueToothCentralManager

- (instancetype)init
{
    if (self = [super init]) {
        
        _centralManager = [XCYSDKBleOutgoingService getBleCentralManager];
        _curPeripheralList = [[NSMutableArray alloc] initWithCapacity:1];
        _isDisconnectShowAlert = YES;
    }
    
    return self;
}

+ (instancetype)shareInstance
{
    static XCYBlueToothCentralManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance p_setDisconnectBlock];
    });
    return instance;
}

- (void)clearCentralManager
{
    _isDisconnectShowAlert = YES;
    [_centralManager clearCentralManager];
    [_centralManager cancelBlock];
}

- (void)showAlertAfterDisconnected:(BOOL)isShow
{
    _isDisconnectShowAlert = isShow;
}

- (void)getCentralManagerCompletionHandler:(void(^)(CBManagerState state))handler
{
    [self.centralManager getCentralManagerCompletionHandler:handler];
}

- (void)startScanForPeripheralsWithServices:(nullable NSArray<CBUUID *> *)serviceUUIDs
                                    options:(nullable NSDictionary<NSString *, id> *)options
                          completionHandler:(void(^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))handler
{
    [self.centralManager startScanForPeripheralsWithServices:serviceUUIDs options:options completionHandler:handler];
}

- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                  options:(nullable NSDictionary<NSString *, id> *)options
       compeletionHandler:(void(^)(CBPeripheral *peripheral, NSError *error))handler
{
    _isDisconnectShowAlert = YES;//从连接开始，断开连接默认是需要显示Alert的
    [self.centralManager connectPeripheral:peripheral options:options compeletionHandler:handler];
}

- (void)discoverServices:(NSArray<CBUUID *>* )serviceUUIDs
            inPeripheral:(CBPeripheral *)peripheral
      compeletionHandler:(void(^)(CBPeripheral *peripheral,NSError *error))handler
{
    [self.centralManager discoverServices:serviceUUIDs inPeripheral:peripheral compeletionHandler:handler];
}

- (void)discoverCharacteristics:(NSArray<CBUUID *> *)characteristicUUIDs
                     forService:(CBService *)service
                   inPeripheral:(CBPeripheral *)peripheral
             compeletionHandler:(void(^)(CBPeripheral *peripheral,CBService *service,NSError *error))handler
{
    [self.centralManager discoverCharacteristics:characteristicUUIDs forService:service inPeripheral:peripheral compeletionHandler:handler];
}

/**
 *  设置断开连接回调
 *
 *  @param disconnectedBlock disconnectedBlock
 */
- (void)setDisconnectedNotifyBlock:(void(^)(CBPeripheral *peripheral, NSError *error))disconnectedBlock
{
    self.disconnectedBlock = disconnectedBlock;
}

-(void)writeToPeripheralWithoutResponse:(nonnull CBPeripheral *)peripheral
                         characteristic:(nonnull CBUUID *)characteristicUUID
                                  value:(nullable NSData *)value
                     compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *charactic, NSError *error))handler
{
    [self.centralManager writeToPeripheralWithoutResponse:peripheral characteristic:characteristicUUID value:value compeletionHandler:handler];
}


-(void)writeToPeripheral:(nonnull CBPeripheral *)peripheral
     characteristicsUUID:(CBUUID *)characteristicsUUID
                   value:(nullable NSData *)value
      compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *charactic, NSError *error))handler
{

    [self.centralManager writeToPeripheral:peripheral characteristic:characteristicsUUID value:value compeletionHandler:handler];
    
}

/**
 *  订阅chist
 */
- (void)notifyToPeripheral:(CBPeripheral *)peripheral
            characteristic:(CBUUID *)characteristicUUID
               notifyValue:(BOOL)isNotify
        compeletionHandler:(void(^)(CBPeripheral *peripheral,CBCharacteristic *chist, NSError *error))handler
{
    [self.centralManager notifyToPeripheral:peripheral characteristic:characteristicUUID notifyValue:isNotify compeletionHandler:handler];
}

/**
 *  设置订阅通知回调
 */
- (void)notifyCharacteristicDidUpdateValue:(void(^)(CBPeripheral *peripheral,CBCharacteristic *chist, NSError *error))updateBlock
{
    [self.centralManager notifyCharacteristicDidUpdateValue:updateBlock];
}



/**
 *  取消连接外设
 *
 *  @param peripheral peripheral
 */
- (void)disConnectPeripheral:(nonnull CBPeripheral *)peripheral
{
    _isDisconnectShowAlert = NO;//主动断开连接时，确认为不显示提示
    [self.centralManager disConnectPeripheral:peripheral];
}

- (void)stopScan
{
    [self.centralManager stopScan];
}


- (void)p_setDisconnectBlock
{
    __weak __typeof(self)weakSelf = self;
    [self.centralManager setDisconnectedNotifyBlock:^(CBPeripheral * _Nonnull peripheral, NSError * _Nonnull error) {
       
        if (weakSelf.isDisconnectShowAlert) {
            
            [weakSelf p_showDisconnectAlert];
        }
        
        if (weakSelf.disconnectedBlock) {
            weakSelf.disconnectedBlock(peripheral, error);
            weakSelf.disconnectedBlock=nil;
        }

    }];
}

- (void)p_showDisconnectAlert
{
//    id<XCYUISystemAlertInterface> alertServer = [XCYUISystemAlertServer initSystemAlert];
//    [alertServer showSysAlertTitle:@"提示" msg:@"设备已断开连接！" cancelButtonTitle:@"确定" cancelBlock:^{
//
//        //退出到首页
//        UINavigationController *rootVc = [UIApplication applicationRootViewController_xcy];
//        [rootVc popToRootViewControllerAnimated:YES];
//
//    } otherButtonTitle:nil otherBlock:nil];
}

@end
