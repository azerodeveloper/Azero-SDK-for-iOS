/*
 * OpenDenoiseEngineImpl.h
 *
 *  Created on: Mar 5, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_OPENDENOISEENGINEIMPL_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_OPENDENOISEENGINEIMPL_H_

#include <list>
#include <atomic>
#include <AACE/OpenDenoise/ModeControl.h>
#include <AACE/OpenDenoise/ModeControlEngineInterface.h>
#include <AACE/OpenDenoise/ModeObserverInterface.h>
#include <AACE/OpenDenoise/AudioInput.h>
#include <AACE/OpenDenoise/AudioInputEngineInterface.h>
#include <AACE/OpenDenoise/LocalSpeechDetector.h>
#include <AACE/OpenDenoise/LocalSpeechDetectorEngineInterface.h>
#include <AACE/OpenDenoise/OfflineCommand.h>
#include <AACE/OpenDenoise/VOIPStream.h>
#include <AACE/OpenDenoise/VOIPStreamEngineInterface.h>
#include <AVSCommon/Utils/RequiresShutdown.h>

#include "EventHandleStrategy/Mode.h"
#include "OpenDenoiseConfiguration.h"
#include "OpenDenoiseInstance.h"
#include "VOIPStreamSubject.h"

namespace aace {
namespace engine {
namespace openDenoise {

class OpenDenoiseEngineImpl :
	public VOIPStreamSubject,
	public aace::openDenoise::LocalSpeechDetectorEngineInterface,
	public aace::openDenoise::AudioInputEngineInterface,
	public aace::openDenoise::ModeControlEngineInterface,
	public eventHandleStrategy::ModeExecutionExceptionObserverInterface,
	public alexaClientSDK::avsCommon::utils::RequiresShutdown,
	public std::enable_shared_from_this<OpenDenoiseEngineImpl> {
private:
	enum class LifeCycleState {
		NotInited,
		Switching,
		AlmostSwitched,
		Running,
		FatalError,
	};
	using LocalSpeechDetector = aace::openDenoise::LocalSpeechDetector;
	using WakeMode = eventHandleStrategy::Mode;
public:
	using ModeObserverList = std::list<std::shared_ptr<aace::openDenoise::ModeObserverInterface>>;
	using VOIPStreamList = std::list<std::shared_ptr<aace::openDenoise::VOIPStream>>;
	using VOIPStreamEngineInterface = aace::openDenoise::VOIPStreamEngineInterface;
	using VOIPStreamObserverList = std::list<std::shared_ptr<VOIPStreamEngineInterface>>;

private:
	OpenDenoiseEngineImpl(
			std::shared_ptr<OpenDenoiseConfiguration> &&configuration,
			std::shared_ptr<aace::openDenoise::ModeControl> &&modeControl,
			ModeObserverList &&modeObserverList,
			std::shared_ptr<aace::openDenoise::AudioInput> &&audioInput,
			std::shared_ptr<aace::openDenoise::OfflineCommand> &&offlineCommand,
			std::shared_ptr<aace::openDenoise::LocalSpeechDetector> &&localSpeechDetector,
			VOIPStreamList &&voipStreamList);

public:
	static std::shared_ptr<OpenDenoiseEngineImpl> create(
			std::shared_ptr<OpenDenoiseConfiguration> &&configuration,
			std::shared_ptr<aace::openDenoise::ModeControl> &&modeControl,
			ModeObserverList &&modeObserverList,
			std::shared_ptr<aace::openDenoise::AudioInput> &&audioInput,
			std::shared_ptr<aace::openDenoise::OfflineCommand> &&offlineCommand,
			std::shared_ptr<aace::openDenoise::LocalSpeechDetector> &&localSpeechDetector,
			VOIPStreamList &&voipStreamList);

	void increaseVOIPReference();
	void decreaseVOIPReference();

protected:
	void createVOIPStreamObservers();
	void doShutdown() override;

	//return value is used to avoid to write data if initialization failed.
	bool write( const char* data, const size_t size ) override;
	bool tapToTalk( int tag, TapToTalkSyncTask &&syncTask ) override;
	bool stopAudioQuery( SequenceIdType sequenceId );
	void dispatchVOIPData( const char *data, size_t size ) override;
	void notifyStreamOpened() override;
	void notifyStreamClosed() override;

	aace::openDenoise::OpenDenoiseErrc
	getMode( ModeConfiguration &config ) const override;
	aace::openDenoise::OpenDenoiseErrc
	setMode( const ModeConfiguration &config ) override;
	void onException() override;

private:
	bool doChangeMode( const ModeConfiguration &config );
	bool startUpMode( const ModeConfiguration &config );
	std::unique_ptr<WakeMode> createWakeMode( ModeConfiguration::WakeupMode wakeMode );

	void setEngineInterfaces();

	template< typename R, typename ... Args>
	void notifyModeChangeEvent(
			R (aace::openDenoise::ModeObserverInterface::* handler)( Args ... ),
			Args &&... args) {
		for ( auto &ptr : m_modeObserverList ) {
				((*ptr).*handler)( std::forward<Args>(args)... );
		}
	}

	template< typename R, typename ... Args>
	void notifyVOIPEvent(
			R (VOIPStreamEngineInterface::* handler)( Args ... ),
			Args ... args) {
		for ( auto &ptr : m_voipStreamObserverList ) {
				((*ptr).*handler)( std::forward<Args>(args)... );
		}
	}

private:
	std::shared_ptr<OpenDenoiseConfiguration> m_configuration;
	std::shared_ptr<aace::openDenoise::ModeControl> m_modeControl;
	ModeObserverList m_modeObserverList;
	std::shared_ptr<aace::openDenoise::AudioInput> m_audioInput;
	std::shared_ptr<aace::openDenoise::OfflineCommand> m_offlineCommand;
	std::shared_ptr<aace::openDenoise::LocalSpeechDetector> m_localSpeechDetector;
	VOIPStreamList m_voipStreamList;
	VOIPStreamObserverList m_voipStreamObserverList;

	std::mutex m_voipReferenceCountMutex;
	volatile unsigned int m_voipReferenceCount = 0;
	mutable std::mutex m_lifeCycleMutex;
	std::condition_variable m_lifeCycleCond;
	LifeCycleState m_lifeCycleState { LifeCycleState::NotInited };
	ModeConfiguration m_currentModeConfiguration;

	std::shared_ptr<WakeMode> m_wakeModeStrategy;
	std::shared_ptr<OpenDenoiseInstance> m_denosieInstance;
};

} // aace::engine::openDenoise
} // aace::engine
} // aace


#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_OPENDENOISEENGINEIMPL_H_ */
