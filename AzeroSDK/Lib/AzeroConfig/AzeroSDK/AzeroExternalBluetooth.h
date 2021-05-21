//
//  AzeroExternalBluetooth.h
//  AzeroDemo
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include <AACE/Alexa/AzeroBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface AzeroExternalBluetooth : AzeroPlatformInterface

-(bool) executeCmd:(aace::alexa::AzeroBluetooth::BluetoothCmd)cmd;

@end

NS_ASSUME_NONNULL_END
