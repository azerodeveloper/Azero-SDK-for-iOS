//
//  SaiRightViewController.h
//  HeIsComing
//
//  Created by mike on 2020/11/2.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiBaseRootController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SaiRightViewController : SaiBaseRootController
@property(copy,nonatomic)void (^backBlock)(NSString *renderTemplateStr);
@end

NS_ASSUME_NONNULL_END
