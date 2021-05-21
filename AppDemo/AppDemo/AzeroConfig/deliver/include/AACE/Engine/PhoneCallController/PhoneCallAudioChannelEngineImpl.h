/*
 * Copyright 2017-2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *     http://aws.amazon.com/apache2.0/
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#ifndef AACE_ENGINE_PHONECALLCONTROLLER_PHONECALL_AUDIOCHANNEL_ENGINE_IMPL_H
#define AACE_ENGINE_PHONECALLCONTROLLER_PHONECALL_AUDIOCHANNEL_ENGINE_IMPL_H

#include <istream>

#include <AVSCommon/Utils/MediaPlayer/MediaPlayerInterface.h>
#include <AVSCommon/Utils/MediaPlayer/MediaPlayerObserverInterface.h>
#include <AVSCommon/Utils/Threading/Executor.h>
#include <AVSCommon/Utils/RequiresShutdown.h>
#include <AVSCommon/Utils/Timing/Timer.h>
#include <AVSCommon/SDKInterfaces/SpeakerInterface.h>
#include <AVSCommon/SDKInterfaces/SpeakerManagerInterface.h>

#include "AACE/Alexa/AlexaEngineInterfaces.h"
#include "AACE/Alexa/AudioChannel.h"
#include "AACE/Alexa/MediaPlayer.h"
#include "AACE/Alexa/Speaker.h"

#include <AVSCommon/AVS/Attachment/InProcessAttachmentReader.h>
#include <AVSCommon/AVS/Attachment/InProcessAttachmentWriter.h>
#include <AVSCommon/AVS/Attachment/InProcessAttachment.h>
#include <AVSCommon/AVS/BlockingPolicy.h>

namespace aace {
namespace engine {
namespace phoneCallController {

class PhoneCallAudioChannelEngineImpl :
    public aace::alexa::MediaPlayerEngineInterface,
    public alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerInterface,
    public alexaClientSDK::avsCommon::utils::RequiresShutdown,
    public std::enable_shared_from_this<PhoneCallAudioChannelEngineImpl> {
public:
    PhoneCallAudioChannelEngineImpl( std::shared_ptr<aace::alexa::AudioChannel> audioChannelPlatformInterface, const std::string& name );
    virtual bool initializeAudioChannel();
    virtual void doShutdown() override;
    virtual ~PhoneCallAudioChannelEngineImpl() = default;

    //
    // aace::engine::MediaPlayerEngineInterface
    //
    void onMediaStateChanged( MediaState state ) override;
    void onMediaError( MediaError error, const std::string& description = "" ) override;
    ssize_t read( char* data, const size_t size ) override;
    bool isRepeating() override;
    bool isClosed() override;

    //
    // alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerInterface
    //
    alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerInterface::SourceId setSource( std::shared_ptr<alexaClientSDK::avsCommon::avs::attachment::AttachmentReader> attachmentReader, const alexaClientSDK::avsCommon::utils::AudioFormat* format = nullptr ) override;
    alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerInterface::SourceId setSource( std::shared_ptr<std::istream> stream, bool repeat ) override;
    alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerInterface::SourceId setSource( const std::string& url, std::chrono::milliseconds offset ) override;
    bool play( alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerInterface::SourceId id ) override;
    bool stop( alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerInterface::SourceId id ) override;
    bool pause( alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerInterface::SourceId id ) override;
    bool resume( alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerInterface::SourceId id ) override;
    std::chrono::milliseconds getOffset( alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerInterface::SourceId id ) override;
    uint64_t getNumBytesBuffered() override;
    void setObserver( std::shared_ptr<alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerObserverInterface> observer ) override;

    void startPlayPhoneAudio(void);
    void stopPlayPhoneAudio(void);
    void moveDataToPhoneAudio(const char* data, size_t size);

    bool play( void );
    bool stop( void );

    void playFile(std::string file,bool isrepeat=false);
    void stopPlayRepeatedFile(void);

    typedef std::function<void(void)> CallbackFun;
    static void registerRecvPhoneAudioTimeoutCallback(CallbackFun cb);
    
protected:
    using SourceId = alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerInterface::SourceId;

    std::shared_ptr<alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerObserverInterface> getObserver() {
        return m_observer;
    }
    
    alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerInterface::SourceId nextId() {
        return ++s_nextId;
    }
    
    bool validateSource( alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerInterface::SourceId id );

private:
    enum class PendingEventState {
        NONE, PLAYBACK_STARTED, PLAYBACK_PAUSED, PLAYBACK_RESUMED, PLAYBACK_STOPPED
    };

    enum class MediaStateChangeInitiator {
        NONE, PLAY, PAUSE, RESUME, STOP
    };
    
    void sendPendingEvent();
    void sendEvent( PendingEventState state );
    void resetSource();
    
    //
    // MediaPlayerEngineInterface executor methods
    //
    void executeMediaStateChanged( SourceId id, MediaState state );
    void executeMediaError( SourceId id, MediaError error, const std::string& description );
    void executePlaybackStarted( SourceId id );
    void executePlaybackFinished( SourceId id );
    void executePlaybackPaused( SourceId id );
    void executePlaybackResumed( SourceId id );
    void executePlaybackStopped( SourceId id );
    void executePlaybackError( SourceId id, MediaError error, const std::string& description );
    void executeBufferUnderrun( SourceId id );
    void executeBufferRefilled( SourceId id );

    void restartRecvPhoneAudioTimer(void);
    void stopRecvPhoneAudioTimer(void);

    friend std::ostream& operator<<(std::ostream& stream, const PendingEventState& state);

private:
    std::shared_ptr<aace::alexa::AudioChannel> m_audioChannelPlatformInterface;
    std::shared_ptr<aace::alexa::MediaPlayer> m_mediaPlayerPlatformInterface;
    std::shared_ptr<alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerObserverInterface> m_observer;
    std::shared_ptr<alexaClientSDK::avsCommon::avs::attachment::AttachmentReader> m_attachmentReader;
    
    alexaClientSDK::avsCommon::avs::attachment::AttachmentReader::ReadStatus m_status;
    std::shared_ptr<std::istream> m_stream;
    alexaClientSDK::avsCommon::utils::mediaPlayer::MediaPlayerInterface::SourceId m_currentId;
    bool m_repeat;
    bool m_closed;
    std::string m_url;
    std::chrono::milliseconds m_savedOffset;
    std::string m_name;
    
    PendingEventState m_pendingEventState;
    MediaState m_currentMediaState;
    MediaStateChangeInitiator m_mediaStateChangeInitiator;

    // executor used to send asynchronous events back to observer
    alexaClientSDK::avsCommon::utils::threading::Executor m_executor;

    int m_playTimes;
    int m_playTimesCounter;

    // global counter for media source id
    static SourceId s_nextId;

    // mutex for blocking setSource calls
    std::mutex m_mutex;

    // mutex for blocking restartRecvPhoneAudioTimer
    std::mutex m_recvPhoneAudioTimerMutex;
    
    // wait condition
    // std::condition_variable m_trigger;    

     /// An InProcessAttachment used to feed A2DP stream data into the MediaPlayer.
    std::shared_ptr<alexaClientSDK::avsCommon::avs::attachment::InProcessAttachment> m_pcmAttachment;
    std::shared_ptr<alexaClientSDK::avsCommon::avs::attachment::AttachmentReader> m_pcmAttachmentReader;
    std::shared_ptr<alexaClientSDK::avsCommon::avs::attachment::AttachmentWriter> m_pcmAttachmentWriter;

    std::atomic<bool> m_isPlayingPhoneAudio;
    std::atomic<bool> m_isPlayRepeatedFile;

    // for receiving phone audio timeout 
    using Timer = alexaClientSDK::avsCommon::utils::timing::Timer;
    Timer m_recvPhoneAudioTimer;
    std::chrono::time_point<std::chrono::steady_clock> m_timerStartPoint;

    static CallbackFun recvPhoneAudioTimeoutCallback;

};

inline std::ostream& operator<<(std::ostream& stream, const PhoneCallAudioChannelEngineImpl::PendingEventState& state) {
    switch (state) {
        case PhoneCallAudioChannelEngineImpl::PendingEventState::NONE:
            stream << "NONE";
            break;
        case PhoneCallAudioChannelEngineImpl::PendingEventState::PLAYBACK_STARTED:
            stream << "PLAYBACK_STARTED";
            break;
        case PhoneCallAudioChannelEngineImpl::PendingEventState::PLAYBACK_PAUSED:
            stream << "PLAYBACK_PAUSED";
            break;
        case PhoneCallAudioChannelEngineImpl::PendingEventState::PLAYBACK_RESUMED:
            stream << "PLAYBACK_RESUMED";
            break;
        case PhoneCallAudioChannelEngineImpl::PendingEventState::PLAYBACK_STOPPED:
            stream << "PLAYBACK_STOPPED";
            break;
    }
    return stream;
}

} // aace::engine::phoneCallController
} // aace::engine
} // aace

#endif
