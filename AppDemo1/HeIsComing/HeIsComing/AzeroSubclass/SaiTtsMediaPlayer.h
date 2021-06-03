//
//  SaiTtsMediaPlayer.h
//  HeIsComing
//
//  Created by silk on 2020/4/23.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroMediaPlayer.h"
typedef enum{
    SaiTtsMediaPlayerStatePLAYING    = 0,
    SaiTtsMediaPlayerStateSTOPPED    = 1,
}SaiTtsMediaPlayerState;
NS_ASSUME_NONNULL_BEGIN
typedef void(^mediaplayerPrepareBlock)(void);
@interface SaiTtsMediaPlayer : AzeroMediaPlayer
@property (nonatomic ,assign) SaiTtsMediaPlayerState ttsMediaPlayerState;

- (void)myMediaplayerPrepareHandle:(mediaplayerPrepareBlock )mediaplayPrepare;
@end

NS_ASSUME_NONNULL_END
