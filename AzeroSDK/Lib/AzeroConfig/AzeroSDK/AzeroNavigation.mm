//
//  AzeroNavigation.m
//  AzeroDemo
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroNavigation.h"

class NavigationWrapper : public aace::navigation::Navigation {
public:
    NavigationWrapper(AzeroNavigation *imp)
    : w (imp) {};
    
//    void startNavigation( const std::string& payload ) override {
//        [w startNavigation:[[NSString alloc] initWithUTF8String:payload.c_str()]];
//        return;
//    }

    bool cancelNavigation() override {
        return [w cancelNavigation];
    }

private:
    __weak AzeroNavigation *w;
};


@implementation AzeroNavigation
{
    std::shared_ptr<aace::navigation::Navigation> wrapper;
}

-(AzeroNavigation *) init {
    if (self = [super init]) {
//        wrapper = std::make_shared<NavigationWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

@end
