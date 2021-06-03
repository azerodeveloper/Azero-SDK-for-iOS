//
//  SaiChooseView.h
//  HeIsComing
//
//  Created by mike on 2020/3/25.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiChooseView : UIView
@property (nonatomic,copy)void(^tableViewSelectBlock)(NSInteger  integer);

-(instancetype)initWithFrame:(CGRect)frame withTitleArray:(nullable NSArray *)array;
@end

NS_ASSUME_NONNULL_END
