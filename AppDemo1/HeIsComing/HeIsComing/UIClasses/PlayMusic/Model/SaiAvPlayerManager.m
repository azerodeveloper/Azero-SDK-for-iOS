//
//  SaiAvPlayerManager.m
//  HeIsComing
//
//  Created by silk on 2020/8/26.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiAvPlayerManager.h"
@interface SaiAvPlayerManager ()
@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,assign) BOOL isStop;

@end
@implementation SaiAvPlayerManager
singleton_m(AvPlayerManager);

- (void)managerPlayUrl:(NSString *)url{
    self.alertUrl = url;
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    [self.player replaceCurrentItemWithPlayerItem:item];
}
- (AVPlayer *)player{
    if (_player==nil) {
        _player = [[AVPlayer alloc] init];
        [SaiNotificationCenter addObserver:self selector:@selector(itemDidPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return _player;
}
- (void)play{
//    self.isStop = NO;
    [self.player play];
}
- (void)stop{
//    self.isStop = YES;
    [self.player pause];
}
- (void)itemDidPlayEnd:(NSNotification *)noti{
//    if ([self.alertUrl isEqualToString:@"https://api-azero.soundai.cn/v1/cmsservice/resource/95cef31b643f1f6616815e77a3bd080f.mp3"]) {
//        if (self.isStop) {
//            [self.player pause];
//        }else{
//            [self managerPlayUrl:self.alertUrl];
//            [self play];
//        }
//    }else{
        [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReportAlertPlayStateFinished];
        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:[QKUITools getNowyyyymmddmmss] messmage:@"SaiAlertMediaPlayer**************************************************************** Stop"];
        TYLog(@"SaiAlertMediaPlayer**************************************************************** Stop");
//    }
    
}
@end
