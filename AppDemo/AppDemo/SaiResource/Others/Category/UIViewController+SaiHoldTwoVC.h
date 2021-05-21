//
//  UIViewController+SaiHoldTwoVC.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/12/6.
//  Copyright © 2018 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SaiHoldTwoVC)

/**
 * 控制是否移除当前控制器和根控制器之间的其余控制器
 * 此属性设置在 -sai_holdRootVCAndCurrentVCInNavgationVCs中
 * 默认是NO, 不移除中间的VC,
 */
@property (nonatomic, assign) BOOL SaiPopMiddleVC;

/**
 *  在创建新的控制器时,控制navigationController中维护的VC只有root和当前VC
 */
- (void)sai_holdRootVCAndCurrentVCInNavgationVCs;


@end

NS_ASSUME_NONNULL_END
