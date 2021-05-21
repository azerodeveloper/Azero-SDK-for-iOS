/*
 * SpeechRecognizerHandler.cpp
 *
 *  Created on: Mar 13, 2020
 *      Author: nero
 */

#include "SpeechRecognizerHandler.h"
#include <AACE/Engine/Core/EngineMacros.h>

namespace azeroSDK {

const static std::string TAG = "azeroSDK.SpeechRecognizerHandler";

SpeechRecognizerHandler::SpeechRecognizerHandler() {
}

SpeechRecognizerHandler::~SpeechRecognizerHandler() {
}

std::shared_ptr<SpeechRecognizerHandler>
SpeechRecognizerHandler::create() {
	return std::shared_ptr<SpeechRecognizerHandler> ( new SpeechRecognizerHandler {} );
}

bool SpeechRecognizerHandler::init (
		std::shared_ptr<LocalSpeechDetectorHandler> handler,
		int talkTag ) {
	m_speechDetector = handler;
	m_talkTag = talkTag;
	return true;
}

bool SpeechRecognizerHandler::expectSpeech() {
	SAI_INFO(LX(TAG, __FUNCTION__));
	if ( !m_allowRemoteInitiation.load() ) {
		//return false;
		return true;	//must success
	}

	auto detector = m_speechDetector.lock();
	if ( !detector ) {
		//return false;
		return true;	//must success
	}

	auto ret = detector->tapToTalk( m_talkTag, LocalSpeechDetectorHandler::TapToTalkSyncTask() );
	if ( !ret ) {
		SAI_ERROR(LX(TAG, __FUNCTION__).m("tapToTalk fail"));
		//return false;
		return true;	//must success
	}
	std::lock_guard<std::mutex> lk( m_mutex );
	m_expectingSpeech = true;
	return true;
}

bool SpeechRecognizerHandler::startAudioInput() {
	SAI_INFO(LX(TAG, __FUNCTION__));
    std::lock_guard<std::mutex> lk( m_mutex );
	m_enableWrite = true;
	return true;
}

bool SpeechRecognizerHandler::stopAudioInput() {
	SAI_INFO(LX(TAG, __FUNCTION__));
	bool ret = false;
	auto detector = m_speechDetector.lock();
	if (detector) {
		ret = detector->stopAudioQuery( m_currentSequenceId );
		if ( ret ) {
			SAI_INFO(LX(TAG, __FUNCTION__).m("stopSpeech success"));
		} else {
			SAI_ERROR(LX(TAG, __FUNCTION__).m("stopSpeech fail"));
		}
	}
	std::lock_guard<std::mutex> lk( m_mutex );
	m_enableWrite = false;	//FORCE disable audio input
	m_expectingSpeech = false;
	SAI_INFO(LX(TAG, __FUNCTION__).m("disable write"));
	return ret;
}

void SpeechRecognizerHandler::enableRemoteInitiation( bool enable ) {
	SAI_INFO(LX(TAG, __FUNCTION__).d("new enable state", enable).d("old enable state", m_allowRemoteInitiation.load()));
	m_allowRemoteInitiation.store( enable );
}

bool SpeechRecognizerHandler::onAudioQueryStart(
		SequenceIdType sequenceId ) {
	bool ret  = false;
	do {
		bool needStartCapture = true;
		{
			std::lock_guard<std::mutex> lk( m_mutex );
			if ( m_expectingSpeech && m_enableWrite ) {
				needStartCapture = false;
			}
		}
		if ( !needStartCapture ) {
			ret = true;
			break;
		}
		ret = holdToTalk();
	} while ( 0 );

	if ( ret ) {
		std::lock_guard<std::mutex> lk( m_mutex );
		m_AudioQueryStarted = true;
		m_currentSequenceId = sequenceId;
	}

	return ret;
}

void SpeechRecognizerHandler::onAudioQueryStop(
		SequenceIdType sequenceId ) {
	bool needStopCapture = false;
	{
		std::lock_guard<std::mutex> lk( m_mutex );
		m_AudioQueryStarted = false;
		needStopCapture = m_enableWrite;
	}
	if ( needStopCapture ) {
		stopCapture();
	}
}

size_t SpeechRecognizerHandler::onAudioQueryWriteData(
		SequenceIdType sequenceId, const char *data, size_t size ) {
	std::lock_guard<std::mutex> lk( m_mutex );
	if ( m_enableWrite && m_AudioQueryStarted && sequenceId == m_currentSequenceId ) {
		auto ret = write( reinterpret_cast<const int16_t *>(data), size/sizeof(int16_t) );
		return ret < 0 ? 0 : ( ret * sizeof(int16_t) );
	}
	return size;
}

void SpeechRecognizerHandler::stopSpeech() {
	if ( m_AudioQueryStarted ) {
		auto detector = m_speechDetector.lock();
		if ( detector ) {
			detector->stopAudioQuery( m_currentSequenceId );
		}
	}
	if ( m_enableWrite ) {
		stopCapture();
	}
}

} /* namespace azeroSDK */
