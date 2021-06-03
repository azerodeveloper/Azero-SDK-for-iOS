//
//  UIButton+YLY.h
//  EastOffice2.0
//
//  Created by YLY on 2017/12/9.
//  Copyright © 2017年 EO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ButtonEdgeInsetsStyle) {
    ButtonEdgeInsetsStyle_Top,
    ButtonEdgeInsetsStyle_Left,
    ButtonEdgeInsetsStyle_Right,
    ButtonEdgeInsetsStyle_Bottom
};

@interface UIButton (YLY)

@property (nonatomic, copy) NSString * clickArea;


+(UIButton *)CreatButtontext:(NSString *)text image:(UIImage *)image Font:(UIFont *)font Textcolor:(UIColor *)color ;

+ (instancetype)initButtonTitleFont:(CGFloat)font titleColor:(UIColor *)color titleName:(NSString *)name;

/**
 创建文字图片btn
 */
+ (instancetype)initButtonTitleFont:(CGFloat)font titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backColor imageName:(NSString *)imageName titleName:(NSString *)titleName;

- (void)setButtonTitleFont:(CGFloat)font titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backColor imageName:(NSString *)imageName titleName:(NSString *)titleName;

- (void)layoutWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style
                  imageTitleSpace:(CGFloat)space;

@end
