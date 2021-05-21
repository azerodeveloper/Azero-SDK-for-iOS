/*
 * LocalSpeechDetectorHandler.cpp
 *
 *  Created on: Mar 16, 2020
 *      Author: nero
 */

#include "LocalSpeechDetectorHandler.h"
#include "SpeechRecognizerHandler.h"
#include <AACE/Engine/Core/EngineMacros.h>

namespace azeroSDK {

const static std::string TAG = "azeroSDK.LocalSpeechDetectorHandler";

LocalSpeechDetectorHandler::LocalSpeechDetectorHandler(
		 std::shared_ptr<LocalSpeechDetectorEventInterface> eventHandler )
: m_eventHandler ( eventHandler ){
	m_speechRecognizer = SpeechRecognizerHandler::create();
}

LocalSpeechDetectorHandler::~LocalSpeechDetectorHandler() {
}

std::shared_ptr<LocalSpeechDetectorHandler>
LocalSpeechDetectorHandler::create(
		std::shared_ptr<LocalSpeechDetectorEventInterface> eventHandler ) {
	auto ptr = std::shared_ptr<LocalSpeechDetectorHandler>( new LocalSpeechDetectorHandler { eventHandler } );
	do {
		if ( !ptr ) {
			break;
		}
		if ( !ptr->m_speechRecognizer ) {
			ptr.reset();
			break;
		}
		if ( !ptr->m_speechRecognizer->init( ptr, TALKTAG_EXPECTSPEECH ) ) {
			ptr.reset();
			break;
		}
	} while ( 0 );
	return ptr;
}

void LocalSpeechDetectorHandler::onWakeWordDetected(
	int tag, SequenceIdType sequenceId, float angle ) {
	SAI_WARN(LX(TAG, __FUNCTION__));
	if ( m_eventHandler ) {
		m_eventHandler->onWakeWordDetected( tag, sequenceId, angle );
	}
}

void LocalSpeechDetectorHandler::onSpeechStartTimeout( int tag, SequenceIdType sequenceId ) {
	SAI_WARN(LX(TAG, __FUNCTION__));
	if ( m_eventHandler ) {
		m_eventHandler->onSpeechStartTimeout( tag, sequenceId );
	}
}

void LocalSpeechDetectorHandler::onSpeechStartDetected( int tag, SequenceIdType sequenceId ) {
	SAI_WARN(LX(TAG, __FUNCTION__));
	if ( m_eventHandler ) {
		m_eventHandler->onSpeechStartDetected( tag, sequenceId );
	}
}

void LocalSpeechDetectorHandler::onSpeechStopDetected( int tag, SequenceIdType sequenceId ) {
	SAI_WARN(LX(TAG, __FUNCTION__));
	if ( m_eventHandler ) {
		m_eventHandler->onSpeechStopDetected( tag, sequenceId );
	}
}

void LocalSpeechDetectorHandler::onAudioQueryError( SequenceIdType sequenceId, AudioQueryError err ) {
	SAI_WARN(LX(TAG, __FUNCTION__));
	if ( m_eventHandler ) {
		m_eventHandler->onAudioQueryError( sequenceId, err );
	}
}

bool LocalSpeechDetectorHandler::onAudioQueryStart( SequenceIdType sequenceId ) {

	SAI_WARN(LX(TAG, __FUNCTION__));
	auto ret = m_speechRecognizer->onAudioQueryStart( sequenceId );
	SAI_WARN(LX(TAG, __FUNCTION__).d("ret", ret));
	if ( m_eventHandler ) {
		m_eventHandler->onAudioQueryStart( sequenceId, ret );
	}
	return ret;
}

void LocalSpeechDetectorHandler::onAudioQueryStop( SequenceIdType sequenceId ) {

	SAI_WARN(LX(TAG, __FUNCTION__));
	m_speechRecognizer->onAudioQueryStop( sequenceId );
	if ( m_eventHandler ) {
		m_eventHandler->onAudioQueryStop( sequenceId );
	}
}

size_t LocalSpeechDetectorHandler::onAudioQueryWriteData(
	SequenceIdType sequenceId, const char *data, size_t size ) {
	return m_speechRecognizer->onAudioQueryWriteData( sequenceId, data, size );
}

bool LocalSpeechDetectorHandler::onModeChangePrepare( const ModeConfiguration &config ) {
	SAI_WARN(LX(TAG, __FUNCTION__));
	m_speechRecognizer->enableRemoteInitiation( false );
	return true;
}

void LocalSpeechDetectorHandler::onModeChangeCancelled( const ModeConfiguration &config ) {
	SAI_WARN(LX(TAG, __FUNCTION__));
	m_speechRecognizer->enableRemoteInitiation( true );
}

void LocalSpeechDetectorHandler::onModeChanged( const ModeConfiguration &config ) {
	SAI_WARN(LX(TAG, __FUNCTION__).d("ModeConfiguration", config.toString()));
	m_speechRecognizer->enableRemoteInitiation( true );
}

void LocalSpeechDetectorHandler::onModeChangeFailed() {
	SAI_WARN(LX(TAG, __FUNCTION__));
	m_speechRecognizer->enableRemoteInitiation( false );
}

void LocalSpeechDetectorHandler::onModeSystemShutDown() {
	SAI_WARN(LX(TAG, __FUNCTION__));
	m_speechRecognizer->enableRemoteInitiation( false );
}

void LocalSpeechDetectorHandler::onModeExecutionException() {
	SAI_WARN(LX(TAG, __FUNCTION__));
}

std::shared_ptr<aace::alexa::SpeechRecognizer>
LocalSpeechDetectorHandler::getSpeechRecognizerHandler() {
	return m_speechRecognizer;
}

void LocalSpeechDetectorHandler::stopSpeech() {
	m_speechRecognizer->stopSpeech();
}
} /* namespace azeroSDK */
