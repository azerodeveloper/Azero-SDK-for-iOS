#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_SCOPEGUARD_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_SCOPEGUARD_H_

#include <string>

namespace aace {
namespace engine {
namespace openDenoise {

template <typename Callable>
class ScopeGuard {
public:
	ScopeGuard( Callable f ) : f( f ) {}
	~ScopeGuard() { if ( !m_abort ) f(); }
	void abort() { m_abort = true; }
private:
	Callable f;
	bool m_abort = false;
};

} // aace::engine::openDenoise
} // aace::engine
} // aace

#endif	//ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_SCOPEGUARD_H_
