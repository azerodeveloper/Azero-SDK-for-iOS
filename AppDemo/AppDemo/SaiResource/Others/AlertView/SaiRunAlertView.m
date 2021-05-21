//
//  SaiRunAlertView.m
//  HeIsComing
//
//  Created by mike on 2020/8/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiRunAlertView.h"
#import "SaiMotionView.h"
#import "SaiShareView.h"
#import <UMShare/UMShare.h>

@implementation SaiRunAlertView
-(instancetype)initAlertView:(NSString *)mileage time:(NSString *)time calories:(NSString *)calories{
    if (self=[super init]) {
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pbjs_bj"]];
        UIImageView *runningImageView=[UIImageView new];
        runningImageView.image=[UIImage imageNamed:@"icon_AppStore"];
        runningImageView.contentMode=UIViewContentModeScaleAspectFit;
        ViewRadius(runningImageView, kSCRATIO(26));
        runningImageView.layer.borderWidth=1;
          runningImageView.layer.borderColor=[kColorFromRGBHex(0x3699E0) CGColor];
        
        [self addSubview:runningImageView];
        [runningImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(kSCRATIO(27));
            make.top.mas_offset(kSCRATIO(13)+kStatusBarHeight);
            make.width.height.mas_offset(kSCRATIO(52));
            
        }];
        UILabel *runnningLabel=[UILabel CreatLabeltext:@"TA来了" Font:[UIFont fontWithName:@"PingFang-SC-Bold" size:kSCRATIO(20)] Textcolor:Color999999 textAlignment:0];
        [self addSubview:runnningLabel];
        [runnningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(runningImageView.mas_right).offset(kSCRATIO(15));
            make.centerY.equalTo(runningImageView);
            make.height.mas_offset(kSCRATIO(12));
            
        }];
//        NSString * currentDistanceString  =  [[NSUserDefaults standardUserDefaults]objectForKey:[QKUITools getNowyyyymmdd]];
        UILabel * _distanceLabel=[UILabel CreatLabeltext:![QKUITools isBlankString:mileage]?mileage:@"0.00" Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(80)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
        [self addSubview:_distanceLabel];
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(kSCRATIO(120)+kStatusBarHeight);
            make.centerX.equalTo(self);
            make.height.mas_offset(kSCRATIO(107));
            
        }];
        UILabel *distanceTitleLabel=[UILabel CreatLabeltext:@"公里" Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(18)] Textcolor:Color999999 textAlignment:NSTextAlignmentCenter];
        [self addSubview:distanceTitleLabel];
        [distanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_distanceLabel.mas_bottom).offset(kSCRATIO(12));
            make.centerX.equalTo(self);
            make.height.mas_offset(kSCRATIO(14));
            
        }];
        self.webString=[NSString stringWithFormat:@"https://app-azero.soundai.com.cn/downloads/share_exercise.html﻿?km=%@&time=%@&kcal=%@",mileage,[QKUITools timeFormatted:SaiContext.currentTime],calories];
//        self.webString=[NSString stringWithFormat:@"http://192.168.199.179/heriscoming/share_exercise.html?km=%@&time=%@&kcal=%@",mileage,[QKUITools timeFormatted:SaiContext.currentTime],calories];
        NSArray *imageArray=@[@"pbjs_icon_time",@"zl_icon_kcal"];
        NSArray *numberArray=@[[QKUITools timeFormatted:SaiContext.currentTime],calories];
        
        NSArray *titleArray=@[@"用时",@"千卡"];
        
        for (int i=0; i<imageArray.count; i++) {
            SaiMotionView *speedView=[[SaiMotionView alloc]initWithFrame:CGRectMake(0, 0, KScreenW/2, kSCRATIO(120))];
            speedView.tag=i+1000;
            speedView.iconString=imageArray[i];
            speedView.numberString=numberArray[i];
            speedView.titleString=titleArray[i];
            [self addSubview:speedView];
            [speedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(KScreenW/2*i);
                make.width.mas_offset(KScreenW/2);
                make.top.equalTo(distanceTitleLabel.mas_bottom).offset(kSCRATIO(50));
                make.height.mas_offset(kSCRATIO(120));
                
            }];
            
        }
        UILabel *titleLabel=[UILabel CreatLabeltext:@"快来和TA一起运动" Font:[UIFont boldSystemFontOfSize:kSCRATIO(19)] Textcolor:kColorFromRGBHex(0xFBFBFB) textAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(distanceTitleLabel.mas_bottom).offset(kSCRATIO(230));
            make.centerX.equalTo(self);
            
        }];
        UIButton *stopButton=[UIButton CreatButtontext:@"" image:[UIImage imageNamed:@"pbjs_btn_end"] Font:[UIFont boldSystemFontOfSize:kSCRATIO(16)] Textcolor:kColorFromRGBHex(0x20232C)];
        [self addSubview:stopButton];
        [stopButton addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        [stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(kSCRATIO(35));
            make.right.equalTo(self.mas_centerX).offset(kSCRATIO(-20));
            make.width.mas_offset(kSCRATIO(121));
            make.height.mas_offset(kSCRATIO(57));
        }];
        UIButton *shareButton=[UIButton CreatButtontext:@"" image:[UIImage imageNamed:@"pbjs_btn_share"] Font:[UIFont boldSystemFontOfSize:kSCRATIO(16)] Textcolor:UIColor.whiteColor];
        [self addSubview:shareButton];
        [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];

        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(kSCRATIO(35));
            make.left.equalTo(self.mas_centerX).offset(kSCRATIO(20));
            make.width.mas_offset(kSCRATIO(121));
            make.height.mas_offset(kSCRATIO(57));
            
        }];
    }
    return self;
}
-(void)remove{
    if (self.backblock) {
        self.backblock();
    }
}
-(void)share{
//    UIView *bgV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    bgV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
//    [[UIApplication sharedApplication].keyWindow addSubview:bgV];
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//        [bgV removeFromSuperview];
//    }];
//    [bgV addGestureRecognizer:tap];
    SaiShareView *shareView = [[SaiShareView alloc] initWithFrame:CGRectMake(0, KScreenH, KScreenW, kSCRATIO(165)+BOTTOM_HEIGHT)];
    shareView.closeblock  = ^{
        if (self.backblock) {
               self.backblock();
           }
        
    };
    shareView.buttonblock = ^(NSInteger index) {
        UMSocialPlatformType type = UMSocialPlatformType_UnKnown;
        NSString *title=@"TA来了";
        NSString *descr=@"说跑就跑，一切为了套进S码的幸福。";

        switch (index) {
            case 0:
            {
                type = UMSocialPlatformType_WechatSession;
            }
                break;
            case 1:
            {
                type = UMSocialPlatformType_WechatTimeLine;
            }
                break;
            case 2:
            {
                title=@"说跑就跑，一切为了套进S码的幸福。";
                descr=@"";
                type = UMSocialPlatformType_Sina;
            }
                break;
            default:
                break;
        }
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:[UIImage imageNamed:@"icon_share"]];
        shareObject.webpageUrl = self.webString;
        messageObject.shareObject = shareObject;
        [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
//                [MessageAlertView showHudMessage:@"分享失败"];
            } else {
            }
        }];
if (self.backblock) {
              self.backblock();
          }
        
    };
    [self addSubview:shareView];
    [UIView animateWithDuration:0.15 animations:^{
        shareView.bottom = KScreenH;
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
