//
//  DHomeView.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/22.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DHomeView.h"

@implementation DHomeView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setLayout];
    }
    return self;
}

- (void)setLayout{
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kSCRATIO(16));
        make.centerY.equalTo(self);
    }];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kSCRATIO(12), kSCRATIO(12)));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
//    [self.completeProportionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(self);
//        make.height.mas_equalTo(20);
//    }];
    
    
    
}

-(UIImageView*)stateView{
    if (!_stateView) {
        _stateView=[UIImageView new];
        _stateView.layer.cornerRadius=kSCRATIO(4);
        _stateView.clipsToBounds = YES;
        [self addSubview:_stateView];
    }
    return _stateView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[JhtHorizontalMarquee alloc] initWithFrame:CGRectMake(0, 0, 60, 20) singleScrollDuration:0.0];
        [self addSubview:_titleLabel];
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if (self.tapBlock) {
                self.tapBlock(self);
            }
        }];
          [_titleLabel addGestureRecognizer:tapGes];
        [_titleLabel setFont:[UIFont systemFontOfSize:kSCRATIO(8)]];
        _titleLabel.textColor=[UIColor whiteColor];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UILabel *)completeProportionLabel{
    if (!_completeProportionLabel) {
        _completeProportionLabel=[[UILabel alloc] init];
//        [self addSubview:_completeProportionLabel];
        [_completeProportionLabel setFont:[UIFont systemFontOfSize:13]];
        _completeProportionLabel.textColor=UIColor.redColor;
        _completeProportionLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _completeProportionLabel;
}

-(void)setData:(SaiHomePageBallModelItems *)model{
    self.completeProportionLabel.hidden=YES;
    //    NSString *str=@"%";
    //    self.completeProportionLabel.text=[NSString stringWithFormat:@"%ld %@",model.completeProportion*10,str];
    
    self.model=model;
    NSArray *imageArray=@[@"duojiaoxing-8",@"duojiaoxing-9",@"duojiaoxing-10",@"duojiaoxing-11",@"duojiaoxing-12"];

    self.stateView.image=[UIImage imageNamed:imageArray[rand()%4]];
    
    
    self.titleLabel.text=model.intent;
    if (self.titleLabel.isPaused) {
        [self.titleLabel marqueeOfSettingWithState:MarqueeContinue_H];
    }else{
        [self.titleLabel marqueeOfSettingWithState:MarqueeStart_H];
    }
    
}

@end
