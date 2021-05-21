//
//  SaiSoundWaveView.h
//  HeIsComing
//
//  Created by mike on 2020/3/31.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiSoundWaveView : NSObject

@property(nonatomic,assign)float level;


+(SaiSoundWaveView *)shareHud;

+(void)showMessage:(NSString *)messgae;

+(void)dismissHudAni;

+(void)showHudAni;

+(void)showBlue;

+(void)showWhite;

+(void)hideAllView;
@end

NS_ASSUME_NONNULL_END
