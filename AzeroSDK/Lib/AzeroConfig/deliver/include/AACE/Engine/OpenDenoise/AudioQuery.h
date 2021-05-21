/*
 * AudioQuery.h
 *
 *  Created on: Apr 2, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERY_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERY_H_

#include "Cache/Cache.h"
#include "AudioQueryInterface.h"
#include <functional>

namespace aace {
namespace engine {
namespace openDenoise {

class AudioQuery
	: public AudioQueryInterface
	, public cache::Cache<MyCachePolicy>::Stream::EventObserverInterface
	, public std::enable_shared_from_this<AudioQuery> {
public:
	using Stream = cache::Cache<MyCachePolicy>::Stream;
	using NotifyFunctionType = std::function<void(std::shared_ptr<AudioQueryInterface>)>;

private:
	enum class State {
		ok,
		closed,
		cacheOverflow,
		almostClosed,
	};

public:
	virtual ~AudioQuery();

	bool bad() override;

	bool closed() override;

	void close() override;

	QuantumPtr getQuantumWithoutBlocking() override;

	static std::shared_ptr<AudioQuery>
	create( std::shared_ptr<Stream> stream,
			SequenceIdType sequenceId,
			NotifyFunctionType notifyCb );

protected:
	//cache::Cache::Stream::EventObserverInterface
	void onDetached() override;
	void onDataUpdated( SizeType count ) override;
	void onExceedMaxCacheLength( SizeType max ) override;

private:
	AudioQuery(
			std::shared_ptr<Stream> stream,
			SequenceIdType sequenceId,
			NotifyFunctionType notifyCb );

private:
	std::shared_ptr<Stream> m_stream;
	NotifyFunctionType m_notifyCallback;
	std::mutex  m_mutex;
	State m_state = State::ok;
};

} /* namespace openDenoise */
} /* namespace engine */
} /* namespace aace */

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERY_H_ */
