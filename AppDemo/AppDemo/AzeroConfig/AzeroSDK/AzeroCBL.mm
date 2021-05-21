//
//  AzeroCBL.m
//  test000
//
//  Created by nero on 2020/2/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroCBL.h"

std::string name="ios_app";
std::string email="hanqiyuan@soundai.com";
class CBLWrapper : public aace::cbl::CBL {
public:
    CBLWrapper(AzeroCBL *imp)
    : w (imp) {};
    
    void cblStateChanged(CBLState state, CBLStateChangedReason reason, const std::string& url, const std::string& code) override {
        [w cblStateChanged:state
                  byReason:reason
                   withUrl:[[NSString alloc] initWithUTF8String:url.c_str()]
                   andCode:[[NSString alloc] initWithUTF8String:code.c_str()]];
    }

    void clearRefreshToken() override {
        [w clearRefreshToken];
    }

    void setRefreshToken(const std::string& refreshToken ) override {
        [w setRefreshToken:[[NSString alloc] initWithUTF8String:refreshToken.c_str()]];
    }

    std::string getRefreshToken() override {
        auto token = [w getRefreshToken];
        return [token cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    std::string getAuthToken() {
        auto token = [w getAuthToken];
        return [token cStringUsingEncoding:NSUTF8StringEncoding];
    }

    void reset() {
        [w reset];
    }

    void setUserProfile(const std::string& name, const std::string& email) {
        [w setUserProfile:[[NSString alloc] initWithUTF8String:name.c_str()] email:[[NSString alloc] initWithUTF8String:email.c_str()]];
    }
    
private:
    __weak AzeroCBL *w;
};

@implementation AzeroCBL
{
    std::shared_ptr<aace::cbl::CBL> wrapper;
}

-(AzeroCBL *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<CBLWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(void) start {
    wrapper->start();
}

-(void) cancel {
    wrapper->cancel();
}

-(NSString *) getAuthToken {
    return [[NSString alloc] initWithUTF8String:wrapper->getAuthToken().c_str()];
}

-(void) reset {
    wrapper->reset();
}
- (void)setUserProfile:(NSString *)name email:(NSString *)email{
    wrapper->setUserProfile([name cStringUsingEncoding:NSUTF8StringEncoding], [email cStringUsingEncoding:NSUTF8StringEncoding]);
}


@end
