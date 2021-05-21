//
//  SaiShareView.m
//  HeIsComing
//
//  Created by mike on 2020/3/31.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiShareView.h"

@implementation SaiShareView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=UIColor.whiteColor;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
               
           }]];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(kSCRATIO(10), kSCRATIO(10))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        UILabel *titleLabel=[UILabel CreatLabeltext:@"分享至" Font:[UIFont boldSystemFontOfSize:kSCRATIO(16)] Textcolor:Color333333 textAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_offset(kSCRATIO(23));
            make.height.mas_offset(kSCRATIO(15));
        }];
        UIButton *closeButton=[UIButton new];
        [closeButton setImage:[UIImage imageNamed:@"fx_icon_close"] forState:0];
        [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-kSCRATIO(12));
            make.top.mas_offset(kSCRATIO(12));
            make.width.height.mas_offset(kSCRATIO(12));
        }];
        NSArray *imageArray=@[@"fx_icon_weixin",@"fx_icon_friends",@"fx_icon_weibo"];
        NSArray *titleArray=@[@"微信好友",@"朋友圈",@"微博"];
        for (int i=0; i<imageArray.count; i++) {
            UIButton *button=[UIButton CreatButtontext:titleArray[i] image:[UIImage imageNamed:imageArray[i]] Font:[UIFont boldSystemFontOfSize:kSCRATIO(12)] Textcolor:Color666666];
            [self addSubview:button];
            button.tag=1000+i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(kSCRATIO(30)+kSCRATIO(105)*i);
                make.top.mas_offset(kSCRATIO(70));
                make.width.mas_offset(kSCRATIO(105));
                make.height.mas_offset(kSCRATIO(50));
                
            }];
            [button layoutIfNeeded];
            [button layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyle_Top imageTitleSpace:kSCRATIO(10)];
            
        }
    }
    return self;
}
-(void)buttonClick:(UIButton *)sender{
    if (self.buttonblock) {
        self.buttonblock(sender.tag-1000);
    }
}
-(void)closeButtonClick{
    if (self.closeblock) {
        self.closeblock();
    }
}
@end
