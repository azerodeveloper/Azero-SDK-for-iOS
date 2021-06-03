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

#ifndef AACE_ENGINE_ALEXA_BLUETOOTH_ENGINE_IMPL_H
#define AACE_ENGINE_ALEXA_BLUETOOTH_ENGINE_IMPL_H

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
#include <AVSCommon/AVS/CapabilityAgent.h>
#include <AVSCommon/Utils/RequiresShutdown.h>
#include <AVSCommon/Utils/Threading/Executor.h>
#include <AVSCommon/Utils/Bluetooth/BluetoothEventBus.h>
#include <Bluetooth/Bluetooth.h>
#include <Bluetooth/BluetoothAVRCPTransformer.h>
#include <BlueZ/BlueZBluetoothDeviceManager.h>

#include <AVSCommon/SDKInterfaces/AVSConnectionManagerInterface.h>


#include "AACE/Alexa/Bluetooth.h"
#include "AudioChannelEngineImpl.h"

namespace aace {
namespace engine {
namespace alexa {

class BluetoothEngineImpl :
    public AudioChannelEngineImpl
    // , public alexaClientSDK::avsCommon::avs::CapabilityAgent
    // , public alexaClientSDK::avsCommon::sdkInterfaces::CapabilityConfigurationInterface
    // , public alexaClientSDK::avsCommon::utils::RequiresShutdown
    , public aace::alexa::BluetoothEngineInterface{
    // , public std::enable_shared_from_this<BluetoothEngineImpl>{

private:
    BluetoothEngineImpl( std::shared_ptr<aace::alexa::Bluetooth> bluetoothPlatformInterface);
        // std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ExceptionEncounteredSenderInterface> exceptionSender);

    bool initialize(
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::DirectiveSequencerInterface> directiveSequencer,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::CapabilitiesDelegateInterface> capabilitiesDelegate,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ContextManagerInterface> contextManager,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::FocusManagerInterface> focusManager,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::MessageSenderInterface> messageSender,//std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::AVSConnectionManagerInterface> connectManager,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ExceptionEncounteredSenderInterface> exceptionSender,
        std::shared_ptr<alexaClientSDK::capabilityAgents::bluetooth::BluetoothStorageInterface> bluetoothStorage,
        std::shared_ptr<alexaClientSDK::registrationManager::CustomerDataManager> dataManager,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::PlaybackRouterInterface> playbackRouter,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::SpeakerManagerInterface> speakerManager);

public:
    static std::shared_ptr<BluetoothEngineImpl> create(
        std::shared_ptr<aace::alexa::Bluetooth> bluetoothPlatformInterface,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::DirectiveSequencerInterface> directiveSequencer,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::CapabilitiesDelegateInterface> capabilitiesDelegate,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ContextManagerInterface> contextManager,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::FocusManagerInterface> focusManager,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::MessageSenderInterface> messageSender,// std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::AVSConnectionManagerInterface> connectManager,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ExceptionEncounteredSenderInterface> exceptionSender,
        std::shared_ptr<alexaClientSDK::capabilityAgents::bluetooth::BluetoothStorageInterface> bluetoothStorage,
        std::shared_ptr<alexaClientSDK::registrationManager::CustomerDataManager> dataManager,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::PlaybackRouterInterface> playbackRouter,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::SpeakerManagerInterface> speakerManager);

protected:
    virtual void doShutdown() override;
private:
    // /**
    //  * This function handles any unknown directives received by @c TemplateRuntime CA.
    //  *
    //  * @param info The @c DirectiveInfo containing the @c AVSDirective and the @c DirectiveHandlerResultInterface.
    //  */
    // void handleUnknownDirective(std::shared_ptr<DirectiveInfo> info);
    
    /// Set of capability configurations that will get published using the Capabilities API
    // std::unordered_set<std::shared_ptr<alexaClientSDK::avsCommon::avs::CapabilityConfiguration>> m_capabilityConfigurations;
    std::shared_ptr<alexaClientSDK::capabilityAgents::bluetooth::Bluetooth> m_bluetoothCapabilityAgent;
    std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::MessageSenderInterface> m_messageSender;
    std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::AVSConnectionManagerInterface> m_connectManager;

    std::shared_ptr<aace::alexa::Bluetooth> m_bluetoothPlatformInterface;

    std::shared_ptr<alexaClientSDK::avsCommon::utils::bluetooth::BluetoothEventBus> m_eventBus;
    std::atomic<bool> m_isDeviceManagerValid{false};
    std::condition_variable m_BluetoothDeviceTurnOnCV;
    std::mutex m_BluetoothDeviceTurnOnMutex;
    bool setDeviceManager(void) override;
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
