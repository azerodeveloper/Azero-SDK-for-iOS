//
//  UIImage+WNScaling.m
//  WuNuo
//
//  Created by silk on 2019/2/18.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "UIImage+WNScaling.h"

@implementation UIImage (WNScaling)
- (UIImage *)getThumbImage{
    CGSize size100 = self.size;
    double maxLen = (size100.height>size100.width?size100.height:size100.width);
    
    UIImage *imageSmall = nil;
    
    if (maxLen > 100)
    {
        double scale = 100.0/maxLen;
        imageSmall = [self scaledImageWithWidth:size100.width*scale andHeight:size100.height*scale];
    }
    return imageSmall;
}


- (UIImage *)scaledImageBasedIPhoneSizeWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    CGSize size = [self size];
    double scaleHeight = self.size.height > aHeight ? aHeight / self.size.height : 1;
    double scaleWidth = self.size.width> aWidth? aWidth/self.size.width:1;
    double scale=scaleHeight>scaleWidth?scaleHeight:scaleWidth;
    UIImage *image1 = self;
    if (scale < 1) {
        image1 = [self scaledImageWithWidth:size.width * scale andHeight:size.height * scale];
    }
    return image1;
}

- (UIImage *)scaledImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight{
    
    CGRect rect = CGRectIntegral(CGRectMake(0, 0, aWidth,aHeight));
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)scaledHeadImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    CGSize endSize = CGSizeMake(aWidth, aHeight);
    CGRect backRect = CGRectMake(0, 0, aWidth, aHeight);
    float imagex =0;
    float imagey =0;
    
    BOOL needBack = NO;
    if (self.size.width > self.size.height) {
        aWidth = aWidth > self.size.width ? self.size.width : aWidth;
        imagex =0;
        float ff = self.size.width /aWidth;
        aHeight = self.size.height/ff;
        imagey = (aWidth-aHeight)/2;
        needBack =YES;
        backRect = CGRectMake(0, 0, aWidth, aWidth);
        endSize = CGSizeMake(aWidth, aWidth);
    }
    else if(self.size.width < self.size.height)
    {
        aHeight = aHeight > self.size.height ? self.size.height : aHeight;
        imagey =0;
        float ff = self.size.height /aHeight;
        aWidth = self.size.width/ff;
        imagex = (aHeight-aWidth)/2;
        needBack =YES;
        backRect = CGRectMake(0, 0, aHeight, aHeight);
        endSize = CGSizeMake(aHeight, aHeight);
    }
    else
    {
        aWidth = aWidth > self.size.width ? self.size.width : aWidth;
        aHeight = aHeight > self.size.height ? self.size.height : aHeight;
    }
    CGRect rect = CGRectMake(imagex, imagey, aWidth,aHeight);
    UIGraphicsBeginImageContext(endSize);  //rect.size);
    
    if (needBack) {
        // get a reference to that context we created
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        UIColor *color = [UIColor blackColor];
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextAddRect(context, backRect);
        CGContextDrawPath(context,kCGPathFill);
    }
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)scaledImage:(CGFloat)scale
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scale, self.size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)scaledImageStretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight
{
    //    UIImage *scaledImage = [self scaledImage:0.5];
    //    return [scaledImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    return [self stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
}

//发送图片压缩算法
- (NSData *)compressImage:(CGFloat)aQuality
{
    NSData *ret = nil;
    //    if (aQuality>1 || aQuality < 0.3)
    //    {
    //        aQuality = 0.65;
    //    }
    CGSize sizeBig = self.size;
    
    //原始图片文件体积
    NSData *data = UIImageJPEGRepresentation(self, aQuality);
    
    //如果文件体积小于100k 直接发送
    if ([data length] < 1024 * 100)
    {
        ret = data;
    }
    else
    {
        
        double rateW = 800.0/sizeBig.width;
        double rateH = 800.0/sizeBig.height;
        double rate = rateW<rateH?rateW:rateH;
        
        UIImage *image = [self scaledImageWithWidth:sizeBig.width*rate andHeight:sizeBig.height*rate];
        NSData *data  = UIImageJPEGRepresentation(image,aQuality);
        NSInteger i = 1;
        while([data length] > 100 * 1024)
        {
            rate = rate * 0.8;
            image = [self scaledImageWithWidth:sizeBig.width * rate andHeight:sizeBig.height * rate];
            data = UIImageJPEGRepresentation(image,aQuality);
            i++;
        }
        ret = data;
    }
    return ret;
}

- (UIImage *)scaledImageV2WithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    CGRect rect = CGRectIntegral(CGRectMake(0, 0, aWidth,aHeight));
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)clipImageInRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}
@end
