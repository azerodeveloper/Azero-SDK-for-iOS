/*
 * VOIPStreamEngineInterface.h
 *
 *  Created on: Mar 10, 2020
 *      Author: nero
 */

#ifndef PLATFORM_INCLUDE_AACE_OPENDENOISE_VOIPSTREAMENGINEINTERFACE_H_
#define PLATFORM_INCLUDE_AACE_OPENDENOISE_VOIPSTREAMENGINEINTERFACE_H_

#include <stdlib.h>

namespace aace {
namespace openDenoise {

class VOIPStreamEngineInterface {
protected:
	VOIPStreamEngineInterface() = default;

public:
	virtual ~VOIPStreamEngineInterface() = default;

	virtual bool start() = 0;
	virtual bool stop() = 0;
	virtual void notifyStreamOpened() = 0;
	virtual void notifyStreamClosed() = 0;
	virtual void write( const char *data, size_t size ) = 0;
};

}	//namespace openDenoise
}	//namespace aace


#endif /* PLATFORM_INCLUDE_AACE_OPENDENOISE_VOIPSTREAMENGINEINTERFACE_H_ */
