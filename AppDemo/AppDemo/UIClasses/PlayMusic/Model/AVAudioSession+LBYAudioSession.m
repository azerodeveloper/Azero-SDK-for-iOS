//
//  AVAudioSession+LBYAudioSession.m
//  HeIsComing
//
//  Created by mike on 2020/4/15.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AVAudioSession+LBYAudioSession.h"

@implementation AVAudioSession (LBYAudioSession)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSEL = @selector(setActive:withOptions:error:);
        SEL swizzledSEL = @selector(lby_setActive:withOptions:error:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSEL);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
        
        BOOL didAddMethod = class_addMethod(class, originalSEL , method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (BOOL)lby_setActive:(BOOL)active withOptions:(AVAudioSessionSetActiveOptions)options error:(NSError * _Nullable __autoreleasing *)outError {
//    BOOL realActive = kPlayer.isPlaying ? YES : active;
    return [self lby_setActive:active withOptions:options error:outError];
}
@end
