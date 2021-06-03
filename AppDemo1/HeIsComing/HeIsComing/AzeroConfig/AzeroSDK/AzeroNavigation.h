//
//  AzeroNavigation.h
//  HeIsComing
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include <AACE/Navigation/Navigation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AzeroNavigation : AzeroPlatformInterface

//virtual
-(bool) setDestination:(NSString *)payload;
//virtual
-(bool) cancelNavigation;

-(void)startNavigation:(NSString *)payload;

- (void)showPreviousWaypoints;

- (void)navigateToPreviousWaypoint;

- (void)showAlternativeRoutes:(aace::navigation::NavigationEngineInterface::AlternateRouteType )alternateRouteType;

- (void)controlDisplay:(aace::navigation::Navigation::ControlDisplay)controlDisplay;

- (NSString *)getNavigationState;

- (void)announceManeuver:(NSString *)payload;
 
- (void)announceRoadRegulation:(aace::navigation::Navigation::RoadRegulation)roadRegulation;

@end

NS_ASSUME_NONNULL_END
