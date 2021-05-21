//
//  SaiBaseRootController.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/27.
//  Copyright © 2018 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaiTableView.h"
//@class SaiTableView;
@class SaiSearchEmptyView;
NS_ASSUME_NONNULL_BEGIN
@interface SaiBaseRootController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *upSwipe;
@property (nonatomic, strong) NSMutableArray *datasourceArray;
@property (nonatomic, assign) BOOL isGroupTableView;
@property (nonatomic, strong) SaiSearchEmptyView * emptyView;
@property (nonatomic ,strong) SaiTableView *tableView;
-(void)setNavigation;
- (void)backAction;
- (void)jumpVC:(BOOL)isJump renderTemplateStr:(NSString *)renderTemplateStr;
@property (copy, nonatomic) void(^GetDataBlock)(NSString *type, NSString *content);
@property (copy, nonatomic) void(^responseRenderTemplateStr)(NSString *renderTemplateStr);
@property (copy, nonatomic) void(^walkDataBlock)(NSString *type, NSString *content);

@end

NS_ASSUME_NONNULL_END
