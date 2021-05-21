//
//  XYRecorder.h
//  XYRealTimeRecord
//
//  Created by zxy on 2017/3/17.
//  Copyright © 2017年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYRecorder : NSObject

singleton_h(Recorder);
- (void)initRemoteIO ;
- (void)startRecorder;
- (void)stopRecorder;

- (void)saveVoiceData;

@end
