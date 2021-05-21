//
//  AzeroLocationProvider.h
//  HeIsComing
//
//  Created by nero on 2020/4/22.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include <AACE/Location/LocationProvider.h>

NS_ASSUME_NONNULL_BEGIN

@interface AzeroLocationProvider : AzeroPlatformInterface

//virtual
-(aace::location::Location) getLocation;
//virtual
-(NSString *) getCountry;

@end

NS_ASSUME_NONNULL_END
