//
//  CommentsPopView.h
//  HeIsComing
//
//  Created by mike on 2020/11/9.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentToolBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentsPopView : UIView
@property (nonatomic, strong) UIView           *container;
@property (nonatomic,strong)CommentToolBar *commentView; //评论框
@property(nonatomic,strong)void (^textClick)(NSString *text) ;

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
