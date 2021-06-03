//
//  SaiMotionView.h
//  HeIsComing
//
//  Created by mike on 2020/3/26.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiMotionView : UIView
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)NSString *titleString;
@property(nonatomic,strong)NSString *numberString;
@property(nonatomic,strong)NSString *iconString;

@end

NS_ASSUME_NONNULL_END
