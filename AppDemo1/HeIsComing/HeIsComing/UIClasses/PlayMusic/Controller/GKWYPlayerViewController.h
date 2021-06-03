//
//  GKWYPlayerViewController.h
//  GKWYMusic
//
//  Created by gaokun on 2018/4/19.
//  Copyright © 2018年 gaokun. All rights reserved.
//  播放器页面

typedef NS_ENUM(NSUInteger, GKWYPlayerPlayStyle) {
    GKWYPlayerPlayStyleLoop,        // 循环播放
    GKWYPlayerPlayStyleOne,         // 单曲循环
    GKWYPlayerPlayStyleRandom       // 随机播放
};

#define kWYPlayerVC [GKWYPlayerViewController sharedInstance]

#import "GKNavigationBarViewController.h"
#import "GKWYMusicModel.h"

@interface GKWYPlayerViewController : GKNavigationBarViewController
/**
 看美剧学英语
*/
@property (nonatomic ,assign) BOOL isEnglish;

@property (nonatomic, assign) BOOL                  is_Asmr;       // 是否是ASMR

@property (nonatomic, assign) GKWYPlayerPlayStyle   playStyle;      // 循环类型


@property (nonatomic, copy) NSArray  * menuListItems;      // 循环类型


/** 当前播放的音频的id */
@property (nonatomic, copy) NSString *song_name;


/** 是否发送 */
@property (nonatomic, assign) BOOL isNotSendBack;
/** 是否正在播放 */
@property (nonatomic, assign) BOOL isPlaying;

@property(nonatomic,assign)MediaType mediaType;

@property (copy, nonatomic) void(^textblock)(NSString *text);

/**
 播放状态
 */
@property (nonatomic, assign) GKAudioPlayerState    playerState;
+ (instancetype)sharedInstance;

/**
 初始化播放器数据
 */
- (void)initialData;

/**
 重置播放器id列表

 @param playList 列表
 */
- (void)setPlayerList:(NSArray *)playList;

/**
 根据索引及列表播放音乐
 
 @param index 列表中的索引
 @param isSetList 列表
 */
- (void)playMusicWithIndex:(NSInteger)index isSetList:(BOOL)isSetList;

/**
 播放单个音频

 @param model 单个音频数据模型
 */
- (void)playMusicWithModel:(GKWYMusicModel *)model;



/**
 播放
 */
- (void)playMusic;

/**
 暂停
 */
- (void)pauseMusic;

/**
 停止
 */
- (void)stopMusic;

/**
 下一曲
 */
- (void)playNextMusic;

/**
 上一曲
 */
- (void)playPrevMusic;




@end
