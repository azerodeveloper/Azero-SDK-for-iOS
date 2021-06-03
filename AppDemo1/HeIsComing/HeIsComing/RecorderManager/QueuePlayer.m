//
//  QueuePlayer.m
//  audioqueue 录音
//
//  Created by Hellen Yang on 2017/7/19.
//  Copyright © 2017年 yjl. All rights reserved.
//

#import "QueuePlayer.h"
#import <AVFoundation/AVFoundation.h>

BOOL audioQueueUsed[QUEUE_BUFFER_SIZE];
AudioQueueBufferRef rBuffer[QUEUE_BUFFER_SIZE];
AudioQueueBufferRef pBuffer[QUEUE_BUFFER_SIZE];



@interface QueuePlayer ()
@property (nonatomic ,strong) NSMutableData *testAllData;



@end

@implementation QueuePlayer
{
    AudioQueueRef recordQueue;
    
    AudioQueueRef playQueue;
    
    
    NSLock *lock;
}
singleton_m(QueuePlayer);

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
        
 
        AudioQueueNewOutput(&ASBD, OutputCallback, (__bridge void * _Nullable)(self), nil, nil, 0, &playQueue);
        
        
        AudioQueueNewInput(&ASBD, InputCallback,(__bridge void * _Nullable)(self), nil, nil, 0, &recordQueue);
        
       
        for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
            AudioQueueAllocateBuffer(recordQueue, MIN_SIZE_PER_FRAME, rBuffer+i);
            AudioQueueAllocateBuffer(playQueue, MIN_SIZE_PER_FRAME, pBuffer+i);
        }
        
        
    }
    return self;
}


- (void)startRecord
{
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        AudioQueueEnqueueBuffer(recordQueue, rBuffer[i], 0, nil);
    }
    AudioQueueStart(recordQueue, 0);
}

- (void)endRecord
{
    AudioQueueStop(recordQueue, 0);
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *certsDir = [NSString stringWithFormat:@"%@/endRecord3.pcm",docDir];
    [self.testAllData writeToFile:certsDir atomically:YES];
}

//- (void)startPlay
//{
//    AudioQueueStart(playQueue, 0);
//}
//
//- (void)endPlay
//{
//    AudioQueueStop(playQueue, 0);
//}


//- (void)playerWithData:(NSData *)data
//{
//    AudioQueueBufferRef theBuffer = NULL;
//    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
//        if (audioQueueUsed[i]) {
//            continue;
//        }
//        theBuffer = pBuffer[i];
//        audioQueueUsed[i] = YES;
//        
//        
//        memcpy(theBuffer->mAudioData, data.bytes, data.length);
//        theBuffer->mAudioDataByteSize = data.length;
//        AudioQueueEnqueueBuffer(playQueue, theBuffer, 0, nil);
//        break;
//    }
//    
//    
//    
//    //
//
//}


void OutputCallback(
                 void * __nullable       inUserData,
                 AudioQueueRef           inAQ,
                 AudioQueueBufferRef     inBuffer)
{
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        if (inBuffer == pBuffer[i]) {
            audioQueueUsed[i] = NO;
            
//            NSLog(@"buff(%d) 使用完成",i);
            break;
            
        }
    }
}


void InputCallback(
                                void * __nullable               inUserData,
                                AudioQueueRef                   inAQ,
                                AudioQueueBufferRef             inBuffer,
                                const AudioTimeStamp *          inStartTime,
                                UInt32                          inNumberPacketDescriptions,
                                const AudioStreamPacketDescription * __nullable inPacketDescs)
{
    QueuePlayer *player = (__bridge QueuePlayer *)(inUserData);
     [player playWithbuffer:inBuffer];
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil);
    @autoreleasepool {
        QueuePlayer *self = (__bridge QueuePlayer*)inUserData;
        NSData *recordData = [NSData dataWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize];
        float channelValue[2];
//        caculate_bm_db(inBuffer->mAudioData, inBuffer->mAudioDataByteSize, 0, k_Mono, channelValue,true);
//        NSDictionary *dict = @{@"data":recordData,@"volLDB":[NSNumber numberWithFloat:channelValue[0]]};
//        [[NSNotificationCenter defaultCenter] postNotificationName:SaiRecordCallback object:nil userInfo:dict];
        [self.testAllData appendData:recordData];
    }    
}


- (void)playWithbuffer:(AudioQueueBufferRef )buffRef
{
    
    NSData *data = [NSData dataWithBytes:buffRef->mAudioData length:buffRef->mAudioDataByteSize];
    [self.testAllData appendData:data];

    if (_recordBack) {
        _recordBack(data);
    }
    
    
}
- (NSMutableData *)testAllData{
    if (_testAllData == nil) {
        _testAllData = [NSMutableData data];
    }
    return _testAllData;
}

//#pragma mark Calculate DB
//enum ChannelCount
//{
//    k_Mono = 1,
//    k_Stereo
//};
//
//void caculate_bm_db(void * const data ,size_t length ,int64_t timestamp, enum ChannelCount channelModel,float channelValue[2],bool isAudioUnit) {
//    int16_t *audioData = (int16_t *)data;
//
//    if (channelModel == k_Mono) {
//        int     sDbChnnel     = 0;
//        int16_t curr          = 0;
//        int16_t max           = 0;
//        size_t traversalTimes = 0;
//
//        if (isAudioUnit) {
//            traversalTimes = length/2;// 由于512后面的数据显示异常  需要全部忽略掉
//        }else{
//            traversalTimes = length;
//        }
//
//        for(int i = 0; i< traversalTimes; i++) {
//            curr = *(audioData+i);
//            if(curr > max) max = curr;
//        }
//
//        if(max < 1) {
//            sDbChnnel = -100;
//        }else {
//            sDbChnnel = (20*log10((0.0 + max)/32767) - 0.5);
//        }
//
//        channelValue[0] = channelValue[1] = sDbChnnel;
//
//    } else if (channelModel == k_Stereo){
//        int sDbChA = 0;
//        int sDbChB = 0;
//
//        int16_t nCurr[2] = {0};
//        int16_t nMax[2] = {0};
//
//        for(unsigned int i=0; i<length/2; i++) {
//            nCurr[0] = audioData[i];
//            nCurr[1] = audioData[i + 1];
//
//            if(nMax[0] < nCurr[0]) nMax[0] = nCurr[0];
//
//            if(nMax[1] < nCurr[1]) nMax[1] = nCurr[0];
//        }
//
//        if(nMax[0] < 1) {
//            sDbChA = -100;
//        } else {
//            sDbChA = (20*log10((0.0 + nMax[0])/32767) - 0.5);
//        }
//
//        if(nMax[1] < 1) {
//            sDbChB = -100;
//        } else {
//            sDbChB = (20*log10((0.0 + nMax[1])/32767) - 0.5);
//        }
//
//        channelValue[0] = sDbChA;
//        channelValue[1] = sDbChB;
//    }
//}
@end
