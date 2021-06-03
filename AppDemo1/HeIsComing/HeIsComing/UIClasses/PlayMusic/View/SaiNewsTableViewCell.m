//
//  SaiNewsTableViewCell.m
//  HeIsComing
//
//  Created by mike on 2020/4/3.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiNewsTableViewCell.h"
#import "SDWebImage.h"
@interface SaiNewsTableViewCell()
@property (nonatomic ,strong) UILabel *numLabel;
@property(nonatomic,strong)UILabel  *titleLabel;
@property(nonatomic,strong)UILabel  *detailLabel;
@end
@implementation SaiNewsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupSubview];
    }
    
    return self;
}
- (void)_setupSubview
{
    //    @property(nonatomic,strong)UILabel  *titleLabel;
    //    @property(nonatomic,strong)UILabel  *detailLabel;
    //
    //    @property(nonatomic,strong)UIImageView  *iconImageView;
    UIView *whiteView=[UIView new];
    [self.contentView addSubview:whiteView];
    ViewRadius(whiteView, kSCRATIO(6));
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(kSCRATIO(345));
        make.center.height.equalTo(self.contentView);
    }];
    
    UIImageView *greenImageView = [[UIImageView alloc] init];
    greenImageView.image = [UIImage imageNamed:@"xw_bg_number_green"];
    [whiteView addSubview:greenImageView];
    [greenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(67/2);
        make.height.mas_offset(20);
        make.left.mas_offset(0);
        make.top.mas_offset(0);
    }];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.font = [UIFont qk_PingFangSCRegularFontwithSize:12.0];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.text = @"1";
    [greenImageView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(35);
        make.height.mas_offset(20);
        make.left.mas_offset(0);
        make.top.mas_offset(0);
    }];
    _numLabel = numLabel;
    
    _titleLabel=[UILabel CreatLabeltext:@"习近平主席致辞第六届世界互联网大会" Font:[UIFont qk_PingFangSCRegularBoldFontwithSize:kSCRATIO(13)] Textcolor:Color333333 textAlignment:0];
    _titleLabel.numberOfLines=0;
    [whiteView addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        //        make.right.mas_offset(-15);
        make.top.mas_offset((24));
        make.width.mas_offset(kSCRATIO(170));
        
    }];
    _detailLabel=[UILabel CreatLabeltext:@"小时" Font:[UIFont systemFontOfSize:kSCRATIO(11)] Textcolor:Color999999 textAlignment:0];
    [whiteView addSubview:self.detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(15));
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset(kSCRATIO(12));
        make.width.mas_offset(kSCRATIO(170));
    }];
    _iconImageView=[UIImageView new];
    _iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds=YES;
    [whiteView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(kSCRATIO(-15));
        make.width.mas_offset(kSCRATIO(125));
        make.height.mas_offset(kSCRATIO(70));
        make.centerY.equalTo(whiteView);
    }];
    
    //    self.contentView.layer.masksToBounds = YES;
    //    self.contentView.layer.cornerRadius = 6.0;
}
-(void)setSaiNewsModel:(SaiMusicListModel *)saiNewsModel{
    self.titleLabel.text=saiNewsModel.title;
    [self.iconImageView setImageURL:[NSURL URLWithString:saiNewsModel.pic_url]];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setNum:(NSInteger)num{
    _num = num;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",num];
}


- (void)setFrameModel:(SaiMusicListCellFrameModel *)frameModel{
    _frameModel = frameModel;
    SaiMusicListModel *model = frameModel.listModel;
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.provider[@"name"];
    [self.iconImageView  sd_setImageWithURL:[NSURL URLWithString:model.pic_url]];
}
@end
