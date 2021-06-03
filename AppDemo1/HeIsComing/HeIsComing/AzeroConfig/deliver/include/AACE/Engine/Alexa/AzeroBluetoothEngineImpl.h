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

#ifndef AACE_ENGINE_AZEROBLUETOOTH_ENGINE_IMPL_H
#define AACE_ENGINE_AZEROBLUETOOTH_ENGINE_IMPL_H

#include <chrono>
#include <memory>
#include <queue>
#include <string>
#include <unordered_set>

#include <AVSCommon/SDKInterfaces/DirectiveSequencerInterface.h>
#include <AVSCommon/AVS/CapabilityConfiguration.h>
#include <AVSCommon/SDKInterfaces/CapabilityConfigurationInterface.h>
#include <AVSCommon/SDKInterfaces/CapabilitiesDelegateInterface.h>
#include <AVSCommon/SDKInterfaces/MessageSenderInterface.h>
#include <AVSCommon/SDKInterfaces/PlaybackRouterInterface.h>
#include <AVSCommon/SDKInterfaces/FocusManagerInterface.h>
#include <AVSCommon/AVS/CapabilityAgent.h>
#include <AVSCommon/Utils/RequiresShutdown.h>
#include <AVSCommon/Utils/Threading/Executor.h>

#include <AVSCommon/SDKInterfaces/AVSConnectionManagerInterface.h>

#include <AACE/Alexa/AzeroBluetooth.h>

#include "AACE/Engine/Alexa/AzeroBluetoothInterface.h"
#include "AACE/Alexa/AlexaEngineInterfaces.h"
#include "AACE/Engine/Alexa/AzeroBluetoothCapabilityAgent.h"

namespace aace {
namespace engine {
namespace alexa {

class AzeroBluetoothEngineImpl :
    public aace::engine::alexa::AzeroBluetoothInterface
    , public alexaClientSDK::avsCommon::utils::RequiresShutdown
    , public aace::alexa::AzeroBluetoothEngineInterface
    , public std::enable_shared_from_this<AzeroBluetoothEngineImpl>{

private:
    AzeroBluetoothEngineImpl( std::shared_ptr<aace::alexa::AzeroBluetooth> bluetoothPlatformInterface);
    bool initialize(
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::DirectiveSequencerInterface> directiveSequencer,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::CapabilitiesDelegateInterface> capabilitiesDelegate,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ExceptionEncounteredSenderInterface> exceptionSender,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ContextManagerInterface> contextManager,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::MessageSenderInterface> messageSender,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::FocusManagerInterface> focusManager);

public:
    static std::shared_ptr<AzeroBluetoothEngineImpl> create(
        std::shared_ptr<aace::alexa::AzeroBluetooth> bluetoothPlatformInterface,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::DirectiveSequencerInterface> directiveSequencer,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::CapabilitiesDelegateInterface> capabilitiesDelegate,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ExceptionEncounteredSenderInterface> exceptionSender,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ContextManagerInterface> contextManager,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::MessageSenderInterface> messageSender,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::FocusManagerInterface> focusManager);
    
    void onConnected(void) override;
    void onDisconnected(void) override;
    void onEnterDiscoverableMode(void) override;
    void onExitDiscoverableMode(void) override;
    void onPlaying(void) override;
    void onPaused(void) override;
    void onStopped(void) override;

    bool turnOn(void) override;
    bool turnOff(void) override;
    bool play(void) override;
    bool stop(void) override;
    bool pause(void) override;
    bool next(void) override;
    bool previous(void) override;

protected:
    virtual void doShutdown() override;
private:
    
    // todo : shutdown
    std::shared_ptr<aace::engine::alexa::AzeroBluetoothCapabilityAgent> m_azeroBluetoothCapabilityAgent;
    std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::MessageSenderInterface> m_messageSender;
    std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::AVSConnectionManagerInterface> m_connectManager;

    std::shared_ptr<aace::alexa::AzeroBluetooth> m_bluetoothPlatformInterface;


    // @name RequiresShutdown Functions
    /// @{
    // void doShutdown() override;

//     /// This is the worker thread for the @c AzeroExpress CA.
//     alexaClientSDK::avsCommon::utils::threading::Executor m_executor;
   
};

} // aace::engine::alexa
} // aace::engine
} // aace

#endif // AACE_ENGINE_ALEXA_SAMPLESKILL_ENGINE_IMPL_H
