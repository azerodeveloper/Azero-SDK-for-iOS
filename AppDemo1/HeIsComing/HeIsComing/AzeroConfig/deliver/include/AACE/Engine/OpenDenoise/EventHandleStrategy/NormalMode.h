/*
 * NormalMode.h
 *
 *  Created on: Mar 31, 2020
 *      Author: nero
 */

#ifndef ENGINE_SRC_LSDEVENTHANDLEPOLICY_NORMALMODE_H_
#define ENGINE_SRC_LSDEVENTHANDLEPOLICY_NORMALMODE_H_

#include <AACE/OpenDenoise/LocalSpeechDetector.h>
#include <AACE/OpenDenoise/LocalSpeechDetectorEngineInterface.h>
#include <AACE/OpenDenoise/OfflineCommand.h>
#include "../EventHandleStrategy/Mode.h"
#include "../EventHandleStrategy/IndependentVadStateMachine.h"
#include "../VOIPStreamSubject.h"

namespace aace {
namespace engine {
namespace openDenoise {
namespace eventHandleStrategy {

class NormalMode : public Mode
	, public IndependentVadStateMachine {
private:
	using OutEventHandler = void (NormalMode::*)();
	using LocalSpeechDetector = aace::openDenoise::LocalSpeechDetector;
	using OfflineCommand = aace::openDenoise::OfflineCommand;

public:
	virtual ~NormalMode();

	std::unique_ptr<NormalMode>
	static create( std::weak_ptr<VOIPStreamSubject> voipStreamSubject,
			std::weak_ptr<ModeExecutionExceptionObserverInterface> modeExcutionExceptionObserver,
			std::shared_ptr<OfflineCommand> offlineCommand,
			std::shared_ptr<LocalSpeechDetector> localSpeechDetector );

private:
	NormalMode( std::weak_ptr<VOIPStreamSubject> voipStreamSubject,
			std::weak_ptr<ModeExecutionExceptionObserverInterface> modeExcutionExceptionObserver,
			std::shared_ptr<OfflineCommand> offlineCommand,
			std::shared_ptr<LocalSpeechDetector> localSpeechDetector );

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
	//bool stopSpeech() override;
	bool stopAudioQuery( SequenceIdType sequenceId );

	void onSmReady();
	void onSmWakeWordDetected();
	void onSmSpeechStartDetected();
	void onSmSpeechStartTimeout();
	void onSmSpeechStopDetected();

	void onOutEvent( OutEventType event ) override;
	OutEventHandler getOutEventHandler( OutEventType event );

	bool sendStartBeamEvent( int tag, TapToTalkSyncTask &&syncTask );
	bool stopBeam();

	void enableAsrOutput( bool enable );

private:
	std::weak_ptr<VOIPStreamSubject> m_voipStreamSubject;
	std::shared_ptr<OfflineCommand> m_offlineCommand;
	std::shared_ptr<LocalSpeechDetector> m_localSpeechDetector;

	volatile SequenceIdType m_sequenceId = 0;
	bool m_beamStarted { false };	//avoid to start twice
	bool m_beamStopped { true };	//avoid to stop twice
	std::atomic<int> m_wakeupTag { LocalSpeechDetector::TALKTAG_WAKEWORD };
	volatile int m_thisTurnWakeupTag { LocalSpeechDetector::TALKTAG_WAKEWORD };
	std::atomic<float> m_wakeUpAngle { 0.0 };
	std::mutex m_asrWirteMutex;
	bool m_allowToWriteAsr = false;
};

} /* namespace lsdEventHandlePolicy */
} /* namespace openDenoise */
} /* namespace engine */
} /* namespace aace */

#endif /* ENGINE_SRC_LSDEVENTHANDLEPOLICY_NORMALMODE_H_ */
