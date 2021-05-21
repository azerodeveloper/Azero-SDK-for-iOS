//
//  UITableView+SaiScrollToIndexPath.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/12/5.
//  Copyright © 2018 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (SaiScrollToIndexPath)
/**
 *  TableView滚动到底部
 *
 *  @param animated 是否有动画
 */
-(void)ty_scrollToBottomAnimated:(BOOL)animated;

/**
 *  TableView滚动到指定的indexPath
 *
 *  @param indexPath 滚动到的目标行
 *  @param animated  是否有动画
 */
- (void)ty_scrollToIndexPath:(NSIndexPath*)indexPath Animated:(BOOL)animated;

/**
 *  TableView滚动到指定的indexPath
 *
 *  @param indexPath 滚动到的目标行
 *  @param postion   tablev滚动显示的位置
 *  @param animated  是否有动画
 */
- (void)ty_scrollToIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)postion Animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
