//
//  SaiMusicListCellFrameModel.h
//  HeIsComing
//
//  Created by silk on 2020/4/18.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaiMusicListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SaiMusicListCellFrameModel : NSObject
@property (nonatomic ,strong) SaiMusicListModel *listModel;
@property (nonatomic ,assign) CGFloat cellHeight;
+ (instancetype)createFrameModelWithListModel:(SaiMusicListModel *)listModel;
@end

NS_ASSUME_NONNULL_END
