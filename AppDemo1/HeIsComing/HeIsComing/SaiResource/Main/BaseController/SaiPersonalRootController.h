//
//  SaiPersonalRootController.h
//  HeIsComing
//
//  Created by silk on 2020/7/25.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaiTableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SaiPersonalRootController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL isGroupTableView;
@property (nonatomic ,strong) SaiTableView *tableView;

-(void)setNavigation;
- (void)backAction;
@end

NS_ASSUME_NONNULL_END
