//
//  SaiAlertView.h
//  HeIsComing
//
//  Created by mike on 2020/3/25.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaiHomePageBallModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SaiAlertView : UIView
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel   *alertTitleLabel;
@property(nonatomic,strong)UILabel   *alertDescribeLabel;
@property(nonatomic,strong)UITextView   *alertTextView;

@property (nonatomic,strong)NSMutableArray *listArr;
- (instancetype)initWithFrame:(CGRect)frame WithDHomeModel:(SaiHomePageBallModelItems *)dHomeModel ;

@end

NS_ASSUME_NONNULL_END
