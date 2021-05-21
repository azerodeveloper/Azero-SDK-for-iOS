//
//  SaiTextInputModel.h
//  HeIsComing
//
//  Created by silk on 2020/4/1.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiTextInputModel : NSObject
+ (NSString *)azeroTextInputEvent:(NSString *)eventText;

+ (NSString *)azeroTtsTextInputEvent:(NSString *)eventText;


+ (NSString *)azeroModelSwitchWithMode:(NSString *)mode andValue:(BOOL )value;

+ (NSString *)azeroModelRunSensorDataWithCalorie:(NSNumber * )calorie andDistance:(NSNumber * )distance
andDuration:(NSNumber * )duration andStartTime:(NSNumber * )startTime andEndTime:(NSNumber * )endTime;

+ (NSString *)azeroModelWalkSensorDataWithCalorie:(NSNumber * )calorie  andDistance:(NSNumber * )distance andStepCount:(NSNumber * )stepCount;
+ (NSString *)azeroModelAcquireType:(NSString * )acquireType contentId:(NSString *)contentId  count:(int )count;
+ (NSString *)azeroManagerAnswerQuestion:(NSDictionary *)payload;

+ (NSString *)azeroModelAction:(NSString * )action  position:(NSString * )position selectedPosition:(NSString * )selectedPosition andResourceId:(NSString * )resourceId andkeyword:(NSString * )keyword;

+ (NSString *)azeroModelAction:(NSString * )action  position:(NSString * )position selectedPosition:(NSString * )selectedPosition andResourceId:(NSString * )resourceId andkeyword:(NSString * )keyword acquireType:(NSString *)acquireType;
@end

NS_ASSUME_NONNULL_END
