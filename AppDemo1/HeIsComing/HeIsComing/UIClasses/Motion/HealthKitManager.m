//
//  HealthKitManager.m
//  BJTResearch
//
//  Created by yunlong on 2017/6/9.
//  Copyright © 2017年 yunlong. All rights reserved.
//

#import "HealthKitManager.h"
#import <HealthKit/HealthKit.h>
@interface HealthKitManager ()
//HKHealthStore类提供用于访问和存储用户健康数据的界面。
@property (nonatomic, strong) HKHealthStore *healthStore;
@end
@implementation HealthKitManager

#pragma mark - 健康单例
+ (instancetype)sharedInstance {
    static HealthKitManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HealthKitManager alloc] init];
    });
    return instance;
}


#pragma mark - 检查是否支持获取健康数据
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion {
    if (![HKHealthStore isHealthDataAvailable]) {
        NSError *error = [NSError errorWithDomain: @"不支持健康数据" code: 2 userInfo: [NSDictionary dictionaryWithObject:@"HealthKit is not available in th is Device"                                                                      forKey:NSLocalizedDescriptionKey]];
        if (compltion != nil) {
            compltion(NO, error);
        }
        return;
    }else{
        if(self.healthStore == nil){
            self.healthStore = [[HKHealthStore alloc] init];
        }
        //组装需要读写的数据类型
        NSSet *writeDataTypes = [self dataTypesToWrite];
        NSSet *readDataTypes = [self dataTypesToWrite];
        HKObjectType *hkObjectType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        
        HKAuthorizationStatus hkAuthStatus = [self.healthStore authorizationStatusForType:hkObjectType];
        switch (hkAuthStatus) {
            case HKAuthorizationStatusSharingDenied:{
                if (compltion != nil) {
                    compltion(NO, nil);
                }
            }
                break;
                
                
            default:
            {
                //注册需要读写的数据类型，也可以在“健康”APP中重新修改
                [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
                    
                    if (compltion != nil) {
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HealthKitManager"];
                        TYLog(@"error->%@", error.localizedDescription);
                        compltion (YES, error);
                    }
                }];
            }
                break;
        }
        
    }
}

#pragma mark - 写权限
- (NSSet *)dataTypesToWrite{
    //步数
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    // 步行+跑步距离
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    //    //身高
    //    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    //    //体重
    //    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    //    //活动能量
    //    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    //    //体温
    //    HKQuantityType *temperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    //    //睡眠分析
    //    HKCategoryType *sleepAnalysisType = [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    return [NSSet setWithObjects:stepCountType,distanceType,nil];
}


#pragma mark - 获取步数
- (void)getStepCount:(void(^)(NSString *stepValue, NSError *error))completion{
    
    //要检索的数据类型。
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    //NSSortDescriptors用来告诉healthStore怎么样将结果排序。
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    /*
     @param         sampleType      要检索的数据类型。
     @param         predicate       数据应该匹配的基准。
     @param         limit           返回的最大数据条数
     @param         sortDescriptors 数据的排序描述
     @param         resultsHandler  结束后返回结果
     */
    HKSampleQuery*query = [[HKSampleQuery alloc] initWithSampleType:stepType predicate:[HealthKitManager getStepPredicateForSample] limit:HKObjectQueryNoLimit sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if(error){
            completion(0,error);
        }else{
            //把结果装换成字符串类型
            double totleSteps = 0;
            for(HKQuantitySample *quantitySample in results){
                HKQuantity *quantity = quantitySample.quantity;
                NSDictionary *diction=quantitySample.metadata;
#pragma mark 筛选用户自己修改的数据
                NSInteger wasUserEntered = [diction[@"HKWasUserEntered"]integerValue];
                if(wasUserEntered != 1)
                {
                    HKUnit *heightUnit = [HKUnit countUnit];
                    double usersHeight = [quantity doubleValueForUnit:heightUnit];
                    totleSteps += usersHeight;
                }
                
            }
            
            TYLog(@"最新步数：%ld",(long)totleSteps);
            completion([NSString stringWithFormat:@"%ld",(long)totleSteps],error);
        }
    }];
    [self.healthStore executeQuery:query];
}
- (void)getDistanceCount:(void(^)(NSString *distancepValue, NSError *error))completion{
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:distanceType predicate:[HealthKitManager getStepPredicateForSample] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        if(error)
        {
            completion(0,error);
        }
        else
        {
            double totleSteps = 0;
            for(HKQuantitySample *quantitySample in results)
            {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *distanceUnit = [HKUnit meterUnitWithMetricPrefix:HKMetricPrefixKilo];
                double usersHeight = [quantity doubleValueForUnit:distanceUnit];
                totleSteps += usersHeight;
            }
            
            TYLog(@"当天行走距离 = %.2f",totleSteps);
            completion([NSString stringWithFormat:@"%.2f",totleSteps],error);
        }
    }];
    [self.healthStore executeQuery:query];
    
}

#pragma mark - 获取睡眠(昨天12点到今天12点)
- (void)getSleepCount:(void(^)(NSString *sleepValue, NSError *error))completion{
    
    //要检索的数据类型。
    HKSampleType *sleepType = [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:false];
    
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:sleepType predicate:[HealthKitManager getSleepPredicateForSample] limit:HKObjectQueryNoLimit sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            
            TYLog(@"=======%@", error.domain);
        }else{
            TYLog(@"resultCount = %ld result = %@",results.count,results);
            NSInteger totleSleep = 0;
            for (HKCategorySample *sample in results) {//0：卧床时间 1：睡眠时间  2：清醒状态
                TYLog(@"=======%@=======%ld",sample, sample.value);
                if (sample.value == 1) {
                    NSTimeInterval i = [sample.endDate timeIntervalSinceDate:sample.startDate];
                    totleSleep += i;
                }
            }
            
            TYLog(@"睡眠分析：%.2f",totleSleep/3600.0);
            completion([NSString stringWithFormat:@"%.2f",totleSleep/3600.0],error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}


#pragma mark - 当天时间段
+ (NSPredicate *)getStepPredicateForSample {
    NSDate *now = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *startFormatValue = [NSString stringWithFormat:@"%@000000",[formatter stringFromDate:now]];
    NSString *endFormatValue = [NSString stringWithFormat:@"%@235959",[formatter stringFromDate:now]];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate * startDate = [formatter dateFromString:startFormatValue];
    NSDate * endDate = [formatter dateFromString:endFormatValue];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

#pragma mark - 昨天12点到今天12点
+ (NSPredicate *)getSleepPredicateForSample {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    //今天12点
    NSDate *now = [NSDate date];
    NSString *endFormatValue = [NSString stringWithFormat:@"%@120000",[formatter stringFromDate:now]];
    
    //昨天12点
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:now];//前一天
    NSString *startFormatValue = [NSString stringWithFormat:@"%@120000",[formatter stringFromDate:lastDay]];
    
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate * startDate = [formatter dateFromString:startFormatValue];
    NSDate * endDate = [formatter dateFromString:endFormatValue];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

@end
