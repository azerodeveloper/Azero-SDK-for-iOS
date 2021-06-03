//
//  UIViewController+SaiNavBarItemExtension.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/28.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "UIViewController+SaiNavBarItemExtension.h"   
#import <objc/runtime.h>

@implementation UIViewController (SaiNavBarItemExtension)    
/** 设置navigation的titleView *///黑色字体
- (UILabel *)sai_initTitleView:(NSString *)title{
    UIView *SaiTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.navigationItem.titleView.frame), 30)];
    SaiTitleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = SaiTitleView;
    
    UILabel *SaiTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    SaiTitleLabel.center = SaiTitleView.center;
    SaiTitleLabel.textColor = [UIColor blackColor];
    SaiTitleLabel.textAlignment = NSTextAlignmentCenter;
    SaiTitleLabel.backgroundColor = [UIColor clearColor];
    SaiTitleLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:18.0f];
    SaiTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [SaiTitleView addSubview:SaiTitleLabel];
    self.SaiTitleLabel = SaiTitleLabel;
    
    SaiTitleLabel.text = title;
    return SaiTitleLabel;  
}
/** 设置navigation的titleView *///白色字体
- (UILabel *)sai_initWhiteTitleView:(NSString *)title{
    UIView *SaiTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.navigationItem.titleView.frame), 30)];
    SaiTitleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = SaiTitleView;
    
    UILabel *SaiTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    SaiTitleLabel.center = SaiTitleView.center;
    SaiTitleLabel.textColor = [UIColor whiteColor];
    SaiTitleLabel.textAlignment = NSTextAlignmentCenter;
    SaiTitleLabel.backgroundColor = [UIColor clearColor];
    SaiTitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    SaiTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [SaiTitleView addSubview:SaiTitleLabel];
    self.SaiTitleLabel = SaiTitleLabel;
    
    SaiTitleLabel.text = title;
    return SaiTitleLabel;
}
/** 设置返回按钮的文字 */
- (UIButton *)sai_setBackItemTitle:(NSString *)string{
    if(string == nil || !string.length){
        return [UIButton new];
    }
    
    if (self.SaiBackButton == nil) {
        [self sai_initGoBackButton];
    }
    
    [self.SaiBackButton setTitle:string forState:UIControlStateNormal];
    return self.SaiBackButton;
    
};
/**给控制器添加返回的按钮 */
- (void) sai_initGoBackButton{
    // 返回按钮
    self.SaiBackButton = [[UIButton alloc ]init];
    self.SaiBackButton.frame = CGRectMake(0, 0, 44, 44);
    [self.SaiBackButton setImage:[UIImage imageNamed:@"Nav_back"] forState:UIControlStateNormal];
    if (isIOS13) {
        self.SaiBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        self.SaiBackButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);

    }
    [self.SaiBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.SaiBackButton addTarget:self action:@selector(sai_backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.SaiBackButton];
    
//    // 向左移动的空格
//    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                                                           target:nil action:nil];
//    space.width = -15.0f;
    
//    self.navigationItem.leftBarButtonItems = @[ space,backButtonItem];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}
- (void) sai_initGoBackBlackButton{
    // 返回按钮
    self.SaiBackButton = [[UIButton alloc ]init];
    self.SaiBackButton.frame = CGRectMake(0, 0, 44, 44);  
    [self.SaiBackButton setImage:[UIImage imageNamed:@"skill_back_graw_n"] forState:UIControlStateNormal];
    if (isIOS13) {
        self.SaiBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        self.SaiBackButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    [self.SaiBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.SaiBackButton addTarget:self action:@selector(sai_backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.SaiBackButton];
    //    // 向左移动的空格
    //    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
    //                                                                           target:nil action:nil];
    //    space.width = -15.0f;
    
    //    self.navigationItem.leftBarButtonItems = @[ space,backButtonItem];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}
- (void) sai_backAction:(UIButton *)button{
    // 再点击返回后,这个按钮就设置为不能点击,防止卡顿的时候,一个按钮连按的情况
    button.userInteractionEnabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
};
- (UIButton *)sai_initNavRightBtn{
    if (self.SaiRightButton) {
        return self.SaiRightButton;
    }
    UIBarButtonItem *buttonItem = [self sai_creatNavBtn];
    self.SaiRightButton = (UIButton *)buttonItem.customView;
//    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    space.width = -20.0f;
//    self.navigationItem.rightBarButtonItems = @[space,buttonItem];
    self.navigationItem.rightBarButtonItem = buttonItem;
    return buttonItem.customView;
}
- (UIButton *)sai_initNavLeftBtn{
    if (self.SaiLeftButton) {
        return self.SaiLeftButton;
    };
    UIBarButtonItem *buttonItem = [self sai_creatNavBtn];
    self.SaiLeftButton = (UIButton *)buttonItem.customView;
//    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    space.width = -20.0f;
//    self.navigationItem.leftBarButtonItems = @[space,buttonItem];
    self.navigationItem.leftBarButtonItem = buttonItem;
    return (UIButton *)buttonItem.customView;
}
// 生成顶部的按钮.
- (UIBarButtonItem *)sai_creatNavBtn
{
    UIButton* Button = [[UIButton alloc ]init];
    Button.frame = CGRectMake(0, 0, 44, 44);
    [Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Button setTitleColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:0.50] forState:UIControlStateDisabled];
    Button.titleLabel.textAlignment = NSTextAlignmentCenter;
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:Button];
//    Button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    Button.titleLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:17.0];
    return ButtonItem;
}

#pragma mark -  Getters and Getters
- (UIButton *)SaiLeftButton{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSaiLeftButton:(UIButton *)SaiLeftButton{
    objc_setAssociatedObject(self, @selector(SaiLeftButton), SaiLeftButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIButton *)SaiRightButton{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSaiRightButton:(UIButton *)SaiRightButton{
    objc_setAssociatedObject(self, @selector(SaiRightButton), SaiRightButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setSaiBackButton:(UIButton *)SaiBackButton{
    objc_setAssociatedObject(self, @selector(SaiBackButton), SaiBackButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIButton *)SaiBackButton{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSaiTitleLabel:(UILabel *)SaiTitleLabel{
    objc_setAssociatedObject(self, @selector(SaiTitleLabel), SaiTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)SaiTitleLabel{
    return objc_getAssociatedObject(self, _cmd);
    
}
@end
