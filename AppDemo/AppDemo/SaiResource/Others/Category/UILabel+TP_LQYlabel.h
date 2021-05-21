//
//  UILabel+TP_LQYlabel.h
//  TimePrints
//
//  Created by 梁前勇 on 2017/12/7.
//  Copyright © 2017年 microdreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TP_LQYlabel)

+(UILabel *)CreatLabeltext:(NSString *)text Font:(UIFont *)font Textcolor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment;
+ (UILabel *)getLabelWithFontSize:(CGFloat)fontSize
backgroundColor:(UIColor *)color
      textColor:(UIColor *)textColor
      superView:(UIView *)superView;
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;
@end
