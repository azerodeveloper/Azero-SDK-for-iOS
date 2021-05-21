#ifndef AACE_ALEXA_AZERO_FILEUPLOADER_H
#define AACE_ALEXA_AZERO_FILEUPLOADER_H

#include "AACE/Core/PlatformInterface.h"
#include "AACE/Alexa/AlexaEngineInterfaces.h"

namespace aace {
namespace alexa {

class AzeroFileUploader : public aace::core::PlatformInterface {
protected:
    AzeroFileUploader() = default;
public:
    virtual ~AzeroFileUploader();
    bool sendFile(const std::string& file);
    void setEngineInterface( std::shared_ptr<aace::alexa::AzeroFileUploaderEngineInterface> fileUploaderEngineInterface );

private:
    std::shared_ptr<aace::alexa::AzeroFileUploaderEngineInterface> m_fileUploaderEngineInterface;
};

} // aace::alexa
} // aace

#endif // AACE_ALEXA_AZERO_FILEUPLOADER_H
