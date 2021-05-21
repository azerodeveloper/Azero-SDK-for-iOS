//
//  UIViewController+SaiNavBarItemExtension.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/28.
//  Copyright © 2018 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SaiNavBarItemExtension)
@property (nonatomic, strong) UIButton *SaiBackButton;
@property (nonatomic ,strong) UIButton *SaiLeftButton;
@property (nonatomic ,strong) UIButton *SaiRightButton;
@property (nonatomic, strong) UILabel *SaiTitleLabel;
/** 设置navigation的titleView *///黑色字体
- (UILabel *)sai_initTitleView:(NSString *)title;
/** 设置navigation的titleView *///白色字体
- (UILabel *)sai_initWhiteTitleView:(NSString *)title;
/**给控制器添加返回的按钮 */
- (void) sai_initGoBackButton;
/** 设置返回按钮的文字 */
- (UIButton *)sai_setBackItemTitle:(NSString *)string;
/**给控制器添加返回的按钮 */
- (void) sai_initGoBackBlackButton;
/** 左: 初始化控制器左侧的按钮, 需要添加target方法和 设置按钮的文字或图片 */
- (UIButton *)sai_initNavLeftBtn;
/** 右: 初始化控制器右侧的按钮, 需要添加target方法和 设置按钮的文字或图片 */
- (UIButton *)sai_initNavRightBtn;
@end

NS_ASSUME_NONNULL_END
