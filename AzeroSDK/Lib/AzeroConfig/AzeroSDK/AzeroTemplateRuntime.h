//
//  AzeroTemplateRuntime.h
//  test000
//
//  Created by nero on 2020/3/9.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface AzeroTemplateRuntime : AzeroPlatformInterface

//virtual
-(void) renderTemplate:(NSString *)payload;
//virtual
-(void) clearTemplate;
//virtual
-(void) renderPlayerInfo:(NSString *)payload;
//virtual
-(void) clearPlayerInfo;

-(bool) reclockTemplateTimer;
-(bool) reclockPlayerTimer;

@end

NS_ASSUME_NONNULL_END
