//
//  AzeroPlatformInterface.h
//  AzeroSDKWrapper
//
//  Created by nero on 2020/2/25.
//  Copyright © 2020 nero. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AACE/Core/PlatformInterface.h>

NS_ASSUME_NONNULL_BEGIN

@interface AzeroPlatformInterface : NSObject

//virtual
-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr;

@end

NS_ASSUME_NONNULL_END
