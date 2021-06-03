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
    TYLog(@"payload1%@",payload);

    if (self.renderTemplatHandle) {

        self.renderTemplatHandle(payload);
    }

}
//virtual
-(void) clearTemplate{
    TYLog(@"AzeroSubclass ------clearTemplate");
}
//virtual
-(void) renderPlayerInfo:(NSString *)payload{
//    TYLog(@"返回的数据信息是 ----------------------------  %@",payload);
    if (self.azeroRenderPlayerInfoHandle) {
       self.azeroRenderPlayerInfoHandle(payload);
    }
}
//virtual
-(void) clearPlayerInfo{
    TYLog(@"AzeroSubclass ------clearPlayerInfo");
}

-(bool) reclockTemplateTimer{
    TYLog(@"AzeroSubclass ------reclockTemplateTimer");
    return true;
}
-(bool) reclockPlayerTimer{
    TYLog(@"AzeroSubclass ------reclockTemplateTimer");
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
