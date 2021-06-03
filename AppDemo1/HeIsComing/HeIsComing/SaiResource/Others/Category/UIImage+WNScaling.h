//
//  UIImage+WNScaling.h
//  WuNuo
//
//  Created by silk on 2019/2/18.
//  Copyright © 2019 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (WNScaling)
- (nullable UIImage   *)getThumbImage;
// 缩放
- (UIImage *)scaledImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;
- (UIImage *)scaledHeadImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;
- (UIImage *)scaledImage:(CGFloat)scale;
- (UIImage *)scaledImageBasedIPhoneSizeWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;

// 拉伸
- (UIImage *)scaledImageStretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;

//发送图片压缩算法
- (NSData *)compressImage:(CGFloat)aQuality;

- (UIImage *)scaledImageV2WithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;

//截取图片的某一部分
- (UIImage *)clipImageInRect:(CGRect)rect;
@end

NS_ASSUME_NONNULL_END
