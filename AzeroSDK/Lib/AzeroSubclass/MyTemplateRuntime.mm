//
//  MyTemplateRuntime.m
//  test000
//
//  Created by silk on 2020/3/23.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "MyTemplateRuntime.h"
@interface MyTemplateRuntime()
@property (nonatomic ,copy) azeroRenderTemplateBlock renderTemplatHandle;
@property (nonatomic ,copy) azeroRenderPlayerInfoBlock azeroRenderPlayerInfoHandle;
@end
@implementation MyTemplateRuntime
//virtual
-(void) renderTemplate:(NSString *)payload{
    //下发模板的回调
    if (self.renderTemplatHandle) {
        self.renderTemplatHandle(payload);
    }
}
//virtual
-(void) clearTemplate{
}
//virtual
-(void) renderPlayerInfo:(NSString *)payload{
    //下发的模板信息
    if (self.azeroRenderPlayerInfoHandle) {
       self.azeroRenderPlayerInfoHandle(payload);
    }
}
//virtual
-(void) clearPlayerInfo{
}

-(bool) reclockTemplateTimer{
    return true;
}
-(bool) reclockPlayerTimer{
    return false;
}

- (void)azeroRenderTemplateWith:(azeroRenderTemplateBlock)azeroRenderTemplate{
    if (azeroRenderTemplate) {
         self.renderTemplatHandle = azeroRenderTemplate;
     }
}
- (void)azeroRenderPlayerInfoWith:(azeroRenderPlayerInfoBlock)azeroRenderPlayerInfo{
    if (azeroRenderPlayerInfo) {
        self.azeroRenderPlayerInfoHandle = azeroRenderPlayerInfo;
    }
}
@end
