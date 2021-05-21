//
//  AzeroEqualizerController.m
//  AzeroDemo
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroEqualizerController.h"

@implementation AzeroEqualizerBandLevel
@end

class EqualizerControllerWrapper : public aace::alexa::EqualizerController {
public:
    EqualizerControllerWrapper(AzeroEqualizerController *imp)
    : w (imp) {};
    
    void setBandLevels( const std::vector<EqualizerBandLevel>& bandLevels ) override {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for ( auto &bandLevel : bandLevels ) {
            AzeroEqualizerBandLevel *ocBandLevel = [[AzeroEqualizerBandLevel alloc] init];
            ocBandLevel->band = std::get<0>(bandLevel);
            ocBandLevel->level = std::get<1>(bandLevel);
            [array addObject:ocBandLevel];
        }
        [w setBandLevels:[NSArray arrayWithArray:array]];
    }

    std::vector<EqualizerBandLevel> getBandLevels() override {
        auto array = [w getBandLevels];
        
        std::vector<EqualizerBandLevel> ret;
        if ( array ) {
            for ( AzeroEqualizerBandLevel *ocBandLevel in array ) {
                if ( ocBandLevel ) {
                    ret.emplace_back( ocBandLevel->band, ocBandLevel->level );
                }
            }
        }
        return ret;
    }
    
private:
    __weak AzeroEqualizerController *w;
};


@implementation AzeroEqualizerController
{
    std::shared_ptr<aace::alexa::EqualizerController> wrapper;
}

-(AzeroEqualizerController *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<EqualizerControllerWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(std::vector<aace::alexa::EqualizerController::EqualizerBandLevel>) ocBandLevels2Vector:(NSArray *)bandLevels {
    std::vector<aace::alexa::EqualizerController::EqualizerBandLevel> vBandLevels;
    if ( bandLevels ) {
        for ( AzeroEqualizerBandLevel *bandLevel in bandLevels ) {
            if ( bandLevel ) {
                vBandLevels.emplace_back( bandLevel->band, bandLevel->level );
            }
        }
    }
    return vBandLevels;
}

//bandLevels: array of AzeroEqualizerBandLevel *
-(void) localSetBandLevels:(NSArray *)bandLevels {
    wrapper->localSetBandLevels( [self ocBandLevels2Vector:bandLevels] );
}

//bandAdjustments: array of AzeroEqualizerBandLevel *
-(void) localAdjustBandLevels:(NSArray *)bandAdjustments {
    wrapper->localAdjustBandLevels( [self ocBandLevels2Vector:bandAdjustments] );
}

-(void) localResetBands:(aace::alexa::EqualizerController::EqualizerBand *)bands withSize:(size_t) size {
    std::vector<aace::alexa::EqualizerController::EqualizerBand> vecBands;
    if ( bands ) {
        for( size_t i = 0; i < size; ++i ) {
            vecBands.push_back( bands[i] );
        }
    }
    wrapper->localResetBands( vecBands );
}

@end
