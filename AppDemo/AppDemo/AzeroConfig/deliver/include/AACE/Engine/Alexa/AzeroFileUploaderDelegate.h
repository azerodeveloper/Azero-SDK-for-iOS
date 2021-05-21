#ifndef AACE_ENGINE_ALEXA_AZEROFILEUPLOADERDELEGATE_ENGINE_IMPL_H
#define AACE_ENGINE_ALEXA_AZEROFILEUPLOADERDELEGATE_ENGINE_IMPL_H

#include <mutex>
#include <fstream>

#include <AVSCommon/Utils/LibcurlUtils/HttpPost.h>
#include <AVSCommon/Utils/LibcurlUtils/HTTPResponse.h>
#include <AVSCommon/Utils/Timing/Timer.h>
#include "AACE/Engine/Core/EngineMacros.h"
#include <AVSCommon/SDKInterfaces/AuthDelegateInterface.h>

namespace aace {
namespace engine {
namespace alexa {
class AzeroFileUploaderDelegate
    // public aace::engine::alexa::AuthProviderEngineImpl 
    {
protected:
    AzeroFileUploaderDelegate(std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::AuthDelegateInterface> authProviderEngineImpl);

public:
    static std::shared_ptr<AzeroFileUploaderDelegate> create(std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::AuthDelegateInterface> authProviderEngineImpl);
    virtual ~AzeroFileUploaderDelegate();
    bool sendFile(const std::string& file);

private:
    bool executeUploadFile(const std::string& fileName);
    bool compressLogFile(FILE *source,FILE *dest);
    bool exists( const std::string& filename );
    std::shared_ptr<alexaClientSDK::avsCommon::sdkInterfaces::AuthDelegateInterface> m_authProviderEngineImpl;
    static size_t staticWriteCallback(char* ptr, size_t size, size_t nmemb, std::string* userdata);

private:
    std::unique_ptr<alexaClientSDK::avsCommon::utils::libcurlUtils::HttpPost> m_httpPost;
    std::mutex m_mutex;
    std::string m_deviceSN{""};

    using Timer = alexaClientSDK::avsCommon::utils::timing::Timer;
    Timer m_timerDelayUploadFile;
};

} // aace::engine::alexa
} // aace::engine
} // aace

#endif //AACE_ENGINE_ALEXA_AZEROFILEUPLOADERDELEGATE_ENGINE_IMPL_H
