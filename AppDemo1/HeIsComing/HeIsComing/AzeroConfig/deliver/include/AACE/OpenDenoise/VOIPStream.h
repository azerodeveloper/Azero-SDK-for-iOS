/*
 * VOIPStream.h
 *
 *  Created on: Mar 6, 2020
 *      Author: nero
 */

#ifndef PLATFORM_INCLUDE_AACE_OPENDENOISE_VOIPSTREAM_H_
#define PLATFORM_INCLUDE_AACE_OPENDENOISE_VOIPSTREAM_H_

#include <stdlib.h>
#include <AACE/Core/PlatformInterface.h>

namespace aace {
namespace openDenoise {

class VOIPStreamEngineInterface;

class VOIPStream : public aace::core::PlatformInterface {
protected:
	VOIPStream() = default;

public:
	virtual ~VOIPStream() = default;

	bool start();
	bool stop();

	virtual void onStreamOpened() = 0;
	virtual void onStreamClosed() = 0;
	virtual void write( const char *data, size_t size ) = 0;

	//internal
	void setEngineInterface(
			std::shared_ptr<VOIPStreamEngineInterface>
				engineInterface );
private:
	std::weak_ptr<VOIPStreamEngineInterface> m_engineInterface;
};

}	//namespace openDenoise
}	//namespace aace

#endif /* PLATFORM_INCLUDE_AACE_OPENDENOISE_VOIPSTREAM_H_ */
