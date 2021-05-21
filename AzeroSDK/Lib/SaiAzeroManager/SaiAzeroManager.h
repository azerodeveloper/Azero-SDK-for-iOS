//
//  SaiAzeroManager.h
//  AzeroDemo
//
//  Created by silk on 2020/4/1.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
typedef enum{
    ModeNormal = 0,
    ModeHeadset    = 1,
    ModeGuide    = 2,
    ModeAnswer      = 3,
}ModeType;
typedef enum{
    ConnectionStatusConnect = 0,
    ConnectionStatusDisConnect    = 1,
    ConnectionStatusPENDING =2,
    
}ConnectionStatus;
typedef enum{
    ButtonTypePLAY = 0,
    ButtonTypePAUSE    = 1,
    ButtonTypeNEXT    = 2,
    ButtonTypePREVIOUS      = 3,
    ButtonTypeSKIP_FORWARD      = 4,
    ButtonTypeEXIT      = 5,
}ButtonType;

typedef enum {
    SongCycleModeSingle,
    SongCycleModeOrder,
    SongCycleModeRandom
}SongCycleMode;

typedef NS_ENUM(NSUInteger, SaiAppLoggerLevel) {
    SaiVERBOSE,
    SaiINFO,
    SaiMETRIC,
    SaiWARN,
    SaiERROR,
    SaiCRITICAL
};


typedef void(^azeroManagerPreparePlayTtsBlock)(void);
typedef void(^azeroManagerPreparePlaySongUrlBlock)(NSString *songUrl);
typedef void(^azeroManagerSongListInfoBlock)(NSString *songListStr) ;
typedef void(^azeroManagerRenderTemplateBlock)(NSString *renderTemplateStr) ;
typedef void(^azeroManagerExpressBlock)(NSString *type,NSString *content) ;
typedef void(^azeroManagerVadStartBlock)(void);
typedef void(^azeroManagerVadStopBlock)(void);
typedef void(^azeroManagerConnectionStatusBlock)(ConnectionStatus status);
typedef void(^azeroManagerConnectionStatusBlock)(ConnectionStatus status);
typedef void(^azeroManagerTtsPlayComplete)(void);
typedef void(^azeroManagerRecordCallBackBlock)(NSDictionary *dict);

@interface SaiAzeroManager : NSObject
singleton_h(AzeroManager);
//歌曲的循环模式
@property(nonatomic,assign) SongCycleMode songMode;
//本地音量
@property(nonatomic,assign)int  volumeNum;
@property(nonatomic,strong)NSString *renderTemplateStr;
@property(nonatomic,strong)NSString *songListStr;
@property(nonatomic,strong)NSString *alert_token;

//初始化SDK
- (void)setUpAzeroSDK;
//将音频Data传入SDK
- (void)saiAzeroManagerWriteData:(NSData *)data;
//SDK返回音频数据data
- (ssize_t)saiAzeroManagerReadDataWith:(char*)buffer andSize:(size_t)bufferSize;
//判断manager数据是否读取完成
- (bool)saiAzeroManagerReadDataComplete;
//状态上报 - TTS播放
- (void)saiAzeroManagerReportTtsPlayStateStart;
//状态上报 - Mp3播放
- (void)saiAzeroManagerReportMp3PlayStateStart;
//状态上报 - TTS停止
- (void)saiAzeroManagerReportTtsPlayStateStop;
//状态上报 - Mp3播放停止
- (void)saiAzeroManagerReportMp3PlayStateStop;
//状态上报 - TTS播放完成
- (void)saiAzeroManagerReportTtsPlayStateFinished;
//状态上报 - Mp3播放完成
- (void)saiAzeroManagerReportMp3PlayStateFinished;
//状态上报 - Mp3播放错误
- (void)saiAzeroManagerReportMp3PlayStateError;
//发送文字
- (void)saiAzeroManagerSentTxet:(NSString *)text;
//准备播放tts
- (void)saiAzeroPlayTtsStatePrepare:(azeroManagerPreparePlayTtsBlock)azeroPreparePlayTts;
//云端返回的歌曲url
- (void)saiAzeroPlaySongUrl:(azeroManagerPreparePlaySongUrlBlock)azeroPlaySongUrl;
//云端返回的歌曲列表
- (void)saiAzeroSongListInfo:(azeroManagerSongListInfoBlock)azeroSongListInfo;
//云端返回的模板信息
- (void)saiAzeroManagerRenderTemplate:(azeroManagerRenderTemplateBlock)azeroManagerRenderTemplate;
//云端返回的信息
- (void)saiAzeroManagerExpress:(azeroManagerExpressBlock)azeroManagerExpress;
//vad-start
- (void)saiAzeroManagerVadStart:(azeroManagerVadStartBlock)vadStart;
//vad-end
- (void)saiAzeroManagerVadStop:(azeroManagerVadStopBlock)vadStop;
//退出SDK
- (void)saiLogoutAzeroSDK;
//开始上传通讯录
- (BOOL)saiAddContactsBegin;
//结束上传通讯录
- (BOOL)saiAddContactsEnd;
//上传通讯录
- (BOOL)saiAddContact:(NSString *)contact;
//查询通讯录
- (NSString *)saiQueryContact;
//sdk的链接状态发生变化的回调
- (void)saiSDKConnectionStatusChangedWithStatus:(azeroManagerConnectionStatusBlock )connectionStatus;
//设置播放模式
- (void)managerSetSongCycleMode:(SongCycleMode)mode;
//切换模式
- (void)saiAzeroManagerSwitchMode:(ModeType )localeMode andValue:(BOOL )value;
//按钮的点击事件
- (void)saiAzeroButtonPressed:(ButtonType)button;
//移除闹钟
- (void)saiAzeroManagerRemoveAlert:(NSString *)alert_token;
//移除所有闹钟
- (void)saiAzeroManagerRemoveAllAlert;
//状态上报 - 闹钟播放完成
- (void)saiAzeroManagerReportAlertPlayStateFinished;
//上报系统音量
- (void)reportSystemCurrentVolume:(int )volume;
//上传日志
- (void)saiUpdateMessageWithLevel:(SaiAppLoggerLevel )level tag:(NSString *)tag messmage:(NSString *)message;















#pragma mark -   已下方法暂时用不到
- (void)saiAzeroManagerUploadRunWithCalorie:(NSNumber * )calorie andDistance:(NSNumber * )distance
andDuration:(NSNumber * )duration andStartTime:(NSNumber * )startTime andEndTime:(NSNumber * )endTime;
- (void)saiAzeroManagerUploadWalkSensorDataWithCalorie:(NSNumber * )calorie andDistance:(NSNumber * )distance andStepCount:(NSNumber * )stepCount;
-(void )saiAzeroManagerAzeroModelAcquireType:(NSString * )acquireType contentId:(NSString *)contentId  count:(int )count;



@end

