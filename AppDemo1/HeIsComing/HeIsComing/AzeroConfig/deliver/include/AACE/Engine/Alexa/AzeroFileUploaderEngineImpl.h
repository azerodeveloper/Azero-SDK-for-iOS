#ifndef AACE_ENGINE_AZEROFILEUPLOADER_ENGINE_IMPL_H
#define AACE_ENGINE_AZEROFILEUPLOADER_ENGINE_IMPL_H

// #include <chrono>
#include <memory>
// #include <queue>
// #include <string>
// #include <unordered_set>

// #include <AVSCommon/SDKInterfaces/DirectiveSequencerInterface.h>
// #include <AVSCommon/AVS/CapabilityConfiguration.h>
// #include <AVSCommon/SDKInterfaces/CapabilityConfigurationInterface.h>
// #include <AVSCommon/SDKInterfaces/CapabilitiesDelegateInterface.h>
// #include <AVSCommon/SDKInterfaces/MessageSenderInterface.h>
// #include <AVSCommon/SDKInterfaces/PlaybackRouterInterface.h>
// #include <AVSCommon/SDKInterfaces/FocusManagerInterface.h>
// #include <AVSCommon/AVS/CapabilityAgent.h>
#include <AVSCommon/Utils/RequiresShutdown.h>
// #include <AVSCommon/Utils/Threading/Executor.h>

// #include <AVSCommon/SDKInterfaces/AVSConnectionManagerInterface.h>

// #include <AACE/Alexa/AzeroBluetooth.h>

// #include "AACE/Engine/Alexa/AzeroBluetoothInterface.h"
// #include "AACE/Alexa/AlexaEngineInterfaces.h"
// #include "AACE/Engine/Alexa/AzeroBluetoothCapabilityAgent.h"

#include <AACE/Alexa/AzeroFileUploader.h>

#include "AACE/Alexa/AlexaEngineInterfaces.h"
#include "AACE/Engine/Alexa/AzeroFileUploaderDelegate.h"

namespace aace {
namespace engine {
namespace alexa {

class AzeroFileUploaderEngineImpl :
    public aace::alexa::AzeroFileUploaderEngineInterface
    , public alexaClientSDK::avsCommon::utils::RequiresShutdown
    , public std::enable_shared_from_this<AzeroFileUploaderEngineImpl>{
private:
    AzeroFileUploaderEngineImpl( std::shared_ptr<aace::alexa::AzeroFileUploader> fileUploaderPlatformInterface,
                                 std::shared_ptr<AzeroFileUploaderDelegate> fileUploaderDelegate);
public:
    static std::shared_ptr<AzeroFileUploaderEngineImpl> create(
        std::shared_ptr<aace::alexa::AzeroFileUploader> fileUploaderPlatformInterface,
        std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::AuthDelegateInterface> authProviderEngineImpl);
    bool sendFile(const std::string& file) override;
protected:
    virtual void doShutdown() override;
private:
    std::shared_ptr<aace::alexa::AzeroFileUploader> m_fileUploaderPlatformInterface;
    std::shared_ptr<AzeroFileUploaderDelegate> m_fileUploaderDelegate;
};

} // aace::engine::alexa
} // aace::engine
} // aace

#endif // AACE_ENGINE_AZEROFILEUPLOADER_ENGINE_IMPL_H
