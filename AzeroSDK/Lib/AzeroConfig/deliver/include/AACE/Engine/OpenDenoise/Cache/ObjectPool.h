/*
 * ObjectPool.h
 *
 *  Created on: Apr 2, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_CACHE_OBJECTPOOL_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_CACHE_OBJECTPOOL_H_

#include <memory>
#include <list>
#include <mutex>

namespace aace {
namespace engine {
namespace openDenoise {
namespace cache {

template< typename T>
class ObjectPool {
public:
	using ObjectPoolPtr = std::unique_ptr<ObjectPool>;
	using ObjectRawPtrList = std::list<T *>;

public:
	struct object_delete
	{
		constexpr object_delete() noexcept = default;

		void
		operator()(T* ptr) {
			ObjectPool::instance().put( ptr );
		}
	};
	friend object_delete;

	using ObjectPtr = std::unique_ptr<T, object_delete>;

public:
	ObjectPool( const ObjectPool & ) = delete;
	ObjectPool( ObjectPool && ) = delete;
	ObjectPool & operator=( const ObjectPool & ) = delete;
	ObjectPool & operator=( ObjectPool && ) = delete;

	~ObjectPool() {
		for ( auto ptr : m_objectList ) {
			delete ptr;
		}
	}

	static ObjectPool & instance() {
		static ObjectPoolPtr pool;
		if ( !pool ) {
			static std::once_flag once;
			std::call_once(once, []() {
				pool.reset(new ObjectPool);
			});
		}
		return *pool;
	}

	ObjectPtr get() {
		ObjectPtr ptr;
		do {
			std::lock_guard<std::mutex> lg( m_mutex );
			if ( m_objectList.empty() ) {
				break;
			}

			//cache friendly
			ptr.reset( m_objectList.back() );
			m_objectList.pop_back();
			return ptr;
		} while (0);

		ptr.reset( new T );
		return ptr;
	}

private:
	ObjectPool() {
		static_assert(!std::is_void<T>::value,
				"incomplete type");
		static_assert(sizeof(T)>0,
					"incomplete type");
		static_assert(!std::is_pointer<T>::value,
						"pointer is not supported");
	}

	void put( T *rawPtr ) {
		m_objectList.push_back( rawPtr );
	}

private:
	std::mutex m_mutex;
	ObjectRawPtrList m_objectList;
};

} /* namespace cache */
} /* namespace openDenoise */
} /* namespace engine */
} /* namespace aace */

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_CACHE_OBJECTPOOL_H_ */
