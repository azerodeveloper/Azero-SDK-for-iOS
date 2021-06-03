//
//  SaiMusicListController.h
//  HeIsComing
//
//  Created by silk on 2020/2/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiBaseRootController.h"
#import "GKSliderView.h"
#import "GKWYMusicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SaiMusicListController : SaiBaseRootController


@property(nonatomic,assign)NSInteger  currentIndex;

+ (instancetype)sharedInstance;

- (void)dealPlistDataWith:(NSString *)text;

- (void)azeroSdkHandle;
@end

NS_ASSUME_NONNULL_END
