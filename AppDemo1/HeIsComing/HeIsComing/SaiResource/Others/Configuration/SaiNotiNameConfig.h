//
//  SaiNotiNameConfig.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2019/1/2.
//  Copyright © 2019 soundai. All rights reserved.
//

#ifndef SaiNotiNameConfig_h
#define SaiNotiNameConfig_h
static NSString * const SaiPayload                   = @"SaiPayloadNotification";           //歌曲的列表信息
static NSString * const SaiRegisteredSingleton       = @"SaiRegisteredSingletonNotification";           //歌曲的列表信息
static NSString * const SaiTtsPlayComplete           = @"SaiTtsPlayCompleteNotification";           //歌曲的列表信息
static NSString * const SaiRecordCallback            = @"SaiRecordCallbackNotification";           //歌曲的列表信息
//static NSString * const SaiLoginSuccess              = @"SaiLoginSuccessNotification";           //登录成功
static NSString * const SaiSetHeadsetModeSuccess     = @"SaiSetHeadsetModeSuccessNotification";           //设置headsetmode失败
static NSString * const SaiSetTranslateModeSuccess     = @"SaiSetTranslateModeSuccessNotification";           //设置translate失败


static NSString * const SaiSettingNetworkingSuccess                    = @"SaiSettingNetworkingSuccessNotification";           //配置网络成功
static NSString * const SaiSettingNetworkingFailure                    = @"SaiSettingNetworkingFailureNotification";           //配置网络失败
static NSString * const SaiFailedObtainInformation                     = @"SaiFailedObtainInformationNotification";

//蓝牙状态
static NSString * const SaiBlueToothOn                                 = @"SaiBlueToothOnNotification";                    //蓝牙开启
static NSString * const SaiBlueToothOff                                = @"SaiBlueToothOffNotification";                   //蓝牙关闭
static NSString * const SaiBlueToothUnauthorized                       = @"SaiBlueToothUnauthorizedNotification";                   //未授权 SaiBlueToothUnauthorized
static NSString * const SaiDisconnectPeripheral                        = @"SaiDisconnectPeripheralNotification";

static NSString * const SaiDidBecomeActiveNoti                           = @"SaiDidBecomeActiveNotification";            //程序进入活跃状态

static NSString * const DeviceInformationModifiedSuccessfully          = @"SaiDeviceInformationModifiedSuccessfullyNotification";            //修改设备信息成功
//OTA SaiOTAUpgradeCompleteNoti
static NSString * const SaiOTAUpgradeNoti                              = @"SaiOTAUpgradeNotification";            //OTA升级通知
static NSString * const SaiOTAUpgradeProgressNoti                      = @"SaiOTAUpgradeProgressNotification";            //OTA升级进度
static NSString * const SaiOTAUpgradeCompleteNoti                      = @"SaiOTAUpgradeCompleteNotification";            //OTA升级完成
//static NSString * const SaiGetOTAUpgradeProgressNoti                   = @"SaiGetOTAUpgradeProgressNoti";            //主动获取OTA的更新进度
static NSString * const SaiLogoutSuccessNoti                             = @"SaiLogoutSuccessNotification";        
static NSString * const SaiLoginSuccessNoti                             = @"SaiLoginSuccessNotification";


static NSString * const SaiApplicationWillEnterForeground               = @"SaiApplicationWillEnterForegroundNotification";


typedef enum{
    MediaTypeNews = 0,
    MediaTypeMp3  = 1,
    MediaTypeAudio  = 2,
    MediaTypeTalkShow  = 3,
    MediaTypeSketch  = 4,
    MediaTypeEnglish  = 5
    
}MediaType;

#endif /* SaiNotiNameConfig_h */
