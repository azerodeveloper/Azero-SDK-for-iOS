//
//  AzeroNavigation.h
//  AzeroDemo
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include <AACE/Navigation/Navigation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AzeroNavigation : AzeroPlatformInterface

//virtual
-(bool) setDestination:(NSString *)payload;
//virtual
-(bool) cancelNavigation;

@end

NS_ASSUME_NONNULL_END
