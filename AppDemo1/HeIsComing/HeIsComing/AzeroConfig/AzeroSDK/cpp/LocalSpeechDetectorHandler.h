/*
 * LocalSpeechDetectorHandler.h
 *
 *  Created on: Mar 16, 2020
 *      Author: nero
 */

#ifndef SRC_OPENDENOISE_LOCALSPEECHDETECTORHANDLER_H_
#define SRC_OPENDENOISE_LOCALSPEECHDETECTORHANDLER_H_

#include <AACE/Alexa/SpeechRecognizer.h>
#include <AACE/OpenDenoise/LocalSpeechDetector.h>

namespace azeroSDK {

class SpeechRecognizerHandler;

class LocalSpeechDetectorHandler : public aace::openDenoise::LocalSpeechDetector
				, public std::enable_shared_from_this<LocalSpeechDetectorHandler>{
public:
	class LocalSpeechDetectorEventInterface {
	public:
		using SequenceIdType = aace::openDenoise::LocalSpeechDetector::SequenceIdType;
	protected:
		LocalSpeechDetectorEventInterface() = default;
	public:
		virtual ~LocalSpeechDetectorEventInterface() = default;
		virtual void onWakeWordDetected( int tag, SequenceIdType sequenceId, float angle ) {};
		virtual void onSpeechStartTimeout( int tag, SequenceIdType sequenceId ) {};
		virtual void onSpeechStartDetected( int tag, SequenceIdType sequenceId ) {};
		virtual void onSpeechStopDetected( int tag, SequenceIdType sequenceId ) {};

		virtual void onAudioQueryError( SequenceIdType sequenceId, AudioQueryError err ) {};
		virtual void onAudioQueryStart( SequenceIdType sequenceId, bool success ) { };
		virtual void onAudioQueryStop( SequenceIdType sequenceId ) {};
	};

public:
	static constexpr int TALKTAG_EXPECTSPEECH = 1;
	static constexpr int TALKTAG_TAPTOTALK = 2;

private:
	LocalSpeechDetectorHandler( std::shared_ptr<LocalSpeechDetectorEventInterface> eventHandler );

public:
	virtual ~LocalSpeechDetectorHandler();

	static std::shared_ptr<LocalSpeechDetectorHandler> create( std::shared_ptr<LocalSpeechDetectorEventInterface> eventHandler );

	std::shared_ptr<aace::alexa::SpeechRecognizer> getSpeechRecognizerHandler();

	void stopSpeech();

protected:
	void onWakeWordDetected( int tag, SequenceIdType sequenceId, float angle ) override;
	void onSpeechStartTimeout( int tag, SequenceIdType sequenceId ) override;
	void onSpeechStartDetected( int tag, SequenceIdType sequenceId ) override;
	void onSpeechStopDetected( int tag, SequenceIdType sequenceId ) override;

	void onAudioQueryError( SequenceIdType sequenceId, AudioQueryError err ) override;
	bool onAudioQueryStart( SequenceIdType sequenceId ) override;
	void onAudioQueryStop( SequenceIdType sequenceId ) override;
	size_t onAudioQueryWriteData( SequenceIdType sequenceId, const char *data, size_t size ) override;

	bool onModeChangePrepare( const ModeConfiguration &config ) override;
	void onModeChangeCancelled( const ModeConfiguration &config ) override;
	void onModeChanged( const ModeConfiguration &config ) override;
	void onModeChangeFailed() override;
	void onModeSystemShutDown() override;
	void onModeExecutionException() override;

private:
	std::shared_ptr<SpeechRecognizerHandler> m_speechRecognizer;
	std::shared_ptr<LocalSpeechDetectorEventInterface> m_eventHandler;
};

} /* namespace azeroSDK */

#endif /* SRC_OPENDENOISE_LOCALSPEECHDETECTORHANDLER_H_ */
