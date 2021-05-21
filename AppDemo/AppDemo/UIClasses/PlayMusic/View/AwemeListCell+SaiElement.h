//
//  AwemeListCell+SaiElement.h
//  HeIsComing
//
//  Created by mike on 2020/10/29.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AwemeListCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AwemeListCell (SaiElement)<UUMarqueeViewDelegate,GKWYMusicCoverViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
- (void)playMusicWithModel:(GKWYMusicModel *)model;
- (void)initSubViews ;

@end

NS_ASSUME_NONNULL_END
