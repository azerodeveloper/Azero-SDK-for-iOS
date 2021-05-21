//
//  SaiNewsTableViewCell.h
//  HeIsComing
//
//  Created by mike on 2020/11/3.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiNewsTableViewCell : UITableViewCell
@property(nonatomic,assign)NSInteger  cellInteger ;
@property(nonatomic,strong)UILabel *integerLabel ;
@property(nonatomic,strong)UILabel *cellTitleLabel ;
@property(nonatomic,strong)UILabel *cellDescLabel ;
@property(nonatomic,strong)UIImageView *newsImageView ;

@end

NS_ASSUME_NONNULL_END
