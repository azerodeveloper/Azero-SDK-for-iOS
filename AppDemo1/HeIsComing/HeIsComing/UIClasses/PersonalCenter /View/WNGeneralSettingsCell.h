//
//  WNGeneralSettingsCell.h
//  WuNuo
//
//  Created by silk on 2019/5/21.
//  Copyright © 2019 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNChooseTimeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WNGeneralSettingsCell : UITableViewCell
@property (nonatomic ,strong) WNChooseTimeModel *model;
@property (weak, nonatomic) IBOutlet UIView *pointView;

@end

NS_ASSUME_NONNULL_END
