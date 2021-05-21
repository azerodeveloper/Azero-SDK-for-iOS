/*
 * AudioQueryManagerInerface.h
 *
 *  Created on: Apr 3, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERYMANAGERINTERFACE_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERYMANAGERINTERFACE_H_

#include "AudioQueryInterface.h"

namespace aace {
namespace engine {
namespace openDenoise {

class AudioQueryManagerInterface {
public:
	virtual ~AudioQueryManagerInterface() = default;

public:
	using QueryPtr = std::shared_ptr<AudioQueryInterface>;
	using QueryNotifyFunctionType = std::function<void(QueryPtr)>;
	using QuerySequenceIdType = AudioQueryInterface::SequenceIdType;

public:
	//blocking
	virtual bool start() = 0;
	//blocking
	virtual void stop() = 0;

	//no blocking
	virtual void addQuery( QueryPtr audioQuery ) = 0;

	//blocking
	virtual void stopQuery( QuerySequenceIdType id ) = 0;

	virtual QueryNotifyFunctionType getQueryNotifyFunction() = 0;
};

} /* namespace openDenoise */
} /* namespace engine */
} /* namespace aace */

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERYMANAGERINTERFACE_H_ */
