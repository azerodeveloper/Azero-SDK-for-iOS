//
//  SaiAzeroManager.h
//  HeIsComing
//
//  Created by silk on 2020/4/1.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXCTimer.h"

typedef enum{
    ModeNormal = 0,
    ModeHeadset    = 1,
    ModeGuide    = 2,
    ModeAnswer      = 3,
    ModeTranslate   =  4,
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

@interface SaiAzeroManager : NSObject
singleton_h(AzeroManager);
@property (nonatomic ,strong) NSMutableString *promptInformation;
//歌曲的循环模式
@property(nonatomic,assign) SongCycleMode songMode;
//本地音量
@property(nonatomic,assign)int  volumeNum;
@property(nonatomic,assign)BOOL  isNavigation;
@property(nonatomic,strong)NSString *eventString;

@property(nonatomic,strong)NSString *helloWeatherTemplate;
@property(nonatomic,strong)NSString *renderTemplateStr;
@property(nonatomic,strong)NSString *songListStr;
@property(nonatomic,strong)NSString *alert_token;
@property(nonatomic,strong)ZXCCyclesQueueItem *cyclesQueueItem;

@property (copy, nonatomic) void(^locationblock)(NSString *text);


- (void)setUpAzeroSDK;
- (void)saiAzeroManagerWriteData:(NSData *)data;
- (ssize_t)saiAzeroManagerReadDataWith:(char*)buffer andSize:(size_t)bufferSize;
- (bool)saiAzeroManagerReadDataComplete;
//- (void)saiAzeroManagerReportTtsPlayStateStart;
- (void)saiAzeroManagerReportMp3PlayStateStart;
//- (void)saiAzeroManagerReportTtsPlayStateStop;
- (void)saiAzeroManagerReportTtsPlayStateFinished;
- (void)saiAzeroManagerReportMp3PlayStateStop;
- (void)saiAzeroManagerReportMp3PlayStateFinished;
- (void)saiAzeroManagerReportAlertPlayStateFinished;
- (void)saiAzeroManagerReportMp3PlayStateError;

-(void)removeRetransmissionMechanism;
- (void)saiAzeroManagerSentTxet:(NSString *)text;
- (void)saiAzeroManagerSentTtsTxet:(NSString *)text;
- (void)saiAzeroManagerAnswerQuestion:(NSDictionary *)payload;
- (void)saiAzeroPlayTtsStatePrepare:(azeroManagerPreparePlayTtsBlock)azeroPreparePlayTts;
- (void)saiAzeroPlaySongUrl:(azeroManagerPreparePlaySongUrlBlock)azeroPlaySongUrl;
- (void)saiAzeroSongListInfo:(azeroManagerSongListInfoBlock)azeroSongListInfo;
- (void)saiAzeroManagerRenderTemplate:(azeroManagerRenderTemplateBlock)azeroManagerRenderTemplate;
- (void)saiAzeroManagerExpress:(azeroManagerExpressBlock)azeroManagerExpress;
- (void)saiAzeroManagerSwitchMode:(ModeType )localeMode andValue:(BOOL )value;
- (void)saiAzeroManagerVadStart:(azeroManagerVadStartBlock)vadStart;
- (void)saiAzeroManagerVadStop:(azeroManagerVadStopBlock)vadStop;
- (void)saiAzeroManagerAction:(NSString * )action andPosition:(NSString * )position  andResourceId:(NSString * )resourceId;

- (void)saiAzeroManagerAction:(NSString * )action andPosition:(NSString * )position selectedPosition:(NSString * )selectedPosition andResourceId:(NSString * )resourceId andkeyword:(NSString * )keyword;
- (void)saiAzeroManagerAction:(NSString * )action andPosition:(NSString * )position  andResourceId:(NSString * )resourceId acquireType:(NSString *)acquireType;

- (void)saiAzeroManagerUploadRunWithCalorie:(NSNumber * )calorie andDistance:(NSNumber * )distance
andDuration:(NSNumber * )duration andStartTime:(NSNumber * )startTime andEndTime:(NSNumber * )endTime;
-(void )saiAzeroManagerAzeroModelAcquireType:(NSString * )acquireType contentId:(NSString *)contentId  count:(int )count;

- (void)saiAzeroManagerUploadWalkSensorDataWithCalorie:(NSNumber * )calorie andDistance:(NSNumber * )distance andStepCount:(NSNumber * )stepCount;

////navigation
//- (BOOL)saiCancelNavigation;


- (void)saiLogoutAzeroSDK;
- (BOOL)saiAddContactsBegin;
- (BOOL)saiAddContactsEnd;
- (BOOL)saiAddContact:(NSString *)contact;
- (NSString *)saiQueryContact;

- (void)saiSDKConnectionStatusChangedWithStatus:(azeroManagerConnectionStatusBlock )connectionStatus;

- (void)saiAzeroButtonPressed:(ButtonType)button;

- (int )systemCurrentVolume;
- (void)settedSystemCurrentVolume:(int )volume;
- (void)reportSystemCurrentVolume:(int )volume;

//设置播放模式
- (void)managerSetSongCycleMode:(SongCycleMode)mode;

- (void)saiAzeroManagerRemoveAlert:(NSString *)alert_token;

- (void)saiAzeroManagerRemoveAllAlert;


////原始的ser文件
//- (BOOL)saiOriginalSerSet;
////新的ser文件
//- (BOOL)saiNewSerSet;
////重新设置ser文件
//- (BOOL)saiRetSerFile;
//检测和重置ser文件
- (void)detectAndSetSerFile;

//上传日志
- (void)saiUpdateMessageWithLevel:(SaiAppLoggerLevel )level tag:(NSString *)tag messmage:(NSString *)message;


- (void)stopAlarmClock;
@end

