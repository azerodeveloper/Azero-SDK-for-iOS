//
//  AudioQueuePlay.m
//  test000
//
//  Created by silk on 2020/3/14.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AudioQueuePlay.h"
#import <AudioToolbox/AudioToolbox.h>

#define SIZE_PER_FRAME 2000*40
#define QUEUE_BUFFER_SIZE_AudioQueuePlay 3    //队列缓冲个数
@interface AudioQueuePlay (){
    
    AudioQueueRef audioQueue;                                 //音频播放队列
    AudioStreamBasicDescription _audioDescription;
    AudioQueueBufferRef audioQueueBuffers[QUEUE_BUFFER_SIZE_AudioQueuePlay]; //音频缓存
    BOOL audioQueueBufferUsed[QUEUE_BUFFER_SIZE_AudioQueuePlay];             //判断音频缓存是否在使用
    NSLock *sysnLock;
    NSMutableData *tempData;
    OSStatus osState;
    
}

//@property (nonatomic ,assign) BOOL playBuffer;
@property (nonatomic ,strong) NSMutableData *allData;
@property (nonatomic , assign) NSInteger    dataInteger;

@property (nonatomic ,copy) azeroAudioQueuePlayTtsCompleteBlock ttsCompleteHandle;

@end
@implementation AudioQueuePlay
singleton_m(AudioQueuePlay);
- (instancetype)init
{
    self = [super init];
    if (self) {
        sysnLock = [[NSLock alloc]init];
        // 播放PCM使用
        if (_audioDescription.mSampleRate <= 0) {
            //设置音频参数
            _audioDescription.mSampleRate = 16000;//采样率
            _audioDescription.mFormatID = kAudioFormatLinearPCM;
            // 下面这个是保存音频数据的方式的说明，如可以根据大端字节序或小端字节序，浮点数或整数以及不同体位去保存数据
            _audioDescription.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
            //1单声道 2双声道
//            _audioDescription.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked;
            _audioDescription.mChannelsPerFrame = 1;
            //每一个packet一侦数据,每个数据包下的桢数，即每个数据包里面有多少桢
            _audioDescription.mFramesPerPacket = 1;
            //每个采样点16bit量化 语音每采样点占用位数
            _audioDescription.mBitsPerChannel = 16;
            _audioDescription.mBytesPerFrame = (_audioDescription.mBitsPerChannel / 8) * _audioDescription.mChannelsPerFrame;
            //每个数据包的bytes总数，每桢的bytes数*每个数据包的桢数
            _audioDescription.mBytesPerPacket = _audioDescription.mBytesPerFrame * _audioDescription.mFramesPerPacket;
        }
        // 使用player的内部线程播放 新建输出
        AudioQueueNewOutput(&_audioDescription, AudioPlayerAQInputCallback, (__bridge void * _Nullable)(self), nil, 0, 0, &audioQueue);
        // 设置音量
        AudioQueueSetParameter(audioQueue, kAudioQueueParam_Volume, 1);
        AudioQueueSetParameter(audioQueue, kAudioQueueParam_PlayRate, 1.0f);

        //监听播放状态
        AudioQueueAddPropertyListener(audioQueue, kAudioQueueProperty_IsRunning, listenerCallback, (__bridge void * _Nullable)(self));
        // 初始化需要的缓冲区
        for (int i = 0; i < QUEUE_BUFFER_SIZE_AudioQueuePlay; i++) {
            audioQueueBufferUsed[i] = false;
            osState = AudioQueueAllocateBuffer(audioQueue, SIZE_PER_FRAME, &audioQueueBuffers[i]);
        }
        osState = AudioQueueStart(audioQueue, NULL);
        if (osState != noErr) {
            printf("AudioQueueStart Error");
        }
        
    }
    return self;
}

- (void)resetPlay {
    if (audioQueue != nil) {
        AudioQueueReset(audioQueue);
        osState = AudioQueueStart(audioQueue, NULL);
        if (osState != noErr) {
            printf("AudioQueueStart Error");
        }
    }
}

// 播放相关
-(void)playWithData:(NSData *)data {
    if (self.stop) {
        return;
    }
    [sysnLock lock];
    self.dataInteger++;
    NSUInteger len = data.length;
    int i = 0;
    self.isStop=YES;
    TYLog(@"*******-[AudioQueuePlay sharedAudioQueuePlay] playWithData**************------while**************----start");
    while (true) {

        usleep(72000);
        if (!audioQueueBufferUsed[i]) {
            audioQueueBufferUsed[i] = true;
            break;
        }else {
            i++;
            if (i >= QUEUE_BUFFER_SIZE_AudioQueuePlay) {
                i = 0;
            }
        }
    }
    TYLog(@"*******-[AudioQueuePlay sharedAudioQueuePlay] playWithData**************------while**************----end");
    self.isStop=NO;
    
    if (self.stop) {
        [sysnLock unlock];
        
        return;
    }
    audioQueueBuffers[i] -> mAudioDataByteSize =  (unsigned int)len;
    if (audioQueueBuffers[i] -> mAudioData) {
        memcpy(audioQueueBuffers[i] -> mAudioData, data.bytes, len);
       AudioQueueEnqueueBuffer(audioQueue, audioQueueBuffers[i], 0, NULL);
    }
    [sysnLock unlock];
}

//stop
- (void)stopPlay{
    AudioQueueStop(audioQueue,false);
}
//immediatelyStop
- (void)immediatelyStopPlay{
    //    AudioQueueFlush(audioQueue);
    //    AudioQueueReset(audioQueue);
    AudioQueuePause(audioQueue);
    AudioQueueStop(audioQueue,true);
    AudioQueueFlush(audioQueue);
    
    for (int i = 0; i < QUEUE_BUFFER_SIZE_AudioQueuePlay; i++) {
        OSStatus status =  AudioQueueFreeBuffer(audioQueue, audioQueueBuffers[i]);
        if (status != noErr) {
            printf("AudioQueueFreeBuffer Error");
        }
    }
    [NSThread sleepForTimeInterval:0.5];


}

//Pause
- (void)playPause{
    AudioQueuePause(audioQueue);
}
//resume
- (void)playQueueStart{
    AudioQueueStart(audioQueue, NULL);
}
//
- (void)audioQueueFlush{
    OSStatus status =AudioQueueFlush(audioQueue);
    if (status != noErr) {
        printf("AudioQueueStart Error");
    }
}
// ************************** 回调 **********************************

// 回调回来把buffer状态设为未使用
static void AudioPlayerAQInputCallback(void* inUserData,AudioQueueRef audioQueueRef, AudioQueueBufferRef audioQueueBufferRef) {
    AudioQueuePlay* player = (__bridge AudioQueuePlay*)inUserData;
    [player resetBufferState:audioQueueRef and:audioQueueBufferRef];
}

// 回调回来把buffer状态设为未使用
static void listenerCallback(
                             void * __nullable       inUserData,
                             AudioQueueRef           inAQ,
                             AudioQueuePropertyID    inID){
    AudioQueuePlay* player = (__bridge AudioQueuePlay*)inUserData;
    UInt32 isRunning = 0;
    UInt32 size = sizeof(isRunning);
    
    if(player == NULL)
        return ;
    OSStatus err = AudioQueueGetProperty (inAQ, kAudioQueueProperty_IsRunning, &isRunning, &size);
       if (err) {
           TYLog(@"%s: error in kAudioQueueProperty_IsRunning\n", __PRETTY_FUNCTION__);
           return;
       }
       if (isRunning) {
       } else {
           TYLog(@"listenerCallback  --- stop");

           if (!player.isInterrupted) {
               if (player.ttsCompleteHandle) {
                   player.ttsCompleteHandle();
               }
              }
                  player.isInterrupted=NO;
           
       }
    
}



- (void)resetBufferState:(AudioQueueRef)audioQueueRef and:(AudioQueueBufferRef)audioQueueBufferRef {
    for (int i = 0; i < QUEUE_BUFFER_SIZE_AudioQueuePlay; i++) {
        // 将这个buffer设为未使用
        if (audioQueueBufferRef == audioQueueBuffers[i]) {
            audioQueueBufferUsed[i] = false;
            break;
        }
    }
    
}

// ************************** 内存回收 **********************************

- (void)dealloc {
    if (audioQueue != nil) {
        AudioQueueStop(audioQueue,true);
    }
    audioQueue = nil;
    sysnLock = nil;
}


- (NSMutableData *)allData{
    if (_allData == nil) {
        _allData = [NSMutableData data];
    }
    return _allData;
}

- (void)resetQueue{
    for (int i = 0; i < QUEUE_BUFFER_SIZE_AudioQueuePlay; i++) {
        audioQueueBufferUsed[i] = false;
        osState = AudioQueueAllocateBuffer(audioQueue, SIZE_PER_FRAME, &audioQueueBuffers[i]);
        //            printf("第 %d 个AudioQueueAllocateBuffer 初始化结果 %d (0表示成功)", i + 1, osState);
    }
}

- (void)azeroAudioQueuePlayTtsComplete:(azeroAudioQueuePlayTtsCompleteBlock)TtsCompleteBlock{
    if (TtsCompleteBlock) {
        self.ttsCompleteHandle = TtsCompleteBlock;
    }
}
@end
