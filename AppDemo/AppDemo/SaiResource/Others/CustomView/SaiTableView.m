//
//  SaiTableView.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/12/6.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "SaiTableView.h"

@implementation SaiTableView
@synthesize isNoCancelEditWhenTouch;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (!isNoCancelEditWhenTouch) {
        [self.superview endEditing:YES];
    }
}

@end
