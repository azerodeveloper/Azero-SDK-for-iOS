/*
 * OpenDenoiseEngineService.h
 *
 *  Created on: Mar 5, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_OPENDENOISEENGINESERVICE_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_OPENDENOISEENGINESERVICE_H_

#include <memory>
#include <iostream>
#include <list>
#include <AACE/Engine/Alexa/AlexaEngineService.h>
#include <AACE/OpenDenoise/VOIPStream.h>
#include <AACE/OpenDenoise/ModeObserver.h>
#include "OpenDenoiseEngineImpl.h"

#include <rapidjson/document.h>
#include <rapidjson/prettywriter.h>
#include <rapidjson/stringbuffer.h>
#include <rapidjson/error/en.h>
#include <rapidjson/istreamwrapper.h>

namespace aace {
namespace engine {
namespace openDenoise {

class OpenDenoiseEngineService : public aace::engine::core::EngineService {
	DESCRIBE("aace.openDenoise",VERSION("0.1"),DEPENDS(aace::engine::alexa::AlexaEngineService))

private:
	using VOIPStreamList = OpenDenoiseEngineImpl::VOIPStreamList;
	using ModeObserverList = OpenDenoiseEngineImpl::ModeObserverList;

private:
	OpenDenoiseEngineService( const aace::engine::core::ServiceDescription& description );

public:
	virtual ~OpenDenoiseEngineService() = default;

protected:
	bool configure( const std::vector<std::shared_ptr<std::istream>>& configuration ) override;
	bool start() override;
	bool stop() override;

	bool registerPlatformInterface( std::shared_ptr<aace::core::PlatformInterface> platformInterface ) override;

private:
	void configure( rapidjson::Document &document );
	void parseDeviceSerialNumber( rapidjson::Document &document );
	void parseDenoiseConfiguration( rapidjson::Document &document );
	void string2WakeupMode( const std::string &name, OpenDenoiseConfiguration::WakeupMode &mode );

	// platform interface registration
	template <class T>
	bool registerPlatformInterfaceType( std::shared_ptr<aace::core::PlatformInterface> platformInterface ) {
		std::shared_ptr<T> typedPlatformInterface = std::dynamic_pointer_cast<T>( platformInterface );
		return typedPlatformInterface != nullptr ? registerPlatformInterfaceType( typedPlatformInterface ) : false;
	}

	bool registerPlatformInterfaceType( std::shared_ptr<aace::openDenoise::ModeControl> modeControl );
	bool registerPlatformInterfaceType( std::shared_ptr<aace::openDenoise::ModeObserver> modeObserver );
	bool registerPlatformInterfaceType( std::shared_ptr<aace::openDenoise::AudioInput> audioInput );
	bool registerPlatformInterfaceType( std::shared_ptr<aace::openDenoise::OfflineCommand> offlineCommand );
	bool registerPlatformInterfaceType( std::shared_ptr<aace::openDenoise::LocalSpeechDetector> localSpeechDetector );
	bool registerPlatformInterfaceType( std::shared_ptr<aace::openDenoise::VOIPStream> voipStream );

private:
	std::shared_ptr<aace::engine::openDenoise::OpenDenoiseEngineImpl> m_engineImpl;
	std::shared_ptr<aace::openDenoise::ModeControl> m_modeControl;
	ModeObserverList m_modeObserverList;
	std::shared_ptr<aace::openDenoise::AudioInput> m_audioInput;
	std::shared_ptr<aace::openDenoise::OfflineCommand> m_offlineCommand;
	std::shared_ptr<aace::openDenoise::LocalSpeechDetector> m_localSpeechDetector;
	VOIPStreamList m_voipStreamList;
	std::shared_ptr<OpenDenoiseConfiguration> m_configuration;
	bool m_configured { false };
};

} // aace::engine::openDenoise
} // aace::engine
} // aace


#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_OPENDENOISEENGINESERVICE_H_ */
