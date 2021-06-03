//
//  SaiMusicListCell.h
//  HeIsComing
//
//  Created by silk on 2020/2/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaiMusicListCellFrameModel.h"
//#import "SaiMusicListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SaiMusicListCell : UITableViewCell
//@property (nonatomic ,strong) SaiMusicListModel *model;
@property (nonatomic ,assign) NSInteger num;
@property (nonatomic ,strong) SaiMusicListCellFrameModel *frameModel;

@end

NS_ASSUME_NONNULL_END
