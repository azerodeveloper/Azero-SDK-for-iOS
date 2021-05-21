/*
 * IndependentVadStateMachine.h
 *
 *  Created on: Mar 9, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_EVENTHANDLESTRATEGY_INDEPENDENTVADSTATEMACHINE_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_EVENTHANDLESTRATEGY_INDEPENDENTVADSTATEMACHINE_H_

#include <mutex>
#include <memory>
#include <queue>
#include <thread>
#include <chrono>
#include <future>
#include <condition_variable>

namespace aace {
namespace engine {
namespace openDenoise {
namespace eventHandleStrategy {

class IndependentVadStateMachine {
	using duration = std::chrono::system_clock::duration;
	using timepoint = std::chrono::system_clock::time_point;
	enum class State {
		stopped,
		ready,
		waiting,
		speaking,
	};

	static constexpr int STATE_WAITING_TIMEOUT_IN_SECONDS = 15;
	static constexpr int STATE_SPEAKING_TIMEOUT_IN_SECONDS = 15;

protected:
	enum class InputEventType {
		start,
		wakeUpManually,
		stopBeamManually,
		wakeWordDetected,
		vadStart,
		vadStartTimeout,
		vadEnd,
		internalTimeout,
		stop,
	};

	enum class OutEventType {
		onReady,
		onWakeWordDetected,
		onSpeechStartDetected,
		onSpeechStartTimeout,
		onSpeechStopDetected,
	};

	using InputEventTask = std::packaged_task<void(bool)>;

	struct InputEvent {
		InputEvent ( InputEventType type,
				InputEventTask &&task = InputEventTask())
		: m_eventType ( type ) {
			m_task = std::move( task );
		}

		InputEventType m_eventType;
		InputEventTask m_task;

		InputEvent( const InputEvent &evt ) = delete;
		InputEvent( InputEvent &&evt ) = default;
		InputEvent & operator=( const InputEvent &evt ) = delete;
		InputEvent & operator=( InputEvent &&evt ) = default;
	};

protected:
	IndependentVadStateMachine();

public:
	virtual ~IndependentVadStateMachine();

	virtual void onOutEvent( OutEventType event ) = 0;

	void sendEvent( InputEventType type );
	void sendEvent( InputEventType type, InputEventTask &&task);
	void sendEventSync( InputEventType type );

private:
	void timerThread();
	void stopTimerThread();

	void onInputEvent(InputEvent &evt);
	void stopTimer();
	void startTimer(duration duration);

private:
	std::queue<InputEvent> m_eventQueue;
	State m_state {State::stopped};
	std::mutex m_mutex;
	std::condition_variable m_cond;
	timepoint m_expireTimepoint;
	bool m_needCounting {false};
	bool m_stopTimerThread {false};

	std::thread m_timerThread;
};

} // aace::engine::openDenoise::lsdEventHandlePolicy
} // aace::engine::openDenoise
} // aace::engine
} // aace

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_EVENTHANDLESTRATEGY_INDEPENDENTVADSTATEMACHINE_H_ */
