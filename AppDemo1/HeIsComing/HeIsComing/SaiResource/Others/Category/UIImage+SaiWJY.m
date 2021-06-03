//
//  UIImage+SaiWJY.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/12/10.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "UIImage+SaiWJY.h"

@implementation UIImage (SaiWJY)
/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}
/**
 *  根据颜色来生成图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIColor *)colorWithPicture:(CGPoint)point {
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage));
    const UInt8 *data = CFDataGetBytePtr(pixelData);
    
    NSUInteger width = self.size.width;
    int pixelInfo = ((width * point.y) + point.x) * 4;
    
    CGFloat red   = (CGFloat)data[pixelInfo] / 255.0f;
    CGFloat green = (CGFloat)data[pixelInfo + 1] / 255.0f;
    CGFloat blue  = (CGFloat)data[pixelInfo + 2] / 255.0f;
    CGFloat alpha = (CGFloat)data[pixelInfo + 3] / 255.0f;
    CFRelease(pixelData);
       
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (NSArray *)colorAtPixel:(CGPoint)point withImage:(UIImage *)image imageWidth:(CGFloat)imageWidth
{
    
    //    判断给定的点是否被一个CGRect包含
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return [NSArray array];
    }
    
    //    trunc（n1,n2），n1表示被截断的数字，n2表示要截断到那一位。n2可以是负数，表示截断小数点前。注意，TRUNC截断不是四舍五入。
    //    TRUNC(15.79)---15
    //    trunc(15.79,1)--15.7
    
    NSInteger pointX = trunc(point.x);
    
    NSInteger pointY = trunc(point.y);
    
    CGImageRef cgImage = image.CGImage;
    
    NSUInteger width = imageWidth;
    
    NSUInteger height = imageWidth;
    
    //    创建色彩标准
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    int bytesPerPixel = 4;
    
    int bytesPerRow = bytesPerPixel * 1;
    
    NSUInteger bitsPerComponent = 8;
    
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
//    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
//    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
//    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
//    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    int  red   = (CGFloat)pixelData[0] ;
    int green = (CGFloat)pixelData[1] ;
    int blue  = (CGFloat)pixelData[2] ;
//    CGFloat alpha = (CGFloat)pixelData[3] ;
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:red],[NSNumber numberWithFloat:green],[NSNumber numberWithFloat:blue], nil];
//    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
@end
