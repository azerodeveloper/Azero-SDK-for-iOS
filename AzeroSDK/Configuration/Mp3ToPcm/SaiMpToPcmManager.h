//
//  SaiMpToPcmManager.h
//  AzeroDemo
//
//  Created by silk on 2020/5/15.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiMpToPcmManager : NSObject
singleton_h(SaiMpToPcmManager);
@property (nonatomic ,assign) BOOL isTimer;

- (void)prepareConversionAudio;
- (void)setup;
- (void)stopTimer;
//- (void)writeData;
- (void)memsetBuffer;
@end

NS_ASSUME_NONNULL_END
