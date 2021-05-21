//
//  UINavigationController+SaiFixSpace.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/28.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "UINavigationController+SaiFixSpace.h"
#import "NSObject+SaiRuntime.h"
#import "SaiNavigationConfig.h"

static BOOL sai_tempDisableFixSpace = NO;

@implementation UINavigationController (SaiFixSpace)
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(viewWillAppear:)
                                     swizzledSel:@selector(sx_viewWillAppear:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(viewWillDisappear:)
                                     swizzledSel:@selector(sx_viewWillDisappear:)];
        //FIXME:修正iOS11之后push或者pop动画为NO 系统不主动调用UINavigationBar的layoutSubviews方法
        if (isIOS11) {
            [self swizzleInstanceMethodWithOriginSel:@selector(pushViewController:animated:)
                                         swizzledSel:@selector(sx_pushViewController:animated:)];
            
            [self swizzleInstanceMethodWithOriginSel:@selector(popViewControllerAnimated:)
                                         swizzledSel:@selector(sx_popViewControllerAnimated:)];
            
            [self swizzleInstanceMethodWithOriginSel:@selector(popToViewController:animated:)
                                         swizzledSel:@selector(sx_popToViewController:animated:)];
            
            [self swizzleInstanceMethodWithOriginSel:@selector(popToRootViewControllerAnimated:)
                                         swizzledSel:@selector(sx_popToRootViewControllerAnimated:)];
            
            [self swizzleInstanceMethodWithOriginSel:@selector(setViewControllers:animated:)
                                         swizzledSel:@selector(sx_setViewControllers:animated:)];
        }
    });
}
-(void)sx_viewWillAppear:(BOOL)animated {
    if ([self isKindOfClass:[UIImagePickerController class]]) {
        sai_tempDisableFixSpace = [SaiNavigationConfig sharedSaiNavigationConfig].sai_disableFixSpace;
        [SaiNavigationConfig sharedSaiNavigationConfig].sai_disableFixSpace = YES;
    }
    
    [self sx_viewWillAppear:animated];
}

-(void)sx_viewWillDisappear:(BOOL)animated{
    if ([self isKindOfClass:[UIImagePickerController class]]) {
        [SaiNavigationConfig sharedSaiNavigationConfig].sai_disableFixSpace = sai_tempDisableFixSpace;
    }
    [self sx_viewWillDisappear:animated];
}

//FIXME:修正iOS11之后push或者pop动画为NO 系统不主动调用UINavigationBar的layoutSubviews方法
-(void)sx_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self sx_pushViewController:viewController animated:animated];
    if (![SaiNavigationConfig sharedSaiNavigationConfig].sai_disableFixSpace) {
        if (!animated) {
            [self.navigationBar layoutSubviews];
        }
    }
}

- (nullable UIViewController *)sx_popViewControllerAnimated:(BOOL)animated{
    UIViewController *vc = [self sx_popViewControllerAnimated:animated];
    if (![SaiNavigationConfig sharedSaiNavigationConfig].sai_disableFixSpace) {
        if (!animated) {
            [self.navigationBar layoutSubviews];
        }
    }
    return vc;
}

- (nullable NSArray<__kindof UIViewController *> *)sx_popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSArray *vcs = [self sx_popToViewController:viewController animated:animated];
    if (![SaiNavigationConfig sharedSaiNavigationConfig].sai_disableFixSpace) {
        if (!animated) {
            [self.navigationBar layoutSubviews];
        }
    }
    return vcs;
}

- (nullable NSArray<__kindof UIViewController *> *)sx_popToRootViewControllerAnimated:(BOOL)animated{
    NSArray *vcs = [self sx_popToRootViewControllerAnimated:animated];
    if (![SaiNavigationConfig sharedSaiNavigationConfig].sai_disableFixSpace) {
        if (!animated) {
            [self.navigationBar layoutSubviews];
        }
    }
    return vcs;
}

- (void)sx_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated NS_AVAILABLE_IOS(3_0){
    [self sx_setViewControllers:viewControllers animated:animated];
    if (![SaiNavigationConfig sharedSaiNavigationConfig].sai_disableFixSpace) {
        if (!animated) {
            [self.navigationBar layoutSubviews];
        }
    }
}
@end
