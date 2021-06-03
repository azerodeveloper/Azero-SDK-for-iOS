//
//  AzeroSpeaker.h
//  test000
//
//  Created by nero on 2020/2/28.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <AACE/Alexa/Speaker.h>

using AzeroSpeakerType = aace::alexa::Speaker::Type;

NS_ASSUME_NONNULL_BEGIN

@interface AzeroSpeaker : NSObject

//virtual
-(bool) setVolume:(int8_t)volume;
//virtual
-(bool) adjustVolume:(int8_t)delta;
//virtual
-(bool) setMute:(bool)mute;
//virtual
-(int8_t) getVolume;
//virtual
-(bool) isMuted;

-(std::shared_ptr<aace::alexa::Speaker>) getRawPtr;
-(AzeroSpeaker *) initWithRawPtr:(std::shared_ptr<aace::alexa::Speaker>)ptr;
-(void) localVolumeSet:(int8_t)volume;
-(void) localMuteSet:(bool)mute;
@end

NS_ASSUME_NONNULL_END
