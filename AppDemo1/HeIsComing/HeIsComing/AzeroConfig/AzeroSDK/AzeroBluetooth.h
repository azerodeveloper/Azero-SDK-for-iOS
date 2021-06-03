//
//  AzeroBluetooth.h
//  HeIsComing
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroAudioChannel.h"
#include <AACE/Alexa/Bluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface AzeroBluetooth : AzeroAudioChannel

//virtual
-(bool) waitForBluetoothDeviceTurnOn;
//virtual
-(bool) handleCmd:(aace::alexa::Bluetooth::BluetoothCmd)cmd;
//virtual
-(bool) handleEvent:(aace::alexa::Bluetooth::BluetoothEvent)evt;

@end

NS_ASSUME_NONNULL_END
