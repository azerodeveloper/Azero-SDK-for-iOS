//
//  UIButton+YLY.m
//  EastOffice2.0
//
//  Created by YLY on 2017/12/9.
//  Copyright © 2017年 EO. All rights reserved.
//

#import "UIButton+YLY.h"

@implementation UIButton (YLY)
+(UIButton *)CreatButtontext:(NSString *)text image:(UIImage *)image Font:(UIFont *)font Textcolor:(UIColor *)color {
    UIButton * button = [[UIButton alloc]init];
    if (image) {
        [button setImage:image forState:0];

    }
    if ([text isNotBlank]) {
        [button setTitle:text forState:0];

    }
    [button setTitleColor:color forState:0];
    button.titleLabel.font=font;
    return button;
}

+ (instancetype)initButtonTitleFont:(CGFloat)font titleColor:(UIColor *)color titleName:(NSString *)name {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:[color colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:font]];
    return btn;
}

// 创建文字图片btn
+ (instancetype)initButtonTitleFont:(CGFloat)font titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backColor imageName:(NSString *)imageName titleName:(NSString *)titleName {
    
    titleName = titleName == nil ? @"" : titleName;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitle:titleName forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:font]];
    btn.backgroundColor = backColor;
    return btn;
}

- (void)setButtonTitleFont:(CGFloat)font titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backColor imageName:(NSString *)imageName titleName:(NSString *)titleName {
    
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self setTitle:titleName forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:font]];
}
- (void)layoutWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style
                  imageTitleSpace:(CGFloat)space {
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
    CGFloat labelHeight = self.titleLabel.intrinsicContentSize.height;
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    switch (style) {
        case ButtonEdgeInsetsStyle_Top:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case ButtonEdgeInsetsStyle_Left:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case ButtonEdgeInsetsStyle_Bottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case ButtonEdgeInsetsStyle_Right:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    [super pointInside:point withEvent:event];
    //获取bounds 实际大小
    CGRect bounds = self.bounds;
    if (self.clickArea) {
        CGFloat area = [self.clickArea floatValue];
        CGFloat widthDelta = MAX(area * bounds.size.width - bounds.size.width, .0);
        CGFloat heightDelta = MAX(area * bounds.size.height - bounds.size.height, .0);
        //扩大bounds
        bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
       
    }
    //点击的点在新的bounds 中 就会返回YES
    return CGRectContainsPoint(bounds, point);
}

- (void)setClickArea:(NSString *)clickArea{
    objc_setAssociatedObject(self, @selector(clickArea), clickArea, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)clickArea{
    return objc_getAssociatedObject(self, @selector(clickArea));
}
//重写该方法可以去除长按按钮时出现的高亮效果
- (void)setHighlighted:(BOOL)highlighted
{

}


@end
