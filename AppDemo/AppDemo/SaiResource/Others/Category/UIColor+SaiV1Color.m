//
//  UIColor+SaiV1Color.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/28.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "UIColor+SaiV1Color.h"

@implementation UIColor (SaiV1Color)
+ (UIColor *)sai_ControllerBackGroundColor{
    return [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
}
+ (UIColor *)sai_NavgationBarColor{
    return [UIColor ty_colorWithHex:@"5098ff"];
}
+ (UIColor *)sai_buttonUnableClickBackgroundColor{
    return [UIColor ty_colorWithHex:@"97bbee"];
}

+ (UIColor *) ty_colorWithHex:(NSString *)string {
    
    NSString *cleanString = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
@end
