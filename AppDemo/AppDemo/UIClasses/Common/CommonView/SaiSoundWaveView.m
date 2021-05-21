//
//  SaiSoundWaveView.m
//  HeIsComing
//
//  Created by mike on 2020/3/31.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiSoundWaveView.h"
#import "RecordSoundWaveAnimationView.h"
static SaiSoundWaveView *alertView;
@interface SaiSoundWaveView ()
{
    UIView *  contentUIView;
    UILabel *  contentLab;
    __block  RecordSoundWaveAnimationView *soundWaveAnimationView;
}

@end
@implementation SaiSoundWaveView

+(SaiSoundWaveView *)shareHud{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        alertView = [[self alloc] init];
        [alertView initView];
    });
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    [window bringSubviewToFront:alertView->contentUIView];
    return alertView;
}
-(void)initView{
    
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    contentUIView=[[UIView alloc]init];
    contentUIView.backgroundColor= [UIColor clearColor];
    [window addSubview:contentUIView];
    [contentUIView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(window);
            make.bottom.mas_offset(-BOTTOM_HEIGHT);

            make.height.mas_offset(kSCRATIO(50));
       
       
    }];
    //lable
    contentLab=[UILabel new];
    contentLab.textAlignment=NSTextAlignmentCenter;
    contentLab.textColor=RGBA(80, 91, 77, 0.5);
    contentLab.numberOfLines=2;
    contentLab.lineBreakMode=NSLineBreakByTruncatingMiddle;
    contentLab.font=[UIFont qk_PingFangSCRegularFontwithSize:kSCRATIO(20)];
    [contentLab sizeToFit];
    [contentUIView addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(contentUIView);
    }];

//    soundWaveAnimationView=[[RecordSoundWaveAnimationView alloc]initWithFrame:CGRectMake(0, 0, kSCRATIO(305), kSCRATIO(45))];
//    [contentUIView addSubview:soundWaveAnimationView];
//    [soundWaveAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_offset(kSCRATIO(305));
//        make.bottom.mas_offset(-20);
//        make.height.mas_offset(kSCRATIO(45));
//        make.centerX.equalTo(contentUIView);
//    }];
//    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.width.equalTo(soundWaveAnimationView);
//        make.bottom.equalTo(soundWaveAnimationView.mas_top).offset(-25);
////        make.top.mas_offset(0);
//    }];
//    blockWeakSelf;
//    __weak RecordSoundWaveAnimationView *weakmanager = soundWaveAnimationView;
//    soundWaveAnimationView.itemLevelCallback = ^{
//        weakmanager.level = weakSelf.level;
//    };
    contentLab.text=@"";
//    soundWaveAnimationView.hidden=YES;
//    [soundWaveAnimationView stop];
    
}

+(void)showMessage:(NSString *)messgae
{
    [[self shareHud] showMessage:messgae ];
}
-(void)showMessage:(NSString *)messgae
{
    if (messgae.length == 0) {
        contentLab.hidden=YES;
        if (soundWaveAnimationView.hidden == YES) {
            [self setupSuperViewHide];
        }
    }else{
        contentLab.hidden=NO;
        [self setupSuperViewShow];
    }
    contentLab.text=messgae;
}
+(void)showHudAni
{
    [[self shareHud] showHudAni];
    [[self shareHud] setupSuperViewShow];
}
-(void)showHudAni
{
    [soundWaveAnimationView start];
    soundWaveAnimationView.hidden = NO;
}
+(void)dismissHudAni
{
    [[self shareHud] dismissHudAni];
    NSString *message = [self shareHud]->contentLab.text;
    if (message.length == 0) {
        [[self shareHud] setupSuperViewHide];
    }
}
-(void)dismissHudAni
{
    [soundWaveAnimationView stop];
    soundWaveAnimationView.hidden = YES;
}


+(void)showBlue
{
    [[self shareHud] showBlue];
}
- (void)showBlue
{
    contentLab.textColor=RGBA(80, 91, 77, 0.5) ;
}

+(void)showWhite
{
    [[self shareHud] showWhite];
}
- (void)showWhite
{
    contentLab.textColor=RGBA(80, 91, 77, 0.5) ;
}

-(void)setLevel:(float)level
{
    _level=level;
}

- (void)setupSuperViewShow
{
    contentUIView.hidden = NO;
}
- (void)setupSuperViewHide
{
    contentUIView.hidden = YES;
}

+(void)hideAllView
{
    [[self shareHud] setupSuperViewHide];
}


@end
