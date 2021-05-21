//
//  MySpeechRecognizer.m
//  test000
//
//  Created by silk on 2020/3/5.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "MySpeechRecognizer.h"

@implementation MySpeechRecognizer
-(bool) wakewordDetected:(NSString *)wakeword {
    TYLog(@"AzeroSubclass ------wakewordDetected");
    return true;
}
-(void) endOfSpeechDetected {
    TYLog(@"AzeroSubclass ------endOfSpeechDetected");
    //TODO:
}
-(bool) startAudioInput{
    TYLog(@"AzeroSubclass ------startAudioInput");
    return YES;
}
- (bool)stopAudioInput{
    TYLog(@"AzeroSubclass ------stopAudioInput");
    return YES;
}

@end
