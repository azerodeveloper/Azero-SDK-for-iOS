//
//  MyTemplateRuntime.h
//  test000
//
//  Created by silk on 2020/3/23.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroTemplateRuntime.h"
typedef void(^azeroRenderTemplateBlock) (NSString *payload);
typedef void(^azeroRenderPlayerInfoBlock) (NSString *payload);

@interface MyTemplateRuntime : AzeroTemplateRuntime

- (void)azeroRenderTemplateWith:(azeroRenderTemplateBlock)azeroRenderTemplate;
- (void)azeroRenderPlayerInfoWith:(azeroRenderPlayerInfoBlock)azeroRenderPlayerInfo;

@end

