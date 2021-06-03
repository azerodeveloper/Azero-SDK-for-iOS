//
//  SaiTextInputModel.m
//  HeIsComing
//
//  Created by silk on 2020/4/1.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiTextInputModel.h"

@implementation SaiTextInputModel
+ (NSString *)azeroTextInputEvent:(NSString *)eventText{
    NSString *messageId = [SaiUIUtils generateTradeNOWith:32];
    NSDictionary *dic = @{
        @"event":@{
                @"header":@{
                        @"namespace":@"AzeroExpress",
                        @"name":@"TextInput",
                        @"messageId":messageId,
                        @"dialogRequestId":@""
                },
                @"payload":@{
                        @"text":eventText,
                }
        }
    };
    NSString *jsonStr = [SaiJsonConversionModel dictionaryToJson:dic];
    return jsonStr;
}
+ (NSString *)azeroTtsTextInputEvent:(NSString *)eventText{
    NSString *messageId = [SaiUIUtils generateTradeNOWith:32];
    NSDictionary *dic = @{
        @"event":@{
                @"header":@{
                        @"namespace":@"AzeroExpress",
                        @"name":@"AcquireTTS",
                        @"messageId":messageId,
                },
                @"payload":@{
                        @"format":@"plainText",
                        @"content":eventText,
                }
        }
    };
    NSString *jsonStr = [SaiJsonConversionModel dictionaryToJson:dic];
    return jsonStr;
}

+ (NSString *)azeroModelSwitchWithMode:(NSString *)mode andValue:(BOOL )value{
    NSString *messageId = [SaiUIUtils generateTradeNOWith:11];
    NSDictionary *dic = @{
        @"event":@{
                @"header":@{
                        @"namespace":@"AzeroExpress",
                        @"name":@"SwitchLocaleMode",
                        @"messageId":messageId,
                        @"dialogRequestId":@""
                },
                @"payload":@{
                        @"mode":mode,
                        @"value":value?@"ON":@"OFF"
                }
        }
    };
    NSString *jsonStr = [SaiJsonConversionModel dictionaryToJson:dic];
    return jsonStr;
}
+ (NSString *)azeroModelAcquireType:(NSString * )acquireType contentId:(NSString *)contentId  count:(int )count {
    NSString *messageId = [SaiUIUtils generateTradeNOWith:11];
    NSDictionary *dic = @{
        @"event":@{
                @"header":@{
                        @"namespace":@"AzeroExpress",
                        @"name":@"AcquireLauncher",
                        @"messageId":messageId,
                        @"dialogRequestId":@""
                },
                @"payload":@{
                        @"acquireType":acquireType,
                        @"contentId":contentId,
                        @"count":[NSNumber numberWithInt:count],

                }
        }
    };
    NSString *jsonStr = [SaiJsonConversionModel dictionaryToJson:dic];
    return jsonStr;
}

+ (NSString *)azeroModelRunSensorDataWithCalorie:(NSNumber * )calorie andDistance:(NSNumber * )distance
                                   andDuration:(NSNumber * )duration andStartTime:(NSNumber * )startTime andEndTime:(NSNumber * )endTime{
  
    NSString *messageId = [SaiUIUtils generateTradeNOWith:11];
    NSDictionary *dic = @{
        @"event":@{
                @"header":@{
                        @"namespace":@"AzeroExpress",
                        @"name":@"SensorData",
                        @"messageId":messageId,
                },
                @"payload":@{
                        @"run":@{
                                @"Id":[NSNumber numberWithLong:([NSDate timeStamp].longLongValue+messageId.longLongValue)],
                                @"Calorie":calorie,
                                @"DataTag":[QKUITools getNowyyyymmdd],
                                @"Distance":distance,
                                @"Duration":duration,
                                @"StartTime":startTime,
                                @"EndTime":endTime
                        }
                }
        }
    };
    NSString *jsonStr = [SaiJsonConversionModel dictionaryToJson:dic];
    return jsonStr;
}
+ (NSString *)azeroModelWalkSensorDataWithCalorie:(NSNumber * )calorie  andDistance:(NSNumber * )distance andStepCount:(NSNumber * )stepCount{
    NSString *messageId = [SaiUIUtils generateTradeNOWith:11];
    NSDictionary *dic = @{
        @"event":@{
                @"header":@{
                        @"namespace":@"AzeroExpress",
                        @"name":@"SensorData",
                        @"messageId":messageId,
                },
                @"payload":@{
                        @"walk":@{
                                @"Calorie":calorie,
                                @"DataTag":[QKUITools getNowyyyymmdd],
                                @"Distance":distance,
                                @"StepCount":stepCount
                        }
                }
        }
    };
    NSString *jsonStr = [SaiJsonConversionModel dictionaryToJson:dic];
    return jsonStr;
}
+ (NSString *)azeroManagerAnswerQuestion:(NSDictionary *)payload{
    NSString *messageId = [SaiUIUtils generateTradeNOWith:11];
    NSDictionary *dic = @{
        @"event":@{
                @"header":@{
                        @"namespace":@"AzeroExpress",
                        @"name":@"UserEvent",
                        @"messageId":messageId,
                },
                @"payload":payload
        }
    };
    NSString *jsonStr = [SaiJsonConversionModel dictionaryToJson:dic];
    return jsonStr;
}
@end
