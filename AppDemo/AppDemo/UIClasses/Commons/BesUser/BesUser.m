//
//  BesUser.m
//  XCYBlueBox
//
//  Created by max on 2019/3/22.
//  Copyright © 2019 XCY. All rights reserved.
//

#import "BesUser.h"

@implementation BesUser

+ (BesUser*)sharedUser
{
    __strong static id _sharedWexUserObject = nil;
    static dispatch_once_t preWexUser = 0;

    dispatch_once(&preWexUser, ^
                  {
                      _sharedWexUserObject = [[self alloc] init];
                      [_sharedWexUserObject commonInit];
                  });
    
    return _sharedWexUserObject;
}

- (void)commonInit
{
    _selected_left_filePath = nil;
    _selected_right_filePath = nil;
    _is_secondLap = NO;
    _user_fileType = 0;
    _MTU_Exchange = 128;
}

@end
