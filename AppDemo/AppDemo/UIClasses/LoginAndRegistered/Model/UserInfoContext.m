//
//  UserInfoContext.m
//  xiaoyixiu
//
//  Created by hanzhanbing on 16/6/17.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import "UserInfoContext.h"

@implementation UserInfoContext

- (instancetype)init
{
    self  = [super init];
    if (self) {
        
      
    }
    return self;
}

+ (UserInfoContext *)sharedContext
{
    static UserInfoContext *sharedContextInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedContextInstance = [[UserInfoContext alloc] init];
    });
    return sharedContextInstance;
}

@end
