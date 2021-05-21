/*
 * Mode.h
 *
 *  Created on: Mar 31, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_LSDEVENTHANDLEPOLICY_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_LSDEVENTHANDLEPOLICY_H_

#include <stdlib.h>
#include <AACE/OpenDenoise/LocalSpeechDetectorEngineInterface.h>
#include "SequenceIdGenerator.h"

namespace aace {
namespace engine {
namespace openDenoise {

class OpenDenoiseInstance;

namespace eventHandleStrategy {

class ModeExecutionExceptionObserverInterface {
public:
	virtual ~ModeExecutionExceptionObserverInterface() = default;
	virtual void onException() = 0;
};

class Mode : public aace::openDenoise::LocalSpeechDetectorEngineInterface {
public:
	struct SequenceIdGeneratorBindType {};
	using SequenceIdGenerator = eventHandleStrategy::SequenceIdGenerator<
			SequenceIdGeneratorBindType, SequenceIdType>;
public:
	Mode( std::weak_ptr<ModeExecutionExceptionObserverInterface> modeExcutionExceptionObserver );
	virtual ~Mode() = default;

	void setOpenDenoiseInstance( std::shared_ptr<OpenDenoiseInstance> instance );
	std::weak_ptr<OpenDenoiseInstance> getOpenDenosieInstance();
	virtual bool start() = 0;
	virtual void shutdown() = 0;
	virtual void onASRData( const char *data, size_t size ) = 0;
	virtual void onVOIPData( const char *data, size_t size ) = 0;
	virtual void onKWD( float angle ) = 0;
	virtual void onVADStart() = 0;
	virtual void onVADStartTimeout() = 0;
	virtual void onVADEnd() = 0;
	virtual void onOfflineCommand( const char *cmd ) = 0;

protected:
	void sendModeExecutionException();

private:
	std::weak_ptr<OpenDenoiseInstance> m_denoiseWeakPtr;
	std::weak_ptr<ModeExecutionExceptionObserverInterface> m_modeExcutionExceptionObserver;
};

} /* namespace lsdEventHandlePolicy */
} /* namespace openDenoise */
} /* namespace engine */
} /* namespace aace */

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_LSDEVENTHANDLEPOLICY_H_ */
