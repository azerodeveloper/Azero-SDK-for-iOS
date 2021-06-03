//
//  SaiAzeroManager.m
//  HeIsComing
//
//  Created by silk on 2020/4/1.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiAzeroManager.h"  
#import "AudioManager.h"
#import "MyLogger.h"
#import "MyCBL.h"
#import "MySpeechRecognizer.h"
#import "AzeroAudioInput.h"
#import "MyLocalDetectorEventHandler.h"
#import "AzeroLocalSpeechDetector.h"
#import "SaiTtsMediaPlayer.h"
#import "SaiMp3MediaPlayer.h"
//#import "MyAzeroSpeaker.h"
#import "MySpeechSynthesizer.h"
#import "MyAzeroAudioPlayer.h"
#import "MyTemplateRuntime.h"
#import "MyAzeroExpress.h"
#import "AzeroEngine.h"
#import "SaiTextInputModel.h"
#import "AzeroContactUploader.h"
#import "SaiAzeroClient.h"
#import "SaiTtsAzeroSpeaker.h"
#import "SaiMp3AzeroSpeaker.h"
#import "AzeroPlaybackController.h"
#import "SaiPhoneCallController.h"
#import "GKVolumeView.h"
#import "MyAzeroAlerts.h"
#import "SaiMyAzeroModeControl.h"
#import "SaiAlertMediaPlayer.h"
#import "MyAzeroNavigation.h"
#import "MyAzeroLocationProvider.h"

extern void UpdateFileAudioOutputFolderName(const char *folder);
@interface SaiAzeroManager ()
@property (nonatomic ,strong) MyLogger *logger;
@property (nonatomic ,strong) MyCBL *cbl;
@property (nonatomic ,strong) MySpeechRecognizer *speechRecognizer;
@property (nonatomic ,strong) AzeroAudioInput *audioInput;
@property (nonatomic ,strong) MyLocalDetectorEventHandler *localDetector;
@property (nonatomic ,strong) AzeroLocalSpeechDetector *localSpeechDetector;
@property (nonatomic ,strong) SaiTtsMediaPlayer *ttsMediaPlayer;
@property (nonatomic ,strong) SaiMp3MediaPlayer *mp3MediaPlayer;
@property (nonatomic ,strong) SaiAlertMediaPlayer *alertsMediaPlayer;

@property (nonatomic ,strong) SaiTtsAzeroSpeaker *ttsSpeaker;
@property (nonatomic ,strong) SaiMp3AzeroSpeaker *Mp3Speaker;
@property (nonatomic ,strong) MySpeechSynthesizer *speechSynthesizer;
@property (nonatomic ,strong) MyAzeroAudioPlayer *audioPlayer;
@property (nonatomic ,strong) MyTemplateRuntime *templateRuntime;
@property (nonatomic ,strong) MyAzeroExpress *myAzeroExpress;
@property (nonatomic ,strong) AzeroEngine *engine;
@property (nonatomic ,strong) SaiMyAzeroModeControl *myAzeroModeControl;

@property (nonatomic ,strong) MyAzeroAlerts *myAzeroAlerts;
@property (nonatomic ,strong) MyAzeroNavigation *myAzeroNavigation;

@property (nonatomic ,strong) MyAzeroLocationProvider *myLocationProvider;



//block
@property (nonatomic ,copy) azeroManagerPreparePlayTtsBlock azeroManagerPreparePlayTtsHandle;
@property (nonatomic ,copy) azeroManagerPreparePlaySongUrlBlock azeroManagerPreparePlaySongUrlHandle;
@property (nonatomic ,copy) azeroManagerSongListInfoBlock azeroManagerSongListInfoHandle;
@property (nonatomic ,copy) azeroManagerRenderTemplateBlock azeroManagerRenderTemplateHandle;
@property (nonatomic ,copy) azeroManagerExpressBlock azeroManagerExpressHandle;
@property (nonatomic ,copy) azeroManagerVadStartBlock azeroManagerVadStartHandle;
@property (nonatomic ,copy) azeroManagerVadStopBlock azeroManagerVadStopHandle;

@property (nonatomic ,strong) NSLock *writeDataLock;

@property (nonatomic ,strong) AzeroContactUploader *contactUploader;

@property (nonatomic ,strong) SaiAzeroClient *azeroClient;
@property (nonatomic ,copy) azeroManagerConnectionStatusBlock connectionStatusHandle;

@property (nonatomic ,strong) AzeroPlaybackController *PlaybackControl;

@property (nonatomic ,strong) SaiPhoneCallController *phoneCallController;

@property (nonatomic ,strong) GKVolumeView *volumeView;


@end

@implementation SaiAzeroManager  
#pragma mark -  Life Cycle
- (void)dealloc{
    TYLog(@"SaiAzeroManager ----------- dealloc");
}
#pragma mark -  UITableViewDelegate
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Methods
#pragma mark -  Button Callbacks
#pragma mark -  Private Methods
- (void)createFolder:(NSString *)name{
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [docsdir stringByAppendingPathComponent:name];//将需要创建的串拼接到后面
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL dataIsDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    BOOL dataExisted = [fileManager fileExistsAtPath:filePath isDirectory:&dataIsDir];
    if ( !(isDir == YES && existed == YES) ) {//如果文件夹不存在
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (!(dataIsDir == YES && dataExisted == YES) ) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
- (void)copyCertsToDocumentFolder:(NSString *)filePath{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *certs_list[] = {
        @"09789157",
        @"6d41d539",
        @"8cb5ee0f",
        @"b204d74a",
        @"ce5e74ef",
        @"de6d66f3",
        @"f387163d" };
    for (int i = 0; i < sizeof(certs_list)/sizeof(NSString *); ++i) {
        NSString *srcpath = [[NSBundle mainBundle]pathForResource:certs_list[i] ofType:@"0"];
        NSString *dstpath = [NSString stringWithFormat:@"%@/%@.0",filePath,certs_list[i]];
        if ([fileManage fileExistsAtPath:dstpath]) {
            [fileManage removeItemAtPath:dstpath error:nil];
        }
        BOOL isSuccess = [fileManage copyItemAtPath:srcpath toPath:dstpath error:nil];
        TYLog(@"%@%@", dstpath, isSuccess ? @"拷贝成功" : @"拷贝失败");
    }
}
- (void)copyOpenDenoiseFileTxtTo:(NSString *)filePath{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSArray *txtAry = @[@"saires_sai"];
    for (NSString *txtFile in txtAry) {
        NSString *srcpath = [[NSBundle mainBundle]pathForResource:txtFile ofType:@"txt"];
        NSString *dstpath = [NSString stringWithFormat:@"%@/%@.txt",filePath,txtFile];
        if ([fileManage fileExistsAtPath:dstpath]) {
            [fileManage removeItemAtPath:dstpath error:nil];
        }
        BOOL isSuccess = [fileManage copyItemAtPath:srcpath toPath:dstpath error:nil];
        TYLog(@"%@%@", dstpath, isSuccess ? @"拷贝txt成功" : @"拷贝txt失败");
    }
}
- (void)copyOpenDenoiseFileQTo:(NSString *)filePath{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSArray *qAry = @[@"saires0",@"saires1",@"saivad"];
    for (NSString *qFile in qAry) {
        NSString *srcpath = [[NSBundle mainBundle]pathForResource:qFile ofType:@"q"];
        NSString *dstpath = [NSString stringWithFormat:@"%@/%@.q",filePath,qFile];
        if ([fileManage fileExistsAtPath:dstpath]) {
            [fileManage removeItemAtPath:dstpath error:nil];
        }
        BOOL isSuccess = [fileManage copyItemAtPath:srcpath toPath:dstpath error:nil];
        TYLog(@"%@%@", dstpath, isSuccess ? @"拷贝q成功" : @"拷贝q失败");
    }
}
- (void)copyOpenDenoiseFileBinTo:(NSString *)filePath{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *srcpath = [[NSBundle mainBundle]pathForResource:@"wopt_2mic" ofType:@"bin"];
    NSString *dstpath = [NSString stringWithFormat:@"%@/%@.bin",filePath,@"wopt_2mic"];
    if ([fileManage fileExistsAtPath:dstpath]) {
        [fileManage removeItemAtPath:dstpath error:nil];
    }
    BOOL isSuccess = [fileManage copyItemAtPath:srcpath toPath:dstpath error:nil];
    TYLog(@"%@%@", dstpath, isSuccess ? @"拷贝bin成功" : @"拷贝bin失败");
}
- (void)copyOpenDenoiseFileSerTo:(NSString *)filePath{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *srcpath = [[NSBundle mainBundle]pathForResource:@"saipara" ofType:@"ser"];
   
    NSString *dstpath = [NSString stringWithFormat:@"%@/%@.ser",filePath,@"saipara"];
    if ([fileManage fileExistsAtPath:dstpath]) {
        [fileManage removeItemAtPath:dstpath error:nil];
    }
    BOOL isSuccess = [fileManage copyItemAtPath:srcpath toPath:dstpath error:nil];
    TYLog(@"%@%@", dstpath, isSuccess ? @"拷贝ser成功" : @"拷贝ser失败");
}

//原始的ser文件
- (BOOL)saiOriginalSerSet{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *srcpath = [[NSBundle mainBundle]pathForResource:@"saipara" ofType:@"ser"];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *txtDir = [NSString stringWithFormat:@"%@/OpenDenoiseLib",docDir];
    NSString *dstpath = [NSString stringWithFormat:@"%@/%@.ser",txtDir,@"saipara"];
    if ([fileManage fileExistsAtPath:dstpath]) {
        [fileManage removeItemAtPath:dstpath error:nil];
    }
    BOOL isSuccess = [fileManage copyItemAtPath:srcpath toPath:dstpath error:nil];
    TYLog(@"%@%@", dstpath, isSuccess ? @"拷贝ser成功" : @"拷贝ser失败");
    return isSuccess;
}
//新的ser文件
- (BOOL)saiNewSerSet{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *srcpath = [[NSBundle mainBundle]pathForResource:@"saipara1" ofType:@"ser"];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *txtDir = [NSString stringWithFormat:@"%@/OpenDenoiseLib",docDir];
    NSString *dstpath = [NSString stringWithFormat:@"%@/%@.ser",txtDir,@"saipara"];
    if ([fileManage fileExistsAtPath:dstpath]) {
        [fileManage removeItemAtPath:dstpath error:nil];
    }
    BOOL isSuccess = [fileManage copyItemAtPath:srcpath toPath:dstpath error:nil];
    TYLog(@"%@%@", dstpath, isSuccess ? @"拷贝ser成功" : @"拷贝ser失败");
    return isSuccess;
}
- (void)copyOpenDenoiseFileLogTo:(NSString *)filePath{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *srcpath = [[NSBundle mainBundle]pathForResource:@"sai_release_debug_level" ofType:@"txt"];
    NSString *dstpath = [NSString stringWithFormat:@"%@/%@.txt",filePath,@"sai_release_debug_level"];
    if ([fileManage fileExistsAtPath:dstpath]) {
        [fileManage removeItemAtPath:dstpath error:nil];
    }
    BOOL isSuccess = [fileManage copyItemAtPath:srcpath toPath:dstpath error:nil];
    TYLog(@"%@%@", dstpath, isSuccess? @"拷贝ser成功" : @"拷贝ser失败");
}
- (NSDictionary *)readLocalFileWithName:(NSString *)name{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:kNilOptions
                                             error:nil];
    
    
}
- (void)addPrefixPath:(NSDictionary *)dict andContainer:(NSString *)container andPath:(NSString *)path_name andPrefix:(NSString *)prefix{
    NSMutableDictionary *dDbContainer = [NSMutableDictionary dictionaryWithDictionary:dict[container]];
    NSString *path = dDbContainer[path_name];
    NSString *new_path = [NSString stringWithFormat:@"%@/%@",prefix,path];
    [dDbContainer setValue:new_path forKey:path_name];
    [dict setValue:dDbContainer forKey:container];
}


- (void)addLoggerPath:(NSMutableDictionary *)dic  andPath:(NSString *)path{
    NSDictionary *dic0 = dic[@"aace.logger"];
    NSMutableDictionary *mutableDic0 = [NSMutableDictionary dictionaryWithDictionary:dic0];
    NSArray *sinksAry = dic0[@"sinks"];
    NSDictionary *sinksDic = sinksAry[0];
    NSMutableDictionary *mutableSinksDic = [NSMutableDictionary dictionaryWithDictionary:sinksDic];
    NSDictionary *configDic = sinksDic[@"config"];
    NSMutableDictionary *mutableConfigDic = [NSMutableDictionary dictionaryWithDictionary:configDic];
    [mutableConfigDic  setObject:path forKey:@"path"];
    [mutableSinksDic setObject:mutableConfigDic forKey:@"config"];
    [mutableDic0 setObject:@[mutableSinksDic] forKey:@"sinks"];
    [dic setObject:mutableDic0 forKey:@"aace.logger"];
}

- (void)arrayClassAddPrefixPath:(NSDictionary *)dict andContainer:(NSString *)container andPath:(NSString *)path_name andPrefix:(NSString *)prefix{
    NSMutableDictionary *dDbContainer = [NSMutableDictionary dictionaryWithDictionary:dict[container]];
    NSArray *pathArray = dDbContainer[path_name];
    NSDictionary *pathDic = pathArray[0];
    NSString *path = pathDic[@"folderPath"];
    NSString *new_path = [NSString stringWithFormat:@"%@/%@",prefix,path];
    NSArray *array = @[@{@"name":@"normal",@"folderPath":new_path}];
    [dDbContainer setValue:array forKey:path_name];
    [dict setValue:dDbContainer forKey:container];
}
- (void)updateDictionaryItem:(NSDictionary *)dict andContainer:(NSString *)container andPath:(NSString *)path andValue:(NSString *)value{
    NSMutableDictionary *dDbContainer = [NSMutableDictionary dictionaryWithDictionary:dict[container]];
    [dDbContainer setValue:value forKey:path];
    [dict setValue:dDbContainer forKey:container];
}
- (int )systemCurrentVolume{
    return  (int )(self.volumeView.volumeValue*100);
}
- (void)settedSystemCurrentVolume:(int )volume{
    [self.volumeView setVolume:(volume/100.00)];
}
- (void)reportSystemCurrentVolume:(int )volume{
    [self.ttsSpeaker localVolumeSet:(char)(volume & 0xff)];
    [self.Mp3Speaker localVolumeSet:(char)(volume & 0xff)];
}
//重新设置ser文件
- (BOOL)saiRetSerFile{
   return [self.myAzeroModeControl restartOpenDenoise];
}
- (void)detectAndSetSerFile{
    if ([QKUITools isSaiHeadsetPluggedIn]) {//如果是声智的耳机
        BOOL fileRet = [[SaiAzeroManager sharedAzeroManager] saiNewSerSet];
        if (fileRet == NO) {
            [SaiHUDTools showError:@"声智ser写文件失败"];
        }
    }else{
        BOOL fileRet = [[SaiAzeroManager sharedAzeroManager] saiOriginalSerSet];
        if (fileRet == NO) {
            [SaiHUDTools showError:@"原始ser写文件失败"];
        }
    }
    //重新启动opdenoise
    BOOL reset = [[SaiAzeroManager sharedAzeroManager] saiRetSerFile];
    if (reset == NO) {
        [SaiHUDTools showError:@"重启openDenoise失败"];
    }
}
//上传日志
- (void)saiUpdateMessageWithLevel:(SaiAppLoggerLevel )level tag:(NSString *)tag messmage:(NSString *)message{
    switch (level) {
        case SaiINFO:
            [self.logger log:INFO withTag:@"iOS_App" withMessage:message];
            break;
       case SaiWARN:
            [self.logger log:WARN withTag:@"iOS_App" withMessage:message];
            break;
        default:
            break;
    }
}
#pragma mark -  Public Methods
singleton_m(AzeroManager);
- (void)saiAzeroManagerWriteData:(NSData *)data{
    [self.writeDataLock lock];
    NSMutableData *allData = [NSMutableData data];
    int num = data.length/2;
    for (int i=0; i<num; i++) {
        @autoreleasepool {
            NSData *firstData = [data subdataWithRange:NSMakeRange(i*2, 2)];
            Byte byte[] = {0x00,0x00};
            NSData *sedData = [NSData dataWithBytes:byte length:sizeof(byte)];
            [allData appendData:firstData];
            [allData appendData:sedData];
        }
    }
    [self.audioInput writeData:(const char *)allData.bytes withSize:allData.length];
    [self.writeDataLock unlock];
}
- (ssize_t)saiAzeroManagerReadDataWith:(char*)buffer andSize:(size_t)bufferSize{
    ssize_t i = [self.ttsMediaPlayer readData:buffer withSize:bufferSize];
    return i;
}
- (bool)saiAzeroManagerReadDataComplete{
    return [self.ttsMediaPlayer isClosed];
}
//设置播放模式
- (void)managerSetSongCycleMode:(SongCycleMode)mode{
    switch (mode) {
        case SongCycleModeSingle:
            [self.PlaybackControl togglePressed:(aace::alexa::PlaybackController::PlaybackToggle::REPEAT) withAction:true];
            break;
        case SongCycleModeOrder:
           [self.PlaybackControl togglePressed:(aace::alexa::PlaybackController::PlaybackToggle::LOOP) withAction:true];
            break;
        case SongCycleModeRandom:
           [self.PlaybackControl togglePressed:(aace::alexa::PlaybackController::PlaybackToggle::SHUFFLE) withAction:true];
           break;
        default:
            break;
    }
}
- (void)saiAzeroManagerRemoveAlert:(NSString *)alert_token{
    if (alert_token.length==0) {
        return;
    }
    [self.myAzeroAlerts removeAlert:alert_token];
}
- (void)saiAzeroManagerRemoveAllAlert{
    [self.myAzeroAlerts removeAllAlerts];
}
- (void)saiAzeroManagerReportTtsPlayStateStart{
    switch (self.ttsMediaPlayer.ttsMediaPlayerState) {
        case SaiTtsMediaPlayerStatePLAYING:
            break;
        default:
            [self.ttsMediaPlayer mediaStateChanged:(AzeroMediaPlayerMediaState::PLAYING)];
            self.ttsMediaPlayer.ttsMediaPlayerState = SaiTtsMediaPlayerStatePLAYING;
            TYLog(@"播放的状态 ：SaiTtsMediaPlayer ************************************************************** playing");
            break;
    }
}
- (void)saiAzeroManagerReportTtsPlayStateStop{
    switch (self.ttsMediaPlayer.ttsMediaPlayerState) {
        case SaiTtsMediaPlayerStateSTOPPED:
            break;
        default:
            [self.ttsMediaPlayer mediaStateChanged:(AzeroMediaPlayerMediaState::STOPPED)];
            self.ttsMediaPlayer.ttsMediaPlayerState = SaiTtsMediaPlayerStateSTOPPED;;
            TYLog(@"播放的状态 ：SaiTtsMediaPlayer ************************************************************** stop");
            break;
    }
}
- (void)saiAzeroManagerReportTtsPlayStateFinished{
    switch (self.ttsMediaPlayer.ttsMediaPlayerState) {
        case SaiTtsMediaPlayerStateSTOPPED:
            break;
        default:
            [self.ttsMediaPlayer mediaStateChanged:(AzeroMediaPlayerMediaState::STOPPED)];
            self.ttsMediaPlayer.ttsMediaPlayerState = SaiTtsMediaPlayerStateSTOPPED;
            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmdd] messmage:@"SaiTtsMediaPlayer************************************************************** STOPPED(Finished)"];
            TYLog(@"播放的状态 ：SaiTtsMediaPlayer************************************************************** stop");
            break;
    }
}
- (void)saiAzeroManagerReportMp3PlayStateStart{
    switch (self.mp3MediaPlayer.mp3MediaPlayerState) {
        case SaiMp3MediaPlayerStatePLAYING:
            break;
        default:
            [self.mp3MediaPlayer mediaStateChanged:(AzeroMediaPlayerMediaState::PLAYING)];
            self.mp3MediaPlayer.mp3MediaPlayerState = SaiMp3MediaPlayerStatePLAYING;
        TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************play(中）");
            break;
    }
}
- (void)saiAzeroManagerReportMp3PlayStateStop{
    switch (self.mp3MediaPlayer.mp3MediaPlayerState) {
        case SaiMp3MediaPlayerStateSTOPPED:
            break;
            
        default:
            [self.mp3MediaPlayer mediaStateChanged:(AzeroMediaPlayerMediaState::STOPPED)];
            self.mp3MediaPlayer.mp3MediaPlayerState = SaiMp3MediaPlayerStateSTOPPED;
            TYLog(@"播放的状态 ：SaiMP3MediaPlayer ************************************************************** stop");
            break;
    }
}
- (void)saiAzeroManagerReportMp3PlayStateFinished{
    switch (self.mp3MediaPlayer.mp3MediaPlayerState) {
        case SaiMp3MediaPlayerStateSTOPPED:
            break;
        default:
            [self.mp3MediaPlayer mediaStateChanged:(AzeroMediaPlayerMediaState::STOPPED)];
            self.mp3MediaPlayer.mp3MediaPlayerState = SaiMp3MediaPlayerStateSTOPPED;
            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmdd] messmage:@"SaiMP3MediaPlayer ************************************************************** STOPPED(Finished)"];
            TYLog(@"播放的状态 ：SaiMP3MediaPlayer ************************************************************** stop");
            break;
    }
}
- (void)saiAzeroManagerReportAlertPlayStateFinished{
    switch (self.alertsMediaPlayer.alertMediaPlayerState) {
        case SaiAlertMediaPlayerStateSTOPPED:
            break;
        default:
            [self.alertsMediaPlayer mediaStateChanged:(AzeroMediaPlayerMediaState::STOPPED)];
            self.alertsMediaPlayer.alertMediaPlayerState = SaiAlertMediaPlayerStateSTOPPED;
            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmdd] messmage:@"SaiAlertMediaPlayer ************************************************************** STOPPED(Finished)"];
            TYLog(@"播放的状态 ：SaiAlertMediaPlayer ************************************************************** stop");
            break;
    }
}
- (void)saiAzeroManagerReportMp3PlayStateError{
    switch (self.mp3MediaPlayer.mp3MediaPlayerState) {
        case SaiMp3MediaPlayerStateERROR:
            break;
        default:
            [self.mp3MediaPlayer mediaStateChanged:(AzeroMediaPlayerMediaState::ERROR)];
            self.mp3MediaPlayer.mp3MediaPlayerState = SaiMp3MediaPlayerStateERROR;
            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmdd] messmage:@"SaiMP3MediaPlayer ************************************************************** ERROR"];
            TYLog(@"播放的状态 ：SaiMP3MediaPlayer ************************************************************** error");
            break;
    }
}
- (void)saiAzeroPlayTtsStatePrepare:(azeroManagerPreparePlayTtsBlock)azeroPreparePlayTts{
    if (azeroPreparePlayTts) {
        self.azeroManagerPreparePlayTtsHandle = azeroPreparePlayTts;
    }
}
- (void)saiAzeroManagerSentTxet:(NSString *)text{
    [self.myAzeroExpress sendEvent:[SaiTextInputModel azeroTextInputEvent:text]];
}
- (void)saiAzeroManagerSentTtsTxet:(NSString *)text{
    [self.myAzeroExpress sendEvent:[SaiTextInputModel azeroTtsTextInputEvent:text]];
}
- (void)saiAzeroManagerAnswerQuestion:(NSDictionary *)payload{
    [self.myAzeroExpress sendEvent:[SaiTextInputModel azeroManagerAnswerQuestion:payload]];
}
-(void )saiAzeroManagerAzeroModelAcquireType:(NSString * )acquireType contentId:(NSString *)contentId  count:(int )count{
    [self.myAzeroExpress sendEvent:[SaiTextInputModel azeroModelAcquireType:acquireType contentId:contentId count:count]];
}
- (void)saiAzeroManagerUploadRunWithCalorie:(NSNumber * )calorie andDistance:(NSNumber * )distance
                                andDuration:(NSNumber * )duration andStartTime:(NSNumber * )startTime andEndTime:(NSNumber * )endTime{
    [self.myAzeroExpress sendEvent:[SaiTextInputModel azeroModelRunSensorDataWithCalorie:calorie andDistance:distance andDuration:duration andStartTime:startTime andEndTime:endTime]];
}
- (void)saiAzeroManagerUploadWalkSensorDataWithCalorie:(NSNumber * )calorie andDistance:(NSNumber * )distance andStepCount:(NSNumber * )stepCount{
    [self.myAzeroExpress sendEvent:[SaiTextInputModel azeroModelWalkSensorDataWithCalorie:calorie andDistance:distance andStepCount:stepCount]];
}
- (void)saiAzeroManagerSwitchMode:(ModeType )localeMode andValue:(BOOL )value{
    switch (localeMode) {
        case ModeAnswer:
            [self.myAzeroExpress sendEvent:[SaiTextInputModel azeroModelSwitchWithMode:@"answer" andValue:value]];
            break;
        case ModeGuide:
            [self.myAzeroExpress sendEvent:[SaiTextInputModel azeroModelSwitchWithMode:@"guide" andValue:value]];
            break;
        case ModeHeadset:
            [self.myAzeroExpress sendEvent:[SaiTextInputModel azeroModelSwitchWithMode:@"headset" andValue:value]];
            break;
        case ModeTranslate:
            [self.myAzeroExpress sendEvent:[SaiTextInputModel azeroModelSwitchWithMode:@"translate" andValue:value]];
            break;
        default:
            break;
    }
}

- (void)saiAzeroPlaySongUrl:(azeroManagerPreparePlaySongUrlBlock)azeroPlaySongUrl{
    if (azeroPlaySongUrl) {
        self.azeroManagerPreparePlaySongUrlHandle = azeroPlaySongUrl;
    }
}
- (void)saiAzeroSongListInfo:(azeroManagerSongListInfoBlock)azeroSongListInfo{
    if (azeroSongListInfo) {
        self.azeroManagerSongListInfoHandle = azeroSongListInfo;
    }
}
- (void)saiAzeroManagerRenderTemplate:(azeroManagerRenderTemplateBlock)azeroManagerRenderTemplate{
    if (azeroManagerRenderTemplate) {
        self.azeroManagerRenderTemplateHandle = azeroManagerRenderTemplate;
    }
}
- (void)saiAzeroManagerExpress:(azeroManagerExpressBlock)azeroManagerExpress{
    if (azeroManagerExpress) { 
        self.azeroManagerExpressHandle = azeroManagerExpress;
    }
}
- (void)saiAzeroManagerVadStart:(azeroManagerVadStartBlock)vadStart{
    if (vadStart) {
        self.azeroManagerVadStartHandle = vadStart;
    }
}
- (void)saiAzeroManagerVadStop:(azeroManagerVadStopBlock)vadStop{
    if (vadStop) {
        self.azeroManagerVadStopHandle = vadStop;
    }
}
- (void)saiSDKConnectionStatusChangedWithStatus:(azeroManagerConnectionStatusBlock )connectionStatus{
    if (connectionStatus) {
        self.connectionStatusHandle = connectionStatus;
    }
}


////navigation
//- (BOOL)saiCancelNavigation{
//    BOOL cancel = [self.myAzeroNavigation cancelNavigation];
//    return cancel;
//}

- (void)saiAzeroButtonPressed:(ButtonType)button{
    switch (button) {
        case ButtonTypePLAY:
            [self.PlaybackControl buttonPressed:(aace::alexa::PlaybackController::PlaybackButton::PLAY)];
            break;
        case ButtonTypePAUSE:
            [self.PlaybackControl buttonPressed:(aace::alexa::PlaybackController::PlaybackButton::PAUSE)];
            break;
        case ButtonTypeNEXT:
            [self.PlaybackControl buttonPressed:(aace::alexa::PlaybackController::PlaybackButton::NEXT)];
            break;
        case ButtonTypePREVIOUS:
            [self.PlaybackControl buttonPressed:(aace::alexa::PlaybackController::PlaybackButton::PREVIOUS)];
            break;
        case ButtonTypeSKIP_FORWARD:
            [self.PlaybackControl buttonPressed:(aace::alexa::PlaybackController::PlaybackButton::SKIP_FORWARD)];
            break;
        case ButtonTypeEXIT:
            [self.PlaybackControl buttonPressed:(aace::alexa::PlaybackController::PlaybackButton::EXIT)];
            break;
        default:
            break;
    }
}
- (void)setUpAzeroSDK{
    
    [self createFolder:@"Announcement"];
    [self createFolder:@"FileAudio"];
    [self createFolder:@"certs"];
    [self createFolder:@"OpenDenoiseLib"];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *certsDir = [NSString stringWithFormat:@"%@/certs",docDir];
    [self copyCertsToDocumentFolder:certsDir];
    NSString *txtDir = [NSString stringWithFormat:@"%@/OpenDenoiseLib",docDir];
    [self copyOpenDenoiseFileTxtTo:txtDir];
    [self copyOpenDenoiseFileBinTo:txtDir];
    [self copyOpenDenoiseFileQTo:txtDir];
    [self copyOpenDenoiseFileSerTo:txtDir];
//    [self copyOpenDenoiseFileLogTo:txtDir];
    NSDictionary *dic = [self readLocalFileWithName:@"config"];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self addPrefixPath:mutableDic andContainer:@"miscDatabase" andPath:@"databaseFilePath" andPrefix:docDir];
    [self addPrefixPath:mutableDic andContainer:@"certifiedSender" andPath:@"databaseFilePath" andPrefix:docDir];
    [self addPrefixPath:mutableDic andContainer:@"alertsCapabilityAgent" andPath:@"databaseFilePath" andPrefix:docDir];
    [self addPrefixPath:mutableDic andContainer:@"notifications" andPath:@"databaseFilePath" andPrefix:docDir];
    [self addPrefixPath:mutableDic andContainer:@"settings" andPath:@"databaseFilePath" andPrefix:docDir];
    [self addPrefixPath:mutableDic andContainer:@"aace.storage" andPath:@"localStoragePath" andPrefix:docDir];
    [self addLoggerPath:mutableDic andPath:docDir];
    [self arrayClassAddPrefixPath:mutableDic andContainer:@"aace.opendenoise" andPath:@"wakeupModels" andPrefix:docDir];
    [self updateDictionaryItem:mutableDic andContainer:@"libcurlUtils" andPath:@"CURLOPT_CAPATH" andValue:certsDir];
    [self updateDictionaryItem:mutableDic andContainer:@"deviceInfo" andPath:@"deviceSerialNumber" andValue:SaiContext.UUID];
    
    
    //    NSString *jsonStr = [SaiJsonConversionModel dictionaryToJson:mutableDic];
    NSString *jsonStr = [mutableDic jsonStringEncoded];
    NSString *filePath = [docDir stringByAppendingPathComponent:@"Announcement"];//将需要创建的串拼接到后面
    NSString *outConfigFilePath = [NSString stringWithFormat:@"%@/config.json",filePath];
    NSString *fileAudioFolderPath =[NSString stringWithFormat:@"%@/FileAudio",docDir];
    [jsonStr writeToFile:outConfigFilePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    const char *ccFileAudioFolderPath = [fileAudioFolderPath cStringUsingEncoding:NSUTF8StringEncoding];
    UpdateFileAudioOutputFolderName(ccFileAudioFolderPath);
    [self azeroMainLoop:outConfigFilePath];
    
    [self.azeroClient saiAzeroClientConnectionStatusChangedWithStatus:^(NetworkType type) {
        
        //        if (self.connectionStatusHandle) {
        //            self.connectionStatusHandle(ConnectionStatusDisConnect);
        //        }
        switch (type) {
            case NetworkTypeDISCONNECTED:
                if (self.connectionStatusHandle) {
                    self.connectionStatusHandle(ConnectionStatusDisConnect);
                }
                break;
            case NetworkTypeCONNECTED:
                if (self.connectionStatusHandle) {
                    self.connectionStatusHandle(ConnectionStatusConnect);
                }
                break;
            case NetworkTypePENDING:
                if (self.connectionStatusHandle) {
                    self.connectionStatusHandle(ConnectionStatusPENDING);
                }
                break;
            default:
                break;
        }
    }];
    
    
}
- (void) azeroMainLoop:(NSString *)configFile {  
    MyLogger *logger = [[MyLogger alloc]init];
    self.logger = logger;
    MyCBL *cbl = [[MyCBL alloc] init];
    self.cbl = cbl;
    MySpeechRecognizer *speechRecognizer = [[MySpeechRecognizer alloc] init];
    self.speechRecognizer = speechRecognizer;
    auto audioMng = aace::audio::AudioManager::create();
    
    AzeroAudioInput *audioInput = [[AzeroAudioInput alloc] init];
    self.audioInput = audioInput;
    MyLocalDetectorEventHandler *localDetectorEventHandler = [[MyLocalDetectorEventHandler alloc] init];
    self.localDetector = localDetectorEventHandler;
    //开始识别人声
    [self.localDetector localDetectorEventSpeechStartDetected:^{
        if (self.azeroManagerVadStartHandle) {
            self.azeroManagerVadStartHandle();
        }
    }];
    //停止人声识别
    [self.localDetector localDetectorEventSpeechStopDetected:^{
        if (self.azeroManagerVadStopHandle) {
            TYLog(@"--**localDetectorEventSpeechStopDetected2");

            self.azeroManagerVadStopHandle();
        }
    }];
    AzeroLocalSpeechDetector *localDetector = [[AzeroLocalSpeechDetector alloc] initWithEventHandler:localDetectorEventHandler];
    self.localSpeechDetector = localDetector;
    
    auto foSyn = audioMng->openOutputChannel("synthesizer");
    self.ttsMediaPlayer = [[SaiTtsMediaPlayer alloc] init];
    __weak typeof(self)weakSelf = self;
    [self.ttsMediaPlayer myMediaplayerPrepareHandle:^{
        if (weakSelf.azeroManagerPreparePlayTtsHandle) {
            weakSelf.azeroManagerPreparePlayTtsHandle();  
        }
    }];
    self.ttsSpeaker = [[SaiTtsAzeroSpeaker alloc] init];
    MySpeechSynthesizer *speechSynthesizer = [[MySpeechSynthesizer alloc] initWithMediaPlayer:self.ttsMediaPlayer andSpeaker:self.ttsSpeaker];
    self.speechSynthesizer = speechSynthesizer;
    auto foAudioPlayer = audioMng->openOutputChannel("audioplayer");
    self.mp3MediaPlayer = [[SaiMp3MediaPlayer alloc] init];
    [self.mp3MediaPlayer myMediaplayerPrepareSongUrlHandle:^(NSString * _Nonnull songUrl) {
        if (weakSelf.azeroManagerPreparePlaySongUrlHandle) {
            weakSelf.azeroManagerPreparePlaySongUrlHandle(songUrl);
        }
    }];
    self.alertsMediaPlayer = [[SaiAlertMediaPlayer alloc] init];
    self.alertsMediaPlayer.alertMediaPlayerState = SaiAlertMediaPlayerStateSTOPPED;
    [self.alertsMediaPlayer myMediaplayerPrepareSongUrlHandle:^(NSString * _Nonnull songUrl) {
        if (weakSelf.azeroManagerPreparePlaySongUrlHandle) {
            weakSelf.azeroManagerPreparePlaySongUrlHandle(songUrl);
        }
    }];
    self.Mp3Speaker = [[SaiMp3AzeroSpeaker alloc] init];
    self.audioPlayer = [[MyAzeroAudioPlayer alloc] initWithMediaPlayer:self.mp3MediaPlayer andSpeaker:self.Mp3Speaker];
    self.myAzeroAlerts = [[MyAzeroAlerts alloc] initWithMediaPlayer:self.alertsMediaPlayer andSpeaker:self.ttsSpeaker];
    
    self.templateRuntime = [[MyTemplateRuntime alloc] init];
    [self.templateRuntime azeroRenderPlayerInfoWith:^(NSString *payload) {
        if (weakSelf.azeroManagerSongListInfoHandle) {
            weakSelf.azeroManagerSongListInfoHandle(payload);
        }
    }];
    [self.templateRuntime azeroRenderTemplateWith:^(NSString *payload) {
        if (weakSelf.azeroManagerRenderTemplateHandle) {
            weakSelf.azeroManagerRenderTemplateHandle(payload);
        }
    }];
    self.myAzeroExpress = [[MyAzeroExpress alloc] init];
    [self.myAzeroExpress saiAzeroExpressObtainData:^(NSString *type, NSString *content) {
        if (weakSelf.azeroManagerExpressHandle) {
            weakSelf.azeroManagerExpressHandle(type, content);
        }
    }];
    // alloc other platform interfaces  
    AzeroEngine *engine = [[AzeroEngine alloc]init];
    self.engine = engine;
    bool bRet = [engine configure:[NSArray arrayWithObjects:configFile, nil]];
    assert(bRet);
    
    bRet = [engine registerPlatformInterface:logger];
    assert(bRet);
    bRet = [engine registerPlatformInterface:cbl];
    assert(bRet);
    bRet = [engine registerPlatformInterface:audioInput];
    assert(bRet);
    bRet = [engine registerPlatformInterface:localDetector];
    assert(bRet);
    bRet = [engine registerPlatformInterfaceWithRawPtr:[localDetector getSpeechRecognizerHandler]];
    assert(bRet);
    bRet = [engine registerPlatformInterface:speechSynthesizer];
    assert(bRet);
    bRet = [engine registerPlatformInterface:self.audioPlayer];
    assert(bRet);
    bRet = [engine registerPlatformInterface:self.templateRuntime];
    assert(bRet);
    bRet = [engine registerPlatformInterface:self.myAzeroExpress];
    assert(bRet);
    bRet = [engine registerPlatformInterface:self.azeroClient];
    assert(bRet);
    bRet = [engine registerPlatformInterface:self.contactUploader];
    assert(bRet);
    bRet = [engine registerPlatformInterface:self.PlaybackControl];
    assert(bRet);
    bRet = [engine registerPlatformInterface:self.phoneCallController];
    assert(bRet);
    bRet = [engine registerPlatformInterface:self.myAzeroModeControl];
    assert(bRet);
    bRet = [engine registerPlatformInterface:self.myAzeroNavigation];
    assert(bRet);
    
    
    bRet = [engine registerPlatformInterface:self.myAzeroAlerts];
    assert(bRet);
    bRet = [engine registerPlatformInterface:self.myLocationProvider];
    assert(bRet);
    //register other platform interfaces
    bRet = [engine start];
    assert(bRet);
    [cbl start];
    bRet = [engine setInteractMode:1];
    assert(bRet);
    //    //WARNING: all platform interfaces can NOT be destroyed before engine shutted down
}
- (BOOL)saiAddContactsBegin{
    return [self.contactUploader addContactsBegin];
}
- (BOOL)saiAddContactsEnd{
    return [self.contactUploader addContactsEnd];
}
- (BOOL)saiAddContact:(NSString *)contact{
    return [self.contactUploader addContact:contact];
}
- (NSString *)saiQueryContact{
    return [self.contactUploader queryContact];
}
#pragma mark -  Setters and Getters

- (NSLock *)writeDataLock{
    if (_writeDataLock == nil) {
        _writeDataLock = [[NSLock alloc] init];
    }
    return _writeDataLock;
}

- (void)saiLogoutAzeroSDK{
    bool bRet;
    if (self.engine) {
        bRet = [self.engine stop];
        assert(bRet);
        bRet = [self.engine shutdown];
        assert(bRet);
        self.engine=nil;
    }
    
}

- (AzeroContactUploader *)contactUploader{
    if (_contactUploader == nil) {
        _contactUploader = [[AzeroContactUploader alloc] init];
    }
    return _contactUploader;
}

- (SaiAzeroClient *)azeroClient{
    if (_azeroClient == nil) {
        _azeroClient = [[SaiAzeroClient alloc] init];
    }
    return _azeroClient;
}

- (AzeroPlaybackController *)PlaybackControl{
    if (_PlaybackControl == nil) {
        _PlaybackControl = [[AzeroPlaybackController alloc] init];
    }
    return _PlaybackControl;
}
- (SaiPhoneCallController *)phoneCallController{
    if (_phoneCallController == nil) {
        _phoneCallController = [[SaiPhoneCallController alloc] init];
    }
    return _phoneCallController;
}

- (GKVolumeView *)volumeView{
    if (_volumeView == nil) {
        _volumeView = [[GKVolumeView alloc] initWithFrame:CGRectMake(ScreenWidth, ScreenHeight,100, 100  )];
        [[[UIApplication sharedApplication].delegate window ] addSubview:_volumeView];
    }
    return _volumeView;
}
- (SaiMyAzeroModeControl *)myAzeroModeControl{
    if (_myAzeroModeControl == nil) {
        _myAzeroModeControl = [[SaiMyAzeroModeControl alloc] init];
    }
    return _myAzeroModeControl;
}
- (MyAzeroNavigation *)myAzeroNavigation{
    if (_myAzeroNavigation == nil) {
        _myAzeroNavigation = [[MyAzeroNavigation alloc] init];
    }
    return _myAzeroNavigation;
}
- (MyAzeroLocationProvider *)myLocationProvider{
    if (_myLocationProvider == nil) {
        _myLocationProvider = [[MyAzeroLocationProvider alloc] init];
    }
    return _myLocationProvider;
}
@end
