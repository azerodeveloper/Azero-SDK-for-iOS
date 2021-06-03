//
//  SaiNewsTableViewCell.h
//  HeIsComing
//
//  Created by mike on 2020/4/3.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaiMusicListModel.h"
#import "SaiMusicListCellFrameModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SaiNewsTableViewCell : UITableViewCell


@property(nonatomic,strong)UIImageView  *iconImageView;
@property(nonatomic,strong)SaiMusicListModel *saiNewsModel;

//@property (nonatomic ,strong) SaiMusicListModel *model;
@property (nonatomic ,assign) NSInteger num;


@property (nonatomic ,strong) SaiMusicListCellFrameModel *frameModel;



@end

NS_ASSUME_NONNULL_END
