//
//  SaiLocationViewController.h
//  HeIsComing
//
//  Created by mike on 2020/7/29.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiBaseRootController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SaiLocationViewController : SaiBaseRootController
@property(nonatomic,strong)NSDictionary  *diction;
@property(nonatomic,strong)NSMutableArray *locArray;
- (void)selectNaviRouteWithID:(NSInteger)routeID;
@end

NS_ASSUME_NONNULL_END
