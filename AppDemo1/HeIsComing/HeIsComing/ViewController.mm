//
//  ViewController.m
//  test000
//
//  Created by silk on 2020/2/19.
//  Copyright © 2020 soundai. All rights reserved.
//
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Mp3ToPcm/lame.framework/Headers/lame.h"
#import "XYRecorder.h"
#import "SaiMusicListModel.h"
#import "SaiMusicListController.h"
#import "GKAudioPlayer.h"
#import "GKTimer.h"
#import "AudioQueuePlay.h"
#import "SaiAzeroManager.h"


#define MP3FRAMELEN (1152)

extern void UpdateFileAudioOutputFolderName(const char *folder);

const int mp3Size = 1152*20;
static char mp3Buffer[mp3Size];
//const int MP3_SIZE = 1152*20;
//const int PCM_SIZE = MP3_SIZE*10;
//static short pcm_buffer_l[PCM_SIZE];
//static short pcm_buffer_r[PCM_SIZE];
static lame_t lame = lame_init();
static hip_t l = hip_decode_init();

@interface ViewController(){
    UISlider* _volumeSlider;
    UIView* _volumeView;//声音
    UIProgressView* _volumeProgress;
}

@property (nonatomic ,strong) NSTimer *readTimer;
@property (nonatomic ,strong) UIButton *startRecordButton;
@property (nonatomic ,strong) UIButton *stopRecordButton;
@property (nonatomic ,strong) NSMutableArray *musicListAry;
@property (nonatomic ,strong) GKWYMusicModel *currentModel;
@property (nonatomic ,strong) NSMutableData *pcmMutableData;

@property (nonatomic ,copy) NSString *audioItemId;
@end

@implementation ViewController{
    float aa0 ;
}
#pragma mark -  Life Cycle
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)eventP{
    [super touchesBegan:touches withEvent:eventP];
//    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSentTxet:@"获取指南球体数据"];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self registerNoti];
//    [self setupAzeroSdk];
//    [self setupUI];
//    [self setupMp3ToPcm];

}

#pragma mark -  UITableViewDelegate
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Methods
/**
 * @brief 将字符串转化为控制器.
 *
 * @param str 需要转化的字符串.
 *
 * @return 控制器(需判断是否为空).
 */
- (UIViewController*)stringChangeToClass:(NSString *)str {
    id vc = [[NSClassFromString(str) alloc]init];
    if ([vc isKindOfClass:[UIViewController class]]) {
        return vc;
    }
    return nil;
}
- (void)saiWeatherCallback:(NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = noti.userInfo;
        NSDictionary *classDiction=@{@"WeatherTemplate":@"SaiWeatherViewController"};
        NSString *classString=[SaiJsonConversionModel dictionaryWithJsonString:dict[@"payload"]][@"type"];
        UIViewController* vc = [self stringChangeToClass:classDiction[classString]];


         if(vc) {


         [self.navigationController pushViewController:vc animated:YES];

         }

        
    });
}
- (void)saiSongList:(NSNotification *)noti{
    
}
- (void)outputDeviceChanged:(NSNotification *)noti{
 
}
#pragma mark -  Button Callbacks
- (void)recordButtonClickCallBack:(UIButton *)button{
    //注释 test
    [button setBackgroundColor:[UIColor blueColor]];
    [self.stopRecordButton setBackgroundColor:[UIColor orangeColor]];
    [[XYRecorder sharedRecorder] startRecorder];
}

- (void)stopRecordButtonClickCallBack:(UIButton *)button{
//    [SaiSoundWaveView dismissHud];
    [button setBackgroundColor:[UIColor blueColor]];
    [self.startRecordButton setBackgroundColor:[UIColor orangeColor]];
    [[XYRecorder sharedRecorder] stopRecorder];
}

#pragma mark -  Private Methods
- (void)setupUI{
    UIButton *recordButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 100, 100)];
    recordButton.backgroundColor = [UIColor orangeColor];
    [recordButton addTarget:self action:@selector(recordButtonClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [recordButton setTitle:@"录音" forState:UIControlStateNormal];
    [self.view addSubview:recordButton];
    self.startRecordButton = recordButton;
    
    UIButton *stopRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 300, 100, 100)];
    stopRecordButton.backgroundColor = [UIColor orangeColor];
    [stopRecordButton addTarget:self action:@selector(stopRecordButtonClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [stopRecordButton setTitle:@"停止录音" forState:UIControlStateNormal];
    [self.view addSubview:stopRecordButton];
    self.stopRecordButton = stopRecordButton;
}
- (void)setupAzeroSdk{
    [[SaiAzeroManager sharedAzeroManager] setUpAzeroSDK];
    __weak typeof(self)weakSelf = self;
    [[SaiAzeroManager sharedAzeroManager] saiAzeroPlayTtsStatePrepare:^{
       dispatch_async(dispatch_get_main_queue(), ^{
          [[XYRecorder sharedRecorder] stopRecorder];
           weakSelf.readTimer = [GKTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(readData) userInfo:nil repeats:YES];
       });
    }];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroPlaySongUrl:^(NSString *songUrl) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.currentModel.file_link = songUrl;            
            [SaiNotificationCenter postNotificationName:SaiRegisteredSingleton object:nil];

        });
    }];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroSongListInfo:^(NSString *songListStr) {
//        TYLog(@"ViewController ---------------- %@",songListStr);
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [weakSelf.musicListAry removeAllObjects];
//             NSDictionary *dataDic = [SaiJsonConversionModel dictionaryWithJsonString:songListStr];
//             NSString *audioItemId = dataDic[@"audioItemId"];
//            if ([self.audioItemId isEqualToString:audioItemId]) {
//                return ;
//            }else{
//                self.audioItemId = audioItemId;
//            }
//             NSArray *dicAry = dataDic[@"contents"];
//             for (NSDictionary *dic in dicAry) {
//                 SaiMusicListModel *model = [[SaiMusicListModel alloc] init];
//                 model.title = dic[@"title"];
//                 model.header = dic[@"header"];
//                 model.art = dic[@"art"];
//                 model.provider = dic[@"provider"];
//                 NSDictionary *artDic = dic[@"art"];
//                 NSArray *sourcesAry = artDic[@"sources"];
//                 NSDictionary *sourcesDic = [sourcesAry firstObject];
//                 model.pic_url = sourcesDic[@"url"];
//                 [weakSelf.musicListAry addObject:model];
//             }
//
//             SaiMusicListModel *ListModel = weakSelf.musicListAry[0];
//             GKWYMusicModel *model = [[GKWYMusicModel alloc] init];
//             model.song_name = ListModel.title;
//             model.pic_big = ListModel.pic_url;
//             model.pic_small = ListModel.pic_url;
//             model.lrclink = ListModel.provider[@"lyric"];
//             model.album_title = ListModel.provider[@"album"];
//             model.artist_name = ListModel.provider[@"name"];
//             weakSelf.currentModel = model;
//
//             SaiMusicListController *musicListController = [[SaiMusicListController alloc] init];
//             musicListController.audioItemId = audioItemId;
//             musicListController.modelAry = weakSelf.musicListAry;
//             UINavigationController *navMusicListController = [[UINavigationController alloc] initWithRootViewController:musicListController];
//             navMusicListController.modalPresentationStyle = UIModalPresentationFullScreen;
//             [weakSelf presentViewController:navMusicListController animated:YES completion:^{
//                 musicListController.currentModel = model;
//             }];//
//        });
    }];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerRenderTemplate:^(NSString *renderTemplateStr) {
        TYLog(@"获取的球体的信息是 %@",renderTemplateStr);
    }];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerExpress:^(NSString *type, NSString *content) {
        TYLog(@"-----------------------expresstype:%@ content:%@",type,content);
    }];
}

- (void)registerNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordCallback:) name:@"RecordCallback" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ttsPlayComplete:) name:@"TtsPlayComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputDeviceChanged:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
}

- (void)setupMp3ToPcm{
//    memset(pcm_buffer_r, 0, sizeof(pcm_buffer_r));
    lame_set_in_samplerate(lame, 16000);
    lame_set_decode_only(lame, 1);
    lame_set_VBR(lame, vbr_default);
    lame_set_mode(lame, MONO);
    lame_init_params(lame);
}

#pragma mark -  Public Methods
#pragma mark -  Setters and Getters
- (NSMutableArray *)musicListAry{
    if (_musicListAry == nil) {
        _musicListAry = [NSMutableArray array];
    }
    return _musicListAry;
}
- (void)recordCallback:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    NSData *data = dict[@"data"];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerWriteData:data];
//    NSMutableData *allData = [NSMutableData data];
//    float num = data.length/2;
//    for (int i=0; i<num; i++) {
//        NSData *firstData = [data subdataWithRange:NSMakeRange(i*2, 2)];
//        Byte byte[] = {0x00,0x00};
//        NSData *sedData = [NSData dataWithBytes:byte length:sizeof(byte)];
//        [allData appendData:firstData];
//        [allData appendData:sedData];

//    [self.audioInput writeData:(const char *)allData.bytes withSize:allData.length];
}

- (void)ttsPlayComplete:(NSNotification *)noti{
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReportPlayStateStop];
    [[AudioQueuePlay sharedAudioQueuePlay] resetPlay];
    [[AudioQueuePlay sharedAudioQueuePlay] audioQueueFlush];
    [[XYRecorder sharedRecorder] startRecorder];
    TYLog(@"-------------------------------------------------------------------------------------------TTS播报完成");
}

- (void)stopReadData{
//    TYLog(@"停止播放");
//    hip_decode_exit(l);
//    lame_close(lame);
    [self.readTimer invalidate];
    self.readTimer = nil;
//    [self.streamPlayer stop];
}
- (void)readData{
    [self readDataWithHgf:l];
}
- (void)readDataWithHgf:(hip_t )l{
    ssize_t i = [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReadDataWith:mp3Buffer andSize:mp3Size];
    if (i!=0) {
        int ret;
        int tail = 0;
        unsigned char * unMp3Buffer = (unsigned char *)mp3Buffer;
        short *pcm_buffer_l = (short *)malloc(MP3FRAMELEN*20);
        short *pcm_buffer_r = (short *)malloc(MP3FRAMELEN*20);
        while(tail+MP3FRAMELEN < i) {
//            TYLog(@"hip_decode --- 之前");
            memset((void *)pcm_buffer_l, 0, MP3FRAMELEN*20);
            ret = hip_decode(l, unMp3Buffer+tail, MP3FRAMELEN, pcm_buffer_l, pcm_buffer_r);
            tail += MP3FRAMELEN;
//            TYLog(@"hip_decode --- 之后");
            if (ret !=0 ) {
                TYLog(@"hip_decode !0");
                NSData *data = [NSData dataWithBytes:pcm_buffer_l length:ret*(sizeof(unsigned short))];
                [self.pcmMutableData appendData:data];
                TYLog(@"-----------------------------------------------------------------------------------------播放的数据:%@ ",data);
                [[AudioQueuePlay sharedAudioQueuePlay] playWithData:data];
            } else {
                TYLog(@"hip_decode 0");
                continue;
            }
            
        }
        if ((i-tail)>0) {
            memset((void *)pcm_buffer_l, 0, MP3FRAMELEN*20);
            ret = hip_decode(l, unMp3Buffer+tail, i-tail, pcm_buffer_l, pcm_buffer_r);
            if (ret!=0)
            {
                TYLog(@"hip_decode last frame !0");
                NSData *data = [NSData dataWithBytes:pcm_buffer_l length:ret*(sizeof(unsigned short))];
                TYLog(@"-----------------------------------------------------------------------------------------播放的数据:%@ ",data);
                [self.pcmMutableData appendData:data];
                [[AudioQueuePlay sharedAudioQueuePlay] playWithData:data];
            } else {
                TYLog(@"hip_decode last frame 0");
            }
        } else {
            usleep(20);
        }
        free(pcm_buffer_l);
        free(pcm_buffer_l);
    }
    BOOL  isClosed = [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerReadDataComplete];
    if (isClosed) {
        [self stopReadData];
        [[AudioQueuePlay sharedAudioQueuePlay] stopPlay];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *fileAudioFolderPath =[NSString stringWithFormat:@"%@/callBackData.pcm",docDir];
        [self.pcmMutableData writeToFile:fileAudioFolderPath options:NSDataWritingAtomic error:NULL];
        TYLog(@"-----------------------------------------------------------------------------------------audioQueuePlayManagerStopPlay");
    }
}




- (NSMutableData *)pcmMutableData{
    if (_pcmMutableData == nil) {
        _pcmMutableData = [NSMutableData data];
    }
    return _pcmMutableData;
}
@end
