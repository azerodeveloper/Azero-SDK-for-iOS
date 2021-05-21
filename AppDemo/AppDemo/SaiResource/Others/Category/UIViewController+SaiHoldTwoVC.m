//
//  UIViewController+SaiHoldTwoVC.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/12/6.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "UIViewController+SaiHoldTwoVC.h"
#import <objc/runtime.h>

@implementation UIViewController (SaiHoldTwoVC)
- (void)sai_holdRootVCAndCurrentVCInNavgationVCs{
    if (!self.SaiPopMiddleVC) {
        return;
    }
    if (!self.navigationController) {
        return;
    }
    if (self.navigationController.viewControllers.count>2) {
        NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:2];
        [viewControllers addObject:self.navigationController.viewControllers.firstObject];
        [viewControllers addObject:self.navigationController.viewControllers.lastObject];
        self.navigationController.viewControllers = viewControllers;
    }
}
- (BOOL)SaiPopMiddleVC{
    return [objc_getAssociatedObject(self, @selector(setSaiPopMiddleVC:)) boolValue];
}
- (void)setSaiPopMiddleVC:(BOOL)SaiPopMiddleVC{
    objc_setAssociatedObject(self, _cmd, @(SaiPopMiddleVC), OBJC_ASSOCIATION_ASSIGN);
}


@end
