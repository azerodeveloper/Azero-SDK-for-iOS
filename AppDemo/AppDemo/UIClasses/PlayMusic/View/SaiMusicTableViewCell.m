//
//  SaiMusicTableViewCell.m
//  HeIsComing
//
//  Created by mike on 2020/11/3.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiMusicTableViewCell.h"

@implementation SaiMusicTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor=Color222B36;
        self.integerLabel=[UILabel CreatLabeltext:@"" Font:[UIFont systemFontOfSize:kSCRATIO(15)] Textcolor:kColorFromARGBHex(0x182015, 0.5) textAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.integerLabel];
        [self.integerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_offset(kSCRATIO(15));
            make.width.height.mas_offset(kSCRATIO(25));

        }];
        ViewRadius(self.integerLabel, kSCRATIO(12.5));
        self.integerLabel.backgroundColor=[UIColor colorWithWhite:1 alpha:0.2];
        self.cellTitleLabel=[UILabel CreatLabeltext:@"Something Just Like This" Font:[UIFont systemFontOfSize:kSCRATIO(16)] Textcolor:kColorFromRGBHex(0x182015) textAlignment:0];
        [self.contentView addSubview:self.cellTitleLabel];
        [self.cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.integerLabel.mas_right).offset(kSCRATIO(25));
            make.top.mas_offset(kSCRATIO(15));
            make.width.mas_lessThanOrEqualTo(kSCRATIO(200));
            make.height.mas_offset(kSCRATIO(22.5));

        }];
        self.cellDescLabel=[UILabel CreatLabeltext:@"" Font:[UIFont systemFontOfSize:kSCRATIO(13)] Textcolor:kColorFromRGBHex(0x182015) textAlignment:0];
        [self.contentView addSubview:self.cellDescLabel];
        [self.cellDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.integerLabel.mas_right).offset(kSCRATIO(25));
            make.top.equalTo(self.cellTitleLabel.mas_bottom).offset(kSCRATIO(5));

            make.width.mas_lessThanOrEqualTo(kSCRATIO(200));

        }];
        self.cellImageView=[UIImageView new];
        ViewRadius(self.cellImageView, kSCRATIO(35)/2);
        ViewContentMode(self.cellImageView);
        [self.contentView addSubview:self.cellImageView];
        [self.cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_offset(kSCRATIO(35));
            make.centerY.equalTo(self.contentView);
            make.right.mas_offset(kSCRATIO(-15));

        }];
        UILabel *lineLabel=[UILabel new];
        lineLabel.backgroundColor=kColorFromRGBHex(0x1E3317);
        [self.contentView addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0.5);
            make.left.equalTo(self.integerLabel.mas_right).offset(kSCRATIO(25));
            make.right.bottom.equalTo(self.contentView);

        }];
        
    }
    return  self;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
