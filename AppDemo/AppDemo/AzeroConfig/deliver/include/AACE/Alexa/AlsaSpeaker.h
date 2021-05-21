#ifndef AACE_AUDIO_ALSA_SPEAKER_H
#define AACE_AUDIO_ALSA_SPEAKER_H

#include <functional>
#include <string>
#include <memory>

#include "Speaker.h"

namespace aace {
namespace alexa {

class AlsaSpeaker :
  public alexa::Speaker {

public:
  static std::shared_ptr<AlsaSpeaker> getInstance(VolumeHandler vh);
	// Speaker interface
	int8_t getVolume() override;
	bool setVolume(int8_t volume) override;
	bool adjustVolume(int8_t delta) override;
	bool setMute(bool mute) override;
	bool isMuted() override;
	bool isMute;
	int8_t volumeBak;
	int8_t volumeUnmute;

protected:
  AlsaSpeaker(VolumeHandler vh);

  VolumeHandler vh_;

};

}
}

#endif