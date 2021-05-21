//
//  SaiMp3MediaPlayer.m
//  AzeroDemo
//
//  Created by silk on 2020/4/23.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiMp3MediaPlayer.h"
@interface SaiMp3MediaPlayer ()
@property (nonatomic ,copy) mediaplayerPrepareSongUrlBlock playerPrepareSongUrlHandle;

@end
@implementation SaiMp3MediaPlayer
- (bool)prepare{
    return true;
    
}
 
//virtual
-(bool) prepareWithUrl:(NSString *)url{
    //返回将要播放的url
    if(self.playerPrepareSongUrlHandle){
        self.playerPrepareSongUrlHandle(url);
    }
    return true;
}
//virtual
-(bool) play{
    //选择播放器进行播放，并且上报播放状态
    return true;
}

//virtual
-(bool) stop{
    //停止播放，并且上报播放状态
    return true;
}

//virtual
-(bool) pause{
    //暂停播放并上报播放状态
    return true;
}
//virtual
-(bool) resume{
    //继续播放并上报播放状态
    return true;
}
//virtual
-(int64_t) getPosition{
    //上报播放进度
    return 0;
}
//virtual
-(bool) setPosition:(int64_t)position{
    //播放进度
    return true;
}
- (void)myMediaplayerPrepareSongUrlHandle:(mediaplayerPrepareSongUrlBlock )mediaplayerPrepareSongUrl{
    if (mediaplayerPrepareSongUrl) {
        self.playerPrepareSongUrlHandle = mediaplayerPrepareSongUrl;
    }
}
@end
