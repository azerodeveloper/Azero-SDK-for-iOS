//
//  MySpeechSynthesizer.m
//  test000
//
//  Created by silk on 2020/3/6.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "MySpeechSynthesizer.h"

@implementation MySpeechSynthesizer
-(void) handlePrePlaybackStarted {
    TYLog(@"AzeroSubclass ------handlePrePlaybackStarted");
    TYLog(@"%s", __FUNCTION__);
}
-(void) handlePostPlaybackFinished {
    TYLog(@"AzeroSubclass ------handlePostPlaybackFinished");
    TYLog(@"%s", __FUNCTION__);
}
@end
