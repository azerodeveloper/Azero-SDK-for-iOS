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

#ifndef AACE_ENGINE_ALEXA_AZEROEXPRESS_ENGINE_IMPL_H
#define AACE_ENGINE_ALEXA_AZEROEXPRESS_ENGINE_IMPL_H

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
#include <AVSCommon/AVS/CapabilityAgent.h>
#include <AVSCommon/Utils/RequiresShutdown.h>
#include <AVSCommon/Utils/Threading/Executor.h>

#include "AACE/Alexa/AlexaEngineInterfaces.h"
#include "AACE/Alexa/AzeroExpress.h"
#include <AVSCommon/SDKInterfaces/AVSConnectionManagerInterface.h>

namespace aace {
namespace engine {
namespace alexa {

class AzeroExpressEngineImpl :
    public alexaClientSDK::avsCommon::avs::CapabilityAgent
    , public alexaClientSDK::avsCommon::sdkInterfaces::CapabilityConfigurationInterface
    , public alexaClientSDK::avsCommon::utils::RequiresShutdown
    , public aace::alexa::AzeroExpressEngineInterface
    , public std::enable_shared_from_this<AzeroExpressEngineImpl>{

private:
    AzeroExpressEngineImpl( std::shared_ptr<aace::alexa::AzeroExpress> sampleSkillPlatformInterface,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ExceptionEncounteredSenderInterface> exceptionSender);

    bool initialize(
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::MessageSenderInterface> messageSender,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::AVSConnectionManagerInterface> connectManager,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::DirectiveSequencerInterface> directiveSequencer,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::CapabilitiesDelegateInterface> capabilitiesDelegate,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ExceptionEncounteredSenderInterface> exceptionSender);

public:
    static std::shared_ptr<AzeroExpressEngineImpl> create(
        std::shared_ptr<aace::alexa::AzeroExpress> sampleSkillPlatformInterface,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::MessageSenderInterface> messageSender,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::AVSConnectionManagerInterface> connectManager,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::DirectiveSequencerInterface> directiveSequencer,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::CapabilitiesDelegateInterface> capabilitiesDelegate,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::ExceptionEncounteredSenderInterface> exceptionSender);

    // AzeroExpressPlatformInterface
    void handleExpressDirective(const std::string& name, const std::string& jsonPayload);
  
     // AzeroExpressEngineInterface
    void sendEvent(const std::string& jsonContent) override;
    void reconnectAVSnet() override;
    void disconnectAVSnet() override;
    void connectAVSnet() override;
    /// @name CapabilityAgent/DirectiveHandlerInterface Functions
    /// @{
    void handleDirectiveImmediately(std::shared_ptr<alexaClientSDK::avsCommon::avs::AVSDirective> directive) override;
    void preHandleDirective(std::shared_ptr<DirectiveInfo> info) override;
    void handleDirective(std::shared_ptr<DirectiveInfo> info) override;
    void cancelDirective(std::shared_ptr<DirectiveInfo> info) override;
    alexaClientSDK::avsCommon::avs::DirectiveHandlerConfiguration getConfiguration() const override;

    /// @name CapabilityConfigurationInterface Functions
    /// @{
    std::unordered_set<std::shared_ptr<alexaClientSDK::avsCommon::avs::CapabilityConfiguration>> getCapabilityConfigurations() override;
    
private:
    /**
     * This function handles any unknown directives received by @c TemplateRuntime CA.
     *
     * @param info The @c DirectiveInfo containing the @c AVSDirective and the @c DirectiveHandlerResultInterface.
     */
    void handleUnknownDirective(std::shared_ptr<DirectiveInfo> info);
    
    /// Set of capability configurations that will get published using the Capabilities API
    std::unordered_set<std::shared_ptr<alexaClientSDK::avsCommon::avs::CapabilityConfiguration>> m_capabilityConfigurations;
 
    std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::MessageSenderInterface> m_messageSender;
    std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::AVSConnectionManagerInterface> m_connectManager;

    std::shared_ptr<aace::alexa::AzeroExpress> m_azeroExpressPlatformInterface;
    
    // @name RequiresShutdown Functions
    /// @{
    void doShutdown() override;

    /// This is the worker thread for the @c AzeroExpress CA.
    alexaClientSDK::avsCommon::utils::threading::Executor m_executor;
   
    /**
     * Remove a directive from the map of message IDs to DirectiveInfo instances.
     *
     * @param info The @c DirectiveInfo containing the @c AVSDirective whose message ID is to be removed.
     */
    void removeDirective(std::shared_ptr<DirectiveInfo> info);
};

} // aace::engine::alexa
} // aace::engine
} // aace

#endif // AACE_ENGINE_ALEXA_SAMPLESKILL_ENGINE_IMPL_H
