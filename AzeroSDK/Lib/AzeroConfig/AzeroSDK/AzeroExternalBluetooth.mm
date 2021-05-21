//
//  AzeroExternalBluetooth.m
//  AzeroDemo
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroExternalBluetooth.h"

class AzeroBluetoothWrapper : public aace::alexa::AzeroBluetooth {
public:
    AzeroBluetoothWrapper(AzeroExternalBluetooth *imp)
    : w (imp) {};
    
    bool executeCmd(BluetoothCmd cmd) override {
        return [w executeCmd:cmd];
    }
    
private:
    __weak AzeroExternalBluetooth *w;
};


@implementation AzeroExternalBluetooth
{
    std::shared_ptr<aace::alexa::AzeroBluetooth> wrapper;
}

-(AzeroExternalBluetooth *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<AzeroBluetoothWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

@end
