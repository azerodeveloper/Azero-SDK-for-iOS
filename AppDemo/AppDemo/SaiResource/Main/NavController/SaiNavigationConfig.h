//
//  SaiNavigationConfig.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/28.
//  Copyright © 2018 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SaiNavigationConfig : NSObject
singleton_h(SaiNavigationConfig);
@property(nonatomic, assign)CGFloat sai_defaultFixSpace;//item距离两端的间距,默认为0
@property(nonatomic, assign)CGFloat sai_fixedSpaceWidth;//iOS11之前调整间距,默认为-20,
@property(nonatomic, assign)BOOL sai_disableFixSpace;//是否禁止使用修正,默认为NO
@end

NS_ASSUME_NONNULL_END

