/*
 * ModeControl.h
 *
 *  Created on: Mar 25, 2020
 *      Author: nero
 */

#ifndef PLATFORM_INCLUDE_AACE_OPENDENOISE_MODECONTROL_H_
#define PLATFORM_INCLUDE_AACE_OPENDENOISE_MODECONTROL_H_

#include <memory>

#include <AACE/OpenDenoise/ErrorCode.h>
#include "ModeObserverInterface.h"
#include <AACE/Core/PlatformInterface.h>

namespace aace {
namespace openDenoise {

class ModeControlEngineInterface;

class ModeControl : public aace::core::PlatformInterface {
public:
	using ModeConfiguration = aace::openDenoise::ModeObserverInterface::ModeConfiguration;
protected:
	ModeControl() = default;
public:
	virtual ~ModeControl() = default;

	//return false when system is switching mode ( or engine interface is not set )
	OpenDenoiseErrc getMode( ModeConfiguration &config ) const;

	//return false when system is switching mode ( or engine interface is not set )
	OpenDenoiseErrc setMode( const ModeConfiguration &config );

	//internal
	void setEngineInterface(
			std::shared_ptr<ModeControlEngineInterface>
				engineInterface );
private:
		std::weak_ptr<ModeControlEngineInterface> m_engineInterface;
};

} /* namespace openDenoise */
} /* namespace aace */

#endif /* PLATFORM_INCLUDE_AACE_OPENDENOISE_MODECONTROL_H_ */
