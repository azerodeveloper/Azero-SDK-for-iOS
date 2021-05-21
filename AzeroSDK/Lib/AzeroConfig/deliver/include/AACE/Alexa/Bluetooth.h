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

#ifndef AACE_ALEXA_BLUETOOTH_H
#define AACE_ALEXA_BLUETOOTH_H

// #include "AACE/Core/PlatformInterface.h"
// #include "AACE/Alexa/AlexaEngineInterfaces.h"

#include "AudioChannel.h"
#include <AVSCommon/SDKInterfaces/Bluetooth/BluetoothFactoryInterface.h>
/** @file */

namespace aace {
namespace alexa {

// class Bluetooth : public aace::core::PlatformInterface {
class Bluetooth : public AudioChannel,
                  public alexaClientSDK::avsCommon::sdkInterfaces::bluetooth::BluetoothFactoryInterface {
protected:
    // Bluetooth() = default;
    Bluetooth( std::shared_ptr<aace::alexa::MediaPlayer> mediaPlayer, std::shared_ptr<aace::alexa::Speaker> speaker );

public:
    virtual ~Bluetooth();

    // /**
    //  * Provides customized skill metadata.
    //  *
    //  * @param [in] payload need more parsed metadata in structured JSON format
    //  */
    // virtual void handleExpressDirective( const std::string& name, const std::string& payload ) = 0;
 
    // void sendEvent(const std::string& jsonContent);
    // void reconnectAVSnet();
    
    virtual bool waitForBluetoothDeviceTurnOn(void) = 0;

    void setEngineInterface( std::shared_ptr<aace::alexa::BluetoothEngineInterface> bluetoothEngineInterface );

protected:
    std::shared_ptr<aace::alexa::BluetoothEngineInterface> m_bluetoothEngineInterface;
};

} // aace::alexa
} // aace

#endif // AACE_ALEXA_TEMPLATE_RUNTIME_H
