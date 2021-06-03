/*
 * OpenDenoiseInstance.h
 *
 *  Created on: Mar 31, 2020
 *      Author: nero
 */

#ifndef ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_OPENDENOISEINSTANCE_H_
#define ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_OPENDENOISEINSTANCE_H_

#include <memory>
#include <mutex>
#include <AACE/OpenDenoise/ModeControlEngineInterface.h>
#include "OpenDenoiseConfiguration.h"

extern "C" {
	struct sai_denoise_cfg_t;
	struct sai_wake_cfg_t;
	struct sai_denoise_ctx_t;
}

namespace aace {
namespace engine {
namespace openDenoise {

namespace eventHandleStrategy {
	class Mode;
}

class OpenDenoiseInstance {
public:
	using ModeConfiguration = aace::openDenoise::ModeControlEngineInterface::ModeConfiguration;

public:
	virtual ~OpenDenoiseInstance();

	std::shared_ptr<OpenDenoiseInstance>
	static create( std::shared_ptr<OpenDenoiseConfiguration> config,
			const ModeConfiguration &modeConfig,
			std::shared_ptr<eventHandleStrategy::Mode> mode );

	bool startBeam( float angle );
	void stopBeam();
	bool startVOIPStream();
	bool stopVOIPStream();
	bool write( const char* data, const size_t size );

private:
	bool createDenoiseInstance();
	void shutdownDenoiseInstance();

	static void denoiseLoggerHandler(
			int level, const char *tag,
			const char *func, const char *msg);
	static void denoiseASRDataHandler(
			sai_denoise_ctx_t *ctx, const char *type,
			const char *data, size_t size,
			void *userData);
	static void denoiseEventWakeHandler(
			sai_denoise_ctx_t *ctx, const char * type,
			int32_t code, const void *payload,
			void* userData);
	static void denoiseEventVADHandler(
			sai_denoise_ctx_t *ctx, const char *type,
			int32_t code, const void *payload,
			void* userData);
	static void denoiseVOIPDataHandler(
			sai_denoise_ctx_t *ctx, const char *type,
			const char *data, size_t size,
			void* userData);
	static void denoiseEventCMDHandler(
			sai_denoise_ctx_t *ctx, const char *type,
			int32_t code, const void *payload,
			void *userData);

private:
	OpenDenoiseInstance(
			std::shared_ptr<OpenDenoiseConfiguration> config,
			const ModeConfiguration &modeConfig,
			std::shared_ptr<eventHandleStrategy::Mode> mode );
	std::string generateDeviceUniqueId();

private:
	std::shared_ptr<eventHandleStrategy::Mode> m_mode;
	sai_denoise_cfg_t *m_denoiseCfg = nullptr;
	sai_wake_cfg_t *m_wakeCfg = nullptr;
	sai_denoise_ctx_t *m_denoiseCtx = nullptr;
	std::shared_ptr<OpenDenoiseConfiguration> m_config;
	ModeConfiguration m_modeConfig;\
	std::mutex m_mutex;
};

} /* namespace openDenoise */
} /* namespace engine */
} /* namespace aace */

#endif /* ENGINE_INCLUDE_AACE_ENGINE_OPENDENOISE_OPENDENOISEINSTANCE_H_ */
