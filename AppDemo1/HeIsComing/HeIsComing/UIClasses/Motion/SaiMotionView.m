//
//  SaiMotionView.m
//  HeIsComing
//
//  Created by mike on 2020/3/26.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiMotionView.h"

@implementation SaiMotionView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor ;
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.height.mas_offset(kSCRATIO(48.5));
            make.top.mas_offset(0);
        }];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.mas_offset(kSCRATIO(16));
            make.top.equalTo(self.iconImageView.mas_bottom).offset(kSCRATIO(20));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.mas_offset(kSCRATIO(14));
            make.top.equalTo(self.numberLabel.mas_bottom).offset(kSCRATIO(12));
        }];
        
        
    }
    return self;
}
-(void)setIconString:(NSString *)iconString{
    self.iconImageView.image=[UIImage imageNamed:iconString];
}
- (void)setTitleString:(NSString *)titleString{
    self.titleLabel.text=titleString;
}
- (void)setNumberString:(NSString *)numberString{
    self.numberLabel.text=numberString;
    
}

#pragma mark -  Setters and Getters

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[UIImageView new];
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel CreatLabeltext:@"" Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(15)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
        
    }
    return _titleLabel;
}
-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel=[UILabel CreatLabeltext:@"" Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(21)] Textcolor:Color999999 textAlignment:NSTextAlignmentCenter];
        [self addSubview:_numberLabel];
        
    }
    return _numberLabel;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
