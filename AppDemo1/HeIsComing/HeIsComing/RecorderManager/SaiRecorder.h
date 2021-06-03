//
//  SaiRecorder.h
//  HeIsComing
//
//  Created by silk on 2020/8/11.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>
#define QUEUE_BUFFER_SIZE 6//队列缓冲个数
#define MIN_SIZE_PERFRAME 1024 //每帧最小数据长度

@interface SaiRecorder : NSObject
singleton_h(SaiRecorder);
- (void)startRecord;
- (void)endRecord;
- (void)saveVoiceData;
- (void)resetRecorder;
- (void)recordQueueFlush;
- (void)resetCorderQueue;
@end

