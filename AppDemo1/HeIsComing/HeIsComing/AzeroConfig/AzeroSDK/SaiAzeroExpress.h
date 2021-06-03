//
//  SaiAzeroExpress.h
//  HeIsComing
//
//  Created by silk on 2020/4/1.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include <AACE/Alexa/AzeroExpress.h>
NS_ASSUME_NONNULL_BEGIN

@interface SaiAzeroExpress : AzeroPlatformInterface
-(void) handleExpressDirectiveFor:(NSString *)name withPayload:(NSString *)payload;

-(void) sendEvent:(NSString *)jsonContent;
-(void) reconnectAVSnet;
@end

NS_ASSUME_NONNULL_END

