//
//  SaiTtsMediaPlayer.m
//  AzeroDemo
//
//  Created by silk on 2020/4/23.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiTtsMediaPlayer.h"
@interface SaiTtsMediaPlayer ()
@property (nonatomic ,copy) mediaplayerPrepareBlock playerPrepareHandle;
@end
@implementation SaiTtsMediaPlayer

- (bool)prepare{
    //准备播放TTS的时候进行回调
    dispatch_async(dispatch_get_main_queue(), ^{
    if (self.playerPrepareHandle) {
        self.playerPrepareHandle();
    }});
    return true;
}

//virtual
-(bool) prepareWithUrl:(NSString *)url{
    return true;
}
//virtual
-(bool) play{
    return true;
}
//virtual
-(bool) stop{
    //在这里做播放器停止播放的操作，并上报播放状态-stop
    return true;
}

//virtual
-(bool) pause{
    //上报播放状态
    return true;
}
//virtual
-(bool) resume{
    //上报播放状态
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
