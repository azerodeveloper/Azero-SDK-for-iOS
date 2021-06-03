//
//  UIColor+SaiV1Color.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/28.
//  Copyright © 2018 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (SaiV1Color)
+ (UIColor *)sai_ControllerBackGroundColor;
+ (UIColor *)sai_NavgationBarColor;
+ (UIColor *)sai_buttonUnableClickBackgroundColor;
+ (UIColor *) ty_colorWithHex:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
