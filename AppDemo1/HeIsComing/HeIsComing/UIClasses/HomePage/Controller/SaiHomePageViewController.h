//
//  SaiHomePageViewController.h
//  HeIsComing
//
//  Created by mike on 2020/3/25.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiBaseRootController.h"

NS_ASSUME_NONNULL_BEGIN  

@interface SaiHomePageViewController : SaiBaseRootController
+ (instancetype)sharedInstance ;


- (void)assignmentAzeroManagerBlockHandle;

-(void)initResponse:(NSString *)responseRenderTemplateStr;

@property(nonatomic,strong)UIView *bgV ;
@property(nonatomic,strong)UILabel *titleLabel ;
-(void)removeView;
@end

NS_ASSUME_NONNULL_END
