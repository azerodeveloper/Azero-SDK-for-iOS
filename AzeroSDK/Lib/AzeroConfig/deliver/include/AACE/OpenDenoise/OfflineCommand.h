/*
 * OfflineCommand.h
 *
 *  Created on: Mar 6, 2020
 *      Author: nero
 */

#ifndef PLATFORM_INCLUDE_AACE_OPENDENOISE_OFFLINECOMMAND_H_
#define PLATFORM_INCLUDE_AACE_OPENDENOISE_OFFLINECOMMAND_H_

#include <stdlib.h>

#include <AACE/Core/PlatformInterface.h>

namespace aace {
namespace openDenoise {

class OfflineCommand : public aace::core::PlatformInterface {
protected:
	OfflineCommand() = default;

public:
	virtual ~OfflineCommand() = default;

	virtual void onCommandDetected( const char *cmd ) = 0;
};

}	//namespace openDenoise
}	//namespace aace



#endif /* PLATFORM_INCLUDE_AACE_OPENDENOISE_OFFLINECOMMAND_H_ */
