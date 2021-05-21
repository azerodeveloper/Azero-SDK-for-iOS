//
//  AzeroLocationProvider.m
//  AzeroDemo
//
//  Created by nero on 2020/4/22.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroLocationProvider.h"

class LocationProviderWrapper : public aace::location::LocationProvider {
public:
    LocationProviderWrapper(AzeroLocationProvider *imp)
    : w (imp) {};
    
    aace::location::Location getLocation() override {
        return [w getLocation];
    }
    
    std::string getCountry() override {
        std::string str;
        auto nsstr = [w getCountry];
        if ( nsstr ) {
            str = [nsstr cStringUsingEncoding:NSUTF8StringEncoding];
        }
        return str;
    }
    
private:
    __weak AzeroLocationProvider *w;
};

@implementation AzeroLocationProvider
{
    std::shared_ptr<aace::location::LocationProvider> wrapper;
}

-(AzeroLocationProvider *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<LocationProviderWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(NSString *) getCountry {
    return @"";
}

@end
