//
//  UITextField+MSAdd.h
//  SoundAi
//
//  Created by silk on 2019/11/20.
//  Copyright © 2019 soundai. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (MSAdd)
@property(nonatomic,assign) NSRange selectedRange;


-(void)changePlaceholderColor;
@end

NS_ASSUME_NONNULL_END
