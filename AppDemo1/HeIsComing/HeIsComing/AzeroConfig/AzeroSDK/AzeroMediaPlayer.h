//
//  AzeroMediaPlayer.h
//  test000
//
//  Created by nero on 2020/2/28.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <AACE/Alexa/MediaPlayer.h>

using AzeroMediaPlayerMediaState = aace::alexa::MediaPlayer::MediaState;
using AzeroMediaPlayerMediaError = aace::alexa::MediaPlayer::MediaError;

NS_ASSUME_NONNULL_BEGIN

@interface AzeroMediaPlayer : NSObject

//virtual
-(bool) prepare;
//virtual
-(bool) prepareWithUrl:(NSString *)url;
//virtual
-(bool) play;
//virtual
-(bool) stop;
//virtual
-(bool) pause;
//virtual
-(bool) resume;
//virtual
-(int64_t) getPosition;
//virtual
-(bool) setPosition:(int64_t)position;

-(std::shared_ptr<aace::alexa::MediaPlayer>) getRawPtr;
-(AzeroMediaPlayer *) initWithRawPtr:(std::shared_ptr<aace::alexa::MediaPlayer>)ptr;
-(bool) isRepeating;
-(void) mediaStateChanged:(AzeroMediaPlayerMediaState)state;
-(void) mediaError:(AzeroMediaPlayerMediaError)error;
-(void) mediaError:(AzeroMediaPlayerMediaError)error withDescription:(NSString *)description;
//读取数据
-(ssize_t) readData:(char*) data withSize:(size_t) size;
//判断数据是否读取完毕
-(bool) isClosed;

@end

NS_ASSUME_NONNULL_END
