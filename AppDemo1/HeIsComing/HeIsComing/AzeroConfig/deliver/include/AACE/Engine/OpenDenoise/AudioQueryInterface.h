/*
 * AudioQueryInterface.h
 *
 *  Created on: Apr 3, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERYINTERFACE_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERYINTERFACE_H_

#include "Cache/Cache.h"
#include "Cache/Quantum.h"
#include "Cache/ObjectPool.h"
#include <AACE/OpenDenoise/LocalSpeechDetectorEngineInterface.h>

namespace aace {
namespace engine {
namespace openDenoise {

using MyCachePolicy = cache::DefaultCachePolicy;

class AudioQueryInterface {
public:
	using QuantumType = cache::Quantum<MyCachePolicy::QuantumPolicy>;
	using ObjectPoolType = cache::ObjectPool<QuantumType>;
	using QuantumPtr = typename ObjectPoolType::ObjectPtr;
	using SequenceIdType = aace::openDenoise::LocalSpeechDetectorEngineInterface::SequenceIdType;

public:
	AudioQueryInterface( SequenceIdType sequenceId )
	: m_sequenceId( sequenceId ) {}

	virtual ~AudioQueryInterface() = default;

	virtual bool bad() = 0;

	virtual bool closed() = 0;

	virtual void close() = 0;

	virtual QuantumPtr getQuantumWithoutBlocking() = 0;

	SequenceIdType getSequencyId() {
		return m_sequenceId;
	}

private:
	SequenceIdType m_sequenceId;
};

} /* namespace openDenoise */
} /* namespace engine */
} /* namespace aace */

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERYINTERFACE_H_ */
