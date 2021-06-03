/*
 * SequcenceIdGenerator.h
 *
 *  Created on: Apr 7, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_EVENTHANDLESTRATEGY_SEQUENCEIDGENERATOR_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_EVENTHANDLESTRATEGY_SEQUENCEIDGENERATOR_H_

#include <cstdint>
#include <atomic>

namespace aace {
namespace engine {
namespace openDenoise {
namespace eventHandleStrategy {

template< typename BindType, typename CounterType = std::uint64_t>
class SequenceIdGenerator {
public:

	static SequenceIdGenerator &
	instance() {
		static SequenceIdGenerator generator;
		return generator;
	}

	CounterType nextId() {
		return m_atomicCounter.fetch_add(1);
	}

private:
	std::atomic<CounterType> m_atomicCounter { 0 };
};

} /* namespace eventHandleStrategy */
} /* namespace openDenoise */
} /* namespace engine */
} /* namespace aace */

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_EVENTHANDLESTRATEGY_SEQUENCEIDGENERATOR_H_ */
