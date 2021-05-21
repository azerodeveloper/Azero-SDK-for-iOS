//
//  SaiMp3MediaPlayer.h
//  AzeroDemo
//
//  Created by silk on 2020/4/23.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroMediaPlayer.h"
typedef void(^mediaplayerPrepareSongUrlBlock)(NSString *songUrl);
NS_ASSUME_NONNULL_BEGIN
@interface SaiMp3MediaPlayer : AzeroMediaPlayer
- (void)myMediaplayerPrepareSongUrlHandle:(mediaplayerPrepareSongUrlBlock )mediaplayerPrepareSongUrl;

@end

NS_ASSUME_NONNULL_END
