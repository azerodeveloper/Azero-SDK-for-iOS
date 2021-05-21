/*
 * SpeechRecognizerHandler.h
 *
 *  Created on: Mar 13, 2020
 *      Author: nero
 */

#ifndef SRC_OPENDENOISE_SPEECHRECOGNIZERHANDLER_H_
#define SRC_OPENDENOISE_SPEECHRECOGNIZERHANDLER_H_

#include <mutex>
#include <atomic>
#include <AACE/Alexa/SpeechRecognizer.h>
#include "LocalSpeechDetectorHandler.h"

namespace azeroSDK {

class LocalSpeechDetectorHandler;

class SpeechRecognizerHandler : public aace::alexa::SpeechRecognizer {
public:
	using SequenceIdType = aace::openDenoise::LocalSpeechDetector::SequenceIdType;
protected:
	SpeechRecognizerHandler();

public:
	virtual ~SpeechRecognizerHandler();

	static std::shared_ptr<SpeechRecognizerHandler> create ();

	bool init ( std::shared_ptr<LocalSpeechDetectorHandler> handler,
			int talkTag );

	bool expectSpeech() override;
	bool startAudioInput() override;
	bool stopAudioInput() override;

	void enableRemoteInitiation( bool enable );
	bool onAudioQueryStart( SequenceIdType sequenceId );
	void onAudioQueryStop( SequenceIdType sequenceId );
	size_t onAudioQueryWriteData( SequenceIdType sequenceId, const char *data, size_t size );
    
	void stopSpeech();

protected:
	std::weak_ptr<LocalSpeechDetectorHandler> m_speechDetector;
	int m_talkTag = 0;
	std::mutex m_mutex;
	bool m_enableWrite = false;
	bool m_expectingSpeech = false;
	std::atomic<bool> m_allowRemoteInitiation { true };
	bool m_AudioQueryStarted = false;
	SequenceIdType m_currentSequenceId = 0;
};

} /* namespace azeroSDK */

#endif /* SRC_OPENDENOISE_SPEECHRECOGNIZERHANDLER_H_ */
