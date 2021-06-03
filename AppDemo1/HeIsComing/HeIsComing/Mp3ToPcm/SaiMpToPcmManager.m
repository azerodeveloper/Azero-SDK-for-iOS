//
//  SaiMpToPcmManager.m
//  HeIsComing
//
//  Created by silk on 2020/5/15.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiMpToPcmManager.h"
#import <lame/lame.h>
#import "GKTimer.h"
#define MP3FRAMELEN (1152)
const int mp3Size = MP3FRAMELEN*20;
static char mp3Buffer[mp3Size];

@interface SaiMpToPcmManager ()
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) BOOL isTimerRunning;
@property (nonatomic ,assign) lame_t lame;
@property (nonatomic ,assign) hip_t l;
//@property (nonatomic ,strong) NSMutableData *allData;


@end

@implementation SaiMpToPcmManager
singleton_m(SaiMpToPcmManager);
- (void)setup{
    self.lame = lame_init();
    self.l = hip_decode_init();
    lame_set_in_samplerate(self.lame, 16000);
    lame_set_decode_only(self.lame, 1);
    lame_set_VBR(self.lame, vbr_default);
    lame_set_mode(self.lame, MONO);
    lame_init_params(self.lame);
}
- (void)prepareConversionAudio{
    self.isTimer = YES;
    if (self.isTimerRunning) {
        [self stopTimer];
        [self startNimer];
    }else{
        [self startNimer];
    }  
}
- (void)startNimer{
    [[AudioQueuePlay sharedAudioQueuePlay] playQueueStart];
    self.timer = [GKTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(readData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
    self.isTimerRunning = YES;
}
- (void)readData{
    //    TYLog(@"------------***********************************----------------------------------------计时器开始");
    [self readDataWithHgf:self.l];

}
- (void)readDataWithHgf:(hip_t )l{
    ssize_t i = [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReadDataWith:mp3Buffer andSize:mp3Size];
    if (i!=0) {
        int ret = 0;
        int tail = 0;
        short *pcm_buffer_l = (short *)malloc(MP3FRAMELEN*20);
        short *pcm_buffer_r = (short *)malloc(MP3FRAMELEN*20);
        unsigned char * unMp3Buffer = (unsigned char *)mp3Buffer;
        while(tail+MP3FRAMELEN < i) {
            memset((void *)pcm_buffer_l, 0, MP3FRAMELEN*20);
            memset((void *)pcm_buffer_r, 0, MP3FRAMELEN*20);
            ret = hip_decode(l, unMp3Buffer+tail, MP3FRAMELEN, pcm_buffer_l, pcm_buffer_r);

//            TYLog(@"转化的数据长度是 %d ",ret);
            tail += MP3FRAMELEN;
            if (ret !=0 )
            {
                @autoreleasepool {
                    if (self.isTimer) {
                        NSData *data = [NSData dataWithBytes:pcm_buffer_l length:ret*(sizeof(unsigned short))];
//                        [self.allData appendData:data];
//                                            TYLog(@"playWithData上 --- 当前的线程是%@",[NSThread currentThread]);
                        [[AudioQueuePlay sharedAudioQueuePlay] playWithData:data];
                    }
                }
            } else {
                continue;
            }
        }
        if ((i-tail)>0) {
            memset((void *)pcm_buffer_l, 0, MP3FRAMELEN*20);
            memset((void *)pcm_buffer_r, 0, MP3FRAMELEN*20);
            ret = hip_decode(l, unMp3Buffer+tail, i-tail, pcm_buffer_l, pcm_buffer_r);
//            TYLog(@"转化的数据长度是 %d ",ret);
            if (ret!=0)
            {
                @autoreleasepool {
                    if (self.isTimer) {
                        NSData *data = [NSData dataWithBytes:pcm_buffer_l length:ret*(sizeof(unsigned short))];
//                        [self.allData appendData:data];
//                                            TYLog(@"playWithData下 --- 当前的线程是%@",[NSThread currentThread]);
                        [[AudioQueuePlay sharedAudioQueuePlay] playWithData:data];
                    }
                }
            } else {
//                TYLog(@"转化的数据长度是 %d ",ret);

            }
        } else {
            //
//            TYLog(@"转化的数据长度是 %d ",ret);

            hip_decode_exit(self.l);
            usleep(20);
        }
        free(pcm_buffer_l);
        free(pcm_buffer_r);
    }
    BOOL  isClosed = [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReadDataComplete];
    if (isClosed) {
        TYLog(@"------------***********************************----------------------------------------isClosed == yes");
        [self stopTimer];
        
        [[AudioQueuePlay sharedAudioQueuePlay] stopPlay];
    }
}
- (void)stopTimer{
    if (self.timer) {
        [self.timer invalidate];
           self.timer = nil;
           self.isTimerRunning = NO;
    }
    //    TYLog(@"------------***********************************----------------------------------------计时器停止");
}

- (void)memsetBuffer{
    lame_encode_flush_nogap(self.lame,(void *) mp3Buffer, sizeof(mp3Buffer));
    memset((void *)mp3Buffer, 0, MP3FRAMELEN*20);
}

//- (NSMutableData *)allData{
//    if (_allData == nil) {
//        _allData = [NSMutableData data];
//    }
//    return _allData;
//}

@end
