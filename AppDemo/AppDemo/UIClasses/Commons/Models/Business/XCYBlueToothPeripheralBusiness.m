//
//  XCYBlueToothPeripheralBusiness.m
//  XCYBlueBox
//
//  Created by XCY on 2017/5/9.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import "XCYBlueToothPeripheralBusiness.h"
#import "XCYBlueToothCentralManager.h"
//#import "XCYUISystemAlertServer.h"

typedef void(^XCYBlueScanPeripheralBlcok)(NSArray<CBPeripheral*> *peripheralList, BOOL isScanSuccess);

@interface XCYBlueToothPeripheralBusiness ()


@property (strong, nonatomic) XCYBlueToothCentralManager *centralManager;
@property (strong, nonatomic) NSMutableArray<CBPeripheral*> *curPeripheralList;

@property (copy, nonatomic) XCYBlueScanPeripheralBlcok scanFinishHandler;

@property (copy, nonatomic) NSString *curMenuFacture;

@end

@implementation XCYBlueToothPeripheralBusiness

- (instancetype)init
{
    if (self = [super init]) {
        
        _curPeripheralList = [[NSMutableArray alloc] initWithCapacity:1];
        _curMenuFacture = @"45515F54455354";
    }
    
    return self;
}

- (void)setMenufacture:(NSString *)facture
{
    _curMenuFacture = facture;
}

-(void)stopScan{
    [self.centralManager stopScan];
}
/**
 查找设备
 
 @param finishedHandler 返回设备列表
 */
- (void)scanForPeripheralsComplectionHandler:(void(^)(NSArray<CBPeripheral*> *peripheralList, BOOL isScanSuccess))finishedHandler
{
    _scanFinishHandler = finishedHandler;
    
    __weak __typeof(self)weakSelf = self;
    [self.centralManager getCentralManagerCompletionHandler:^(CBManagerState state) {
        
        //没有授权
        if (state == CBManagerStateUnauthorized)
        {
            NSString *alertMsg = @"系统没有授权蓝牙音箱使用蓝牙(可能是您设备上的安全工具禁止蓝牙音箱使用蓝牙)";
            [weakSelf p_showAlertWithMsg:alertMsg];
            if (_scanFinishHandler) {
                _scanFinishHandler(nil, NO);
            }
        }
        //蓝牙关闭
        else if (state == CBManagerStatePoweredOff)
        {
            [weakSelf p_showAlertWithMsg:@"您的手机蓝牙未开启，请先开启蓝牙"];
            if (_scanFinishHandler) {
                _scanFinishHandler(nil, NO);
            }
        }
        //蓝牙状态正常
        else
        {
            //开始连接蓝牙设备
            [weakSelf p_startConnectBlueTooth];
        }

    }];
}

#pragma mark - private
- (void)p_startConnectBlueTooth
{
    [_curPeripheralList removeAllObjects];
    [self.centralManager startScanForPeripheralsWithServices:nil options:nil completionHandler:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        TYLog(@"%@",peripheral.name);

        if (![peripheral.name isEqualToString:@"BES_BLE"]) {
            return;
        }
        if (!peripheral && _curPeripheralList.count ==0) {
            
            if (_scanFinishHandler) {
                _scanFinishHandler(_curPeripheralList, YES);
            }
            return ;
        }
        
        if (!peripheral) {
            return ;
        }
        
//        if (![QKUITools isBlankString:_curMenuFacture]) {
//
//            NSData *manufacturerData = [advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey];
//            NSString *dataStr = [NSString stringFromData_cmbc:manufacturerData];
//            dataStr = [dataStr uppercaseString];
//            if ([dataStr rangeOfString:_curMenuFacture].location == NSNotFound) {
//                if (_scanFinishHandler) {
//                    _scanFinishHandler(_curPeripheralList, YES);
//                }
//
//                return;
//            }
//        }
        
        if (![_curPeripheralList containsObject:peripheral]) {
            
            [_curPeripheralList addObject:peripheral];
            if (_scanFinishHandler) {
                _scanFinishHandler(_curPeripheralList, YES);
            }
        }
        
    }];
    
}

- (void)p_showAlertWithMsg:(NSString *)msg
{
//    id<XCYUISystemAlertInterface> alertServer = [XCYUISystemAlertServer initSystemAlert];
//
//    [alertServer showSysAlertTitle:@"提示"
//                               msg:msg
//                 cancelButtonTitle:@"确认"
//                       cancelBlock:nil
//                  otherButtonTitle:nil
//                        otherBlock:nil];
}


#pragma mark - setter or getter
- (XCYBlueToothCentralManager *)centralManager
{
    if (_centralManager) {
        
        return _centralManager;
    }
    
    _centralManager = [XCYBlueToothCentralManager shareInstance];
    return _centralManager;
}

@end
