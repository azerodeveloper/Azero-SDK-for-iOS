/*
 * OpenDenoiseConfiguration.h
 *
 *  Created on: Mar 6, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_OPENDENOISECONFIGURATION_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_OPENDENOISECONFIGURATION_H_

#include <string>
#include <unordered_map>
#include <AACE/OpenDenoise/ModeObserverInterface.h>

namespace aace {
namespace engine {
namespace openDenoise {

struct OpenDenoiseConfiguration {
	using ModelMap = std::unordered_map<std::string, std::string>;
	using WakeupMode = aace::openDenoise::ModeObserverInterface::WakeupMode;

	std::string deviceClientId;
	std::string deviceSerialNumber;
	std::string deviceProductId;

	std::string licenseKey;

	std::string defaultModelName;
	WakeupMode defaultWakeupMode { WakeupMode::NormalMode };
	ModelMap models;
};

} // aace::engine::openDenoise
} // aace::engine
} // aace

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_OPENDENOISECONFIGURATION_H_ */
