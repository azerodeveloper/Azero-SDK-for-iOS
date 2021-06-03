/*
 * ModeControlEngineInterface.h
 *
 *  Created on: Mar 25, 2020
 *      Author: nero
 */

#ifndef PLATFORM_INCLUDE_AACE_OPENDENOISE_MODECONTROLENGINEINTERFACE_H_
#define PLATFORM_INCLUDE_AACE_OPENDENOISE_MODECONTROLENGINEINTERFACE_H_

#include "ModeObserverInterface.h"
#include "ErrorCode.h"

namespace aace {
namespace openDenoise {

class ModeControlEngineInterface {
public:
	using ModeConfiguration = aace::openDenoise::ModeObserverInterface::ModeConfiguration;

public:
	virtual ~ModeControlEngineInterface() = default;

	virtual OpenDenoiseErrc getMode( ModeConfiguration &config ) const = 0;

	virtual OpenDenoiseErrc setMode( const ModeConfiguration &config ) = 0;
};

} /* namespace openDenoise */
} /* namespace aace */

#endif /* PLATFORM_INCLUDE_AACE_OPENDENOISE_MODECONTROLENGINEINTERFACE_H_ */
