//
//  SaiPlaySoundManager.m
//  AzeroDemo
//
//  Created by silk on 2020/8/18.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiPlaySoundManager.h"
@interface SaiPlaySoundManager ()
@property (nonatomic ,strong) AVPlayer *player;

@end

@implementation SaiPlaySoundManager
singleton_m(PlaySoundManager)
- (void)playSoundWithSource:(NSString *)source{
    NSURL *url = [[NSBundle mainBundle] URLForResource:source withExtension:nil];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
    self.player = player;
    [player play];
}

@end
