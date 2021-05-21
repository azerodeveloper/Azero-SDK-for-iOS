/*
 * ModeObserver.h
 *
 *  Created on: Mar 25, 2020
 *      Author: nero
 */

#ifndef PLATFORM_INCLUDE_AACE_OPENDENOISE_MODEOBSERVERINTERFACE_H_
#define PLATFORM_INCLUDE_AACE_OPENDENOISE_MODEOBSERVERINTERFACE_H_

#include <string>

namespace aace {
namespace openDenoise {

class ModeObserverInterface {
public:
	struct ModeConfiguration {
		std::string name;	//mapping to "aace.opendenoise"."wakeupModels" in configuration json file.
		enum class WakeupMode {
				NormalMode,
				WakeFreeMode,
		} wakeupMode;
		inline std::string toString() const {
			std::string ret = "Name:";
			ret += name;
			ret += " WakeupMode:";
			switch ( wakeupMode ) {
			case WakeupMode::NormalMode:
				ret += "NormalMode";
				break;
			case WakeupMode::WakeFreeMode:
				ret += "WakeFreeMode";
				break;
			}
			return ret;
		}
	};
	using WakeupMode = ModeConfiguration::WakeupMode;

public:
	virtual ~ModeObserverInterface() = default;

	//System tend to change mode and use this function to query if it's ok to change mode
	//system will abort mode change if any observer rejected and invoke @c onModeChangedCancelled to notify all observers.
	// @return false-reject
	virtual bool onModeChangePrepare( const ModeConfiguration &config );

	//invoked when mode change cancelled
	virtual void onModeChangeCancelled( const ModeConfiguration &config );

	//if all observer agree to change mode, this funciton may be invoked multi-times in a mode change turning.
	virtual void onChangeMode( const ModeConfiguration &config );

	virtual void onModeChanged( const ModeConfiguration &config );

	virtual void onModeChangeFailed();

	virtual void onModeSystemShutDown();

	//you can't invoke any mode control function in this callback
	virtual void onModeExecutionException();
};

} /* namespace openDenoise */
} /* namespace aace */

#endif /* PLATFORM_INCLUDE_AACE_OPENDENOISE_MODEOBSERVERINTERFACE_H_ */
