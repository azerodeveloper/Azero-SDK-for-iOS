//
//  AzeroMetricsUploader.h
//  AzeroDemo
//
//  Created by nero on 2020/4/22.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include <AACE/Metrics/MetricsUploader.h>

NS_ASSUME_NONNULL_BEGIN

@interface AzeroMetricsUploader : AzeroPlatformInterface

//virtual
-(bool) recordDatapoints:(const std::vector<aace::metrics::MetricsUploader::Datapoint>&) datapoints andMetaData:(const std::unordered_map<std::string, std::string>&) metadata;

@end

NS_ASSUME_NONNULL_END
