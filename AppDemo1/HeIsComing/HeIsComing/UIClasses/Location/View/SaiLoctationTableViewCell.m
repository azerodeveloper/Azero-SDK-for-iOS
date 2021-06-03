//
//  SaiLoctationTableViewCell.m
//  HeIsComing
//
//  Created by mike on 2020/9/17.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiLoctationTableViewCell.h"

@implementation SaiLoctationTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        [self createInterface];
    }
    return self;
}
-(void)createInterface{
    self.numberLabel=[UILabel CreatLabeltext:@"1" Font:[UIFont systemFontOfSize:kSCRATIO(18)] Textcolor:Color999999 textAlignment:0];
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(kSCRATIO(15));
            make.centerY.equalTo(self.contentView);
    }];
    self.namelLabel=[UILabel CreatLabeltext:@"北京市纵观村" Font:[UIFont systemFontOfSize:kSCRATIO(15)] Textcolor:Color333333 textAlignment:0];
    [self.contentView addSubview:self.namelLabel];
    [self.namelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(kSCRATIO(35));
            make.top.mas_offset(kSCRATIO(15));
    }];
    self.detailLabel=[UILabel CreatLabeltext:@"北京市纵观村北京市纵观村北京市纵观村" Font:[UIFont systemFontOfSize:kSCRATIO(12)] Textcolor:Color666666 textAlignment:0];
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(kSCRATIO(35));
            make.bottom.mas_offset(kSCRATIO(-15));
    }];
    UIButton *rightButton=[UIButton CreatButtontext:@"路线" image:[UIImage imageNamed:@"Navigation"] Font:[UIFont boldSystemFontOfSize:kSCRATIO(12)] Textcolor:kColorFromRGBHex(0x576B95)];
    [self.contentView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(kSCRATIO(-15));
            make.centerY.equalTo(self.contentView);
        make.width.mas_offset(kSCRATIO(30));
        make.height.mas_offset(kSCRATIO(40));

    }];
    [rightButton layoutIfNeeded];
    [rightButton layoutWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle_Top) imageTitleSpace:kSCRATIO(5)];
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
