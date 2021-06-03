/*
 * AudioQueryExecutor.h
 *
 *  Created on: Apr 7, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERYEXECUTOR_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERYEXECUTOR_H_

#include "AudioQueryInterface.h"
#include <AACE/OpenDenoise/LocalSpeechDetector.h>
#include <chrono>

namespace aace {
namespace engine {
namespace openDenoise {

class AudioQueryExecutor {
private:
	enum class State {
		init,
		writing,
		stopped,
	};
	using AudioQueryError = aace::openDenoise::LocalSpeechDetector::AudioQueryError;

public:
	enum class ContinueCondition {
		ok,
		interrupt,
		stop,
	};
	using ContinuePredicate = std::function<ContinueCondition()>;

public:
	using LocalSpeechDetector = aace::openDenoise::LocalSpeechDetector;
	using QueryPtr = std::shared_ptr<AudioQueryInterface>;

public:
	AudioQueryExecutor(
				std::shared_ptr<LocalSpeechDetector> lsd,
				std::chrono::milliseconds startRetryInterval = std::chrono::milliseconds(100),
				int startMaxRetryTimes = 10,
				std::chrono::milliseconds writeRetryInterval = std::chrono::milliseconds(100),
				int dataWriteMaxRetryTimes = 200 );
	virtual ~AudioQueryExecutor();

	//user must make sure previous query completed.
	bool attach( QueryPtr query );

	void execute( ContinuePredicate &predicateFunction );

	bool expectedScheduleTimepoint( std::chrono::system_clock::time_point &tp );

	bool isComplete() const;

	void *operator new(std::size_t ) = delete;
	void *operator new[](std::size_t ) = delete;

private:
	void reset();

	//return true to indicate this query complete
	bool handleStart();
	//return true to indicate this query complete
	bool handleWrite( ContinuePredicate &&predicateFunction );

	void setExpectedScheduleTp( const std::chrono::milliseconds &duration );

	void setComplete();

private:
	State m_state = State::stopped;

	std::shared_ptr<LocalSpeechDetector> m_lsd;
	const int m_startMaxRetryTimes;
	const int m_dataWriteMaxRetryTimes;

	int m_startRetyTimes = 0;
	int m_dataWriteRetryTimes = 0;

	std::chrono::system_clock::time_point m_expectedScheduleTp;
	const std::chrono::milliseconds m_startRetryInterval;
	const std::chrono::milliseconds m_writeRetryInterval;

	QueryPtr m_query;
	AudioQueryInterface::QuantumPtr m_quantum;
	AudioQueryInterface::QuantumType::SizeType m_quantumWrittenSize = 0;
};

} /* namespace openDenoise */
} /* namespace engine */
} /* namespace aace */

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERYEXECUTOR_H_ */
