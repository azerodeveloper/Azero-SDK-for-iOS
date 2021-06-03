//
//  AzeroNavigation.m
//  HeIsComing
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
// 

#import "AzeroNavigation.h"

class NavigationWrapper : public aace::navigation::Navigation {
public:
    NavigationWrapper(AzeroNavigation *imp)
    : w (imp) {};
    
    void startNavigation( const std::string& payload ) override {
        [w startNavigation:[[NSString alloc] initWithUTF8String:payload.c_str()]];
        return ;
    }
    void showPreviousWaypoints() override {
        [w showPreviousWaypoints];
        return ;
    }
    
    void navigateToPreviousWaypoint() override{  
        [w navigateToPreviousWaypoint];
        return;
    }
    void showAlternativeRoutes( AlternateRouteType alternateRouteType ) override{
        [w showAlternativeRoutes:alternateRouteType];
        return;
    }
    
    void controlDisplay( ControlDisplay controlDisplay ) override{
        [w controlDisplay:controlDisplay];
        return;
    }
    bool cancelNavigation() override {
        return [w cancelNavigation];
    }
    
    std::string getNavigationState() override{
        return [[w getNavigationState] cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    void announceManeuver( const std::string& payload ) override{
        [w announceManeuver:[[NSString alloc] initWithUTF8String:payload.c_str()]];
        return;
    }
    
    void announceRoadRegulation( RoadRegulation roadRegulation ) override{
        [w announceRoadRegulation:roadRegulation];
        return;
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
        wrapper = std::make_shared<NavigationWrapper>(self);
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
