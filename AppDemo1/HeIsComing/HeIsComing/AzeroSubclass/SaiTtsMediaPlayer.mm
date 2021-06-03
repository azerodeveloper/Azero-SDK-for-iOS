//
//  SaiTtsMediaPlayer.m
//  HeIsComing
//
//  Created by silk on 2020/4/23.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiTtsMediaPlayer.h"
#import "SaiMpToPcmManager.h"
@interface SaiTtsMediaPlayer ()
@property (nonatomic ,copy) mediaplayerPrepareBlock playerPrepareHandle;
@end
@implementation SaiTtsMediaPlayer
- (instancetype)init{
    self = [super init];
    if (self) {
        self.ttsMediaPlayerState = SaiTtsMediaPlayerStateSTOPPED;
    }
    return self;
}
- (bool)prepare{
    dispatch_async(dispatch_get_main_queue(), ^{
    if (self.playerPrepareHandle) {
        self.playerPrepareHandle();
    }});
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiTtsMediaPlayer****************************************************************prepare "];
    TYLog(@"播放的状态 ：SaiTtsMediaPlayer**************************************************************** prepare");
    return true;
}

//virtual
-(bool) prepareWithUrl:(NSString *)url{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:[NSString stringWithFormat:@"SaiTtsMediaPlayer-------prepareWithUrl****************************************************************%@",url]];
    TYLog(@"播放的状态 ：SaiTtsMediaPlayer-------prepareWithUrl****************************************************************%@",url);
    return true;
}
//virtual
-(bool) play{
    TYLog(@"播放的状态 ：SaiTtsMediaPlayer **************************************************************** play");
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiTtsMediaPlayer **************************************************************** PLAYING(收到)"];
    [AudioQueuePlay sharedAudioQueuePlay].stop=NO;
    switch (self.ttsMediaPlayerState) {
        case SaiTtsMediaPlayerStatePLAYING:
            break;
        default:
            [self mediaStateChanged:(AzeroMediaPlayerMediaState::PLAYING)];
            self.ttsMediaPlayerState = SaiTtsMediaPlayerStatePLAYING;
            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiTtsMediaPlayer **************************************************************** PLAYING"];
            TYLog(@"播放的状态 ：SaiTtsMediaPlayer **************************************************************** 上报play");
            break;
    }
    return true;

}
//virtual
-(bool) stop{
    [self ttsStop];
//
//    if (![AudioQueuePlay sharedAudioQueuePlay].isStop) {
//        [self ttsStop];
//    }else{
//      __block   ZXCCyclesQueueItem *cyclesQueueItem;
//       cyclesQueueItem=[[ZXCTimer shareInstance]addCycleTask:^{
//           TYLog(@"%@",@"stop2");
//           TYLog(@"%@",[AudioQueuePlay sharedAudioQueuePlay].isStop?@"stopYES":@"stopNO");
//
//            if (![AudioQueuePlay sharedAudioQueuePlay].isStop) {
//                TYLog(@"%@",@"stop3");
//
//                [self ttsStop];
//                [[ZXCTimer shareInstance] removeCycleTask:cyclesQueueItem];
//            }
//        } timeInterval:0.0001];
//
//    }

   
    return true;
}
-(void)ttsStop{
    [AudioQueuePlay sharedAudioQueuePlay].isInterrupted=YES;
    [AudioQueuePlay sharedAudioQueuePlay].stop=YES;
    [[AudioQueuePlay sharedAudioQueuePlay] immediatelyStopPlay];
    [[AudioQueuePlay sharedAudioQueuePlay] audioQueueFlush];
    [[AudioQueuePlay sharedAudioQueuePlay] resetQueue];
    [[AudioQueuePlay sharedAudioQueuePlay] resetPlay];
    [[SaiMpToPcmManager sharedSaiMpToPcmManager] stopTimer];
    [SaiMpToPcmManager sharedSaiMpToPcmManager].isTimer = NO;
    [[SaiMpToPcmManager sharedSaiMpToPcmManager] memsetBuffer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaiTtsPlayInterrupt" object:nil];

    switch (self.ttsMediaPlayerState) {
    case SaiTtsMediaPlayerStateSTOPPED:
       break;
    default:
       [self mediaStateChanged:(AzeroMediaPlayerMediaState::STOPPED)];
       self.ttsMediaPlayerState = SaiTtsMediaPlayerStateSTOPPED;
       [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmdd] messmage:@"SaiTtsMediaPlayer **************************************************************** STOPPED（ttsStop）"];
       TYLog(@"播放的状态 ：SaiTtsMediaPlayer **************************************************************** stop");
       break;
    }
}
//virtual
-(bool) pause{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiTtsMediaPlayer **************************************************************** STOPPED(pause收到)"];
    TYLog(@"播放的状态 ：SaiTtsMediaPlayer**************************************************************** pause");
    switch (self.ttsMediaPlayerState) {
        case SaiTtsMediaPlayerStateSTOPPED:
            break;
        default:
            [self mediaStateChanged:(AzeroMediaPlayerMediaState::STOPPED)];
            self.ttsMediaPlayerState = SaiTtsMediaPlayerStateSTOPPED;
            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiTtsMediaPlayer **************************************************************** STOPPED(pause)"];
            TYLog(@"播放的状态 ：SaiTtsMediaPlayer**************************************************************** 上报pause");
            break;
    }
    return true;
}
//virtual
-(bool) resume{
    TYLog(@"播放的状态 ：SaiTtsMediaPlayer**************************************************************** resume");
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiTtsMediaPlayer **************************************************************** PLAYING(resume 收到)"];
    switch (self.ttsMediaPlayerState) {
        case SaiTtsMediaPlayerStatePLAYING:
            break;
        default:
            [self mediaStateChanged:(AzeroMediaPlayerMediaState::PLAYING)];
            self.ttsMediaPlayerState = SaiTtsMediaPlayerStatePLAYING;
            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiTtsMediaPlayer **************************************************************** PLAYING(resume)"];
            TYLog(@"播放的状态 ：SaiTtsMediaPlayer**************************************************************** 上报resume");
            break;
    }
    return true;
}
//virtual
-(int64_t) getPosition{
    return 1;
}
//virtual
-(bool) setPosition:(int64_t)position{
    return true;
}

- (void)myMediaplayerPrepareHandle:(mediaplayerPrepareBlock )mediaplayPrepare{
    if (mediaplayPrepare) {
        self.playerPrepareHandle = mediaplayPrepare;
    }
}

@end
