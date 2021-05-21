//
//  SaiMp3MediaPlayer.m
//  HeIsComing
//
//  Created by silk on 2020/4/23.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiMp3MediaPlayer.h"
#import "GKAudioPlayer.h"
@interface SaiMp3MediaPlayer ()
@property (nonatomic ,copy) mediaplayerPrepareSongUrlBlock playerPrepareSongUrlHandle;


@end
@implementation SaiMp3MediaPlayer
- (instancetype)init{
    self = [super init];
    if (self) {
        self.mp3MediaPlayerState = SaiMp3MediaPlayerStateSTOPPED;
    }
    return self;
}

- (bool)prepare{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************** prepare"];
    TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************** prepare");
    return true;
}
 
//virtual
-(bool) prepareWithUrl:(NSString *)url{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    kPlayer.playUrlStr = url;
   
    TYLog(@"播放的状态 ：SaiMp3MediaPlayer-------prepareWithUrl******************************************************************%@",url);
    //    });
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:[NSString stringWithFormat:@"SaiMp3MediaPlayer-------prepareWithUrl******************************************************************%@",url]];
    if(self.playerPrepareSongUrlHandle){
        self.playerPrepareSongUrlHandle(url);
    }
    return true;
}
//virtual
-(bool) play{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** PLAYING （收到）"];
    if (self.isPostion) {
        self.isPostion=NO;
        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** self.isPostion=NO(return true)"];
        return true;
    }
    TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************** play(上)");
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        TYLog(@"sync - %@", [NSThread currentThread]);
        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** strcmp play (return true)"];
        TYLog(@"sync - %@", [NSThread currentThread]);
        if (kPlayer.playUrlStr!=nil) {
            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** kPlayer.playUrlStr!=nil"];
            if (!kPlayer.isAnswerModel) {
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** kPlayer.isAnswerModel"];
                TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************play(中）");
                //处理play耗时的问题
                //                    [kPlayer play];
                [self performSelector:@selector(player) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
                switch (self.mp3MediaPlayerState) {
                    case SaiMp3MediaPlayerStatePLAYING:
                        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** 已经是PLAYING状态"];
                        break;
                    default:
                        [self mediaStateChanged:AzeroMediaPlayerMediaState::PLAYING];
                        self.mp3MediaPlayerState = SaiMp3MediaPlayerStatePLAYING;
                        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** PLAYING"];
                        TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************上报play");
                        break;
                }
                TYLog(@"播放的状态 ：SaiMp3MediaPlayer**************************************************************** play(下）");
            }
        }
        return true;
    }else{
        TYLog(@"sync - %@", [NSThread currentThread]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            TYLog(@"sync - %@", [NSThread currentThread]);
            if (kPlayer.playUrlStr!=nil) {
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** kPlayer.playUrlStr!=nil"];
                if (!kPlayer.isAnswerModel) {
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** kPlayer.isAnswerModel"];
                    TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************play(中）");
                    //处理play耗时的问题
                    //                    [kPlayer play];
                    [self performSelector:@selector(player) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
                    switch (self.mp3MediaPlayerState) {
                        case SaiMp3MediaPlayerStatePLAYING:
                            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** 已经是PLAYING状态"];
                            break;
                        default:
                            [self mediaStateChanged:AzeroMediaPlayerMediaState::PLAYING];
                            self.mp3MediaPlayerState = SaiMp3MediaPlayerStatePLAYING;
                            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** PLAYING"];
                            TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************上报play");
                            break;
                    }
                    TYLog(@"播放的状态 ：SaiMp3MediaPlayer**************************************************************** play(下）");
                }
            }
        });
    }
    return true;
}
-(void)player{
    NSString *time = [QKUITools getNowyyyymmddmmss];
    [[SaiAzeroManager sharedAzeroManager].promptInformation appendString:[NSString stringWithFormat:@"\n play %@",time]];
//    [SaiHUDTools showMessage:[SaiAzeroManager sharedAzeroManager].promptInformation];
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** [kPlayer play](前)"];
    [kPlayer play];
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** [kPlayer play](后)"];
}
//virtual
-(bool) stop{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** STOPPED（收到）"];
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        TYLog(@"sync - %@", [NSThread currentThread]);
        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** strcmp STOPPED（收到）"];
        //        self.timeNum = kPlayer.playCurrentTime;
        [self performSelector:@selector(stoper) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
        switch (self.mp3MediaPlayerState) {
            case SaiMp3MediaPlayerStateSTOPPED:
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** SaiMp3MediaPlayerStateSTOPPED"];
                break;
            default:
                [self mediaStateChanged:AzeroMediaPlayerMediaState::STOPPED];
                self.mp3MediaPlayerState = SaiMp3MediaPlayerStateSTOPPED;
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** STOPPED"];
                TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************** 上报stop");
                break;
        }
        return true;
    }else{
        TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************** stop");
        dispatch_sync(dispatch_get_main_queue(), ^{
            //        self.timeNum = kPlayer.playCurrentTime;
            [self performSelector:@selector(stoper) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
            switch (self.mp3MediaPlayerState) {
                case SaiMp3MediaPlayerStateSTOPPED:
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** SaiMp3MediaPlayerStateSTOPPED"];
                    break;
                default:
                    [self mediaStateChanged:AzeroMediaPlayerMediaState::STOPPED];
                    self.mp3MediaPlayerState = SaiMp3MediaPlayerStateSTOPPED;
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** STOPPED"];
                    TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************** 上报stop");
                    break;
            }
        });
    }
    return true;
}
-(void)stoper{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** stoper（前）"];
    [kPlayer stop];
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** stoper（后）"];
}
//virtual
-(bool) pause{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** PAUSED（收到）"];
    TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************** pause(上)");
    TYLog(@"sync - %@", [NSThread currentThread]);
    
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        TYLog(@"sync - %@", [NSThread currentThread]);
//        [self performSelector:@selector(pauser) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
        [self pauser];
        switch (self.mp3MediaPlayerState) {
            case SaiMp3MediaPlayerStatePAUSED:
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** SaiMp3MediaPlayerStatePAUSED PAUSED"];
                break;
            default:
                [self mediaStateChanged:AzeroMediaPlayerMediaState::PAUSED];
                self.mp3MediaPlayerState = SaiMp3MediaPlayerStatePAUSED;
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** PAUSED"];
                TYLog(@"播放的状态 ：SaiMp3MediaPlayer**************************************************************** 上报pause");
                break;
        }
        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** strcmp PAUSED（收到）"];
        
        return true;
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************** pause");
//            [self performSelector:@selector(pauser) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
            [self pauser];
            switch (self.mp3MediaPlayerState) {
                case SaiMp3MediaPlayerStatePAUSED:
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** SaiMp3MediaPlayerStatePAUSED PAUSED"];
                    break;
                default:
                    [self mediaStateChanged:AzeroMediaPlayerMediaState::PAUSED];
                    self.mp3MediaPlayerState = SaiMp3MediaPlayerStatePAUSED;
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** PAUSED"];
                    TYLog(@"播放的状态 ：SaiMp3MediaPlayer**************************************************************** 上报pause");
                    break;
            }
            
        });}
    return true;
}
-(void)pauser{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** pauser PAUSED（前）"];
    TYLog(@"播放的状态 ：SaiMp3MediaPlayer**************************************************************** pauser PAUSED（前）");
    [kPlayer pause];
    TYLog(@"播放的状态 ：SaiMp3MediaPlayer**************************************************************** pauser PAUSED（后）");
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** pauser PAUSED（后）"];
}

//virtual
-(bool) resume{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************PLAYING (resume收到) "];
    TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************** resume");
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************strcmp (resume收到) "];
        
        [self performSelector:@selector(resumeer) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
        switch (self.mp3MediaPlayerState) {
            case SaiMp3MediaPlayerStatePLAYING:
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************SaiMp3MediaPlayerStatePLAYING (resume收到) "];
                break;
            default:
                [self mediaStateChanged:AzeroMediaPlayerMediaState::PLAYING];
                self.mp3MediaPlayerState = SaiMp3MediaPlayerStatePLAYING;
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************PLAYING (resume) "];
                TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************** 上报resume");
                break;
                
        }
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(resumeer) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
            switch (self.mp3MediaPlayerState) {
                case SaiMp3MediaPlayerStatePLAYING:
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************SaiMp3MediaPlayerStatePLAYING (resume收到) "];
                    break;
                default:
                    [self mediaStateChanged:AzeroMediaPlayerMediaState::PLAYING];
                    self.mp3MediaPlayerState = SaiMp3MediaPlayerStatePLAYING;
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************PLAYING (resume) "];
                    TYLog(@"播放的状态 ：SaiMp3MediaPlayer****************************************************************** 上报resume");
                    break;
            }
        });
    }
    return true;
}
-(void)resumeer{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************resumeer (前) "];
    [kPlayer resume];
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************resumeer (后) "];
}
//virtual
-(int64_t) getPosition{ 
//        TYLog(@"播放的状态 ：getPosition------%f",kPlayer.playCurrentTime*1000);
    return kPlayer.playCurrentTime*1000;
}
//virtual
-(bool) setPosition:(int64_t)position{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************PLAYING (setPosition收到) "];
    TYLog(@"播放的状态 ：（上）setPosition******************************************************************%lld",position);
    self.isPostion=NO;
    
    if (position != 0) {
        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************PLAYING (position != 0) "];
        self.isPostion=YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer**************************************************************** self.isPostion=YES"];
            
            //此处的延时操作是为了解决，快进XX秒的时候，出现先从0开始播一段时间之后再跳转到XX秒处，[kPlayer setPlayerPosition:(num)]是从num开始播放，而[kPlayer play]是从0开始播放
            float num = position/1000;
            TYLog(@"播放的状态 （回到主线程 中）：setPosition******************************************************************%lld",position);
            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************[kPlayer setPlayerPosition:num] (前) "];
            [kPlayer setPlayerPosition:num];
            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************[kPlayer setPlayerPosition:num] (后) "];
            switch (self.mp3MediaPlayerState) {
                case SaiMp3MediaPlayerStatePLAYING:
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************SaiMp3MediaPlayerStatePLAYING (setPosition)"];
                    break;
                default:
                    [self mediaStateChanged:AzeroMediaPlayerMediaState::PLAYING];
                    self.mp3MediaPlayerState = SaiMp3MediaPlayerStatePLAYING;
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiMp3MediaPlayer****************************************************************PLAYING (setPosition) "];
                    TYLog(@"播放的状态 ：SaiMp3MediaPlayer------------------------------------------------------------------------------------------ 上报play");
                    break;
            }
            TYLog(@"播放的状态 （回到主线程 下）：setPosition******************************************************************%lld",position);
        });
    }
    return true;
}

- (void)myMediaplayerPrepareSongUrlHandle:(mediaplayerPrepareSongUrlBlock )mediaplayerPrepareSongUrl{
    if (mediaplayerPrepareSongUrl) {
        self.playerPrepareSongUrlHandle = mediaplayerPrepareSongUrl;
    }
}
@end
