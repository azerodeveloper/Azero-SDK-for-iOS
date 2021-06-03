//
//  SaiAlertView.m
//  HeIsComing
//
//  Created by mike on 2020/3/25.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiAlertView.h"

@implementation SaiAlertView

- (instancetype)initWithFrame:(CGRect)frame WithDHomeModel:(SaiHomePageBallModelItems *)dHomeModel{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self setLayout];
        [self.iconImageView setImageURL:[NSURL URLWithString:dHomeModel.ic_url]];
        self.alertTitleLabel.text=dHomeModel.skill;
        self.alertDescribeLabel.text=dHomeModel.skill;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

              [paragraphStyle setAlignment:NSTextAlignmentCenter];
           NSDictionary *attribs = @{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size:15],NSParagraphStyleAttributeName:paragraphStyle};
           NSMutableAttributedString*text= [[NSMutableAttributedString alloc] initWithString:[[[[dHomeModel.query modelToJSONString] stringByReplacingOccurrencesOfString:@"," withString:@"\n"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] attributes:attribs];
           [text setColor:Color999999 range:NSMakeRange(0, text.length)];
           text.lineSpacing = kSCRATIO(6);
        self.alertTextView.attributedText=text;
        ViewRadius(self, kSCRATIO(20));
        
        self.backgroundColor=UIColor.blackColor;
    }
    return self;
}
-(void)setLayout{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_offset(kSCRATIO(30));
        make.width.height.mas_offset(kSCRATIO(49));
    }];
    [self.alertTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.equalTo(self);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(kSCRATIO(14));

           make.height.mas_offset(kSCRATIO(16));
       }];
//    [self.alertDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//           make.centerX.equalTo(self);
//        make.top.equalTo(self.alertTitleLabel.mas_bottom).offset(30);
//
//           make.height.mas_offset(16);
//       }];
    [self.alertTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self);
        make.top.equalTo(self.alertTitleLabel.mas_bottom).offset(kSCRATIO(20));
        make.bottom.mas_offset(-kSCRATIO(35));
        
    }];

}

#pragma mark -  Setters and Getters
-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr=[NSMutableArray array];
    }
    return _listArr;
}
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[UIImageView new];
        ViewRadius(_iconImageView, 24.5);
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}
-(UILabel *)alertTitleLabel{
    if (!_alertTitleLabel) {
        _alertTitleLabel=[UILabel CreatLabeltext:@"" Font:[UIFont boldSystemFontOfSize:kSCRATIO(16)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
        [self addSubview:_alertTitleLabel];
    }
    return _alertTitleLabel;
}
-(UILabel *)alertDescribeLabel{
    if (!_alertDescribeLabel) {
        _alertDescribeLabel=[UILabel CreatLabeltext:@"" Font:[UIFont boldSystemFontOfSize:kSCRATIO(16)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
        [self addSubview:_alertDescribeLabel];
    }
    return _alertDescribeLabel;
}
-(UITextView *)alertTextView{
    if (!_alertTextView) {
        _alertTextView = [UITextView new];
        _alertTextView.editable=NO;
        _alertTextView.backgroundColor=UIColor.clearColor;
        _alertTextView.showsVerticalScrollIndicator=NO;
        [self addSubview:_alertTextView];
    }
    return _alertTextView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
