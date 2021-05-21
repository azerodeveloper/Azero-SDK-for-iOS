//
//  UILabel+TP_LQYlabel.m
//  TimePrints
//
//  Created by 梁前勇 on 2017/12/7.
//  Copyright © 2017年 microdreams. All rights reserved.
//

#import "UILabel+TP_LQYlabel.h"

@implementation UILabel (TP_LQYlabel)

+(UILabel *)CreatLabeltext:(NSString *)text Font:(UIFont *)font Textcolor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment
{
    UILabel * label = [[UILabel alloc]init];
    if (textAlignment != 0) {
        label.textAlignment=textAlignment;

    }
    label.text =text;
    label.textColor = color;
    label.font = font;
    return label;
}
+ (UILabel *)getLabelWithFontSize:(CGFloat)fontSize
                  backgroundColor:(UIColor *)color
                        textColor:(UIColor *)textColor
                        superView:(UIView *)superView{
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectZero];
    Label.font = [UIFont qk_PingFangSCRegularFontwithSize:fontSize];
    Label.backgroundColor = color;
    Label.textColor = textColor;
    [superView addSubview:Label];
    return Label;
}
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

@end
