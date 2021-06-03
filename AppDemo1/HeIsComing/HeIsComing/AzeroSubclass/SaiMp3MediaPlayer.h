//
//  SaiMp3MediaPlayer.h
//  HeIsComing
//
//  Created by silk on 2020/4/23.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroMediaPlayer.h"
typedef enum{
    SaiMp3MediaPlayerStatePLAYING    = 0,
    SaiMp3MediaPlayerStateSTOPPED    = 1,
    SaiMp3MediaPlayerStatePAUSED   = 2,
    SaiMp3MediaPlayerStateERROR   = 3,
}SaiMp3MediaPlayerState;
NS_ASSUME_NONNULL_BEGIN
typedef void(^mediaplayerPrepareSongUrlBlock)(NSString *songUrl);
@interface SaiMp3MediaPlayer : AzeroMediaPlayer
@property (nonatomic ,assign) SaiMp3MediaPlayerState mp3MediaPlayerState;
@property(nonatomic,assign)BOOL  isPostion;

- (void)myMediaplayerPrepareSongUrlHandle:(mediaplayerPrepareSongUrlBlock )mediaplayerPrepareSongUrl;
@end

NS_ASSUME_NONNULL_END
