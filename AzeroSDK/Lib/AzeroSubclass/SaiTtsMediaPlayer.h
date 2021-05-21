//
//  SaiTtsMediaPlayer.h
//  AzeroDemo
//
//  Created by silk on 2020/4/23.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroMediaPlayer.h"
typedef void(^mediaplayerPrepareBlock)(void);

NS_ASSUME_NONNULL_BEGIN
@interface SaiTtsMediaPlayer : AzeroMediaPlayer
- (void)myMediaplayerPrepareHandle:(mediaplayerPrepareBlock )mediaplayPrepare;
@end

NS_ASSUME_NONNULL_END
