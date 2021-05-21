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

#ifndef AACE_AZEROBLUETOOTH_H
#define AACE_AZEROBLUETOOTH_H

#include "AACE/Core/PlatformInterface.h"
#include "AACE/Alexa/AlexaEngineInterfaces.h"
// #include "AACE/AzeroBluetooth/AzeroBluetoothEngineInterface.h"

/** @file */

namespace aace {
namespace alexa {

// namespace alexaClientSDK {
// namespace avsCommon {
// namespace sdkInterfaces {
// namespace bluetooth {

// /**
//  * This is an interface to produce functions that invoke user call back .
//  */
// class BluetoothFactoryInterface {

class AzeroBluetooth : public aace::core::PlatformInterface {
                //   public alexaClientSDK::avsCommon::sdkInterfaces::bluetooth::BluetoothFactoryInterface {
                    // public aace::engine::azeroBluetooth::AzeroBluetoothInterface {
protected:
    AzeroBluetooth() = default;
    // AzeroBluetooth( std::shared_ptr<aace::alexa::MediaPlayer> mediaPlayer, std::shared_ptr<aace::alexa::Speaker> speaker );

public:
    virtual ~AzeroBluetooth();
    using BluetoothCmd = aace::alexa::AzeroBluetoothEngineInterface::BluetoothCmd;
    using BluetoothEvent = aace::alexa::AzeroBluetoothEngineInterface::BluetoothEvent;
    
    virtual bool executeCmd(BluetoothCmd cmd) = 0;
    void setEngineInterface( std::shared_ptr<aace::alexa::AzeroBluetoothEngineInterface> bluetoothEngineInterface );

protected:
    std::shared_ptr<aace::alexa::AzeroBluetoothEngineInterface> m_azeroBluetoothEngineInterface;
};

} // aace::alexa
} // aace

#endif // AACE_ALEXA_TEMPLATE_RUNTIME_H
