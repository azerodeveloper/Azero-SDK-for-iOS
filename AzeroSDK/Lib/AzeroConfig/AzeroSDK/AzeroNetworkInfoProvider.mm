//
//  AzeroNetworkInfoProvider.m
//  AzeroDemo
//
//  Created by nero on 2020/4/22.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroNetworkInfoProvider.h"

class NetworkInfoProviderWrapper : public aace::network::NetworkInfoProvider {
public:
    NetworkInfoProviderWrapper(AzeroNetworkInfoProvider *imp)
    : w (imp) {};
    
    NetworkStatus getNetworkStatus() override {
        return [w getNetworkStatus];
    }

    int getWifiSignalStrength() override {
        return [w getWifiSignalStrength];
    }

private:
    __weak AzeroNetworkInfoProvider *w;
};


@implementation AzeroNetworkInfoProvider
{
    std::shared_ptr<aace::network::NetworkInfoProvider> wrapper;
}

-(AzeroNetworkInfoProvider *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<NetworkInfoProviderWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(void) networkStatusChanged:(aace::network::NetworkInfoProvider::NetworkStatus) status withWifiSignalStrength:(int) wifiSignalStrength {
    wrapper->networkStatusChanged( status, wifiSignalStrength );
}

@end
