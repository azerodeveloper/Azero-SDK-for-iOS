//
//  AzeroEngine.h
//  AzeroSDKWrapper
//
//  Created by nero on 2020/2/25.
//  Copyright © 2020 nero. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AACE/Core/Engine.h>
#import "AzeroPlatformInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface AzeroEngine : NSObject
-(bool) configure:(NSArray *)paths;
-(bool) start;
-(bool) stop;
-(bool) shutdown;
-(bool) setProperty:(NSString *)key withValue:(NSString *)value;
-(NSString *) getProperty:(NSString *)key;
-(bool) setInteractMode:(int)mode;
-(bool) registerPlatformInterface:(AzeroPlatformInterface *)platformInterface;
-(bool) registerPlatformInterfaceWithRawPtr:(std::shared_ptr<aace::core::PlatformInterface>)ptr;
@end

NS_ASSUME_NONNULL_END
