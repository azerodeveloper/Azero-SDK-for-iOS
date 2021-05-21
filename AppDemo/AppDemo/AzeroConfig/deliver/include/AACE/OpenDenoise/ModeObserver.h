/*
 * ModeOberserver.h
 *
 *  Created on: Mar 25, 2020
 *      Author: nero
 */

#ifndef PLATFORM_INCLUDE_AACE_OPENDENOISE_MODEOBSERVER_H_
#define PLATFORM_INCLUDE_AACE_OPENDENOISE_MODEOBSERVER_H_

#include <AACE/Core/PlatformInterface.h>
#include "ModeObserverInterface.h"

namespace aace {
namespace openDenoise {

class ModeObserver
		: public aace::core::PlatformInterface
		, public ModeObserverInterface {
protected:
	ModeObserver() = default;
};

} /* namespace openDenoise */
} /* namespace aace */

#endif /* PLATFORM_INCLUDE_AACE_OPENDENOISE_MODEOBSERVER_H_ */
