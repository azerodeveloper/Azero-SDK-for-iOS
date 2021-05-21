//
//  SaiBlueManager.m
//  HeIsComing
//
//  Created by mike on 2020/11/18.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiBlueManager.h"
#import "XCYBlueToothInHouseFactory.h"
#import "BesUser.h"
#define Randomcodekey (@"randomCodeStr")
#define Randomcodekey_Left (@"randomCodeStr_left")
#define Randomcodekey_Right (@"randomCodeStr_right")

@implementation SaiBlueManager

singleton_m(SaiBlueManager);

-(void)setUp{
#pragma mark 扫描设备
    [self.peripheralBusiness scanForPeripheralsComplectionHandler:^(NSArray<CBPeripheral *> *peripheralList, BOOL isScanSuccess) {
        CBPeripheral *  aPeripheral=peripheralList.firstObject;
        if (!isScanSuccess) {
            
            return ;
        }
        if (_curPeripheral) {
            // Clear the last data
            [self.otaBusiness disConnectPeripheral:aPeripheral notifyBlock:nil];
        }
        
        _curPeripheral = aPeripheral;
        
        [self p_connectPeripheral];
        
        
    }];
    
}
-(void)stopScan{
    [self.peripheralBusiness stopScan];
}
#pragma mark 连接设备

- (void)p_connectPeripheral
{
    
    
    [self.otaBusiness connectPeripheral:_curPeripheral complectionHandler:^(XCYOTAPeripheralType curPeripheralType, BOOL isConnected) {
        
        if (!isConnected) {
            return ;
        }
        
        
        
        if (curPeripheralType == XCYOTAPeripheralType_OTA){
            //OTA模式
            
            [self.otaBusiness notifyToOTAPeripheral:_curPeripheral compeletionHandler:^(CBPeripheral *peripheral, CBCharacteristic *chist, NSError *error) {
                
                if (error) {
                    
                    
                } else {
                    if (self.versionBlock) {
                        self.versionBlock(SaiContext.version);
                    }
                    [self performSelector:@selector(max_getCurrentVersion) withObject:nil afterDelay:0.2];
                }
            }];
        }
        else if (curPeripheralType == XCYOTAPeripheralType_Origin){
            
            //正常模式
        }
        else{
        }
    }];
}

#pragma mark 获取版本
- (void)max_getCurrentVersion
{
    
    NSData *currentVersionData = [self.otaDataSource getCurrentVersion];
    __weak __typeof(self)weakSelf = self;
    
    TYLog(@"max_getCurrentVersion");

    [self.otaBusiness writeToPeripheral:_curPeripheral curPeripheralType:XCYOTAPeripheralType_OTA valueData:currentVersionData complectionHandler:^(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error) {
        
        
        
        NSData *typeData = charactic.value;
        NSString *typeStr = [NSString stringFromData_cmbc1:typeData];
        
        TYLog(@"max_getCurrentVersion%@", typeStr);
        
        
        if ([typeStr containsString:@"8F42455354"]) {
            weakSelf.currentVersionStr = [typeStr substringWithRange:NSMakeRange(@"8F42455354".length, 1)];
            NSString *left_earbud = [typeStr substringWithRange:NSMakeRange(@"8F42455354".length+weakSelf.currentVersionStr.length, 4)];
            NSString *right_earbud = [typeStr substringWithRange:NSMakeRange(@"8F42455354".length+weakSelf.currentVersionStr.length+left_earbud.length, 4)];
            
            left_earbud = [self getNewStringWithPoint:left_earbud];
            right_earbud = [self getNewStringWithPoint:right_earbud];
            
            if ([weakSelf.currentVersionStr isEqualToString:@"0"]) {
                
                // stereo device
                weakSelf.currentVersionType = BESCurrentVersionType_Stereo;
                if (self.versionBlock) {
                    self.versionBlock(left_earbud);
                }
            } else if ([weakSelf.currentVersionStr isEqualToString:@"1"]) {
                
                weakSelf.currentVersionType = BESCurrentVersionType_TWS_Left;
                
            } else if ([weakSelf.currentVersionStr isEqualToString:@"2"]) {
                
                weakSelf.currentVersionType = BESCurrentVersionType_TWS_Right;
                
            } else {
                weakSelf.currentVersionType = BESCurrentVersionType_None;
            }
        } else {
            weakSelf.currentVersionType = BESCurrentVersionType_None;
        }
        
    }];
    
}
#pragma mark 选择固件
- (void)choiceUpgradeFile {
    if (!_curPeripheral) {
        
        return;
    }
    
    
    // 初始化随机码(点击了选择升级按钮即为更改了升级文件)
    NSString *randomCodeStr = @"0000000000000000000000000000000000000000000000000000000000000000";
    [[NSUserDefaults standardUserDefaults] setObject:randomCodeStr forKey:Randomcodekey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:randomCodeStr forKey:Randomcodekey_Left];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:randomCodeStr forKey:Randomcodekey_Right];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.FileSelectSame_Count = 0;
    self.left_breakpoint = @"";
    self.right_breakpoint = @"";
    
    NSArray *array=   [self.fileBusiness getOTAbinFileList];
    TYLog(@"%@",[[LDDownloadManager sharedInstance] downloadFilePathWithUrl:otaUrl]);
    NSString *otaFileString=[[LDDownloadManager sharedInstance] downloadFilePathWithUrl:otaUrl];
    [self userChoiceOTAFile:array.firstObject];
}
//
- (void)userChoiceOTAFile:(NSString *)filePath
{
    
    self.left_curUpgradeFilePath = filePath;
    
    XCYOTASettingDataDo *tASettingDataDo=[XCYOTASettingDataDo new];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self okBtnPressedWithData:tASettingDataDo];
        
    });
}
- (void)okBtnPressedWithData:(XCYOTASettingDataDo *)aData
{
    
    _curSettingData = aData;
    [_curSettingData updateFlashOffsetData:[self.otaDataSource getLastFourSizeDataWithDataName:_left_curUpgradeFilePath]];
    
    [_curSettingData getTotalSettingData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getImageSideWithType:[self.otaDataSource getImageSideWithIndex:4]];
        
    });
    
}
// 开始断点续传
- (void)getImageSideWithType:(NSData *)currentData{
    __weak __typeof(self)weakSelf = self;
    
    
    [self.otaBusiness writeToPeripheral:_curPeripheral curPeripheralType:XCYOTAPeripheralType_OTA valueData:currentData complectionHandler:^(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error) {
        
        NSData *typeData = charactic.value;
        NSString *typeStr = [NSString stringFromData_cmbc:typeData];
        TYLog(@"%@",typeStr);
        
        
        if (typeStr.length == 0) {
            return;
        }
        
        NSString *prefixStr = [typeStr substringWithRange:NSMakeRange(0, 2)];
        NSString *resultStr = [typeStr substringWithRange:NSMakeRange(2, 2)];
        
        if ([prefixStr isEqualToString:@"91"]) {
            if ([resultStr isEqualToString:@"01"]) {
                
                if (self.FileSelectSame_Count == 2) {
                    // 比较两次的breakpoint是否相同&不为0
                    if ([weakSelf.left_breakpoint isEqualToString:weakSelf.right_breakpoint] &&
                        [weakSelf.left_breakpoint isEqualToString:@"00000000"] == NO &&
                        [weakSelf.right_breakpoint isEqualToString:@"00000000"] == NO) {
                        
                        // 006D0900 resuming transmisson 00096d00
                        NSData *data = [weakSelf.left_breakpoint dataFromHexString_xcy];
                        
                        NSUInteger breakPointLength = 0;
                        [data getBytes:&breakPointLength length:4];
                        
                        _value_segment = breakPointLength;
                        _curTotalData = [_curTotalData subdataWithRange:NSMakeRange(breakPointLength, _curTotalData.length - breakPointLength)];
                        
                        
                        [self p_sendOtaDataWithType:XCYOTAUpdateType_New maxLength:[BesUser sharedUser].MTU_Exchange - 1];
                        
                    } else {
                        // 重新开始升级
                        _value_segment = 0;
                        
                        //Start upgrading files
                        [self p_startUpgradeFile];
                    }
                } else {
                    
                    
                    // break point check
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self pointCheck_writeToPeripheral];
                        
                    });
                }
                
            } else {
                // fail
                NSLog(@"getImageSideWithType fail");
            }
        }
    }];
}
- (void)p_startUpgradeFile
{
    
    
    __weak __typeof(self)weakSelf = self;
    //OTA模式
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.otaBusiness notifyToOTAPeripheral:_curPeripheral compeletionHandler:^(CBPeripheral *peripheral, CBCharacteristic *chist, NSError *error) {
            
            [weakSelf p_choiceOtaType];
        }];
    });
  
}
//设置MTU
- (void)p_choiceOtaType
{
    [self handle_curTotalData];
    NSData *chocieData = [self.otaDataSource chocieOTATypeData:_curTotalData];
    
    __weak __typeof(self)weakSelf = self;
    [self.otaBusiness writeToPeripheral:_curPeripheral curPeripheralType:XCYOTAPeripheralType_OTA valueData:chocieData complectionHandler:^(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error) {
        
        NSData *typeData = charactic.value;
        NSString *typeStr = [NSString stringFromData_cmbc:typeData];
        if ([typeStr rangeOfString:@"8142455354"].location == NSNotFound) {
            
            return ;
        }
        
      
        
        NSData *lengthData = [typeData subdataWithRange:NSMakeRange(typeData.length-2, 2)];
        NSUInteger maxLength = 0;
        [lengthData getBytes:&maxLength length:2];
        
        if (maxLength == 0 ||
            maxLength > 509) {
            // Special handling
            // A value of 0 indicates that the MTU exchange failed
            maxLength = 509;
        }
        
        
        [BesUser sharedUser].MTU_Exchange = maxLength;
        
        [weakSelf p_sendOtaDataWithType:XCYOTAUpdateType_New maxLength:(maxLength-1)];
    }];
    
}

- (void)p_sendOtaDataWithType:(XCYOTAUpdateType)atype maxLength:(NSUInteger)length
{
    XCYOTANewUpdateBusiness *business = [[XCYOTANewUpdateBusiness alloc] init];
    
    _updateBusiness = business;
    [_updateBusiness setViewDelegate:self];
    [_updateBusiness initResource];
    [_updateBusiness setSecondLap:self.isSecondLap];
    [_updateBusiness setUpdatePeripheral:_curPeripheral];
    [_updateBusiness setTotalSendData:_curTotalData];
    [_updateBusiness setMaxSendDataLength:length];
    [_updateBusiness setMaxCurrentVersionType:4];
    [_updateBusiness setMaxBreakPointLength:_value_segment];
    [_updateBusiness setOTASettgingData:[_curSettingData getTotalSettingData]];
    [_updateBusiness otaUpdateStart];
}

- (BOOL)handle_curTotalData {
    
    if (!_curPeripheral) {
        
        return NO;
    }
    
    
    /*
     flag = 1 第一次upload
     flag = 2 第二次upload
     */
    if (self.isSecondLap == NO) {
        
        _curTotalData = [self.otaDataSource getDocumentDataWithDataName:_left_curUpgradeFilePath];
    } else {
        
        //        _curTotalData = [self.otaDataSource getDocumentDataWithDataName:_right_curUpgradeFilePath];
    }
    
    if (!_curTotalData) {
        
        return NO;
    }
    
    return YES;
}

- (void)pointCheck_writeToPeripheral{

    
    NSString *key = Randomcodekey;
   
    
    
    NSData *currentData = [self.otaDataSource breakcCheckPoint:_curTotalData type:key];
   
    
    [self.otaBusiness writeToPeripheral:_curPeripheral curPeripheralType:XCYOTAPeripheralType_OTA valueData:currentData complectionHandler:^(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error) {
        
        NSData *typeData = charactic.value;
        NSString *typeStr = [NSString stringFromData_cmbc:typeData];
        NSLog(@"%@", typeStr);
        
        if (typeStr.length == 0) {
            
            return;
        }
        
        NSString *packetTypeStr = [typeStr substringWithRange:NSMakeRange(0, 2)];
        
        
        if ([packetTypeStr isEqualToString:@"8D"]) {
            NSString *breakpointStr = [typeStr substringWithRange:NSMakeRange(2, 8)];
            NSString *randomCodeStr = [typeStr substringWithRange:NSMakeRange(10, 64)];
            
            // check breakpoint
            if ([breakpointStr isEqualToString:@"00000000"]) {
                
                // record the new checkpoint in response firstly,and transmitthe wholeimage
                [[NSUserDefaults standardUserDefaults] setObject:randomCodeStr forKey:Randomcodekey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                _value_segment = 0;
                
                //Start upgrading files
                [self p_startUpgradeFile];
                
                
            } else {
                // 006D0900 resuming transmisson 00096d00
                NSData *data = [breakpointStr dataFromHexString_xcy];
                
                NSUInteger breakPointLength = 0;
                [data getBytes:&breakPointLength length:4];
                
                _value_segment = breakPointLength;
                _curTotalData = [_curTotalData subdataWithRange:NSMakeRange(breakPointLength, _curTotalData.length - breakPointLength)];
                
                NSLog(@"breakPointLength:%f restData:%f", (double)breakPointLength, (double)_curTotalData.length);
                
            }
        }
    }];
}

#pragma mark - XCYOTAUpdateEventDelegate
//写入的数据
- (void)writeInDataInfo:(NSString *)info {
    
}
//返回的进度
- (void)setProgress:(CGFloat)aProgress animated:(BOOL)animate
{
  
    TYLog(@"%f",aProgress);
    if (self.proccessBlock) {
        self.proccessBlock(aProgress);
    }
    
}
//升级成功
- (void)otaUpdateSuccessd:(BOOL)laps
{
   
    if (self.otaUpdateSuccessdBlock) {
        self.otaUpdateSuccessdBlock();
    }
}
-(void)disConnect{
    [self.updateBusiness max_disConnectPeripheral];
    [self stopScan];
}

- (void)otaUpdateFaildWithMsg:(NSString *)errorMsg
{
    
    //+++/改为再次连接
    __weak typeof(self) weakSelf = self;
    [self.otaBusiness disConnectPeripheral:_curPeripheral notifyBlock:^(CBPeripheral *peripheral, NSError *error) {
        [weakSelf.otaBusiness connectPeripheral:self->_curPeripheral complectionHandler:^(XCYOTAPeripheralType curPeripheralType, BOOL isConnected) {
            
            if (!isConnected) {
                return ;
            }
            [weakSelf.otaBusiness notifyToOTAPeripheral:_curPeripheral compeletionHandler:^(CBPeripheral *peripheral, CBCharacteristic *chist, NSError *error) {
                
                if (error) {
                    
                    
                } else {
                    [self getImageSideWithType:[self.otaDataSource getImageSideWithIndex:4]];
                }
            }];
        }];
        
    }];
}
- (NSString *)getNewStringWithPoint:(NSString *)number {
    if (number.length > 0) {
        NSString *doneTitle = @"";
        for (int i = 0; i < number.length; i++) {
            doneTitle = [doneTitle stringByAppendingString:[number substringWithRange:NSMakeRange(i, 1)]];
            
            if (i+1 != number.length) {
                
                doneTitle = [NSString stringWithFormat:@"%@.", doneTitle];
            }
        }
        return doneTitle;
    }
    return number;
}
- (id<XCYBlueToothPeripheralBusinessInterface>)peripheralBusiness
{
    if (_peripheralBusiness) {
        
        return _peripheralBusiness;
    }
    
    _peripheralBusiness = [XCYBlueToothInHouseFactory getPeripheralBusiness];
    return _peripheralBusiness;
}
- (XCYOTABusiness *)otaBusiness
{
    if (_otaBusiness) {
        return _otaBusiness;
    }
    
    _otaBusiness = [[XCYOTABusiness alloc] init];
    
    return _otaBusiness;
}
- (XCYOTADataSource *)otaDataSource
{
    if (_otaDataSource) {
        
        return _otaDataSource;
    }
    
    _otaDataSource = [[XCYOTADataSource alloc] init];
    
    return _otaDataSource;
}
- (XCYOTAFileBusiness *)fileBusiness
{
    if (_fileBusiness) {
        
        return _fileBusiness;
    }
    
    _fileBusiness = [[XCYOTAFileBusiness alloc] init];
    return _fileBusiness;
}

@end
