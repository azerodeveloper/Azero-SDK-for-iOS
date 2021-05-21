//
//  CommentToolBar.h
//  VKOOY_iOS
//
//  Created by Mike on 18/8/14.
//  E-mail:vkooys@163.com
//  Copyright © 2015年 VKOOY. All rights reserved.
//

#define MaxTextViewHeight kSCRATIO(82) //限制文字输入的高度
@interface CommentToolBar : UIView
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic) NSInteger row;

//------ 发送文本 -----//
@property (nonatomic,copy) void (^EwenTextViewBlock)(NSString *text);
//------  设置占位符 ------//
- (void)setPlaceholderText:(NSString *)text;

//重置
-(void)resetTextView;

@end
