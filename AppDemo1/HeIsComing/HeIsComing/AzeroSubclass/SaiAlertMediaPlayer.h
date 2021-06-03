//
//  SaiAlertMediaPlayer.h
//  HeIsComing
//
//  Created by silk on 2020/8/26.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroMediaPlayer.h"
typedef enum{
    SaiAlertMediaPlayerStatePLAYING    = 0,
    SaiAlertMediaPlayerStateSTOPPED    = 1,
    SaiAlertMediaPlayerStatePAUSED   = 2,
    SaiAlertMediaPlayerStateERROR   = 3
}SaiAlertMediaPlayerState;
typedef void(^mediaplayerPrepareAlertUrlBlock)(NSString *alertUrl);
@interface SaiAlertMediaPlayer : AzeroMediaPlayer
@property (nonatomic ,assign) SaiAlertMediaPlayerState alertMediaPlayerState;
- (void)myMediaplayerPrepareSongUrlHandle:(mediaplayerPrepareAlertUrlBlock )mediaplayerPrepareSongUrl;
@end

