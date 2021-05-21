//
//  GKVolumeView.m
//  GKWYMusic
//
//  Created by gaokun on 2018/4/20.
//  Copyright © 2018年 gaokun. All rights reserved.
//  自定义音量控件试图

#import "GKVolumeView.h"
@interface GKVolumeView ()
//
@end
@implementation GKVolumeView

- (instancetype)init {
    if (self = [super init]) {
        // 设置自定义音量控件图片
        // 滑杆
        [self setMaximumVolumeSliderImage:[UIImage imageNamed:@"cm2_fm_vol_bg"] forState:UIControlStateNormal];
        [self setMinimumVolumeSliderImage:[UIImage imageNamed:@"cm2_fm_vol_cur"] forState:UIControlStateNormal];
        [self setVolumeThumbImage:[UIImage imageNamed:@"cm2_fm_vol_btn"] forState:UIControlStateNormal];
        
        // 按钮（airplay）
        [self setRouteButtonImage:[UIImage imageNamed:@"cm2_play_icn_airplay"] forState:UIControlStateNormal];
        [self setRouteButtonImage:[UIImage imageNamed:@"cm2_play_icn_airplay_prs"] forState:UIControlStateHighlighted];
        [self setShowsRouteButton:NO];
        [self setShowsVolumeSlider:YES];
        //        [[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew context:nil];
        //        [[AVAudioSession sharedInstance] addObserver:self
        //        forKeyPath:NSStringFromSelector(@selector(outputVolume))
        //           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
        //           context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVolumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

- (void)getValue {
    !self.valueChanged ? : self.valueChanged(self.volumeValue);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置子控件居竖直居中
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint center = obj.center;
        
        center.y = self.frame.size.height * 0.5;
        
        obj.center = center;
    }];
}

- (void)systemVolumeChanged:(NSNotification *)notify {
    NSDictionary *userInfo = notify.userInfo;
    
    if ([[userInfo objectForKey:@"AVSystemController_AudioCategoryNotificationParameter"] isEqualToString:@"Audio/Video"]) {
        if ([[userInfo objectForKey:@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"] isEqualToString:@"ExplicitVolumeChange"]) {
            float value = [[userInfo objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
            [[SaiAzeroManager sharedAzeroManager] reportSystemCurrentVolume:value*100];
            !self.valueChanged ? : self.valueChanged(value);
            TYLog(@"%f",value);
            
        }
    }
    
    //    float value = [[userInfo objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    //    TYLog(@"%f",value);
    //    [[SaiAzeroManager sharedAzeroManager] reportSystemCurrentVolume:value*100];
    //
    //    !self.valueChanged ? : self.valueChanged(value);
}

- (float)volumeValue {
    UISlider *slider = nil;
    for (UIView *view in self.subviews) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            slider = (UISlider *)view;
            self.volumeSlider = slider;
            break;
        }
    }
    return slider.value;
}


- (void)setVolume:(float)value {
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    });
//    [self.volumeSlider setValue:value animated:NO];
//
//    TYLog(@"最终设置的音量为多少 Volume1 %f",value);
//    [self.volumeSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
//    [self sizeToFit];
//    TYLog(@"最终设置的音量为多少 Volume2 %f",self.volumeSlider.value);
//
//    TYLog(@"最终设置的音量为多少 Volume3 %f",[AVAudioSession sharedInstance].outputVolume);
//
//    [self userActivity];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
//        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
//    });
    
    
}


@end
