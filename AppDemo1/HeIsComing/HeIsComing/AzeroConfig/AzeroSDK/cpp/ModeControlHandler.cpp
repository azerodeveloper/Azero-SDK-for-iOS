#include "ModeControlHandler.h"
#include <AACE/Engine/Core/EngineMacros.h>

namespace azeroSDK {

const static std::string TAG = "azeroSDK.ModeControlHandler";

std::shared_ptr<ModeControlHandler> ModeControlHandler::create() {
    return std::shared_ptr<ModeControlHandler>( new ModeControlHandler() );
}

bool ModeControlHandler::restartOpenDenoise() {
    try
    {
        ModeConfiguration config;
        auto ret = getMode( config );

        ThrowIf( ret != aace::openDenoise::OpenDenoiseErrc::Success, "get mode failed");

        ret = setMode(config);

        ThrowIf( ret != aace::openDenoise::OpenDenoiseErrc::Success, "set mode failed");

        return true;
    }
    catch(const std::exception& e)
    {
        SAI_ERROR(LX(TAG, __FUNCTION__).m(e.what()));
        return false;
    }
}

} //namespace azeroSDK
