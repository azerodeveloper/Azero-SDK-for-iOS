/*
 * WakeFreeMode.h
 *
 *  Created on: Apr 7, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_EVENTHANDLESTRATEGY_WAKEFREEMODE_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_EVENTHANDLESTRATEGY_WAKEFREEMODE_H_

#include "Mode.h"
#include "../Cache/Cache.h"
#include "../AudioQueryManager.h"
#include "../VOIPStreamSubject.h"
#include <AACE/OpenDenoise/LocalSpeechDetector.h>
#include <AACE/OpenDenoise/LocalSpeechDetectorEngineInterface.h>
#include <AACE/OpenDenoise/OfflineCommand.h>
#include "../AudioQuery.h"

namespace aace {
namespace engine {
namespace openDenoise {
namespace eventHandleStrategy {

class WakeFreeMode : public Mode {
private:
	using system_clock = std::chrono::system_clock;
	using duration = system_clock::duration;
	using timepoint = system_clock::time_point;

	static constexpr int VAD_START_TIMEOUT_IN_SECONDS = 2;
	static constexpr int SPEAKING_TIMEOUT_IN_SECONDS = 5;

public:
	using LocalSpeechDetector = aace::openDenoise::LocalSpeechDetector;
	using OfflineCommand = aace::openDenoise::OfflineCommand;
	using Cache = cache::Cache<MyCachePolicy>;
public:
	virtual ~WakeFreeMode();

	static
	std::unique_ptr<WakeFreeMode>
	create(	std::weak_ptr<VOIPStreamSubject> voipStreamSubject,
			std::weak_ptr<ModeExecutionExceptionObserverInterface> modeExcutionExceptionObserver,
			std::shared_ptr<OfflineCommand> offlineCommand,
			std::shared_ptr<LocalSpeechDetector> localSpeechDetector );

private:
	bool start() override;
	void shutdown() override;
	void onASRData( const char *data, size_t size ) override;
	void onVOIPData( const char *data, size_t size ) override;
	void onKWD( float angle ) override;
	void onVADStart() override;
	void onVADStartTimeout() override;
	void onVADEnd() override;
	void onOfflineCommand( const char *cmd ) override;

	bool tapToTalk( int tag, TapToTalkSyncTask &&syncTask ) override;
	//	bool stopSpeech() override;
	bool stopAudioQuery( SequenceIdType sequenceId ) override;

private:
	WakeFreeMode(
			std::unique_ptr<Cache> cache,
			std::unique_ptr<AudioQueryManagerInterface> queryManager,
			std::weak_ptr<VOIPStreamSubject> voipStreamSubject,
			std::weak_ptr<ModeExecutionExceptionObserverInterface> modeExcutionExceptionObserver,
			std::shared_ptr<OfflineCommand> offlineCommand,
			std::shared_ptr<LocalSpeechDetector> localSpeechDetector );

	void createAudioQuery();
	void resetAudioQuery();

	bool startBeam();
	bool stopBeam();
	void restartBeam();

	void stopTimer();
	void startTimer(duration duration);
	void handleTimeout();

private:
	std::shared_ptr<Cache> m_cache;
	std::shared_ptr<AudioQueryManagerInterface> m_queryManager;
	std::weak_ptr<VOIPStreamSubject> m_voipStreamSubject;
	std::shared_ptr<OfflineCommand> m_offlineCommand;
	std::shared_ptr<LocalSpeechDetector> m_localSpeechDetector;
	std::mutex m_mutex;
	bool m_running = false;
	bool m_inVADStage = false;
	SequenceIdType m_sequenceId = 0;
	timepoint m_expireTimepoint;
	bool m_timerEnabled = false;
	std::shared_ptr<AudioQuery> m_audioQuery;
};

} /* namespace eventHandleStrategy */
} /* namespace openDenoise */
} /* namespace engine */
} /* namespace aace */

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_EVENTHANDLESTRATEGY_WAKEFREEMODE_H_ */
