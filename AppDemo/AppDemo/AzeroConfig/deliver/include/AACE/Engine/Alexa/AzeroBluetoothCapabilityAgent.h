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

#ifndef AACE_ENGINE_AZERO_BLUETOOTH_CAPABILITY_AGENT_H
#define AACE_ENGINE_AZERO_BLUETOOTH_CAPABILITY_AGENT_H

#include <deque>
#include <functional>
#include <memory>
#include <string>
#include <queue>
#include <unordered_map>
#include <unordered_set>

#include <AVSCommon/AVS/AVSDirective.h>
#include <AVSCommon/AVS/CapabilityAgent.h>
#include <AVSCommon/AVS/CapabilityConfiguration.h>
#include <AVSCommon/AVS/ExceptionErrorType.h>

#include <AVSCommon/AVS/Requester.h>

#include <AVSCommon/SDKInterfaces/CapabilityConfigurationInterface.h>
#include <AVSCommon/SDKInterfaces/ContextManagerInterface.h>
#include <AVSCommon/SDKInterfaces/ContextRequesterInterface.h>
#include <AVSCommon/SDKInterfaces/MessageSenderInterface.h>
#include <AVSCommon/SDKInterfaces/FocusManagerInterface.h>
#include <AVSCommon/Utils/RequiresShutdown.h>

#include <AVSCommon/Utils/Threading/Executor.h>

#include "AACE/Engine/Alexa/AzeroBluetoothInterface.h"

namespace aace {
namespace engine {
namespace alexa {

class AzeroBluetoothCapabilityAgent
        : public std::enable_shared_from_this<AzeroBluetoothCapabilityAgent>
        , public alexaClientSDK::avsCommon::avs::CapabilityAgent
        , public alexaClientSDK::avsCommon::sdkInterfaces::CapabilityConfigurationInterface
        , public alexaClientSDK::avsCommon::utils::RequiresShutdown {
public:
    /**
     * Destructor
     */
    virtual ~AzeroBluetoothCapabilityAgent() ;

    static std::shared_ptr<AzeroBluetoothCapabilityAgent> create(
        std::shared_ptr<AzeroBluetoothInterface> azeroBluetooth,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ExceptionEncounteredSenderInterface> exceptionEncounteredSender,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ContextManagerInterface> contextManager,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::MessageSenderInterface> messageSender,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::FocusManagerInterface> focusManager);
        
    /// @name CapabilityAgent Functions
    /// @{
    alexaClientSDK::avsCommon::avs::DirectiveHandlerConfiguration getConfiguration() const override;
    void handleDirectiveImmediately(std::shared_ptr<alexaClientSDK::avsCommon::avs::AVSDirective> directive) override;
    void preHandleDirective(std::shared_ptr<alexaClientSDK::avsCommon::avs::CapabilityAgent::DirectiveInfo> info) override;
    void handleDirective(std::shared_ptr<alexaClientSDK::avsCommon::avs::CapabilityAgent::DirectiveInfo> info) override;
    void cancelDirective(std::shared_ptr<alexaClientSDK::avsCommon::avs::CapabilityAgent::DirectiveInfo> info) override;

    void onFocusChanged(alexaClientSDK::avsCommon::avs::FocusState newFocus) override;
    
    /// @name CapabilityConfigurationInterface Functions
    /// @{
    std::unordered_set<std::shared_ptr<alexaClientSDK::avsCommon::avs::CapabilityConfiguration>> getCapabilityConfigurations() override;
    /// @}

    // @name ContextRequester Functions
    /// @{
    void onContextAvailable(const std::string& jsonContext) override;
    void onContextFailure(const alexaClientSDK::avsCommon::sdkInterfaces::ContextRequestError error) override;
    /// @}

    void onConnected(void) ;
    void onDisconnected(void) ;
    void onEnterDiscoverableMode(void) ;
    void onExitDiscoverableMode(void) ;
    void onPlaying(void) ;
    void onPaused(void) ;
    void onStopped(void) ;


    // @name RequiresShutdown Functions
    /// @{
    void doShutdown() override;
    /// @}

private:
   
    AzeroBluetoothCapabilityAgent(
        std::shared_ptr<AzeroBluetoothInterface> azeroBluetooth,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ExceptionEncounteredSenderInterface> exceptionEncounteredSender,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ContextManagerInterface> contextManager,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::MessageSenderInterface> messageSender,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::FocusManagerInterface> focusManager);
     
     /**
     * Initializes the agent.
     *
     * @return A bool indicating success.
     */
    bool init();

    /// Helper function to update the context.
    void executeUpdateContext();

    /**
     * Marks the directive as completed.
     *
     * @param info The directive currently being handled.
     */
    void executeSetHandlingCompleted(std::shared_ptr<DirectiveInfo> info);

    /**
     * Removes the directive from the @c CapabilityAgents internal map.
     *
     * @param info The directive currently being handled.
     */
    void removeDirective(std::shared_ptr<DirectiveInfo> info);

    /**
     * Alert AVS that an exception has occurred while handling a directive.
     *
     * @param info The directive currently being handled.
     * @param message A string to send to AVS.
     * @param type The type of exception.
     */
    void sendExceptionEncountered(
        std::shared_ptr<CapabilityAgent::DirectiveInfo> info,
        const std::string& message,
        alexaClientSDK::avsCommon::avs::ExceptionErrorType type);

    /// A state transition function for entering the foreground.
    void executeEnterForeground();

    /// A state transition function for entering the background.
    void executeEnterBackground();

    /// A state transition function for entering the none state.
    void executeEnterNone();

    /**
     * Most events require the context, this method queues the event and requests the context.
     * Once the context is available in onContextAvailable, the event will be dequeued and sent.
     *
     * @param eventName The name of the event.
     * @param eventPayload The payload of the event.
     */
    void executeQueueEventAndRequestContext(const std::string& eventName, const std::string& eventPayload);

    /// Sends an event to indicate the turn on bluetooth device successfully.
    void executeSendTurnOnSucceeded();
    
    /// Sends an event to indicate the turn on bluetooth device failed.
    void executeSendTurnOnFailed();
    
    /// Sends an event to indicate the turn off bluetooth device successfully.
    void executeSendTurnOffSucceeded();
    
    /// Sends an event to indicate the turn off bluetooth device failed.
    void executeSendTurnOffFailed();

    // /**
    //  * Sends an event to alert AVS that the list of found and paired devices has changed.
    //  *
    //  * @param devices A list of devices.
    //  * @param hasMore A bool indicating if we're still looking for more devices.
    //  */
    // void executeSendScanDevicesUpdated(
    //     const std::list<std::shared_ptr<avsCommon::sdkInterfaces::bluetooth::BluetoothDeviceInterface>>& devices,
    //     bool hasMore);

    // /// Sends a scanDevicesFailed event to alert AVS that attempting to scan for devices failed.
    // void executeSendScanDevicesFailed();

    /// Sends an event to indicate the adapter successfully entered discoverable mode.
    void executeSendEnterDiscoverableModeSucceeded();

    /// Sends an event to indicate the adapter failed to enter discoverable mode.
    void executeSendEnterDiscoverableModeFailed();

    void executeSendConnectSucceeded();
    void executeSendDisconnectSucceeded();
    
    /// Sends an event to indicate we successfully sent an AVRCP play to the target.
    void executeSendMediaControlPlaySucceeded();

    /// Sends an event to indicate we failed to send an AVRCP play to the target.
    void executeSendMediaControlPlayFailed();

    /// Sends an event to indicate we successfully sent an AVRCP pause to the target.
    void executeSendMediaControlStopSucceeded();

    /// Sends an event to indicate we failed to send an AVRCP pause to the target.
    void executeSendMediaControlStopFailed();

    /// Sends an event to indicate we successfully sent an AVRCP next to the target.
    void executeSendMediaControlNextSucceeded();

    /// Sends an event to indicate we failed to send an AVRCP next to the target.
    void executeSendMediaControlNextFailed();

    /// Sends an event to indicate we successfully sent an AVRCP previous to the target.
    void executeSendMediaControlPreviousSucceeded();

    /// Sends an event to indicate we failed to send an AVRCP previous to the target.
    void executeSendMediaControlPreviousFailed();

    /**
     * Sends an event that we have started streaming.
     *
     * @param device The activeDevice.
     */
    void executeSendStreamingStarted();

    /**
     * Sends an event that we have stopped streaming.
     *
     * @param device The activeDevice.
     */
    void executeSendStreamingEnded();

    /// Send a play command to the activeDevice.
    void executePlay();

    /// Send a stop command to the activeDevice.
    void executeStop();

    /// Send a next command to the activeDevice.
    void executeNext();

    /// Send a previous command to the activeDevice.
    void executePrevious();

    /// Acquire Channel focus
    void executeAcquireChannel();

    /// Set of capability configurations that will get published using DCF
    std::unordered_set<std::shared_ptr<alexaClientSDK::avsCommon::avs::CapabilityConfiguration>> m_capabilityConfigurations;

    /// Interface to invoke user call back
    // std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::bluetooth::BluetoothFactoryInterface> m_externalEmpl;
    std::shared_ptr<AzeroBluetoothInterface> m_azeroBluetooth;

    /// The @c MessageSenderInterface used to send event messages.
    std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::MessageSenderInterface> m_messageSender;

    /// The @c ContextManager used to generate system context for events.
    std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ContextManagerInterface> m_contextManager;

    /// The @c FocusManager used to manage focus.
    std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::FocusManagerInterface> m_focusManager;

    /// The cmd name
    std::string m_cmdName;

    // /// The current @c FocusState of the device.
    // alexaClientSDK::avsCommon::avs::FocusState m_focusState;

    /// The @c FocusManager used to manage focus.
    // std::shared_ptr<avsCommon::sdkInterfaces::FocusManagerInterface> m_focusManager;

    /// An event queue used to store events which need to be sent. The pair is <eventName, eventPayload>.
    std::queue<std::pair<std::string, std::string>> m_eventQueue;

    alexaClientSDK::avsCommon::utils::threading::Executor m_executor;

    /// for bluetooth Connected heart beat
    std::condition_variable m_bluetoothConnectedHeartBeatCV;
    std::mutex m_bluetoothConnectedMutex;
};

}  // namespace alexa
}  // namespace engine
}  // namespace aace

#endif  // AACE_ENGINE_AZERO_BLUETOOTH_CAPABILITY_AGENT_H
