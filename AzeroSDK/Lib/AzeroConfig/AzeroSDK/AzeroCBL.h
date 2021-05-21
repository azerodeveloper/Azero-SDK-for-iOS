//
//  AzeroCBL.h
//  test000
//
//  Created by nero on 2020/2/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include <AACE/CBL/CBL.h>

using AzeroCBLState = aace::cbl::CBL::CBLState;
using AzeroCBLStateChangedReason = aace::cbl::CBL::CBLStateChangedReason;

NS_ASSUME_NONNULL_BEGIN

@interface AzeroCBL : AzeroPlatformInterface

//virtual
-(void) cblStateChanged:(AzeroCBLState) state byReason:(AzeroCBLStateChangedReason) reason withUrl:(NSString *)url andCode:(NSString *)code;
//virtual
-(void) clearRefreshToken;
//virtual
-(void) setRefreshToken:(NSString *) refreshToken;
//virtual
-(NSString *) getRefreshToken;

-(void) start;
-(void) cancel;

// add by hanqy
//virtual
-(void) setUserProfile:(NSString *)name email:(NSString *)email;

-(void) showMessage:(NSString *)message;

-(NSString *) getAuthToken;
-(void) reset;

@end

NS_ASSUME_NONNULL_END
