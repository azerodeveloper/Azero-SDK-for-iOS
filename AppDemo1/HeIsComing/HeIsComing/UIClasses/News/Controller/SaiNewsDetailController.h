//
//  SaiNewsDetailController.h
//  HeIsComing
//
//  Created by silk on 2020/4/7.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiBaseRootController.h"
#import "SaiMusicListModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^playListInfoBlock)(NSString *listInfo);

@interface SaiNewsDetailController : SaiBaseRootController

+ (instancetype)sharedInstance;

@property (nonatomic ,strong) SaiMusicListModel *newsModel;

@property (nonatomic ,copy) playListInfoBlock listInfoBlock;

@end

NS_ASSUME_NONNULL_END
