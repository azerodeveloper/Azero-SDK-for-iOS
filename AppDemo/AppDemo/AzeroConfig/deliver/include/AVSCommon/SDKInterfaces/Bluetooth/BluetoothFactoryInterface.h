/*
 * Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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

#ifndef ALEXA_CLIENT_SDK_AVSCOMMON_SDKINTERFACES_INCLUDE_AVSCOMMON_SDKINTERFACES_BLUETOOTH_BLUETOOTHFACTORYRINTERFACE_H_
#define ALEXA_CLIENT_SDK_AVSCOMMON_SDKINTERFACES_INCLUDE_AVSCOMMON_SDKINTERFACES_BLUETOOTH_BLUETOOTHFACTORYRINTERFACE_H_

#include <future>
#include <string>

namespace alexaClientSDK {
namespace avsCommon {
namespace sdkInterfaces {
namespace bluetooth {

/**
 * This is an interface to produce functions that invoke user call back .
 */
class BluetoothFactoryInterface {
public:
    virtual ~BluetoothFactoryInterface() = default;

    /**
     * Enum indicating the bluetooth event for user
     */
    enum class BluetoothEvent {
        ON_CONNECT,
        ON_DISCONNECT,
        ON_ENTER_DISCOVERABLE_MODE,
        ON_EXIT_DISCOVERABLE_MODE
    };

    /**
     * Enum indicating the bluetooth cmd from user
     */
    enum class BluetoothCmd {
        TURN_ON,
        TURN_OFF
    };

    
    virtual bool handleCmd(BluetoothCmd cmd) = 0;
    virtual bool handleEvent(BluetoothEvent evt) = 0;

};

}  // namespace bluetooth
}  // namespace sdkInterfaces
}  // namespace avsCommon
}  // namespace alexaClientSDK

#endif  // ALEXA_CLIENT_SDK_AVSCOMMON_SDKINTERFACES_INCLUDE_AVSCOMMON_SDKINTERFACES_BLUETOOTH_BLUETOOTHFACTORYRINTERFACE_H_
