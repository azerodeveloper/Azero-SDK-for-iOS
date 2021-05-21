//
//  SaiAlertMediaPlayer.m
//  AzeroDemo
//
//  Created by silk on 2020/8/26.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiAlertMediaPlayer.h"
@interface SaiAlertMediaPlayer ()
@property (nonatomic ,copy) mediaplayerPrepareAlertUrlBlock playerPrepareAlertUrlHandle;

@end
@implementation SaiAlertMediaPlayer
//virtual
-(bool) prepare{
    //闹钟播放器准备播放音频
    return true;
}
//virtual
-(bool) prepareWithUrl:(NSString *)url{
    //闹钟播放器播放的url信息（一般不用在这里做操作）
    if(self.playerPrepareAlertUrlHandle){
        self.playerPrepareAlertUrlHandle(url);
    }
    return true;
}
//virtual
-(bool) play{
    //开始播放音频信息，并上报播放状态（在这里调用音频播放器进行音频播放）
    return true;
}
//virtual
-(bool) stop{
    //暂停播放，并上报播放状态
    return true;
}
//virtual
-(bool) pause{
    //播放暂停，并上报播放状态
    return true;
}
//virtual
-(bool) resume{
    //恢复播放并上报播放状态
    return true;
}
//virtual
-(int64_t) getPosition{
    return 0;
}
//virtual
-(bool) setPosition:(int64_t)position{
    return true;
}

- (void)myMediaplayerPrepareSongUrlHandle:(mediaplayerPrepareAlertUrlBlock )mediaplayerPrepareSongUrl{
    if (mediaplayerPrepareSongUrl) {
        self.playerPrepareAlertUrlHandle = mediaplayerPrepareSongUrl;
    }
}
@end
