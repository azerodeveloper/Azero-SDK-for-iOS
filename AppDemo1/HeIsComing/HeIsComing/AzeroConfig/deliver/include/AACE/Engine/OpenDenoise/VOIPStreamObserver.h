/*
 * VOIPStreamObserver.h
 *
 *  Created on: Mar 10, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_VOIPSTREAMOBSERVER_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_VOIPSTREAMOBSERVER_H_

#include <memory>
#include <mutex>
#include <AACE/OpenDenoise/VOIPStream.h>
#include <AACE/OpenDenoise/VOIPStreamEngineInterface.h>

namespace aace {
namespace engine {
namespace openDenoise {

class OpenDenoiseEngineImpl;

class VOIPStreamObserver :
		public aace::openDenoise::VOIPStreamEngineInterface,
		public std::enable_shared_from_this<VOIPStreamObserver> {
private:
	VOIPStreamObserver(
			std::shared_ptr<OpenDenoiseEngineImpl> engineImpl,
			std::shared_ptr<aace::openDenoise::VOIPStream> voipStream );

public:
	virtual ~VOIPStreamObserver() = default;

	static std::shared_ptr<VOIPStreamEngineInterface> create(
			std::shared_ptr<OpenDenoiseEngineImpl> engineImpl,
			std::shared_ptr<aace::openDenoise::VOIPStream> voipStream );

	bool start() override;
	bool stop() override;
	void notifyStreamOpened() override;
	void notifyStreamClosed() override;
	void write( const char *data, size_t size ) override;

private:
	std::weak_ptr<OpenDenoiseEngineImpl> m_openDenoiseEngineImpl;
	std::shared_ptr<aace::openDenoise::VOIPStream> m_voipStream;
	bool m_receiveData {false};
	mutable std::mutex m_mutex;
};

}	//namespace openDenoise
}	// aace::engine
}	//namespace aace


#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_VOIPSTREAMOBSERVER_H_ */
