//
//  AudioQueuePlay.h
//  test000
//
//  Created by silk on 2020/3/14.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioQueuePlay : NSObject
singleton_h(AudioQueuePlay);

@property(nonatomic,assign)BOOL isInterrupted;

@property(nonatomic,assign)BOOL isStop;

@property(nonatomic,assign)BOOL stop;

@property(nonatomic,assign)BOOL isSpeaking;


// 播放并顺带附上数据
- (void)playWithData: (NSData *)data;

// reset
- (void)resetPlay;
//stop
- (void)stopPlay;

//immediatelyStop
- (void)immediatelyStopPlay;

//Pause
- (void)playPause;

//Flush
- (void)audioQueueFlush;
//
////是否正在z播放
//- (BOOL)isPlayBuffer;

//重新恢复播放
- (void)playQueueStart;


- (void)resetQueue;

- (BOOL)start;

-(void)setVoume:(float)volume;
@end

NS_ASSUME_NONNULL_END
