//
//  UINavigationBar+SaiFixSpace.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/28.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "UINavigationBar+SaiFixSpace.h"
#import "NSObject+SaiRuntime.h"
#import "SaiNavigationConfig.h"  

@implementation UINavigationBar (SaiFixSpace)
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(layoutSubviews)
                                     swizzledSel:@selector(sx_layoutSubviews)];
    });
}

-(void)sx_layoutSubviews{
    [self sx_layoutSubviews];
    if (isIOS11 && ![SaiNavigationConfig sharedSaiNavigationConfig].sai_disableFixSpace) {//需要调节
        CGFloat space = [SaiNavigationConfig sharedSaiNavigationConfig].sai_defaultFixSpace;
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
                if (isIOS13) {
//                    UIEdgeInsets margins = subview.layoutMargins;
//                       CGRect frame = subview.frame;
//                       frame.origin.x = -margins.left;
//                       frame.origin.y = -margins.top;
//                       frame.size.width += (margins.left + margins.right);
//                       frame.size.height += (margins.top + margins.bottom);
//                       subview.frame = frame;
                }else{
                    subview.layoutMargins = UIEdgeInsetsMake(0, space, 0, space);//可修正iOS11之后的偏移
                }
                break;
            }
        }
    }
}
@end
