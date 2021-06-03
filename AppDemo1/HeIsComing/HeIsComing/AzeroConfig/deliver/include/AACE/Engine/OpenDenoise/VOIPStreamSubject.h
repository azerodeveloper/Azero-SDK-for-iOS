/*
 * VoipStreamSubject.h
 *
 *  Created on: Mar 31, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_VOIPSTREAMSUBJECT_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_VOIPSTREAMSUBJECT_H_

#include <stdlib.h>

namespace aace {
namespace engine {
namespace openDenoise {

class VOIPStreamSubject {
public:
	virtual ~VOIPStreamSubject() = default;

	virtual void dispatchVOIPData( const char *data, size_t size ) = 0;
	virtual void notifyStreamOpened() = 0;
	virtual void notifyStreamClosed() = 0;
};

} /* namespace openDenoise */
} /* namespace engine */
} /* namespace aace */

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_VOIPSTREAMSUBJECT_H_ */
