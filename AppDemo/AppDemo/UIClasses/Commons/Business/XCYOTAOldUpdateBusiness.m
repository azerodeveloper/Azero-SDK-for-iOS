//
//  XCYOTAOldUpdateBusiness.m
//  XCYBlueBox
//
//  Created by zhouaitao on 2017/7/18.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import "XCYOTAOldUpdateBusiness.h"
#import "XCYOTABusiness.h"
//#import "XCYUISystemAlertServer.h"


//static NSUInteger SEC_SIZE = 128;

//数据包发送成功
static NSString *XCYSEND_SUCCESS = @"1122";
static NSString *XCYSEND_SUCCESS2 = @"8301";

//数据包发送失败
static NSString *XCYSEDN_FAILED = @"3344";

@interface XCYOTAOldUpdateBusiness ()

@property (strong, nonatomic) XCYOTABusiness *otaBusiness;

@property (weak, nonatomic) id<XCYOTAUpdateEventDelegate> viewDelegate;

//已发送的Data长度
@property (assign, nonatomic) float curIsSendDataLength;
@property (strong, nonatomic) NSData *curTotalSendData;
@property (assign, nonatomic) NSInteger PACKET_NUM;
@property (strong, nonatomic) NSData *lastSendData;//上次发送的数据包，用于传输出错后再次发送
@property (strong, nonatomic) CBPeripheral *curPeripheral;
@property (assign, nonatomic) NSUInteger maxLength;
//是否已发送完成
@property (assign, nonatomic) BOOL bSendFinished;
@property (assign, nonatomic) BOOL isSecondLap;

@property (assign, nonatomic) NSUInteger breakPointLength; // 上次breakPoint长度
@property (assign, nonatomic) NSUInteger currentVersionType;

@end

@implementation XCYOTAOldUpdateBusiness

- (void)initResource
{
    ///<初始化
    _curIsSendDataLength = 0;
    _curTotalSendData = nil;
    _PACKET_NUM = 0;
    _lastSendData = nil;
    _bSendFinished = NO;
    _breakPointLength = 0;
    ///<end
}

- (void)setViewDelegate:(id<XCYOTAUpdateEventDelegate>)aDelegate
{
    _viewDelegate = aDelegate;
}

- (void)setTotalSendData:(NSData *)totalData
{
    _curTotalSendData = totalData;
}

- (void)setOTASettgingData:(NSData *)aData
{

}

- (void)setMaxSendDataLength:(NSUInteger)aMax
{
    _maxLength = aMax;
}

- (void)setMaxBreakPointLength:(NSUInteger)length {
    _breakPointLength = length;
}

- (void)setSecondLap:(BOOL)flag {
    self.isSecondLap = flag; // default is NO
}

- (void)setMaxCurrentVersionType:(NSUInteger)currentVersionType {
    _currentVersionType = currentVersionType;
}

- (void)setUpdatePeripheral:(CBPeripheral *)aPeripheral
{
    _curPeripheral = aPeripheral;
}

- (void)otaUpdateStart
{
    
    [self p_sendSubOTAData];
}

- (void)p_sendSubOTAData
{
    NSData *fullData = [self p_getSubSendData];
    
    [self p_sendOtaUpgradeWithData:fullData];
}

//再次发送上次的数据包
- (void)p_sendLastOTADataAgain
{
    [self p_sendOtaUpgradeWithData:_lastSendData];
}

#pragma mark - private
//发送数据包
- (void)p_sendOtaUpgradeWithData:(NSData *)subData
{
    //最后一次，charactic.value值不会下发
    if (_bSendFinished) {
        __weak __typeof(self)weakSelf = self;

        // by max
        /*
         BesFileSelectViewType_None = 0,
         BesFileSelectViewType_Same,
         BesFileSelectViewType_No_Same,
         BesFileSelectViewType_Left,
         BesFileSelectViewType_Right,
         BesFileSelectViewType_Stereo,
         */
        // 如果是二对二升级，92协议发最后发（保证92只发一次）
        if (_currentVersionType == 2 && self.isSecondLap == NO) {
            
            [self.otaBusiness showAlertAfterDisconnected:NO];//此时断连不提示

            if ([weakSelf.viewDelegate respondsToSelector:@selector(otaUpdateSuccessd:)]) {
                
                [weakSelf.viewDelegate otaUpdateSuccessd:self.isSecondLap];
            }
            return;
        }
        // 旧协议，跳过92
        if (_currentVersionType == 0) {
            
            if ([weakSelf.viewDelegate respondsToSelector:@selector(otaUpdateSuccessd:)]) {
                
                [weakSelf.viewDelegate otaUpdateSuccessd:self.isSecondLap];
            }
            return;
            
        }
        
        [self getImageOverWritingConfirmation];
        return;
    }
    
    if (!_bSendFinished) {
        
        [self p_addTimeoutNotification];
    }
    __weak __typeof(self)weakSelf = self;
    [self.otaBusiness writeToPeripheral:_curPeripheral
                      curPeripheralType:XCYOTAPeripheralType_OTA
                              valueData:subData
                     complectionHandler:^(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error) {
    
         [weakSelf p_removeTimeoutNotification];
         NSData *notiData = charactic.value;
         NSString *notiStr = [NSString stringFromData_cmbc:notiData];
         if ([notiStr isEqualToString:XCYSEND_SUCCESS] ||
             [notiStr isEqualToString:XCYSEND_SUCCESS2]) {
             
             [weakSelf p_sendSubOTAData];
         }
         else if ([notiStr isEqualToString:XCYSEDN_FAILED])
         {
             //再次发送上次的数据包
             [weakSelf p_sendLastOTADataAgain];
         }
         else
         {
             NSString *errorMsg = [NSString stringWithFormat:@"notify接收数据错误，value= %@",notiStr];
             [self p_showAlertWithMsg:errorMsg];
         }
         
     }];
}

// 92数据, 确认最终覆盖 (之前逻辑发送88回复8401, 现在增加了92) by max
- (void)getImageOverWritingConfirmation
{
    NSString *dataStr = @"9242455354";
    NSMutableData *fullData = [[NSMutableData alloc] initWithCapacity:1];
    [fullData appendData:[dataStr dataFromHexString_xcy]];
    
    NSData *currentData = fullData;
    
    [self.otaBusiness writeToPeripheral:_curPeripheral curPeripheralType:XCYOTAPeripheralType_OTA valueData:currentData complectionHandler:^(CBPeripheral *peripheral, CBCharacteristic *charactic, NSError *error) {
        
        NSData *typeData = charactic.value;
        NSString *typeStr = [NSString stringFromData_cmbc:typeData];
        NSLog(@"%@", typeStr);
        
        NSString *prefixStr = [typeStr substringWithRange:NSMakeRange(0, 2)];
        NSString *resultStr = [typeStr substringWithRange:NSMakeRange(2, 2)];
        
        if ([prefixStr isEqualToString:@"93"]) {
            if ([resultStr isEqualToString:@"01"]) {
                // success
                __weak __typeof(self)weakSelf = self;
                [self.otaBusiness showAlertAfterDisconnected:NO];//此时断连不提示
                
                if ([weakSelf.viewDelegate respondsToSelector:@selector(otaUpdateSuccessd:)]) {
                    
                    [weakSelf.viewDelegate otaUpdateSuccessd:self.isSecondLap];
                }
                
            } else {
                // fail
                [_viewDelegate otaUpdateFaildWithMsg:@"升级失败"];
            }
        }
    }];
}

- (void)max_disConnectPeripheral {
    
    __weak __typeof(self)weakSelf = self;
    
    [self.otaBusiness setDisconnectedNotifyBlock:^(CBPeripheral *peripheral, NSError *error) {
        
        [weakSelf.otaBusiness showAlertAfterDisconnected:YES];//此时断连提示
    }];
}

- (NSData *)p_getSubSendData
{
    //设置发送的长度
    float progress = self.curIsSendDataLength/self.curTotalSendData.length;
    if ([_viewDelegate respondsToSelector:@selector(setProgress:animated:)]) {
        
        [_viewDelegate setProgress:progress animated:YES];
    }
    
    //包头
    NSMutableData *headData = [[NSMutableData alloc] initWithCapacity:1];
    
    //    -	PREFIX:  1字节，固定为PREFIX_CHAR = 0xBE
    //    -	TYPE:  1字节，固定为TYPE_BURN_DATA = 0x64
    //    -	PACKET_NUM:  2字节，待发送的包的总和，根据bin文件大小和每个包的大小来计算得到
    //    -	DATA_SIZE:  4字节，payload的长度
    //    -	CRC:  4字节,  对payload进行crc32后得到的CRC值
    //    -	SEQ:  2字节，包的序列号， 范围：0 ~ PACKET_NUM
    //    -	Padding: 1字节，填0
    //    -	CHKSUM:	1字节，为包头中消息CHKSUM字段前所有字节的累加和取反
    
    NSInteger totalNum = 0;
    
    
    //    -	PREFIX:  1字节，固定为PREFIX_CHAR = 0xBE
    NSData *PREFIXData = [@"BE" dataFromHexString_xcy];
    [headData appendData:PREFIXData];
    
    //    -	TYPE:  1字节，固定为TYPE_BURN_DATA = 0x64
    NSData *TYPEData = [@"64" dataFromHexString_xcy];
    [headData appendData:TYPEData];
    
    //    -	PACKET_NUM:  2字节，待发送的包的总和（总个数），根据bin文件大小和每个包的大小来计算得到,SEC_SIZE=256
    NSInteger packetNum = (_curTotalSendData.length+_maxLength - 1)/_maxLength;
    NSData *PACKET_NUM_Data = [NSData dataWithBytes:&packetNum length:2];
    [headData appendData:PACKET_NUM_Data];
    
    NSInteger length = _maxLength;
    NSInteger nextLength = _curIsSendDataLength + length;
    if (nextLength > _curTotalSendData.length) {
        
        length = _curTotalSendData.length - _curIsSendDataLength;
        nextLength = _curTotalSendData.length;
        _bSendFinished = YES;//最后一个包发送完，结束
    }
    
    //    -	DATA_SIZE:  4字节，payload的长度
    NSData *DATA_SIZE_data = [NSData dataWithBytes:&length length:4];
    [headData appendData:DATA_SIZE_data];
    
    NSData *subData = [_curTotalSendData subdataWithRange:NSMakeRange(_curIsSendDataLength, length)];
    _curIsSendDataLength = nextLength;
    
    //    -	CRC:  4字节,  对payload进行crc32后得到的CRC值
    int32_t crc32 = [subData CRC32Value_xcy];
    NSData *crc32Data = [NSData dataWithBytes:&crc32 length:4];
    [headData appendData:crc32Data];
    
    
    //    -	SEQ:  2字节，包的序列号， 范围：0 ~ PACKET_NUM
    NSData *SEQData = [NSData dataWithBytes:&_PACKET_NUM length:2];
    [headData appendData:SEQData];
    
    //    -	Padding: 1字节，填0
    NSInteger Padding = 0;
    NSData *paddingData = [NSData dataWithBytes:&Padding length:1];
    [headData appendData:paddingData];
    
    
    //    -	CHKSUM:	1字节，为包头中消息CHKSUM字段前所有字节的异或后取反
    for (int i = 0; i < headData.length; ++i) {
        
        NSData *data = [headData subdataWithRange:NSMakeRange(i, 1)];
        NSString *intStr = [NSString stringFromData_cmbc:data];
        NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([intStr UTF8String],0,16)];
        int value = [temp10 intValue];
        totalNum ^= value;
    }
    
    //取反
    totalNum = ~totalNum;
    NSData *totalData = [NSData dataWithBytes:&totalNum length:1];
    [headData appendData:totalData];
    
    //全报文
    NSMutableData *fullData = [NSMutableData dataWithData:headData];
    [fullData appendData:subData];
    
    _lastSendData = fullData;
    
    
    ++_PACKET_NUM;
    
    return fullData;
}

- (void)p_showAlertWithMsg:(NSString *)aMsg
{
//    id<XCYUISystemAlertInterface> alert = [XCYUISystemAlertServer initSystemAlert];
//    [alert showSysAlertTitle:@"提示" msg:aMsg cancelButtonTitle:@"确定" cancelBlock:nil otherButtonTitle:nil otherBlock:nil];
}


//在OTA过程中，APP等待回复的超时时间为5秒，超时时间到达还未收到回复，则认为升级失败
- (void)p_addTimeoutNotification
{
    [self performSelector:@selector(p_updatTimeout) withObject:nil afterDelay:5.0];
}

- (void)p_removeTimeoutNotification
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(p_updatTimeout) object:nil];
}

- (void)p_updatTimeout
{
    if ([_viewDelegate respondsToSelector:@selector(otaUpdateFaildWithMsg:)]) {
        
        [_viewDelegate otaUpdateFaildWithMsg:@"数据接收超时，升级失败"];
    }
}


#pragma mark - getter setter
- (XCYOTABusiness *)otaBusiness
{
    if (_otaBusiness) {
        return _otaBusiness;
    }
    
    _otaBusiness = [[XCYOTABusiness alloc] init];
    
    return _otaBusiness;
}

@end
