/*
 * LocalSpeechDetectorEngineInterface.h
 *
 *  Created on: Mar 10, 2020
 *      Author: nero
 */

#ifndef PLATFORM_INCLUDE_AACE_OPENDENOISE_LOCALSPEECHDETECTORENGINEINTERFACE_H_
#define PLATFORM_INCLUDE_AACE_OPENDENOISE_LOCALSPEECHDETECTORENGINEINTERFACE_H_

#include <memory>
#include <future>

namespace aace {
namespace openDenoise {

class LocalSpeechDetectorEngineInterface {
public:
	using SequenceIdType = std::uint64_t;
	using TapToTalkSyncTask = std::packaged_task<void(bool)>;
public:
	virtual ~LocalSpeechDetectorEngineInterface() = default;

	virtual bool tapToTalk( int tag, TapToTalkSyncTask &&syncTask ) = 0;

	virtual bool stopAudioQuery( SequenceIdType sequenceId ) = 0;
};

}	//namespace openDenoise
}	//namespace aace


#endif /* PLATFORM_INCLUDE_AACE_OPENDENOISE_LOCALSPEECHDETECTORENGINEINTERFACE_H_ */
