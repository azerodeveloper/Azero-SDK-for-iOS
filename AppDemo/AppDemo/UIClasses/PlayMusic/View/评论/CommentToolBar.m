//
//  CommentToolBar.m
//  VKOOY_iOS
//
//  Created by Mike on 18/8/14.
//  E-mail:vkooys@163.com
//  Copyright © 2015年 VKOOY. All rights reserved.
//

#import "CommentToolBar.h"

@interface CommentToolBar()<UITextViewDelegate,UIScrollViewDelegate>
{
    BOOL statusTextView;//当文字大于限定高度之后的状态
    NSString *placeholderText;//设置占位符的文字
    CGFloat textViewHeight;

}
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, assign) CGRect selfFrame;

@end


@implementation CommentToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        self.selfFrame = frame;
        
    }
    return self;
}

- (void)createUI{
    
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kSCRATIO(15));
        make.left.mas_equalTo(kSCRATIO(15));
        make.right.mas_offset(kSCRATIO(-55));
        make.height.mas_offset(kSCRATIO(41));
    }];
    [self.textView becomeFirstResponder];
    ViewRadius(self.textView, kSCRATIO(5));
    [self.textView addSubview:self.placeholderLabel];

    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.textView);
        make.centerY.equalTo(self.textView);
        make.left.mas_offset(kSCRATIO(10));
        make.width.mas_offset(kSCRATIO(100));

    }];
    [self addSubview:self.sendButton];

    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kSCRATIO(25));

        make.right.mas_offset(kSCRATIO(-10));
        make.width.mas_offset(kSCRATIO(32));
        make.height.mas_offset(kSCRATIO(21));

    }];
    
}

//暴露的方法
- (void)setPlaceholderText:(NSString *)text{
    placeholderText = text;
    self.placeholderLabel.text = placeholderText;
}


#pragma mark --- UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self sendClick];
        return NO;
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];

}

- (void)textViewDidChange:(UITextView *)textView{
    /**
     *  设置占位符
     */
    if (textView.text.length == 0) {
        self.placeholderLabel.text = placeholderText;
        self.sendButton.enabled = NO;
    }else{
        self.placeholderLabel.text = @"";
        self.sendButton.enabled = YES;
    }
    if (textView.text.length>30) {
  
        [MessageAlertView showHudMessage:@"评论不能超过30个字"];
        textView.text=[textView.text substringToIndex:30];
        
    }
    
    CGSize size1=[textView sizeThatFits:CGSizeMake(textView.width, CGFLOAT_MAX)];
    if (textViewHeight!=size1.height) {

        textViewHeight=size1.height;
        [UIView animateWithDuration:0.3 animations:^{
            [textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(size1.height);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(size1.height+kSCRATIO(30));
            }];
        

        }];
        
    }
    //---- 计算高度 ---- //
//    CGSize size = CGSizeMake(self.textView.width, CGFLOAT_MAX);
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:textView.font,NSFontAttributeName, nil];
//
//    CGFloat curheight = [textView.text boundingRectWithSize:size
//                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                 attributes:dic
//                                                    context:nil].size.height;
//    CGFloat y = CGRectGetMaxY(self.frame);
//    if (curheight < 19.094) {
//        statusTextView = NO;
//        self.frame = CGRectMake(0, y - self.height, kScreenWidth, self.height);
//    }else if(curheight < kSCRATIO(150)){
//        statusTextView = NO;
//        self.frame = CGRectMake(0, y - textView.contentSize.height-10, kScreenWidth,textView.contentSize.height+10);
//    }else{
//        statusTextView = YES;
//        return;
//    }
//    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_offset(kSCRATIO(-15));
//        make.top.mas_offset(kSCRATIO(15));
//        make.left.mas_equalTo(kSCRATIO(15));
//        make.right.mas_offset(kSCRATIO(-55));
//    }];
////    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.mas_offset(kSCRATIO(15));
////        make.left.mas_equalTo(kSCRATIO(15));
////        make.right.mas_offset(kSCRATIO(-55));
////        make.height.mas_offset(kSCRATIO(41));
////    }];
//    [self.textView  layoutIfNeeded];
    
}

#pragma  mark -- 发送事件
- (void)sendClick{
    [self.textView endEditing:YES];
    if (self.EwenTextViewBlock) {
        self.EwenTextViewBlock(self.textView.text);
    }
    //---- 发送成功之后清空 ------//
    self.textView.text = nil;
    self.placeholderLabel.text = placeholderText;
    self.sendButton.enabled = NO;
    [self.textView resignFirstResponder];
#pragma mark-- 注释了
    CGFloat y = self.selfFrame.origin.y;
    self.frame = CGRectMake(0, y, kScreenWidth, kSCRATIO(72)+BOTTOM_HEIGHT);
}

-(void)resetTextView
{
    if (self.textView.text.length > 0) {//输入了
        self.placeholderLabel.text = @"";
        self.textView.text = nil;
    }
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = [UIFont systemFontOfSize:kSCRATIO(15)];
        _textView.delegate = self;
        _textView.backgroundColor = Color222B36;
        _textView.textColor = kColorFromRGBHex(0x182015);
//        _textView.layer.cornerRadius = kSCRATIO(20);
        _textView.inputAccessoryView = [[UIView alloc] init];
        _textView.returnKeyType=UIReturnKeySend;
//        _textView.textContainerInset = UIEdgeInsetsMake(kSCRATIO(10),kSCRATIO(10), kSCRATIO(10), kSCRATIO(10));
        [self addSubview:_textView];
    }
    return _textView;
}

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.font = [UIFont systemFontOfSize:kSCRATIO(15)];
        _placeholderLabel.textColor = kColorFromRGBHex(0x1E3317);
    }
    return _placeholderLabel;
}

- (UIButton *)sendButton{
    if (!_sendButton) {
        
        _sendButton = [[UIButton alloc]init];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:kColorFromRGBHex(0xA6AAAE)  forState:UIControlStateDisabled];
        [_sendButton setTitleColor:UIColor.whiteColor  forState:UIControlStateNormal];

        [_sendButton addTarget:self action:@selector(sendClick)
              forControlEvents:UIControlEventTouchUpInside];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:kSCRATIO(15)];
        _sendButton.enabled = NO;
        _sendButton.backgroundColor=UIColor.clearColor;
    }
    return _sendButton;
}

@end
