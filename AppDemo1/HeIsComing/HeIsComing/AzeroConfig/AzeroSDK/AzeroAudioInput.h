//
//  AzeroAudioInput.h
//  test000
//
//  Created by nero on 2020/3/20.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"

NS_ASSUME_NONNULL_BEGIN
//灌语音
@interface AzeroAudioInput : AzeroPlatformInterface
-(bool) writeData:(const char *)data withSize:(size_t)size;
@end

NS_ASSUME_NONNULL_END
