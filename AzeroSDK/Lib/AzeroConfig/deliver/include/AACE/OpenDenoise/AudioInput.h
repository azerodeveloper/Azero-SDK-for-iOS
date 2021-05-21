/*
 * AudioInput.h
 *
 *  Created on: Mar 6, 2020
 *      Author: nero
 */

#ifndef PLATFORM_INCLUDE_AACE_OPENDENOISE_AUDIOINPUT_H_
#define PLATFORM_INCLUDE_AACE_OPENDENOISE_AUDIOINPUT_H_


#include <stdlib.h>

#include <AACE/Core/PlatformInterface.h>

namespace aace {
namespace openDenoise {

class AudioInputEngineInterface;

class AudioInput : public aace::core::PlatformInterface {
protected:
	AudioInput() = default;

public:
	virtual ~AudioInput() = default;

	// you can write audio input stream between Engine.start and Engine.stop
	bool write( const char *data, const size_t size );

	//internal
	void setEngineInterface(
			std::shared_ptr<AudioInputEngineInterface>
				engineInterface );
private:
	std::weak_ptr<AudioInputEngineInterface> m_engineInterface;
};

}	//namespace openDenoise
}	//namespace aace

#endif /* PLATFORM_INCLUDE_AACE_OPENDENOISE_AUDIOINPUT_H_ */
