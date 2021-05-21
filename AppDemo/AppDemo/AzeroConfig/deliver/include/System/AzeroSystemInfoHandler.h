#ifndef ALEXA_CLIENT_SDK_CAPABILITYAGENTS_SYSTEM_INCLUDE_SYSTEM_AZERO_INFO_H_
#define ALEXA_CLIENT_SDK_CAPABILITYAGENTS_SYSTEM_INCLUDE_SYSTEM_AZERO_INFO_H_

#include <memory>
#include <chrono>
#include <thread>

#include <AVSCommon/AVS/CapabilityAgent.h>
#include <AVSCommon/SDKInterfaces/AVSEndpointAssignerInterface.h>
#include <AVSCommon/SDKInterfaces/AVSConnectionManagerInterface.h>
#include <AVSCommon/Utils/RequiresShutdown.h>
#include <AVSCommon/Utils/Logger/Logger.h>
#include <AVSCommon/Utils/Threading/Executor.h>


namespace alexaClientSDK {
namespace capabilityAgents {
namespace system {

class AzeroSystemInfoHandler
    : public avsCommon::avs::CapabilityAgent
    , public avsCommon::utils::RequiresShutdown{
private:
    /// The @c AVSEndpointAssignerInterface used to signal endpoint change.
    std::shared_ptr<avsCommon::sdkInterfaces::AVSEndpointAssignerInterface> m_avsEndpointAssigner;

    /// when net ping timeout, reconnect this connectManager
    std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::AVSConnectionManagerInterface> m_connectManager;

    /// ping interval
    int m_interval;

    /// ping thread start time 
    std::chrono::steady_clock::time_point m_startTimePoint;
    /// duration of ping thread, in seconds
    int64_t m_duration;

    /// ping thread
    std::thread m_pingThread;

    std::string m_endPoint;

    /// This is the worker thread for the @c AzeroSystemInfoHandler CA.
    alexaClientSDK::avsCommon::utils::threading::Executor m_executor;

public:
    static std::shared_ptr<AzeroSystemInfoHandler> create(
        std::shared_ptr<avsCommon::sdkInterfaces::AVSEndpointAssignerInterface> avsEndpointAssigner,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::AVSConnectionManagerInterface> connectManager,
        std::shared_ptr<avsCommon::sdkInterfaces::ExceptionEncounteredSenderInterface> exceptionEncounteredSender);

    /// @name RequiresShutdown Functions
    /// @{
    void doShutdown() override;
    /// @}

    ~AzeroSystemInfoHandler();
private:
    AzeroSystemInfoHandler(
        std::shared_ptr<avsCommon::sdkInterfaces::AVSEndpointAssignerInterface> avsEndpointAssigner,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::AVSConnectionManagerInterface> connectManager,
        std::shared_ptr<avsCommon::sdkInterfaces::ExceptionEncounteredSenderInterface> exceptionEncounteredSender);

    /// @name DirectiveHandlerInterface and CapabilityAgent Functions
    /// @{
    avsCommon::avs::DirectiveHandlerConfiguration getConfiguration() const override;
    void handleDirectiveImmediately(std::shared_ptr<avsCommon::avs::AVSDirective> directive) override;
    void preHandleDirective(std::shared_ptr<avsCommon::avs::CapabilityAgent::DirectiveInfo> info) override;
    void handleDirective(std::shared_ptr<avsCommon::avs::CapabilityAgent::DirectiveInfo> info) override;
    void cancelDirective(std::shared_ptr<avsCommon::avs::CapabilityAgent::DirectiveInfo> info) override;
    /// @}

    void handleSetKeepAliveIntervalDirective(std::shared_ptr<avsCommon::avs::CapabilityAgent::DirectiveInfo> info);

    /// main thread of ping
    void pingRunTime();
};

}  // namespace system
}  // namespace capabilityAgents
}  // namespace alexaClientSDK


#endif//ALEXA_CLIENT_SDK_CAPABILITYAGENTS_SYSTEM_INCLUDE_SYSTEM_AZERO_INFO_H_