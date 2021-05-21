/*
 * Quantum.h
 *
 *  Created on: Apr 2, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_CACHE_QUANTUM_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_CACHE_QUANTUM_H_

#include <cstring>
#include <algorithm>

namespace aace {
namespace engine {
namespace openDenoise {
namespace cache {

template< typename Policy >
class Quantum {
public:
	using SizeType = typename Policy::SizeType;
	static constexpr SizeType QuantumSize = Policy::QuantumSize;

public:
	Quantum() noexcept = default;

	Quantum( const Quantum &) = delete;
	Quantum( Quantum && ) = delete;

	Quantum & operator=( const Quantum & ) = delete;
	Quantum & operator=( const Quantum && ) = delete;

	bool isFull() const noexcept {
		return m_usedSize >= QuantumSize;
	}

	SizeType write( const char *data, SizeType size ) noexcept {
		auto copySize = std::min( size, QuantumSize - m_usedSize );
		std::memcpy( m_data + m_usedSize, data, copySize );
		m_usedSize += copySize;
		return copySize;
	}

	SizeType size() const noexcept {
		return m_usedSize;
	}

	void clear() noexcept {
		m_usedSize = 0;
	}

	const char *data() const noexcept {
		return m_data;
	}

	void reset() noexcept {
		m_usedSize = 0;
	}

private:
	char m_data[QuantumSize];
	SizeType m_usedSize = 0;
};

} /* namespace cache */
} /* namespace openDenoise */
} /* namespace engine */
} /* namespace aace */

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_CACHE_QUANTUM_H_ */
