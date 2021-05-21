//
//  LLGifImageView.m
//  LLGifView
//
//  Created by WangZhaomeng on 2017/6/14.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLGifImageView.h"
#import <ImageIO/ImageIO.h>

@interface LLGifImageView ()

@property (nonatomic, assign) BOOL playing;
@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, assign, getter=isSourceChange) BOOL sourceChange;
@property (nonatomic, assign) NSUInteger lastCount;

@end

@implementation LLGifImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configSelf];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSelf];
    }
    return self;
}

- (void)configSelf {
    _playing = NO;
    _loopCount = NSUIntegerMax;
    _imageIndex = 0;
    _speed = 1.0;
    _frameCacheInterval = NSUIntegerMax;
}

#pragma mark - 属性
- (void)setGifData:(NSData *)gifData {
    if (_gifData == gifData) {
        return;
    }
    _gifData = gifData;
    _sourceChange = YES;
    _imageIndex = 0;
    if (gifData) {
        self.image = [UIImage imageWithData:_gifData];
    }
}

#pragma mark - 操作
- (void)startGif {
    _lastCount = self.loopCount;
    [self playGifAnimation];
}

- (void)startGifLoopCount:(NSUInteger)loopCount {
    self.loopCount = loopCount;
    [self startGif];
}

- (void)pauseGif {
    _playing = NO;
}

- (void)stopGif {
    _playing = NO;
    _imageIndex = 0;
    self.image = [UIImage imageWithData:_gifData];
}

#pragma mark - gif播发代码
- (void)playGifAnimation {
    if (self.isPlaying) {
        return;
    }
    else {
        _playing = YES;
    }
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {

        CGImageSourceRef src = nil;
        size_t frameCount = 0;
        size_t frameCacheInterval = NSUIntegerMax;
        NSArray<NSNumber*> *frameDelayArray = nil;
        NSMutableDictionary<NSNumber*, UIImage*> *imageCache = nil;
        while (weakSelf.isPlaying && weakSelf.lastCount > 0) {
            NSDate *beginTime = [NSDate date];
            // gifData改变或者线程刚开始src为nil，并且要gifData有数据
            if ((weakSelf.isSourceChange || src == nil) && weakSelf.gifData != nil) {
                weakSelf.sourceChange = NO;
                if (src) {
                    CFRelease(src);
                }
                src = CGImageSourceCreateWithData((__bridge CFDataRef)weakSelf.gifData, NULL);
                if (src) {
                    frameCount = CGImageSourceGetCount(src);
                    frameDelayArray = [LLGifImageView durationArrayWithSource:src];
                    imageCache = [NSMutableDictionary dictionary];
                    if (weakSelf.frameCacheInterval != NSUIntegerMax) {
                        frameCacheInterval = weakSelf.frameCacheInterval + 1;
                    }
                }
                else {
                    break;
                }
            }
            
            NSTimeInterval frameDelay = 0.0;
            if (weakSelf.imageIndex < frameDelayArray.count) {
                frameDelay = frameDelayArray[weakSelf.imageIndex].floatValue * weakSelf.speed;
            }
            weakSelf.imageIndex ++;
            if (weakSelf.imageIndex == frameCount) {
                weakSelf.imageIndex = 0;
                if (weakSelf.lastCount != NSUIntegerMax) {
                    weakSelf.lastCount --;
                }
            }
            UIImage *image = imageCache[@(weakSelf.imageIndex)];
            if (image == nil && src) {
                image = [LLGifImageView imageWithSource:src andIndex:weakSelf.imageIndex];
                if (frameCacheInterval < frameCount
                    && weakSelf.imageIndex % frameCacheInterval == 0) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        imageCache[@(weakSelf.imageIndex)] = image;
                    });
                }
            }
            [NSThread sleepUntilDate:[beginTime dateByAddingTimeInterval:frameDelay]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (weakSelf.isPlaying && !weakSelf.isSourceChange) {
                    weakSelf.image = image;
                }
            });
        }
        if (src) {
            CFRelease(src);
        }
        weakSelf.playing = NO;
        }
    });
}

+ (UIImage *)imageWithSource:(CGImageSourceRef)src andIndex:(size_t)index {
    CGImageRef cgImg = CGImageSourceCreateImageAtIndex(src, index, NULL);
    UIImage *image = [UIImage imageWithCGImage:cgImg];
    CGImageRelease(cgImg);
    return image;
}

+ (NSTimeInterval)durationTimeWithSource:(CGImageSourceRef)src andIndex:(size_t)index {
    
    NSDictionary *properties    = (__bridge_transfer NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, index, NULL);
    NSDictionary *gifProperties = [properties valueForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
    NSString *gifDelayTime      = [gifProperties valueForKey:(__bridge NSString*)kCGImagePropertyGIFDelayTime];
    
    return [gifDelayTime floatValue];
}

+ (NSArray<NSNumber*> *)durationArrayWithSource:(CGImageSourceRef)src {
    NSMutableArray *array = [NSMutableArray array];
    size_t frameCount = CGImageSourceGetCount(src);
    for (size_t i = 0; i < frameCount; i++) {
        NSTimeInterval delay = [LLGifImageView durationTimeWithSource:src andIndex:i];
        [array addObject:@(delay)];
    }
    return array;
}

#pragma mark - 公开的类方法
+ (NSTimeInterval)durationTimeWithGifData:(NSData *)gifData andIndex:(size_t)index {
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    if (src) {
        NSTimeInterval delay = [LLGifImageView durationTimeWithSource:src andIndex:index];
        CFRelease(src);
        return delay;
    }
    else {
        return 0.0;
    }
}
//获取gif图片的总时长
+ (NSTimeInterval)durationForGifData:(NSData *)data{
    if (!data) {
        return 0;
    }
    //将GIF图片转换成对应的图片源
    CGImageSourceRef gifSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //获取其中图片源个数，即由多少帧图片组成
    size_t frameCout = CGImageSourceGetCount(gifSource);

    //定义数组存储拆分出来的图片
    NSMutableArray* frames = [[NSMutableArray alloc] init];
    NSTimeInterval totalDuration = 0;
    for (size_t i=0; i<frameCout; i++) {
        //从GIF图片中取出源图片
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);

            //将图片源转换成UIimageView能使用的图片源
            UIImage* imageName = [UIImage imageWithCGImage:imageRef];

            //将图片加入数组中
            [frames addObject:imageName];
            NSTimeInterval duration = [LLGifImageView durationTimeWithGifData:data andIndex:i];
            totalDuration += duration;
            CGImageRelease(imageRef);
        }
        
//        //获取循环次数
//        NSInteger loopCount;//循环次数
//        CFDictionaryRef properties = CGImageSourceCopyProperties(gifSource, NULL);
//        if (properties) {
//            CFDictionaryRef gif = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
//            if (gif) {
//                CFTypeRef loop = CFDictionaryGetValue(gif, kCGImagePropertyGIFLoopCount);
//                if (loop) {
//                    //如果loop == NULL，表示不循环播放，当loopCount  == 0时，表示无限循环；
//                    CFNumberGetValue(loop, kCFNumberNSIntegerType, &loopCount);
//                };
//            }
//        }
    CFRelease(gifSource);
    return totalDuration;
}

+ (NSArray<NSNumber*> *)durationArrayWithGifData:(NSData *)gifData {
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    if (src) {
        NSArray *array = [LLGifImageView durationArrayWithSource:src];
        CFRelease(src);
        return array;
    }
    else {
        return nil;
    }
}

+ (UIImage *)imageWithGifData:(NSData *)gifData andIndex:(size_t)index {
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    if (src) {
        UIImage *image = [LLGifImageView imageWithSource:src andIndex:index];
        CFRelease(src);
        return image;
    }
    else {
        return nil;
    }
}

+ (NSArray<UIImage*> *)imageArrayWithGifData:(NSData *)gifData {
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    if (src) {
        NSMutableArray *array = [NSMutableArray array];
        size_t frameCount = CGImageSourceGetCount(src);
        for (size_t i = 0; i < frameCount; i++) {
            UIImage *image = [LLGifImageView imageWithSource:src andIndex:i];
            [array addObject:image];
        }
        CFRelease(src);
        return array;
    }
    else {
        return nil;
    }
}

- (void)removeFromSuperview {
    [self stopGif];
    [super removeFromSuperview];
}

@end
