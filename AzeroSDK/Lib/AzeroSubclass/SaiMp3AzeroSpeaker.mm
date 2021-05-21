//
//  SaiMp3AzeroSpeaker.m
//  AzeroDemo
//
//  Created by silk on 2020/5/19.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiMp3AzeroSpeaker.h"
@interface SaiMp3AzeroSpeaker ()
@end
@implementation SaiMp3AzeroSpeaker
//virtual
-(bool) setVolume:(int8_t)volume{
    //在此处调用系统的设置音量方法
    return YES;
}
//virtual
-(bool) adjustVolume:(int8_t)delta{
    return YES;
}
//virtual
-(bool) setMute:(bool)mute{
    return YES;
}
-(int8_t) getVolume{
    //获取当前的设备音量并上传
    return 0;
}

-(bool) isMuted{
    return false;
}


@end
