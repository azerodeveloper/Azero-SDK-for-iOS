//
//  AzeroEngine.m
//  AzeroSDKWrapper
//
//  Created by nero on 2020/2/25.
//  Copyright © 2020 nero. All rights reserved.
//

#import "AzeroEngine.h"
#include <vector>

#include <AACE/Engine/Alexa/AlexaEngineService.h>
#include <AACE/Engine/CBL/CBLEngineService.h>
#include <AACE/Engine/ContactUploader/ContactUploaderEngineService.h>
#include <AACE/Engine/Location/LocationEngineService.h>
#include <AACE/Engine/Logger/LoggerEngineService.h>
#include <AACE/Engine/Metrics/MetricsEngineService.h>
#include <AACE/Engine/Navigation/NavigationEngineService.h>
#include <AACE/Engine/Network/NetworkEngineService.h>
#include <AACE/Engine/PhoneCallController/PhoneCallControllerEngineService.h>
#include <AACE/Engine/Storage/StorageEngineService.h>
#include <AACE/Engine/Vehicle/VehicleEngineService.h>
#include <AACE/Engine/OpenDenoise/OpenDenoiseEngineService.h>

@implementation AzeroEngine
{
    std::shared_ptr<aace::core::Engine> wrapper;
}

-(AzeroEngine *) init {
    if (self = [super init]) {
        wrapper = aace::core::Engine::create();
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(void) forceLink {
    aace::engine::alexa::AlexaEngineService::ForceLinkLibrary();
    aace::engine::cbl::CBLEngineService::ForceLinkLibrary();
    aace::engine::contactUploader::ContactUploaderEngineService::ForceLinkLibrary();
    aace::engine::location::LocationEngineService::ForceLinkLibrary();
    aace::engine::logger::LoggerEngineService::ForceLinkLibrary();
    aace::engine::metrics::MetricsEngineService::ForceLinkLibrary();
    aace::engine::navigation::NavigationEngineService::ForceLinkLibrary();
    aace::engine::network::NetworkEngineService::ForceLinkLibrary();
    aace::engine::phoneCallController::PhoneCallControllerEngineService::ForceLinkLibrary();
    aace::engine::storage::StorageEngineService::ForceLinkLibrary();
    aace::engine::vehicle::VehicleEngineService::ForceLinkLibrary();
    aace::engine::openDenoise::OpenDenoiseEngineService::ForceLinkLibrary();
}

-(bool) configure:(NSArray *)paths {
    std::vector<std::shared_ptr<aace::core::config::EngineConfiguration>> configurationFiles;
    for (NSString *path in paths) {
        std::string sPath([path cStringUsingEncoding:NSUTF8StringEncoding]);
        auto configurationFile = aace::core::config::ConfigurationFile::create(sPath);
        assert(configurationFile != nullptr);
        configurationFiles.push_back(configurationFile);
    }
    return wrapper->configure(configurationFiles);
}

-(bool) start {
    return wrapper->start();
}

-(bool) stop {
    return wrapper->stop();
}

-(bool) shutdown {
    return wrapper->shutdown();
}

-(bool) setProperty:(NSString *)key withValue:(NSString *)value {
    std::string sKey([key cStringUsingEncoding:NSUTF8StringEncoding]);
    std::string sValue([value cStringUsingEncoding:NSUTF8StringEncoding]);
    return wrapper->setProperty(sKey, sValue);
}

-(NSString *) getProperty:(NSString *)key {
    std::string sKey([key cStringUsingEncoding:NSUTF8StringEncoding]);
    auto sValue = wrapper->getProperty(sKey);
    return [[NSString alloc] initWithUTF8String:sValue.c_str()];
}

-(bool) registerPlatformInterface:(AzeroPlatformInterface *)platformInterface {
    return wrapper->registerPlatformInterface([platformInterface getPlatformInterfaceRawPtr]);
}

-(bool) registerPlatformInterfaceWithRawPtr:(std::shared_ptr<aace::core::PlatformInterface>)ptr {
    return wrapper->registerPlatformInterface(ptr);
}

-(bool) setInteractMode:(int)mode{
    return wrapper->setInteractMode(mode);
}

@end
