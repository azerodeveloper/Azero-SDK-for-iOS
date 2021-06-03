/*
 * AudioInputEngineInterface.h
 *
 *  Created on: Mar 10, 2020
 *      Author: nero
 */

#ifndef PLATFORM_INCLUDE_AACE_OPENDENOISE_AUDIOINPUTENGINEINTERFACE_H_
#define PLATFORM_INCLUDE_AACE_OPENDENOISE_AUDIOINPUTENGINEINTERFACE_H_

#include <memory>

namespace aace {
namespace openDenoise {

class AudioInputEngineInterface {
public:
	virtual ~AudioInputEngineInterface() = default;

	virtual bool write( const char *data, const size_t size ) = 0;
};

}	//namespace openDenoise
}	//namespace aace


#endif /* PLATFORM_INCLUDE_AACE_OPENDENOISE_AUDIOINPUTENGINEINTERFACE_H_ */
