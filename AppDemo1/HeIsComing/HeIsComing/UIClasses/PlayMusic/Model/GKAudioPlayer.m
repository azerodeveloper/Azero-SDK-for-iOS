//
//  GKAudioPlayer.m
//  GKWYMusic
//
//  Created by gaokun on 2018/4/24.
//  Copyright © 2018年 gaokun. All rights reserved.
//  播放器中所以关于FSAudioStream的类都需要在主线程中进行（类中要求的），防止可能造成的崩溃

#import "GKAudioPlayer.h"
#import "GKTimer.h"
#import <TXLiteAVSDK_Player/TXLiveBase.h>
#import "MessageAlertView.h"
#import "FSAudioStream.h"
@interface GKAudioPlayer()<SuperPlayerDelegate,TXLiveAudioSessionDelegate>


@property (nonatomic, strong) FSAudioStream *audioStream;

@property (nonatomic, strong) NSTimer       *playTimer;
@property (nonatomic, strong) NSTimer       *bufferTimer;

//@property (nonatomic ,strong) AVPlayer *player;

@property(nonatomic,strong) SuperPlayerModel *playerModel ;


@end

@implementation GKAudioPlayer

+ (instancetype)sharedInstance {
    static GKAudioPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [GKAudioPlayer new];
    });
    return player;
}

- (instancetype)init {
    if (self = [super init]) {
        self.playerState = GKAudioPlayerStateStopped;
    }
    return self;
}

- (void)setPlayUrlStr:(NSString *)playUrlStr {
    if (![_playUrlStr isEqualToString:playUrlStr]) {
        //
        //        // 切换数据，清除缓存
        //        [self removeCache];
        //
        _playUrlStr = playUrlStr;
        //
        //        if ([playUrlStr hasPrefix:@"http"]) {
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                self.audioStream.url = [NSURL URLWithString:playUrlStr];
        //            });
        //        }else {
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                self.audioStream.url = [NSURL fileURLWithPath:playUrlStr];
        //            });
        //        }
    }
}

- (void)setPlayerProgress:(float)progress {
    //    if (progress == 0) progress = 0.001;
    //    if (progress == 1) progress = 0.999;
    //
    //    FSStreamPosition position = {0};
    //    position.position = progress;
    //
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self.audioStream seekToPosition:position];
    //    });
}
- (void)setPlayerPosition:(float)position{
    
    
    if ([self.playUrlStr hasSuffix:@".m3u8"]) {
        
        self.playerModel.videoURL = self.playUrlStr;
        
        [self.playerView seekToTime:[[NSNumber numberWithFloat:position]integerValue]];
        
    }else{
            FSStreamPosition cur = self.audioStream.currentTimePlayed;
//            NSTimeInterval currentTime = cur.playbackTimeInSeconds * 1000;
//            currentTime+=position;
            cur.position=position/self.audioStream.duration.playbackTimeInSeconds;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.audioStream seekToPosition:cur];
                [self startTimer];

            });
        }
    self.playerState = GKAudioPlayerStatePlaying;
    [self setupPlayerState:self.playerState];
}

- (void)setPlayerPlayRate:(float)playRate {
    //    if (playRate < 0.5) playRate = 0.5f;
    //    if (playRate > 2.0) playRate = 2.0f;
    //
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self.audioStream setPlayRate:playRate];
    //    });
    
}

- (void)play {
    //    if (self.playerState == GKAudioPlayerStatePlaying) return;
    NSAssert(self.playUrlStr, @"url不能为空");
    
    // 设置代理，用于接受事件
    //    _playerView.delegate = self;
    // 设置父View，_playerView会被自动添加到holderView下面
    //    _playerView.fatherView = self.holderView;
    
    // 设置播放地址，直播、点播都可以
    
    //    return;
    //
    //
    //    //    dispatch_async(dispatch_get_main_queue(), ^{
    ////    [self.audioStream pause];
    ////    [self.wmPlayer resetWMPlayer];
    if ([self.playUrlStr hasSuffix:@".m3u8"]) {
        self.playerModel.videoURL = self.playUrlStr;
        // 开始播放
        [self.playerView playWithModel:self.playerModel];
        //        WMPlayerModel *playerModel = [WMPlayerModel new];
        //        playerModel.videoURL = [NSURL URLWithString:self.playUrlStr ];
        //        if(self.wmPlayer==nil){
        //            self.wmPlayer = [[WMPlayer alloc] initPlayerModel:playerModel];
        //        [[XYRecorder sharedRecorder] initRemoteIO];
        //                   [[XYRecorder sharedRecorder] startRecorder];
        //            self.wmPlayer.delegate=self;
        //            self.wmPlayer.enableBackgroundMode=YES;
        //            [[[UIApplication sharedApplication].delegate window] insertSubview:self.wmPlayer atIndex:0];
        //            [self.wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.size.mas_equalTo(CGSizeMake(kSCRATIO(300), kSCRATIO(100)));
        //                make.right.top.mas_offset(0);
        //            }];
    }else{
        [self.audioStream playFromURL:[NSURL URLWithString:self.playUrlStr]];
//        [self.audioStream play];
        [self startTimer];
        
        //            self.wmPlayer.playerModel=playerModel;
    }
    //        [self.wmPlayer play];
    self.playerState = GKAudioPlayerStatePlaying;
    [self setupPlayerState:self.playerState];
    
    //        return;
    //    }else{
    //        [self.audioStream play];
    //
    //    }
    //    });
    
    
    // 如果缓冲未完成
    //    if (self.bufferState != GKAudioBufferStateFinished) {
    //        self.bufferState = GKAudioBufferStateNone;
    //        [self startBufferTimer];
    //    }
    
}

- (void)playFromProgress:(float)progress {
    //    FSSeekByteOffset offset = {0};
    //    offset.position = progress;
    //
    //    dispatch_async(dispatch_get_main_queue(), ^{
    ////        [self.audioStream playFromOffset:offset];
    //    });
    //
    //    [self startTimer];
    //
    //    // 如果缓冲未完成
    //    if (self.bufferState != GKAudioBufferStateFinished) {
    //        self.bufferState = GKAudioBufferStateNone;
    //        [self startBufferTimer];
    //    }
}

- (void)pause {
    if (self.playerState==GKAudioPlayerStatePaused) {
        return;;
    }
    self.playerState = GKAudioPlayerStatePaused;
    [self setupPlayerState:self.playerState];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playerView pause];
        [self.audioStream pause];
        [self stopTimer];
        
    });
    
}
/**
 * Returns the playback status: YES if the stream is playing, NO otherwise.
 */

- (void)resume {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playerState = GKAudioPlayerStatePlaying;
        [self setupPlayerState:self.playerState];
        // 这里恢复播放不能用play，需要用pause
        [self.playerView  resume];

        [self.audioStream seekToPosition:self.audioStream.currentTimePlayed];
        [self startTimer];
        
    });
    
}

- (void)stop {
    
    //    if (self.playerState == GKAudioPlayerStateStoppedBy) return;
    
    self.playerState = GKAudioPlayerStateStoppedBy;
    [self setupPlayerState:self.playerState];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playerView  pause];
        //        self.wmPlayer.playerModel=nil;
        [self stopTimer];
        
        [self.audioStream stop];
    });
    
}

- (void)startTimer {
    if (self.playTimer) return;
    self.playTimer = [GKTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.playTimer forMode:NSRunLoopCommonModes];
    
}

- (void)stopTimer {
    if (self.playTimer) {
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

//- (void)startBufferTimer {
//    if (self.bufferTimer) return;
//    self.bufferTimer = [GKTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(bufferTimerAction:) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.bufferTimer forMode:NSRunLoopCommonModes];
//}

//- (void)stopBufferTimer {
//    if (self.bufferTimer) {
//        [self.bufferTimer invalidate];
//        self.bufferTimer = nil;
//    }
//}

- (void)timerAction:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        FSStreamPosition cur = self.audioStream.currentTimePlayed;
        
        NSTimeInterval currentTime1 = cur.playbackTimeInSeconds ;
        
        NSTimeInterval duration1 = self.audioStream.duration.playbackTimeInSeconds ;
        
        NSTimeInterval progress1 = cur.position;
        //        CGFloat currentTime1=   self.playerView .playCurrentTime;
        //        CGFloat duration1 = self.playerView.playDuration;
        
        
        if (isinf(duration1)) {
            duration1 = MAXFLOAT;
        }
        if (isnan(duration1)) {
            duration1 = MAXFLOAT;
        }
        
        //        NSTimeInterval progress1=currentTime1/duration1;
        if (isinf(progress1)) {
            progress1 = 0;
        }
        if (isnan(progress1)) {
            progress1 = 0;
        }
        if (self.playerView.isLive) {
            currentTime1=duration1=0;
            progress1 = 0;
            
        }
        if (currentTime1>duration1) {
            progress1 = 0;
        }
        if ([self.delegate respondsToSelector:@selector(gkPlayer:currentTime:totalTime:progress:)]) {
            [self.delegate gkPlayer:self currentTime:currentTime1 totalTime:duration1 progress:progress1];
        }
        
        if ([self.delegate respondsToSelector:@selector(gkPlayer:totalTime:)]) {
            [self.delegate gkPlayer:self totalTime:duration1];
        }
    });
}

//- (void)bufferTimerAction:(id)sender {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        float preBuffer      = (float)self.audioStream.prebufferedByteCount;
//        float contentLength  = (float)self.audioStream.contentLength;
//
//        // 这里获取的进度不能准确地获取到1
//        float bufferProgress = contentLength > 0 ? preBuffer / contentLength : 0;
//
//
//
//        // 为了能使进度准确的到1，这里做了一些处理
//        int buffer = (int)(bufferProgress + 0.5);
//
//        if (bufferProgress > 0.9 && buffer >= 1) {
//            self.bufferState = GKAudioBufferStateFinished;
//            [self stopBufferTimer];
//            // 这里把进度设置为1，防止进度条出现不准确的情况
//            bufferProgress = 1.0f;
//
//
//            TYLog(@"缓冲结束了，停止进度");
//        }else {
//            self.bufferState = GKAudioBufferStateBuffering;
//        }
//
//        if ([self.delegate respondsToSelector:@selector(gkPlayer:bufferProgress:)]) {
//            [self.delegate gkPlayer:self bufferProgress:bufferProgress];
//        }
//    });
//}

//- (void)removeCache {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.audioStream.configuration.cacheDirectory error:nil];
//
//        for (NSString *filePath in arr) {
//            if ([filePath hasPrefix:@"FSCache-"]) {
//                NSString *path = [NSString stringWithFormat:@"%@/%@", self.audioStream.configuration.cacheDirectory, filePath];
//                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//            }
//        }
//    });
//}
#pragma mark SuperPlayerDelegate

- (void)setupPlayerState:(GKAudioPlayerState)state {
    if ([self.delegate respondsToSelector:@selector(gkPlayer:statusChanged:)]) {
        [self.delegate gkPlayer:self statusChanged:state];
    }
}
/// 播放结束通知
- (void)superPlayerDidEnd:(SuperPlayerView *)player{
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReportMp3PlayStateFinished];
    
    self.playerState = GKAudioPlayerStateEnded;
    [self setupPlayerState:self.playerState];
    TYLog(@"这个时候上传了saiAzeroManagerReportMp3PlayStateFinished的状态");
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"这个时候上传了saiAzeroManagerReportMp3PlayStateFinished的状态"];
    
}
- (void)superPlayerError:(SuperPlayerView *)player errCode:(int)code errMessage:(NSString *)why{
    
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:[NSString stringWithFormat:@"这个时候上传了saiAzeroManagerReportMp3PlayStateError的状态,对应的uri为%@",self.playUrlStr]];
    TYLog(@"这个时候上传了saiAzeroManagerReportMp3PlayStateError的状态");
    
    [MessageAlertView showHudMessage:@"播放错误"];
    
}
- (void)superPlayerDidStart:(SuperPlayerView *)player{
    //    [[SaiAzeroManager sharedAzeroManager]saiAzeroManagerReportMp3PlayStateStart];
    
    
}

- (void)setProgressTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime
          progressValue:(CGFloat)progress playableValue:(CGFloat)playable{
    if (isnan(totalTime)) {
        totalTime = 0;
    }
    if (isnan(currentTime)) {
        totalTime = 0;
    }
    if (isnan(progress)) {
        progress = 0;
    }
    if (isinf(progress)) {
        progress = 0;
    }
    if (self.playerView.isLive) {
        totalTime=currentTime=0;
        progress = 0;
        
    }
    self.playCurrentTime = self.playerView .playCurrentTime;
    
    if ([self.delegate respondsToSelector:@selector(gkPlayer:currentTime:totalTime:progress:)]) {
        [self.delegate gkPlayer:self currentTime:currentTime totalTime:totalTime progress:progress];
    }
    
    if ([self.delegate respondsToSelector:@selector(gkPlayer:totalTime:)]) {
        [self.delegate gkPlayer:self totalTime:totalTime];
    }
}



#pragma mark - 懒加载
- (FSAudioStream *)audioStream {
    if (!_audioStream) {
        FSStreamConfiguration *configuration = [FSStreamConfiguration new];
        configuration.enableTimeAndPitchConversion = YES;
        
        _audioStream = [[FSAudioStream alloc] initWithConfiguration:configuration];
        _audioStream.strictContentTypeChecking = NO;
        _audioStream.defaultContentType = @"audio/mp4";

        __weak __typeof(self) weakSelf = self;
        
        _audioStream.onCompletion = ^{
            
        };
        _audioStream.onFailure=^(FSAudioStreamError error,NSString *description){
            
            NSLog(@"播放出现问题%@",description);
            
        };
        _audioStream.onStateChange = ^(FSAudioStreamState state) {
            switch (state) {
                case kFsAudioStreamRetrievingURL:       // 检索url
                    TYLog(@"检索url");
                    weakSelf.playerState = GKAudioPlayerStateLoading;
                    break;
                case kFsAudioStreamBuffering:           // 缓冲
                    TYLog(@"缓冲中。。");
                    weakSelf.playerState = GKAudioPlayerStateBuffering;
                    weakSelf.bufferState = GKAudioBufferStateBuffering;
                    break;
                case kFsAudioStreamSeeking:             // seek
                    
                    TYLog(@"seek中。。");
                    weakSelf.playerState = GKAudioPlayerStateLoading;
                    break;
                case kFsAudioStreamPlaying:             // 播放
                    TYLog(@"播放中。。");
                    weakSelf.playerState = GKAudioPlayerStatePlaying;
                    break;
                case kFsAudioStreamPaused:              // 暂停
                    TYLog(@"播放暂停");
                    weakSelf.playerState = GKAudioPlayerStatePaused;
                    break;
                case kFsAudioStreamStopped:              // 停止
                                         // 切换歌曲时主动调用停止方法也会走这里，所以这里添加判断，区分是切换歌曲还是被打断等停止
                    if (weakSelf.playerState != GKAudioPlayerStateStoppedBy && weakSelf.playerState != GKAudioPlayerStateEnded) {
                        
                        weakSelf.playerState = GKAudioPlayerStateStopped;
                    }
                    break;
                case kFsAudioStreamRetryingFailed:              // 检索失败
                    
                    TYLog(@"检索失败");
                    weakSelf.playerState = GKAudioPlayerStateError;
                    break;
                case kFsAudioStreamRetryingStarted:             // 检索开始
                    TYLog(@"检索开始");
                    weakSelf.playerState = GKAudioPlayerStateLoading;
                    break;
                case kFsAudioStreamFailed:                      // 播放失败
                    TYLog(@"播放失败");
                    weakSelf.playerState = GKAudioPlayerStateError;
                    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReportMp3PlayStateError];
                    break;
                case kFsAudioStreamPlaybackCompleted:           // 播放完成
                    TYLog(@"播放完成");
                    weakSelf.playerState = GKAudioPlayerStateEnded;
                    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReportMp3PlayStateFinished];
                    break;
                case kFsAudioStreamRetryingSucceeded:           // 检索成功
                    TYLog(@"检索成功");
                    weakSelf.playerState = GKAudioPlayerStateLoading;
                    break;
                case kFsAudioStreamUnknownState:                // 未知状态
                    TYLog(@"未知状态");
                    weakSelf.playerState = GKAudioPlayerStateError;
                    break;
                case kFSAudioStreamEndOfFile:                   // 缓冲结束
                {
                    
                    TYLog(@"缓冲结束");
                    
                    if (self.bufferState == GKAudioBufferStateFinished) return;
                    // 定时器停止后需要再次调用获取进度方法，防止出现进度不准确的情况
//                    [weakSelf bufferTimerAction:nil];
//
//                    [weakSelf stopBufferTimer];
                }
                    break;
                    
                default:
                    break;
            }
            [weakSelf setupPlayerState:weakSelf.playerState];
        };
    }
    return _audioStream;
}

-(SuperPlayerModel *)playerModel{
    if (!_playerModel) {
        _playerModel=[SuperPlayerModel new];
        
    }
    return _playerModel;
}
-(SuperPlayerView *)playerView{
    if (!_playerView) {
        _playerView=[SuperPlayerView new];
        UIView *superView=[UIView new];
        [[[UIApplication sharedApplication].delegate window] insertSubview:superView atIndex:0];
        [superView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kSCRATIO(300), kSCRATIO(100)));
            make.right.bottom.mas_offset(0);
        }];
        _playerView.isLockScreen=YES;
        _playerView.delegate=self;
        _playerView.fatherView=superView;
    }
    return _playerView;
}


/**
 设置音量
 */
- (void)setVolumeNum:(float )num{
    [self.playerView setMp3Volume:num];
//    [self.audioStream setVolume:num/100];
}
- (void)setMp3VolumeNum:(float )num{
    [self.audioStream setVolume:num/100];
}
@end
