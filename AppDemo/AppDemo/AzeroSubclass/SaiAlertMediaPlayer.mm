//
//  SaiAlertMediaPlayer.m
//  HeIsComing
//
//  Created by silk on 2020/8/26.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiAlertMediaPlayer.h"
#import "SaiAvPlayerManager.h"
@interface SaiAlertMediaPlayer ()
@property (nonatomic ,copy) mediaplayerPrepareAlertUrlBlock playerPrepareAlertUrlHandle;
@end
@implementation SaiAlertMediaPlayer
//virtual
-(bool) prepare{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer****************************************************************** prepare"];
    TYLog(@"播放的状态 ：SaiAlertMediaPlayer****************************************************************** prepare");
    return true;
}
//virtual
-(bool) prepareWithUrl:(NSString *)url{
    TYLog(@"播放的状态 ：SaiAlertMediaPlayer-------prepareWithUrl******************************************************************%@",url);
    [[SaiAvPlayerManager sharedAvPlayerManager] managerPlayUrl:url];
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:[NSString stringWithFormat:@"SaiAlertMediaPlayer-------prepareWithUrl******************************************************************%@",url]];
    if(self.playerPrepareAlertUrlHandle){
        self.playerPrepareAlertUrlHandle(url);
    }
    return true;
}
//virtual
-(bool) play{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** PLAYING （收到）"];
    TYLog(@"播放的状态 ：SaiAlertMediaPlayer****************************************************************** play(上)");
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        TYLog(@"sync - %@", [NSThread currentThread]);
        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** strcmp play (return true)"];
        if ([SaiAvPlayerManager sharedAvPlayerManager].alertUrl!=nil) {
            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** .playUrlStr!=nil"];
            if (![SaiAvPlayerManager sharedAvPlayerManager].isAnswerModel) {
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** .isAnswerModel"];
                TYLog(@"播放的状态 ：SaiAlertMediaPlayer****************************************************************play(中）");
                [self performSelector:@selector(player) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
                switch (self.alertMediaPlayerState) {
                    case SaiAlertMediaPlayerStatePLAYING:
                        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** 已经是PLAYING状态"];
                        break;
                    default:
                        [self mediaStateChanged:AzeroMediaPlayerMediaState::PLAYING];
                        self.alertMediaPlayerState = SaiAlertMediaPlayerStatePLAYING;
                        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** PLAYING"];
                        TYLog(@"播放的状态 ：SaiAlertMediaPlayer****************************************************************上报play");
                        break;
                }
                TYLog(@"播放的状态 ：SaiAlertMediaPlayer**************************************************************** play(下）");
            }
        }
        
        return true;
        
    }else{
        TYLog(@"sync - %@", [NSThread currentThread]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            TYLog(@"sync - %@", [NSThread currentThread]);
            if ([SaiAvPlayerManager sharedAvPlayerManager].alertUrl!=nil) {
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** playUrlStr!=nil"];
                if (![SaiAvPlayerManager sharedAvPlayerManager].isAnswerModel) {
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** isAnswerModel"];
                    TYLog(@"播放的状态 ：SaiAlertMediaPlayer****************************************************************play(中）");
                    [self performSelector:@selector(player) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
                    switch (self.alertMediaPlayerState) {
                        case SaiAlertMediaPlayerStatePLAYING:
                            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** 已经是PLAYING状态"];
                            break;
                        default:
                            [self mediaStateChanged:AzeroMediaPlayerMediaState::PLAYING];
                            self.alertMediaPlayerState = SaiAlertMediaPlayerStatePLAYING;
                            [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** PLAYING"];
                            TYLog(@"播放的状态 ：SaiAlertMediaPlayer****************************************************************上报play");
                            break;
                    }
                    TYLog(@"播放的状态 ：SaiAlertMediaPlayer**************************************************************** play(下）");
                }
            }
        });
    }
    return true;
}
//virtual
-(bool) stop{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** STOPPED（收到）"];
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        TYLog(@"sync - %@", [NSThread currentThread]);
        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** strcmp STOPPED（收到）"];
        [self performSelector:@selector(stoper) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
        
        switch (self.alertMediaPlayerState) {
            case SaiAlertMediaPlayerStateSTOPPED:
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** SaiAlertMediaPlayerStateSTOPPED"];
                break;
            default:
                [self mediaStateChanged:AzeroMediaPlayerMediaState::STOPPED];
                self.alertMediaPlayerState = SaiAlertMediaPlayerStateSTOPPED;
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** STOPPED"];
                TYLog(@"播放的状态 ：SaiAlertMediaPlayer****************************************************************** 上报stop");
                break;
        }
        
        
        return true;
    }else{
        TYLog(@"播放的状态 ：SaiAlertMediaPlayer****************************************************************** stop");
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(stoper) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
            
            switch (self.alertMediaPlayerState) {
                case SaiAlertMediaPlayerStateSTOPPED:
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** SaiAlertMediaPlayerStateSTOPPED"];
                    break;
                default:
                    [self mediaStateChanged:AzeroMediaPlayerMediaState::STOPPED];
                    self.alertMediaPlayerState = SaiAlertMediaPlayerStateSTOPPED;
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** STOPPED"];
                    TYLog(@"播放的状态 ：SaiAlertMediaPlayer****************************************************************** 上报stop");
                    break;
            }
            
        });
        
    }
    
    return true;
}


- (void)player{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** [AlertMediaPlayer play](前)"];
    [[SaiAvPlayerManager sharedAvPlayerManager] play];
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** [AlertMediaPlayer play](后)"];
}
-(void)stoper{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** stoper（前）"];
    [[SaiAvPlayerManager sharedAvPlayerManager] stop];
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** stoper（后）"];
    
}
-(void)pauser{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** pauser PAUSED（前）"];
    [[SaiAvPlayerManager sharedAvPlayerManager] stop];
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** pauser PAUSED（后）"];
}
//virtual
-(bool) pause{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** PAUSED（收到）"];
    TYLog(@"播放的状态 ：SaiAlertMediaPlayer****************************************************************** pause(上)");
    TYLog(@"sync - %@", [NSThread currentThread]);
    
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        TYLog(@"sync - %@", [NSThread currentThread]);
        [self performSelector:@selector(pauser) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
        
        switch (self.alertMediaPlayerState) {
            case SaiAlertMediaPlayerStatePAUSED:
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** SaiAlertMediaPlayerPAUSED PAUSED"];
                break;
            default:
                [self mediaStateChanged:AzeroMediaPlayerMediaState::PAUSED];
                self.alertMediaPlayerState = SaiAlertMediaPlayerStatePAUSED;
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** PAUSED"];
                TYLog(@"播放的状态 ：SaiAlertMediaPlayer**************************************************************** 上报pause");
                break;
        }
        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** strcmp PAUSED（收到）"];
        
        return true;
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            TYLog(@"播放的状态 ：SaiAlertMediaPlayer****************************************************************** pause");
            [self performSelector:@selector(pauser) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
            
            switch (self.alertMediaPlayerState) {
                case SaiAlertMediaPlayerStatePAUSED:
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** SaiAlertMediaPlayerStatePAUSED PAUSED"];
                    break;
                default:
                    [self mediaStateChanged:AzeroMediaPlayerMediaState::PAUSED];
                    self.alertMediaPlayerState = SaiAlertMediaPlayerStatePAUSED;
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** PAUSED"];
                    TYLog(@"播放的状态 ：SaiAlertMediaPlayer**************************************************************** 上报pause");
                    break;
            }
            
        });}
    return true;
}
-(void)resumeer{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer****************************************************************resumeer (前) "];
    [[SaiAvPlayerManager sharedAvPlayerManager] play];
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer****************************************************************resumeer (后) "];
}
//virtual
-(bool) resume{
    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer****************************************************************PLAYING (resume收到) "];
    TYLog(@"播放的状态 ：SaiAlertMediaPlayer****************************************************************** resume");
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        TYLog(@"sync - %@", [NSThread currentThread]);
        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer****************************************************************strcmp (resume收到) "];
        
        [self performSelector:@selector(resumeer) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
        switch (self.alertMediaPlayerState) {
            case SaiAlertMediaPlayerStatePLAYING:
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer****************************************************************SaiAlertMediaPlayerStatePLAYING (resume收到) "];
                break;
            default:
                [self mediaStateChanged:AzeroMediaPlayerMediaState::PLAYING];
                self.alertMediaPlayerState = SaiAlertMediaPlayerStatePLAYING;
                [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer****************************************************************PLAYING (resume) "];
                TYLog(@"播放的状态 ：SaiAlertMediaPlayer****************************************************************** 上报resume");
                break;
                
        }
    }else{
        TYLog(@"sync - %@", [NSThread currentThread]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(resumeer) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
            switch (self.alertMediaPlayerState) {
                case SaiAlertMediaPlayerStatePLAYING:
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer****************************************************************SaiAlertMediaPlayerStatePLAYING (resume收到) "];
                    break;
                default:
                    [self mediaStateChanged:AzeroMediaPlayerMediaState::PLAYING];
                    self.alertMediaPlayerState = SaiAlertMediaPlayerStatePLAYING;
                    [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer****************************************************************PLAYING (resume) "];
                    TYLog(@"播放的状态 ：SaiAlertMediaPlayer****************************************************************** 上报resume");
                    break;
            }
        });
    }
    return true;
}
- (void)myMediaplayerPrepareSongUrlHandle:(mediaplayerPrepareAlertUrlBlock )mediaplayerPrepareSongUrl{
    if (mediaplayerPrepareSongUrl) {
        self.playerPrepareAlertUrlHandle = mediaplayerPrepareSongUrl;
    }
}

//virtual
-(int64_t) getPosition{
    return 0;
}
//virtual
-(bool) setPosition:(int64_t)position{
    return true;
}
@end
