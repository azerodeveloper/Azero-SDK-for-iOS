//
//  AzeroEqualizerController.h
//  HeIsComing
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include <AACE/Alexa/EqualizerController.h>

NS_ASSUME_NONNULL_BEGIN

@interface AzeroEqualizerBandLevel : NSObject
{
    @public
    aace::alexa::EqualizerController::EqualizerBand band;
    int level;
}
@end

@interface AzeroEqualizerController : AzeroPlatformInterface

//virtual
//bandLevels: array of AzeroEqualizerBandLevel *
-(void) setBandLevels:(NSArray *)bandLevels;
//virtual
//return array of AzeroEqualizerBandLevel *
-(NSArray *) getBandLevels;

//bandLevels: array of AzeroEqualizerBandLevel *
-(void) localSetBandLevels:(NSArray *)bandLevels;
//bandAdjustments: array of AzeroEqualizerBandLevel *
-(void) localAdjustBandLevels:(NSArray *)bandAdjustments;
-(void) localResetBands:(aace::alexa::EqualizerController::EqualizerBand *)bands withSize:(size_t) size;

@end

NS_ASSUME_NONNULL_END
