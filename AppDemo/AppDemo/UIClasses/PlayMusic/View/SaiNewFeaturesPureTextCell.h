//
//  SaiNewFeaturesPureTextCell.h
//  HeIsComing
//
//  Created by silk on 2020/11/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaiNewFeaturesCellFrameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SaiNewFeaturesPureTextCell : UITableViewCell
///气泡
@property (nonatomic, strong) UIImageView *bubbleImageView;

@property (nonatomic, strong) SaiNewFeaturesCellFrameModel *frameModel;


@end

NS_ASSUME_NONNULL_END
