//
//  MyAzeroNavigation.m
//  HeIsComing
//
//  Created by silk on 2020/9/7.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "MyAzeroNavigation.h"
#import "SaiJsonConversionModel.h"
@implementation MyAzeroNavigation
-(bool) setDestination:(NSString *)payload{
    NSLog(@"MyAzeroNavigation ------setDestination%@",payload);
    return true;
}
-(bool) cancelNavigation{
    //在这里接受取消导航的回调
    return true;
}

-(void)startNavigation:(NSString *)payload{
    //    NSDictionary *dic = [SaiJsonConversionModel dictionaryWithJsonString:payload];
    [[NSUserDefaults standardUserDefaults] setObject:payload  forKey:@"locationPayload"];
    TYLog(@"%@",payload);
    if ([SaiAzeroManager sharedAzeroManager].locationblock) {
        [SaiAzeroManager sharedAzeroManager].locationblock(payload);
    }
    
}

- (void)showPreviousWaypoints{
    NSLog(@"MyAzeroNavigation ------showPreviousWaypoints");
}

- (void)navigateToPreviousWaypoint{
    NSLog(@"MyAzeroNavigation ------navigateToPreviousWaypoint");
}

- (void)showAlternativeRoutes:(aace::navigation::NavigationEngineInterface::AlternateRouteType )alternateRouteType{
    NSLog(@"MyAzeroNavigation ------showAlternativeRoutes");
}

- (void)controlDisplay:(aace::navigation::Navigation::ControlDisplay)controlDisplay{
    NSLog(@"MyAzeroNavigation ------controlDisplay");
}
- (NSString *)getNavigationState{
    return @"";
}

- (void)announceManeuver:(NSString *)payload{
    NSLog(@"MyAzeroNavigation ------announceManeuver");
}

- (void)announceRoadRegulation:(aace::navigation::Navigation::RoadRegulation)roadRegulation{
    NSLog(@"MyAzeroNavigation ------announceRoadRegulation");
}

@end
