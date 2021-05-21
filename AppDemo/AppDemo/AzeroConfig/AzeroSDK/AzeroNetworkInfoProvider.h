//
//  AzeroNetworkInfoProvider.h
//  HeIsComing
//
//  Created by nero on 2020/4/22.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include <AACE/Network/NetworkInfoProvider.h>

NS_ASSUME_NONNULL_BEGIN

@interface AzeroNetworkInfoProvider : AzeroPlatformInterface

//virtual
-(aace::network::NetworkInfoProvider::NetworkStatus) getNetworkStatus;
//virtual
-(int) getWifiSignalStrength;

-(void) networkStatusChanged:(aace::network::NetworkInfoProvider::NetworkStatus) status withWifiSignalStrength:(int) wifiSignalStrength;

@end

NS_ASSUME_NONNULL_END
