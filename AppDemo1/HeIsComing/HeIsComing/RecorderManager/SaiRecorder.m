//
//  SaiRecorder.m
//  HeIsComing
//
//  Created by silk on 2020/8/11.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiRecorder.h"
BOOL audioQueueUsed[QUEUE_BUFFER_SIZE];
AudioQueueBufferRef rBuffer[QUEUE_BUFFER_SIZE];
@interface SaiRecorder ()
{
    AudioQueueRef recordQueue;
    OSStatus osState;
}
@property (nonatomic ,strong) NSMutableData *recordData;

@end

@implementation SaiRecorder
singleton_m(SaiRecorder);

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[AVAudioSession sharedInstance] setPreferredInputNumberOfChannels:1 error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
        AudioStreamBasicDescription ASBD;
        ASBD.mBitsPerChannel = 16;
        ASBD.mBytesPerFrame = 2;
        ASBD.mBytesPerPacket = 2;
        ASBD.mChannelsPerFrame = 1;
        ASBD.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        ASBD.mFormatID = kAudioFormatLinearPCM;
        ASBD.mFramesPerPacket = 1;
        ASBD.mSampleRate = 16000;
        AudioQueueNewInput(&ASBD, InputCallback,(__bridge void * _Nullable)(self), nil, nil, 0, &recordQueue);
        for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
            AudioQueueAllocateBuffer(recordQueue, MIN_SIZE_PERFRAME, rBuffer+i);
        }        
    }
    return self;
}
void InputCallback(
                                void * __nullable               inUserData,
                                AudioQueueRef                   inAQ,
                                AudioQueueBufferRef             inBuffer,
                                const AudioTimeStamp *          inStartTime,
                                UInt32                          inNumberPacketDescriptions,
                                const AudioStreamPacketDescription * __nullable inPacketDescs)
{
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil);
    @autoreleasepool {
        SaiRecorder *self = (__bridge SaiRecorder *)(inUserData);
        NSData *recordData = [NSData dataWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize];
        float channelValue[2];
        caculate_bm_db1(inBuffer->mAudioData, inBuffer->mAudioDataByteSize, 0, k_Mono, channelValue,true);
        NSDictionary *dict = @{@"data":recordData,@"volLDB":[NSNumber numberWithFloat:channelValue[0]]};
        [[NSNotificationCenter defaultCenter] postNotificationName:SaiRecordCallback object:nil userInfo:dict];
        [self.recordData appendData:recordData];
    }
}


- (void)startRecord
{
    [self endRecord];
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        AudioQueueEnqueueBuffer(recordQueue, rBuffer[i], 0, nil);
    }
    osState = AudioQueueStart(recordQueue, NULL);
          if (osState != noErr) {
              printf("AudioQueueStart Error");
          }
}

- (void)endRecord
{
    AudioQueueStop(recordQueue, 0);
    [self resetRecorder];
    [self recordQueueFlush];
    [self resetCorderQueue];
}
- (void)resetRecorder
{
    if (recordQueue != nil) {
        AudioQueueReset(recordQueue);
        osState = AudioQueueStart(recordQueue, NULL);
        if (osState != noErr) {
            printf("AudioQueueStart Error");
        }
    }
}
- (void)recordQueueFlush{
    OSStatus status =AudioQueueFlush(recordQueue);
    if (status != noErr) {
        printf("AudioQueueStart Error");
    }
}
- (void)resetCorderQueue{
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        rBuffer[i] = false;
        osState = AudioQueueAllocateBuffer(recordQueue, MIN_SIZE_PERFRAME, &rBuffer[i]);
    }
}
- (void)saveVoiceData{
#if DEBUG
//    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *certsDir = [NSString stringWithFormat:@"%@/testAllData.pcm",docDir];
//    [self.recordData writeToFile:certsDir atomically:YES];
#endif
}
- (NSMutableData *)recordData{
    if (_recordData==nil) {
        _recordData = [NSMutableData data];
    }
    return _recordData;
}

#pragma mark Calculate DB
enum ChannelCount
{
    k_Mono = 1,
    k_Stereo
};

void caculate_bm_db1(void * const data ,size_t length ,int64_t timestamp, enum ChannelCount channelModel,float channelValue[2],bool isAudioUnit) {
    int16_t *audioData = (int16_t *)data;

    if (channelModel == k_Mono) {
        int     sDbChnnel     = 0;
        int16_t curr          = 0;
        int16_t max           = 0;
        size_t traversalTimes = 0;

        if (isAudioUnit) {
            traversalTimes = length/2;// 由于512后面的数据显示异常  需要全部忽略掉
        }else{
            traversalTimes = length;
        }

        for(int i = 0; i< traversalTimes; i++) {
            curr = *(audioData+i);
            if(curr > max) max = curr;
        }

        if(max < 1) {
            sDbChnnel = -100;
        }else {
            sDbChnnel = (20*log10((0.0 + max)/32767) - 0.5);
        }

        channelValue[0] = channelValue[1] = sDbChnnel;

    } else if (channelModel == k_Stereo){
        int sDbChA = 0;
        int sDbChB = 0;

        int16_t nCurr[2] = {0};
        int16_t nMax[2] = {0};

        for(unsigned int i=0; i<length/2; i++) {
            nCurr[0] = audioData[i];
            nCurr[1] = audioData[i + 1];

            if(nMax[0] < nCurr[0]) nMax[0] = nCurr[0];

            if(nMax[1] < nCurr[1]) nMax[1] = nCurr[0];
        }

        if(nMax[0] < 1) {
            sDbChA = -100;
        } else {
            sDbChA = (20*log10((0.0 + nMax[0])/32767) - 0.5);
        }

        if(nMax[1] < 1) {
            sDbChB = -100;
        } else {
            sDbChB = (20*log10((0.0 + nMax[1])/32767) - 0.5);
        }

        channelValue[0] = sDbChA;
        channelValue[1] = sDbChB;
    }
}
//- (void)setupRecorder{}
@end
