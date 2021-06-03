//
//  UserInfoContext.h
//  xiaoyixiu
//
//  Created by hanzhanbing on 16/6/17.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootUser.h"
#import "ZXCTimer.h"
#import "WNSoundEquipmentModelV2.h"
@interface UserInfoContext : NSObject

//由大适配小的比例，masnory中用到
@property(nonatomic, assign) float autoSizeScaleX;
@property(nonatomic, assign) float autoSizeScaleY;

//由小适配大的比例，CGRectMake1中用到
@property(nonatomic, assign) float rectScaleX;
@property(nonatomic, assign) float rectScaleY;
//全局计时器
@property(nonatomic,strong)ZXCCyclesQueueItem *timerQueueItem ;
@property(nonatomic,strong)ZXCCyclesQueueItem *queueItem ;
@property(nonatomic,strong)ZXCCyclesQueueItem *cyclesQueueItem ;

@property (nonatomic,assign) int currentTime;
@property (nonatomic,strong) NSString * startTime;
@property (nonatomic,strong) NSString * currentDistance;
@property (nonatomic,strong) NSDictionary * walkDiction;



//当前登录的用户
@property (nonatomic, strong) RootUser *currentUser;

///UUID
@property (nonatomic, strong)NSString *UUID;

@property (nonatomic, strong)NSString *longitude;//经度
@property (nonatomic, strong)NSString *latitude;//纬度
@property (nonatomic, strong)NSString *city;//城市
@property (nonatomic, strong)NSString *address;//城市
@property (nonatomic, assign)BOOL isJump;//是否跳转

+ (UserInfoContext *)sharedContext; //单例


@property (nonatomic ,strong) WNSoundEquipmentModelV2 *currentSpeakersV2;

@property (nonatomic ,strong) NSMutableArray *deviceModelAry;

@end
