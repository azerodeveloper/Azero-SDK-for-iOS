//
//  AzeroMetricsUploader.m
//  AzeroDemo
//
//  Created by nero on 2020/4/22.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroMetricsUploader.h"

class MetricsUploaderWrapper : public aace::metrics::MetricsUploader {
public:
    MetricsUploaderWrapper(AzeroMetricsUploader *imp)
    : w (imp) {};
    
    bool record( const std::vector<Datapoint>& datapoints, const std::unordered_map<std::string, std::string>& metadata ) override {
        return [w recordDatapoints:datapoints andMetaData:metadata];
    }
    
private:
    __weak AzeroMetricsUploader *w;
};


@implementation AzeroMetricsUploader
{
    std::shared_ptr<aace::metrics::MetricsUploader> wrapper;
}

-(AzeroMetricsUploader *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<MetricsUploaderWrapper>(self);
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
