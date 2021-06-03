//
//  AzeroBluetooth.m
//  HeIsComing
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroBluetooth.h"

class BluetoothWrapper : public aace::alexa::Bluetooth {
public:
    BluetoothWrapper(
                AzeroBluetooth *imp,
                std::shared_ptr<aace::alexa::MediaPlayer> mediaPlayer,
                std::shared_ptr<aace::alexa::Speaker> speaker)
    : aace::alexa::Bluetooth(mediaPlayer, speaker)
    , w (imp) {};

    bool waitForBluetoothDeviceTurnOn(void) override {
        return [w waitForBluetoothDeviceTurnOn];
    }
    
    bool handleCmd(BluetoothCmd cmd) override {
        return [w handleCmd:cmd];
    }
    
    bool handleEvent(BluetoothEvent evt) override {
        return [w handleEvent:evt];
    }
    
private:
    __weak AzeroBluetooth *w;
};


@implementation AzeroBluetooth
{
    std::shared_ptr<aace::alexa::Bluetooth> wrapper;
}

-(AzeroBluetooth *) init {
    if (self = [super init]) {
        assert(false);
    }
    return self;
}

-(AzeroBluetooth *) initWithMediaPlayer:(AzeroMediaPlayer *)player andSpeaker:(AzeroSpeaker *)speaker {
    if (self = [super init]) {
        wrapper = std::make_shared<BluetoothWrapper>(
                            self, [player getRawPtr], [speaker getRawPtr]);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr; {
    return wrapper;
}

-(std::shared_ptr<aace::alexa::AudioChannel>) getAudioChannelRawPtr {
    return wrapper;
}

@end
