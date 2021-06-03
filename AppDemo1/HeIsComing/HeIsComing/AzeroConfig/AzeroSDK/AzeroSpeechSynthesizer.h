//
//  AzeroSpeechSynthesizer.h
//  test000
//
//  Created by nero on 2020/2/28.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroAudioChannel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AzeroSpeechSynthesizer : AzeroAudioChannel

//virtual
-(void) handlePrePlaybackStarted;
//virtual
-(void) handlePostPlaybackFinished;

-(AzeroSpeechSynthesizer *) initWithMediaPlayer:(AzeroMediaPlayer *)player andSpeaker:(AzeroSpeaker *)speaker;
@end

NS_ASSUME_NONNULL_END
