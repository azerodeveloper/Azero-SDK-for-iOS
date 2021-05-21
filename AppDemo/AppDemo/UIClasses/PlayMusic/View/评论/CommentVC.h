//
//  CommentVC.h
//  dope
//
//  Created by apple on 2018/11/29.
//  Copyright © 2018 apple. All rights reserved.
//

#import "SaiBaseRootController.h"
//#import "WFMessageBody.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^CommentVCbackBlock)(void);

@interface CommentVC : SaiBaseRootController
//@property (nonatomic, strong)WFMessageBody *model;
@property (nonatomic, strong)CommentVCbackBlock back;
@property (nonatomic)NSUInteger row;
@property (nonatomic, assign)BOOL isHiddenNacBar;

@end

NS_ASSUME_NONNULL_END
