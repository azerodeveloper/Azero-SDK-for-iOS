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
    return true;
}
-(void) endOfSpeechDetected {
    //TODO:
}
-(bool) startAudioInput{
    return YES;
}
- (bool)stopAudioInput{
    return YES;
}

@end
