/*
 * Cache.h
 *
 *  Created on: Apr 2, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_CACHE_CACHE_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_CACHE_CACHE_H_

#include <memory>
#include <mutex>
#include <list>
#include <functional>
#include <atomic>

#include "ObjectPool.h"
#include "Quantum.h"

namespace aace {
namespace engine {
namespace openDenoise {
namespace cache {

template< typename T>
class ObjectPool;

template< typename Policy >
class Quantum;

struct DefaultCachePolicy {
	using SizeType = std::size_t;
	static constexpr SizeType QuantumSize = 256*2;
	struct QuantumPolicy {
		using SizeType = DefaultCachePolicy::SizeType;
		static constexpr SizeType QuantumSize = DefaultCachePolicy::QuantumSize;
	};
	using QuantumType = Quantum<QuantumPolicy>;
	using ObjectPoolType = ObjectPool<QuantumType>;
	using QuantumPtr = typename ObjectPoolType::ObjectPtr;
	struct QuantumAllocator {
		QuantumPtr operator()() {
			auto ptr = ObjectPoolType::instance().get();
			ptr->reset();
			return ptr;
		}
	};

	static constexpr SizeType MaxCachedQuantumNumInStream = 10*64;	//10 seconds
	static constexpr SizeType MaxCachedQuantumNumInCache = 30;
};

template< typename Policy = DefaultCachePolicy >
class Cache {
public:
	using SizeType = typename Policy::SizeType;
	using QuantumAllocator = typename Policy::QuantumAllocator;
	using QuantumType = typename Policy::QuantumType;
	using QuantumPtr = typename Policy::QuantumPtr;
	using QuantumListType = std::list<QuantumPtr>;
	static constexpr SizeType MaxCachedQuantumNumInCache = Policy::MaxCachedQuantumNumInCache;

	class Stream : public std::enable_shared_from_this<Stream> {
	public:
		using SizeType = typename Policy::SizeType;
		using QuantumPtr = typename Policy::QuantumPtr;
		static constexpr SizeType MaxCachedQuantumNumInStream = Policy::MaxCachedQuantumNumInStream;
		class EventObserverInterface {
		public:
			using SizeType = typename Policy::SizeType;
			virtual ~EventObserverInterface() = default;
			virtual void onDetached() {}
			virtual void onDataUpdated( SizeType count ) {}
			virtual void onExceedMaxCacheLength( SizeType max ) {}
		};

	public:
		Stream( std::shared_ptr<Cache> cache )
		: m_cache( cache ) { }

		virtual ~Stream() {
			detach();
		}

		static
		std::shared_ptr<Stream>
		create( std::shared_ptr<Cache>  cache ) {
			return std::shared_ptr<Stream>( new Stream( cache ));
		}

		Stream( const Stream & ) = delete;
		Stream( Stream && ) = delete;
		Stream & operator=( const Stream & ) = delete;
		Stream & operator=( Stream && ) = delete;

		QuantumPtr getQuantumWithoutBlocking() {
			QuantumPtr ptr;
			do {
				std::lock_guard<std::mutex> lg( m_mutex );
				while ( !ptr ) {
					if ( m_quantumList.empty() ) {
						break;
					}

					ptr = std::move( m_quantumList.front() );
					m_quantumList.pop_front();
				}
			} while ( 0 );
			return ptr;
		}

		SizeType pushQuantum( QuantumPtr &&ptr ) {
			SizeType listLen = 0;
			do {
				std::lock_guard<std::mutex> lg( m_mutex );
				if ( m_isDetached || m_exceeded ) {
					return 0;
				}

				if (m_quantumList.size() >= MaxCachedQuantumNumInStream ) {
					m_exceeded = true;
					break;
				}
				m_quantumList.emplace_back( std::move( ptr ));
				listLen = m_quantumList.size();
			} while ( 0 );
			auto eventObserver = m_eventObserver.lock();
			if ( eventObserver ) {
				if ( m_exceeded ) {
					eventObserver->onExceedMaxCacheLength( MaxCachedQuantumNumInStream );
				} else {
					eventObserver->onDataUpdated( listLen );
				}
			}
			return m_exceeded ? 0 : 1;
		}

		SizeType pushQuantums( QuantumListType &&quantums ) {
			SizeType retSize = 0;
			SizeType listLen = 0;

			do {
				std::lock_guard<std::mutex> lg( m_mutex );
				if ( quantums.empty() ) {
					return 0;
				}
				if ( m_isDetached || m_exceeded ) {
					return 0;
				}

				SizeType leftSpace = MaxCachedQuantumNumInStream - m_quantumList.size();
				retSize = std::min(leftSpace, static_cast<SizeType>( quantums.size() ));
				m_exceeded = retSize < quantums.size();

				auto left = retSize;
				while ( left-- ) {
					auto tmp = std::move( quantums.front() );
					quantums.pop_front();
					m_quantumList.emplace_back( std::move( tmp ));
				}
				listLen = m_quantumList.size();
			} while ( 0 );

			auto eventObserver = m_eventObserver.lock();
			if ( eventObserver ) {
				if ( retSize > 0 ) {
					eventObserver->onDataUpdated( listLen );
				}
				if ( m_exceeded ) {
					eventObserver->onExceedMaxCacheLength( MaxCachedQuantumNumInStream );
				}
			}
			return retSize;
		}

		bool isDetached() {
			return m_isDetached;
		}

		void detach() {
			bool firstime = false;
			{
				std::lock_guard<std::mutex> lg( m_mutex );
				if ( !m_isDetached ) {
					m_cache->detach( std::enable_shared_from_this<Stream>::shared_from_this() );
					m_isDetached = true;
					firstime = true;
				}
			}

			if ( !firstime ) {
				return;
			}

			auto eventObserver = m_eventObserver.lock();
			if ( eventObserver ) {
				eventObserver->onDetached();
			}
		}

		void clear() {
			std::lock_guard<std::mutex> lg( m_mutex );
			m_quantumList.clear();
		}

		SizeType size() {
			std::lock_guard<std::mutex> lg( m_mutex );
			return m_quantumList.size();
		}

		void setEventObserver( std::weak_ptr<EventObserverInterface> eventObserver ) {
			m_eventObserver = eventObserver;
		}

	private:
		std::mutex m_mutex;
		QuantumListType m_quantumList;
		std::shared_ptr<Cache> m_cache;
		std::weak_ptr<EventObserverInterface> m_eventObserver;
		volatile bool m_isDetached = false;
		bool m_exceeded = false;
	};

	using StreamPtr = std::shared_ptr<Stream>;
	using StreamWeakPtr = std::weak_ptr<Stream>;

public:
	Cache( const Cache &) = delete;
	Cache( Cache && ) = delete;
	Cache & operator=( const Cache & ) = delete;
	Cache & operator=( const Cache && ) = delete;

public:
	virtual ~Cache() {
		forceDetach();
	}

	static
	std::unique_ptr<Cache>
	create() {
		return std::unique_ptr<Cache>( new Cache() );
	}

	void write( const char *data, SizeType size ) {
		if ( !writeToAttachedStream( data, size )) {
			writeToCacheList( data, size );
		}
	}

	void attach( StreamPtr stream ) {
		if ( !stream ) {
			return;
		}

		StreamWeakPtr oldStreamWeakPtr;
		{
			std::lock_guard<std::mutex> lg( m_quantumListMutex );
			{
				std::lock_guard<std::mutex> lg( m_attachedStreamMutex );
				oldStreamWeakPtr = m_attachedStream;
				m_attachedStream = stream;
			}
			QuantumListType tmpList;
			tmpList.swap( m_quantumList );
			stream->pushQuantums( std::move( tmpList ));
		}

		auto oldStream = oldStreamWeakPtr.lock();
		if ( oldStream ) {
			oldStream->detach();
		}
	}

	bool isAttached() {
		return lockAttachedStream();
	}

	void detach( StreamPtr stream ) {
		std::lock_guard<std::mutex> lg( m_attachedStreamMutex );
		auto attachedStream = m_attachedStream.lock();
		if ( attachedStream == stream ) {
			m_attachedStream.reset();
		}
	}

	void forceDetach() {
		StreamWeakPtr oldStreamWeakPtr;
		{
			std::lock_guard<std::mutex> lg( m_attachedStreamMutex );
			oldStreamWeakPtr = m_attachedStream;
			m_attachedStream.reset();
		}
		auto oldStream = oldStreamWeakPtr.lock();
		if ( oldStream ) {
			oldStream->detach();
		}
	}

private:
	Cache() {}

	StreamPtr lockAttachedStream() {
		std::lock_guard<std::mutex> lg( m_attachedStreamMutex );
		return m_attachedStream.lock();
	}

	bool writeToAttachedStream( const char *data, SizeType size ) {
		auto stream = lockAttachedStream();
		if ( !stream ) {
			return false;
		}

		decltype(size) done = 0;
		while ( done < size ) {
			auto quantum = m_quantumAllocator();
			done += quantum->write( data, size );
			stream->pushQuantum( std::move( quantum ));
		}

		return true;
	}

	void writeToCacheList( const char *data, SizeType size ) {
		std::lock_guard<std::mutex> lg( m_quantumListMutex );
		decltype(size) done = 0;
		while ( done < size ) {
			auto quantum = m_quantumAllocator();
			done += quantum->write( data, size );
			appendToCacheList( std::move( quantum ));
		}
	}

	void appendToCacheList( QuantumPtr &&quantum ) {
		if ( m_quantumList.size() >= MaxCachedQuantumNumInCache ) {
			m_quantumList.pop_front();
		}
		m_quantumList.emplace_back( std::move( quantum ));
	}

	void reset() {
		std::lock_guard<std::mutex> lg( m_quantumListMutex );
		m_quantumList.clear();
	}

private:
	std::mutex m_attachedStreamMutex;
	StreamWeakPtr m_attachedStream;
	std::mutex m_quantumListMutex;
	QuantumListType m_quantumList;
	QuantumAllocator m_quantumAllocator;
};

} /* namespace cache */
} /* namespace openDenoise */
} /* namespace engine */
} /* namespace aace */

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_CACHE_CACHE_H_ */
