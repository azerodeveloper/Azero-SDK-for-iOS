/*
 * LocalSpeechDetector.h
 *
 *  Created on: Mar 6, 2020
 *      Author: nero
 */

#ifndef PLATFORM_INCLUDE_AACE_OPENDENOISE_LOCALSPEECHDETECTOR_H_
#define PLATFORM_INCLUDE_AACE_OPENDENOISE_LOCALSPEECHDETECTOR_H_


#include <AACE/Core/PlatformInterface.h>
#include "ModeObserverInterface.h"
#include "LocalSpeechDetectorEngineInterface.h"

namespace aace {
namespace openDenoise {

class LocalSpeechDetector
		: public aace::core::PlatformInterface
		, public ModeObserverInterface {
protected:
	LocalSpeechDetector() = default;

public:
	using TapToTalkSyncTask = LocalSpeechDetectorEngineInterface::TapToTalkSyncTask;
	using SequenceIdType = LocalSpeechDetectorEngineInterface::SequenceIdType;

	const static int TALKTAG_WAKEWORD = 0;

	enum class AudioQueryError {
		startExceedMaxTimes,
		writeExceedMaxTimes,
		badStream,
		dropped,
		unknown,
	};

public:
	virtual ~LocalSpeechDetector() = default;

	// Start speech process manually.
	// @param tag this a identify id which will be used by @c wakeWordDetected. Must be set to
	//      positive value.
	// @return if current is not in ready state or startBeam fail, @c false will be returned
	// wakeWordDetected will be invoked quickly after @c tapToTalk success
	bool tapToTalk( int tag, TapToTalkSyncTask &&syncTask );

	// Invoked when wake word detected or after @c tapToTalk invoked by user.
	//
	// @param angle Speech angle
	// @param tag Positive value are set by @c tapToTalk, which is used to identify invoke owner.
	//            All none positive values are defined by the SDK.
	//            0-real speech
	virtual void onWakeWordDetected( int tag, SequenceIdType sequenceId, float angle );
	virtual void onSpeechStartTimeout( int tag, SequenceIdType sequenceId );
	virtual void onSpeechStartDetected( int tag, SequenceIdType sequenceId );
	virtual void onSpeechStopDetected( int tag, SequenceIdType sequenceId );

	virtual void onAudioQueryError( SequenceIdType sequenceId, AudioQueryError err ) = 0;
	virtual bool onAudioQueryStart( SequenceIdType sequenceId ) = 0;
	virtual void onAudioQueryStop( SequenceIdType sequenceId ) = 0;
	virtual size_t onAudioQueryWriteData( SequenceIdType sequenceId, const char *data, size_t size ) = 0;
	bool stopAudioQuery( SequenceIdType sequenceId );

	//internal
	void setEngineInterface(
			std::shared_ptr<LocalSpeechDetectorEngineInterface>
				engineInterface );

private:
	std::weak_ptr<LocalSpeechDetectorEngineInterface> m_engineInterface;
};

}	//namespace openDenoise
}	//namespace aace

#endif /* PLATFORM_INCLUDE_AACE_OPENDENOISE_LOCALSPEECHDETECTOR_H_ */
