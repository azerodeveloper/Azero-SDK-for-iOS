//
//  AzeroPlaybackController.h
//  AzeroDemo
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"

#include <AACE/Alexa/PlaybackController.h>

NS_ASSUME_NONNULL_BEGIN

@interface AzeroPlaybackController : AzeroPlatformInterface

-(void) buttonPressed:(aace::alexa::PlaybackController::PlaybackButton) button;
-(void) togglePressed:(aace::alexa::PlaybackController::PlaybackToggle) toggle withAction:(bool) action;

@end

NS_ASSUME_NONNULL_END
