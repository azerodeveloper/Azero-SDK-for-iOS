//
//  AzeroTemplateRuntime.m
//  test000
//
//  Created by nero on 2020/3/9.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroTemplateRuntime.h"
#include <AACE/Alexa/TemplateRuntime.h>

class TemplateRuntimeWrapper : public aace::alexa::TemplateRuntime {
public:
    TemplateRuntimeWrapper(AzeroTemplateRuntime *imp)
    :w (imp) {};
    
    void renderTemplate( const std::string& payload ) override {
        [w renderTemplate:[[NSString alloc] initWithUTF8String:payload.c_str()]];
    }
    
    void clearTemplate() override {
        [w clearTemplate];
    }

    void renderPlayerInfo( const std::string& payload ) override {
        [w renderPlayerInfo:[[NSString alloc] initWithUTF8String:payload.c_str()]];
    }
    
    void clearPlayerInfo() override {
        [w clearPlayerInfo];
    }
    
private:
    __weak AzeroTemplateRuntime *w;
};

@implementation AzeroTemplateRuntime
{
        std::shared_ptr<aace::alexa::TemplateRuntime> wrapper;
}

-(AzeroTemplateRuntime *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<TemplateRuntimeWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(bool) reclockTemplateTimer {
    return wrapper->reclockTemplateTimer();
}

-(bool) reclockPlayerTimer {
    return wrapper->reclockPlayerTimer();
}

@end
