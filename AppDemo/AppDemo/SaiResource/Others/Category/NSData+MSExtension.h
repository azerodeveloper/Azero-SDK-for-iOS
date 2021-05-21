//
//  NSData+MSExtension.h
//  SoundAi
//
//  Created by silk on 2019/9/27.
//  Copyright © 2019 soundai. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (MSExtension)

/**
 NSData转化成string
 
 @return 返回nil的解决方案
 */
-(NSString *)convertedToUtf8String;


@end

NS_ASSUME_NONNULL_END
