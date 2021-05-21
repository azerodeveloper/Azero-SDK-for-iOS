/*
 * QueryManager.h
 *
 *  Created on: Apr 3, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERYMANAGER_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERYMANAGER_H_

#include <thread>
#include <condition_variable>
#include <queue>
#include "AudioQueryInterface.h"
#include "AudioQueryManagerInterface.h"
#include <AACE/OpenDenoise/LocalSpeechDetector.h>
#include "AudioQueryExecutor.h"

namespace aace {
namespace engine {
namespace openDenoise {

class AudioQueryManager
		: public AudioQueryManagerInterface {
private:
	enum class ThreadState {
		running,
		stopping,
		stopped,
		exited,
	};

	struct Event {
		enum class Type {
			none,
			startExcution,
			stopExecution,
			exitThread,
		};

		explicit Event ( Type type )
		: m_type( type ) {
		}

		Type m_type = Type::none;

		Event( const Event &evt ) = delete;
		Event( Event &&evt ) = default;
		Event & operator=( const Event &evt ) = delete;
		Event & operator=( Event &&evt ) = default;
	};
	using system_clock = std::chrono::system_clock;
	using AudioQueryError = aace::openDenoise::LocalSpeechDetector::AudioQueryError;

public:
	using LocalSpeechDetector = aace::openDenoise::LocalSpeechDetector;

public:
	~AudioQueryManager();

	static
	std::unique_ptr<AudioQueryManager>
	create( std::shared_ptr<LocalSpeechDetector> lsd );

protected:
	//blocking
	bool start() override;
	//blocking
	void stop() override;

	//no blocking
	void addQuery( QueryPtr audioQuery ) override;

	//no blocking
	void stopQuery( QuerySequenceIdType id ) override;

	QueryNotifyFunctionType getQueryNotifyFunction() override;

private:
	AudioQueryManager(
			std::shared_ptr<LocalSpeechDetector> lsd );

	void threadMainLoop();
	AudioQueryExecutor::ContinueCondition executorPredicate();

	bool getWaitTimeout(
			std::chrono::system_clock::duration &duration );
	void setQueryExecutorContinueCondition( AudioQueryExecutor::ContinueCondition cond );
	void setThreadState( ThreadState newState );
	bool sentEvent( Event evt );


private:
	std::shared_ptr<LocalSpeechDetector> m_lsd;
	mutable std::mutex m_mutex;
	std::condition_variable m_condVar;
	bool m_queryDataUpdate = false;
	QueryPtr m_pendingQuery;
	QueryPtr m_currentQuery;
	AudioQueryExecutor m_queryExecutor;
	AudioQueryExecutor::ContinuePredicate m_queryExecutorPredicate;
	volatile AudioQueryExecutor::ContinueCondition m_queryExecutorContinueCondtion = AudioQueryExecutor::ContinueCondition::ok;
	std::queue<Event> m_eventQueue;

	ThreadState m_threadState = ThreadState::stopped;
	std::thread m_thread;
};

} /* namespace openDenoise */
} /* namespace engine */
} /* namespace aace */

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_AUDIOQUERYMANAGER_H_ */
