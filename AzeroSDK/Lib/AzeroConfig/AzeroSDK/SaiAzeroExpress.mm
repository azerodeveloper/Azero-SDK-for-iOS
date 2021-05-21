//
//  SaiAzeroExpress.m
//  AzeroDemo
//
//  Created by silk on 2020/4/1.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiAzeroExpress.h"
class AzeroExpressWrapper : public aace::alexa::AzeroExpress {
public:
    AzeroExpressWrapper(::SaiAzeroExpress *imp)
    : w (imp) {};
    
    void handleExpressDirective( const std::string &name, const std::string &payload ) override {
        [w handleExpressDirectiveFor:[[NSString alloc] initWithUTF8String:name.c_str()] withPayload:[[NSString alloc] initWithUTF8String:payload.c_str()]];
    }
    
private:
    __weak ::SaiAzeroExpress *w;
};
@implementation SaiAzeroExpress
{
    std::shared_ptr<aace::alexa::AzeroExpress> wrapper;
}

-(SaiAzeroExpress *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<AzeroExpressWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(void) sendEvent:(NSString *)jsonContent {
    wrapper->sendEvent([jsonContent cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void) reconnectAVSnet {
    wrapper->reconnectAVSnet();
}
@end
