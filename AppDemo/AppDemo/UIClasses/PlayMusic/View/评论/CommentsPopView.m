//
//  CommentsPopView.m
//  HeIsComing
//
//  Created by mike on 2020/11/9.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "CommentsPopView.h"

@implementation CommentsPopView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [[UIScreen mainScreen] bounds];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        self.backgroundColor=  [UIColor colorWithWhite:0 alpha:0.45];
//        UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
//        visualEffectView.frame = self.bounds;
//        visualEffectView.alpha = 0.1;
//        [self addSubview:visualEffectView];
        [self addSubview:self.commentView];
        [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.mas_offset(0);
            make.height.mas_offset(kSCRATIO(72)+BOTTOM_HEIGHT);
        }];
        blockWeakSelf;
        self.commentView.EwenTextViewBlock = ^(NSString *text){
            if (weakSelf.textClick) {
                weakSelf.textClick(text);
            }
            [weakSelf dismiss];
        };
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ketBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ketBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return  self;
    
}
#pragma mark - 监听键盘高度
- (void)ketBoardWillShow:(NSNotification *)noti{
    //获取键盘的高度
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    double height = keyboardRect.size.height;
    [UIView animateWithDuration:0.25 animations:^{

        [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-height);
            make.height.mas_offset(kSCRATIO(72));

        }];
        //        [self.commentView layoutIfNeeded];
    }];
    
}

- (void)ketBoardWillHidden:(NSNotification *)noti{
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(0);
            make.height.mas_offset(kSCRATIO(72)+BOTTOM_HEIGHT);

        }];
    }];
}
- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.frame;
                         frame.origin.y = 0;
        self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        [self removeFromSuperview];

                     }
                     completion:^(BOOL finished) {
//                         [self removeFromSuperview];
                     }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementati}on adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CommentToolBar *)commentView
{
    if (!_commentView) {
        _commentView = [[CommentToolBar alloc]init];
        _commentView.backgroundColor=Color313944;
        [_commentView setPlaceholderText:@"写评论"];
    }
    return _commentView;
}
@end
