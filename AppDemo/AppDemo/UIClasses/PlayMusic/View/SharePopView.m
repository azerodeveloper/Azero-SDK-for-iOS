//
//  SharePopView.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "SharePopView.h"

@implementation SharePopView

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray *topIconsName = @[
            @"wechat_icon",
            @"wechatLine_iocn",
            @"QQ",
        ];
        NSArray *topTexts = @[
            @"微信好友",
            @"朋友圈",
            @"微博",
        ];
        
        
        self.frame = [[UIScreen mainScreen] bounds];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, kSCRATIO(194) + BOTTOM_HEIGHT)];
        _container.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_container];
        
        
        UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualEffectView.frame = self.bounds;
        visualEffectView.alpha = 1.0f;
        [_container addSubview:visualEffectView];
        
        UILabel *label = [UILabel CreatLabeltext:@"分享到" Font:[UIFont systemFontOfSize:kSCRATIO(16)] Textcolor:UIColor.whiteColor textAlignment:0];
        
        [_container addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(kSCRATIO(15));
            make.top.mas_offset(kSCRATIO(20));
            
        }];
        
        CGFloat itemWidth = kSCRATIO(84);
        
        
        for (NSInteger i = 0; i < topIconsName.count; i++) {
            ShareItem *item = [[ShareItem alloc] initWithFrame:CGRectMake(kSCRATIO(100) + itemWidth*i, kSCRATIO(54), kSCRATIO(50), kSCRATIO(70))];
            item.icon.image = [UIImage imageNamed:topIconsName[i]];
            item.label.text = topTexts[i];
            item.tag = i;
            [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShareItemTap:)]];
            [item startAnimation:i*0.03f];
            [_container addSubview:item];
        }
        
      
        
        
        _cancel = [UIButton CreatButtontext:@"取消" image:nil Font:[UIFont systemFontOfSize:kSCRATIO(16)] Textcolor:UIColor.whiteColor];
       
        [_container addSubview:_cancel];
        [_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_container);
            make.top.mas_offset(kSCRATIO(163));
            make.width.mas_offset(kSCRATIO(35));
            make.height.mas_offset(kSCRATIO(25));
            
        }];
        
        [_cancel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
    }
    return self;
}

- (void)onShareItemTap:(UITapGestureRecognizer *)sender {
    
    if (self.clickBlock) {
        self.clickBlock(sender.view.tag);
    }
    [self dismiss];
}
- (void)onActionItemTap:(UITapGestureRecognizer *)sender {
    switch (sender.view.tag) {
        case 0:
            break;
        default:
            break;
    }
    [self dismiss];
}

- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point]) {
        [self dismiss];
        return;
    }
    point = [sender locationInView:_cancel];
    if([_cancel.layer containsPoint:point]) {
        [self dismiss];
    }
}

- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        CGRect frame = self.container.frame;
        frame.origin.y = frame.origin.y - frame.size.height;
        self.container.frame = frame;
    }
                     completion:^(BOOL finished) {
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        CGRect frame = self.container.frame;
        frame.origin.y = frame.origin.y + frame.size.height;
        self.container.frame = frame;
    }
                     completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end



#pragma Item view

@implementation ShareItem
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"iconHomeAllshareCopylink"];
        _icon.contentMode = UIViewContentModeScaleToFill;
        _icon.userInteractionEnabled = YES;
        [self addSubview:_icon];
        
        _label = [UILabel CreatLabeltext:@"" Font:[UIFont systemFontOfSize:kSCRATIO(12)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
        _label.text = @"TEXT";
        
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}
-(void)startAnimation:(NSTimeInterval)delayTime {
    CGRect originalFrame = self.frame;
    self.frame = CGRectMake(CGRectGetMinX(originalFrame), 35, originalFrame.size.width, originalFrame.size.height);
    [UIView animateWithDuration:0.9f
                          delay:delayTime
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.frame = originalFrame;
    }
                     completion:^(BOOL finished) {
    }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kSCRATIO(50));
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.icon.mas_bottom).offset(10);
    }];
}

@end
