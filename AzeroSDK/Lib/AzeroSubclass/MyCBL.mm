//
//  MyCBL.m
//  test000
//
//  Created by silk on 2020/3/3.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "MyCBL.h"

@implementation MyCBL
{
    NSString *mRefreshToken;
}

-(MyCBL *) init {
    if (self = [super init]) {
        [self clearRefreshToken];
    } 
    return self;
}

-(void) cblStateChanged:(AzeroCBLState) state byReason:(AzeroCBLStateChangedReason) reason withUrl:(NSString *)url andCode:(NSString *)code {
    NSLog(@"AzeroSubclass ------cblStateChanged");
//    TYLog(@"%s-%d-%d-%@-%@", __FUNCTION__, state, reason, url, code);
}

-(void) clearRefreshToken {
    NSLog(@"AzeroSubclass ------clearRefreshToken");
    mRefreshToken = @"";
}

-(void) setRefreshToken:(NSString *) refreshToken {
    NSLog(@"AzeroSubclass ------setRefreshToken");
    mRefreshToken = refreshToken;
}

-(NSString *) getRefreshToken {
    NSLog(@"AzeroSubclass ------getRefreshToken");
    return mRefreshToken;
}

//virtual
-(void) setUserProfile:(NSString *)name email:(NSString *)email{
    return;
}

-(void) showMessage:(NSString *)message{
    NSLog(@"message: %@",message);
}
@end
