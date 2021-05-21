#ifndef _SAI_OPENDENOISE_MODECONTROLHANDLER_H_
#define _SAI_OPENDENOISE_MODECONTROLHANDLER_H_

#include <AACE/OpenDenoise/ModeControl.h>

namespace azeroSDK {

class ModeControlHandler : public aace::openDenoise::ModeControl {

	public:
	static std::shared_ptr<ModeControlHandler> create();

	bool restartOpenDenoise();
};

} //namespace azeroSDK


#endif //_SAI_OPENDENOISE_MODECONTROLHANDLER_H_