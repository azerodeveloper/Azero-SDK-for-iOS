//
//  AzeroModeObserver.h
//  test000
//
//  Created by nero on 2020/4/10.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include <AACE/OpenDenoise/ModeObserver.h>

NS_ASSUME_NONNULL_BEGIN


@interface AzeroModeObserver : AzeroPlatformInterface
//virtual
-(bool) onModeChangePrepare:(const aace::openDenoise::ModeObserverInterface::ModeConfiguration &)config;

//virtual
-(void) onModeChangeCancelled:(const aace::openDenoise::ModeObserverInterface::ModeConfiguration &)config;

//virtual
-(void) onChangeMode:(const aace::openDenoise::ModeObserverInterface::ModeConfiguration &)config;

//virtual
-(void) onModeChanged:(const aace::openDenoise::ModeObserverInterface::ModeConfiguration &)config;

//virtual
-(void) onModeChangeFailed;

//virtual
-(void) onModeSystemShutDown;

//virtual
-(void) onModeExecutionException;

@end

NS_ASSUME_NONNULL_END
