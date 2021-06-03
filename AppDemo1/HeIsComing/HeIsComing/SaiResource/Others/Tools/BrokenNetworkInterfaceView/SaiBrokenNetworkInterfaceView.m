//
//  SaiBrokenNetworkInterfaceView.m
//  HeIsComing
//
//  Created by mike on 2020/5/11.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiBrokenNetworkInterfaceView.h"
static SaiBrokenNetworkInterfaceView *alertView;

@implementation SaiBrokenNetworkInterfaceView
{
    UIWindow *window;
    UIView *contentUIView;
    UILabel * contentLab;

}
+(SaiBrokenNetworkInterfaceView *)shareHud{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        alertView = [[self alloc] init];
    });
    
    return alertView;
}
-(instancetype)init{
    self=[super init];
    if (self) {
        [self initView];
        
    }
    return self;
}
-(void)initView{
    window=[[UIApplication sharedApplication].delegate window];
       contentUIView=[[UIView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, ScreenWidth, kSCRATIO(45))];
    contentUIView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
       [window addSubview:contentUIView];
    UIImageView *warnImageView=[UIImageView new];
    [contentUIView addSubview:warnImageView];
    [warnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerY.equalTo(contentUIView);
        make.left.mas_offset(kSCRATIO(9));
        make.width.height.mas_offset(kSCRATIO(38));
      }];
   contentLab=[UILabel CreatLabeltext:@"网络连接不可用，请检查您的网络设置 >" Font:[UIFont systemFontOfSize:kSCRATIO(16)] Textcolor:kColorFromRGBHex(0xFB4242) textAlignment:0];
    
     [contentUIView addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentUIView);
        make.left.equalTo(warnImageView.mas_right).mas_offset(kSCRATIO(9));

    }];
    [self hideHudAni];
}
#pragma mark - 修改显示和隐藏动画
+(void)dismiss{
    [[self shareHud] hideHudAni];
}

+(void)show:(NSString *)hudAni{
    [[self shareHud] showHudAni:hudAni];

}
-(void)hideHudAni{
    contentUIView.hidden=YES;
}

-(void)showHudAni:(NSString *)messgae{
    contentUIView.hidden=NO;

 contentLab.text=messgae;

    contentUIView.transform = CGAffineTransformMakeScale(0.3, 0.3);

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:7 initialSpringVelocity:4 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self->contentUIView.transform  = CGAffineTransformMake(1, 0, 0, 1, 0, 0);;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
