//
//  SaiJXHomePageViewController.h
//  HeIsComing
//
//  Created by mike on 2020/7/7.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiBaseRootController.h"

NS_ASSUME_NONNULL_BEGIN

#define KSaiJXHomePageViewController [SaiJXHomePageViewController sharedInstance]
 
@interface SaiJXHomePageViewController : SaiBaseRootController

+ (instancetype)sharedInstance;

-(void)switchIndex:(NSInteger )index;
@end

NS_ASSUME_NONNULL_END
