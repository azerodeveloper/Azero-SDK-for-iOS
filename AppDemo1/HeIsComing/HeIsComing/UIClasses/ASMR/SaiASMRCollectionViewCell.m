//
//  SaiASMRCollectionViewCell.m
//  HeIsComing
//
//  Created by mike on 2020/7/16.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiASMRCollectionViewCell.h"

@implementation SaiASMRCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColor.clearColor;
        self.imageView=[UIImageView new];
        [self.contentView addSubview:self.imageView];
        self.button=[UIButton CreatButtontext:@"" image:nil Font:[UIFont boldSystemFontOfSize:kSCRATIO(13)] Textcolor:UIColor.whiteColor];
        [self.button setBackgroundImage:[UIImage imageNamed:@"asmrNumberGreen"] forState:0];
        [self.contentView addSubview:self.button];
        self.titleLabel=[UILabel CreatLabeltext:@"混合ASMR" Font:[UIFont boldSystemFontOfSize:kSCRATIO(14)] Textcolor:UIColor.whiteColor textAlignment:0];
        [self.contentView   addSubview:self.titleLabel];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.mas_offset(kSCRATIO(10));
            
            make.width.height.mas_offset(kSCRATIO(51));
        }];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(kSCRATIO(10));
            make.top.equalTo(self.imageView.mas_bottom).mas_offset(kSCRATIO(15));
            
            make.width.height.mas_offset(kSCRATIO(18));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.button.mas_right).mas_offset(kSCRATIO(2));
            make.centerY.equalTo(self.button);
            
            make.right.mas_offset(kSCRATIO(0));
        }];
        
    }
    return self;
    
}
@end
