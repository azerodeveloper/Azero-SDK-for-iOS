//
//  AzeroModeControl.m
//  test000
//
//  Created by nero on 2020/4/10.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroModeControl.h"

@implementation AzeroModeControl
{
    std::shared_ptr<azeroSDK::ModeControlHandler> wrapper;
}

-(AzeroModeControl *) init {
    if (self = [super init]) {
        wrapper = azeroSDK::ModeControlHandler::create();
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(bool) restartOpenDenoise {
    return wrapper->restartOpenDenoise();
}

@end
