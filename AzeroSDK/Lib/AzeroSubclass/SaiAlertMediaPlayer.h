//
//  SaiAlertMediaPlayer.h
//  AzeroDemo
//
//  Created by silk on 2020/8/26.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroMediaPlayer.h"
typedef void(^mediaplayerPrepareAlertUrlBlock)(NSString *alertUrl);

@interface SaiAlertMediaPlayer : AzeroMediaPlayer
- (void)myMediaplayerPrepareSongUrlHandle:(mediaplayerPrepareAlertUrlBlock )mediaplayerPrepareSongUrl;
@end

