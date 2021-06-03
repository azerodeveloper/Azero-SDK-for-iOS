//
//  MyAzeroSpeaker.m
//  HeIsComing
//
//  Created by silk on 2020/4/16.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "MyAzeroSpeaker.h"
#import "GKVolumeView.h"
@interface MyAzeroSpeaker ()
@property (nonatomic ,strong) GKVolumeView *volumeView;

@end
@implementation MyAzeroSpeaker
//virtual
-(bool) setVolume:(int8_t)volume{
    [self.volumeView setVolumeValue:(float)volume];
    TYLog(@"设置音量 setVolume------------ %d",volume);
    return YES;
}
//virtual
-(bool) adjustVolume:(int8_t)delta{
    TYLog(@"设置音量 adjustVolume ------------ %d",delta);
    return YES;
}
//virtual
-(bool) setMute:(bool)mute{
    TYLog(@"设置静音setMute ------------ %d",mute);
    return YES;
}
-(int8_t) getVolume{
    return [self.volumeView obtainVolumeValue];
}

-(bool) isMuted{
    return false;
}
-(void) localVolumeSet:(int8_t)volume{
    TYLog(@"localVolumeSet ------------ %d",volume);
}
-(void) localMuteSet:(bool)mute{
    TYLog(@"localMuteSet ------------ %d",mute);
}

- (GKVolumeView *)volumeView{

    if (_volumeView == nil) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _volumeView = [[GKVolumeView alloc] init];
        });
    }
    return _volumeView;
}


@end
