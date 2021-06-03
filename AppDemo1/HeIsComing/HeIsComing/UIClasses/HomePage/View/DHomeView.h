//
//  DHomeView.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/22.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JhtMarquee/JhtHorizontalMarquee.h>
#import "SaiHomePageBallModel.h"
NS_ASSUME_NONNULL_BEGIN




@interface DHomeView : UIView

/** 指示视图 */
@property (nonatomic,strong) UIImageView                *stateView;
/** 标题*/
@property (strong,nonatomic) JhtHorizontalMarquee  *titleLabel;
/** 完成度*/
@property (strong,nonatomic) UILabel                *completeProportionLabel;
/** 数据*/
@property (nonatomic,strong) SaiHomePageBallModelItems            *model;

-(void)setData:(SaiHomePageBallModelItems *)model;

@property (copy, nonatomic) void(^tapBlock)(DHomeView*homeView);

@end
NS_ASSUME_NONNULL_END
