/*
 * Copyright 2017-2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *     http://aws.amazon.com/apache2.0/
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#ifndef AACE_ENGINE_AZEROBLUETOOTH_INTERFACE_H
#define AACE_ENGINE_AZEROBLUETOOTH_INTERFACE_H

#include <string>

namespace aace {
namespace engine {
namespace alexa {

/**
 * This is an interface to produce functions that invoke user call back .
 */
class AzeroBluetoothInterface {
public:
    virtual ~AzeroBluetoothInterface() = default;

    // /**
    //  * Enum indicating the bluetooth event for user
    //  */
    // enum class BluetoothEvent {
    //     ON_CONNECT,
    //     ON_DISCONNECT,
    //     ON_ENTER_DISCOVERABLE_MODE,
    //     ON_EXIT_DISCOVERABLE_MODE,
    //     PLAYING,
    //     PAUSED,
    //     STOPPED
    // };

    // /**
    //  * Enum indicating the bluetooth cmd from user
    //  */
    // enum class BluetoothCmd {
    //     TURN_ON,
    //     TURN_OFF,
    //     PLAY,
    //     STOP,
    //     PAUSE,
    //     NEXT,
    //     PREVIOUS
    // };

    // virtual bool handleCmd(BluetoothCmd cmd) = 0;
    // virtual bool handleEvent(BluetoothEvent evt) = 0;
    virtual bool turnOn(void) = 0;
    virtual bool turnOff(void) = 0;
    virtual bool play(void) = 0;
    virtual bool stop(void) = 0;
    virtual bool pause(void) = 0;
    virtual bool next(void) = 0;
    virtual bool previous(void) = 0;

};

} // aace::engine::azeroBluetooth
} // aace::engine
} // aace

#endif
