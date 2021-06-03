//
//  AzeroModeControl.h
//  test000
//
//  Created by nero on 2020/4/10.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include "ModeControlHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface AzeroModeControl : AzeroPlatformInterface
-(bool) restartOpenDenoise;
@end

NS_ASSUME_NONNULL_END
