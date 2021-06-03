//
//  XYRecorder.m
//  XYRealTimeRecord
//
//  Created by zxy on 2017/3/17.
//  Copyright © 2017年 zxy. All rights reserved.
//

#import "XYRecorder.h"
#import <AVFoundation/AVFoundation.h>

#define INPUT_BUS 1
#define OUTPUT_BUS 0

AudioUnit audioUnit;
AudioBufferList *buffList;
@interface XYRecorder ()
@property (nonatomic ,strong) AVAudioSession *audioSession;
@property (nonatomic ,strong) NSMutableData *testAllData;
//@property (nonatomic, strong) dispatch_queue_t recordQueue;

@end
@implementation XYRecorder
singleton_m(Recorder);

#pragma mark - init

- (instancetype)init {
    self = [super init];
    
    if (self) {
        AudioUnitInitialize(audioUnit);
    }
    return self;
}

- (void)initRemoteIO {
    [self initAudioSession];
    
    [self initBuffer];
    
    [self initAudioComponent];
    
    [self initFormat];
    
    [self initAudioProperty];
    
    [self initRecordeCallback];
    
    //注释掉 防止耳机模式下，出现返耳
//    [self initPlayCallback];
}

- (void)initAudioSession {
    NSError *error;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:&error];

    [audioSession setPreferredSampleRate:16000 error:&error];
    [audioSession setPreferredInputNumberOfChannels:1 error:&error];
    [audioSession setPreferredIOBufferDuration:0.005 error:&error];
    
    self.audioSession = audioSession;
}
- (void)initBuffer {
    UInt32 flag = 0;
    AudioUnitSetProperty(audioUnit,
                         kAudioUnitProperty_ShouldAllocateBuffer,
                         kAudioUnitScope_Output,
                         INPUT_BUS,
                         &flag,
                         sizeof(flag));
     
    buffList = (AudioBufferList*)malloc(sizeof(AudioBufferList));
    buffList->mNumberBuffers = 1;
    buffList->mBuffers[0].mNumberChannels = 1;
    buffList->mBuffers[0].mDataByteSize = 2048 * sizeof(short);
    buffList->mBuffers[0].mData = (short *)malloc(sizeof(short) * 2048);
}

- (void)initAudioComponent {
    AudioComponentDescription audioDesc;
    audioDesc.componentType = kAudioUnitType_Output;
    audioDesc.componentSubType = kAudioUnitSubType_RemoteIO;
    audioDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    audioDesc.componentFlags = 0;
    audioDesc.componentFlagsMask = 0;
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &audioDesc);
    AudioComponentInstanceNew(inputComponent, &audioUnit);
}

- (void)initFormat {
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate = 16000;
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mChannelsPerFrame = 1;
    audioFormat.mBitsPerChannel = 16;
    audioFormat.mBytesPerPacket = 2;
    audioFormat.mBytesPerFrame = 2;
    AudioUnitSetProperty(audioUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Output,
                         INPUT_BUS,
                         &audioFormat,
                         sizeof(audioFormat));
    AudioUnitSetProperty(audioUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Input,
                         OUTPUT_BUS,
                         &audioFormat,
                         sizeof(audioFormat));
}

- (void)initRecordeCallback {
    AURenderCallbackStruct recordCallback;
    recordCallback.inputProc = RecordCallback;
    recordCallback.inputProcRefCon = (__bridge void *)self;
    AudioUnitSetProperty(audioUnit,
                         kAudioOutputUnitProperty_SetInputCallback,
                         kAudioUnitScope_Global,
                         INPUT_BUS,
                         &recordCallback,
                         sizeof(recordCallback));
}

- (void)initPlayCallback {
    AURenderCallbackStruct playCallback;
    playCallback.inputProc = PlayCallback;
    playCallback.inputProcRefCon = (__bridge void *)self;
    AudioUnitSetProperty(audioUnit,
                         kAudioUnitProperty_SetRenderCallback,
                         kAudioUnitScope_Global,
                         OUTPUT_BUS,
                         &playCallback,
                         sizeof(playCallback));
}

- (void)initAudioProperty {
    UInt32 flag = 1;
    AudioUnitSetProperty(audioUnit,
                         kAudioOutputUnitProperty_EnableIO,
                         kAudioUnitScope_Input,
                         INPUT_BUS,
                         &flag,
                         sizeof(flag));
    AudioUnitSetProperty(audioUnit,
                         kAudioOutputUnitProperty_EnableIO,
                         kAudioUnitScope_Input,
                         OUTPUT_BUS,
                         &flag,
                         sizeof(flag));

}

#pragma mark - callback function
#pragma mark Calculate DB
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
static OSStatus RecordCallback(void *inRefCon,
                               AudioUnitRenderActionFlags *ioActionFlags,
                               const AudioTimeStamp *inTimeStamp,
                               UInt32 inBusNumber,
                               UInt32 inNumberFrames,
                               AudioBufferList *ioData)
{
    AudioUnitRender(audioUnit, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, buffList);
    short *data = (short *)buffList->mBuffers[0].mData;
    XYRecorder *self = (__bridge XYRecorder*)inRefCon;
    @autoreleasepool {
        NSData *recordData = [NSData dataWithBytes:data length:buffList->mBuffers[0].mDataByteSize];
        float channelValue[2];
//    TYLog(@"正在录制音频信息 -----------------------------------------------------------------------------");
//        TYLog(@"%lu",(unsigned long)recordData.length);
//        caculate_bm_db(buffList->mBuffers[0].mData, buffList->mBuffers[0].mDataByteSize, 0, k_Mono, channelValue,true);
        NSDictionary *dict = @{@"data":recordData,@"volLDB":[NSNumber numberWithFloat:channelValue[0]]};
//        [[NSNotificationCenter defaultCenter] postNotificationName:SaiRecordCallback object:nil userInfo:dict];
        [self.testAllData appendData:recordData];
    }
    return noErr;
}

static OSStatus PlayCallback(void *inRefCon,
                            AudioUnitRenderActionFlags *ioActionFlags,
                            const AudioTimeStamp *inTimeStamp,
                            UInt32 inBusNumber,
                            UInt32 inNumberFrames,
                            AudioBufferList *ioData) {
    AudioUnitRender(audioUnit, ioActionFlags, inTimeStamp, 1, inNumberFrames, ioData);
    return noErr;  
}

#pragma mark - public methods

- (void)startRecorder {
//    [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    AudioOutputUnitStart(audioUnit);
}

- (void)stopRecorder {
    AudioOutputUnitStop(audioUnit);
//    [self.audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
}
- (void)saveVoiceData{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *certsDir = [NSString stringWithFormat:@"%@/testAllData.pcm",docDir];
    [self.testAllData writeToFile:certsDir atomically:YES];
}
- (NSMutableData *)testAllData{
    if (_testAllData == nil) {
        _testAllData = [NSMutableData data];
    }
    return _testAllData;
}

//////懒加载创建子线程
//- (dispatch_queue_t)recordQueue{
//    if (!_recordQueue) {
//        _recordQueue = dispatch_queue_create("record.soundai", DISPATCH_QUEUE_CONCURRENT);
//    }
//    return _recordQueue;
//}


@end


