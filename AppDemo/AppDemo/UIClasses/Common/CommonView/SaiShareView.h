//
//  SaiShareView.h
//  HeIsComing
//
//  Created by mike on 2020/3/31.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiShareView : UIView
@property (copy, nonatomic) void(^closeblock)(void);
@property (copy, nonatomic) void(^buttonblock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
