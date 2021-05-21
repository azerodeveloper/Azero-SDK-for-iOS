//
//  UIImage+SaiWJY.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/12/10.
//  Copyright © 2018 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SaiWJY)
/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
/**
 *  根据颜色来生成图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 *  获取图片上某点的颜色
 */
- (UIColor *)colorWithPicture:(CGPoint)point ;

+ (nullable NSArray *)colorAtPixel:(CGPoint)point withImage:(UIImage *)image imageWidth:(CGFloat)imageWidth;

@end

NS_ASSUME_NONNULL_END
