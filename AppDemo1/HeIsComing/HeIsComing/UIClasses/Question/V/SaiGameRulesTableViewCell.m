//
//  SaiGameRulesTableViewCell.m
//  HeIsComing
//
//  Created by mike on 2020/4/7.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiGameRulesTableViewCell.h"
@interface SaiGameRulesTableViewCell ()
@property(nonatomic,strong)UILabel  *titleLabel;
@property(nonatomic,strong)UILabel *tagLabel;

@end
@implementation SaiGameRulesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        [self createInterface];
    }
    return self;
}
#pragma mark - 视图布局
- (void)createInterface {
    UIView *tagView=[UIView new];
    ViewRadius(tagView, kSCRATIO(10));
    [self.contentView addSubview:tagView];
    tagView.backgroundColor=UIColor.greenColor;
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(kSCRATIO(20));
        make.left.top.mas_offset(0);
    }];
    [tagView layoutIfNeeded];
    tagView.layer.shadowColor = [UIColor colorWithRed:21/255.0 green:177/255.0 blue:136/255.0 alpha:0.5].CGColor;
    tagView.layer.shadowOffset = CGSizeMake(0,2);
    tagView.layer.shadowOpacity = 1;
    tagView.layer.shadowRadius = 4;
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = tagView.bounds;
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:14/255.0 green:173/255.0 blue:110/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:43/255.0 green:225/255.0 blue:223/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];

    [tagView.layer addSublayer:gl];
    [self.contentView addSubview:self.tagLabel];
        [self.contentView addSubview:self.titleLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(tagView);
       }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(tagView.mas_right).mas_offset(kSCRATIO(8));
          make.width.mas_offset(kSCRATIO(250));
        make.bottom.mas_offset(kSCRATIO(-10));

          make.top.mas_offset(0);
      }];

    //    [self.scrollV addSubview:self.middleLine];
    
}
-(void)getTitleString:(NSString *)titleString row:(NSInteger )row{
    self.tagLabel.text=[[NSNumber numberWithInteger:row+1] stringValue];
    self.titleLabel.text=titleString;
}
-(UILabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel=[UILabel CreatLabeltext:@"1" Font:[UIFont boldSystemFontOfSize:kSCRATIO(14)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    }
    return _tagLabel;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel CreatLabeltext:@"语音实时直播答题节目，答对 12 题即可瓜分现金奖.." Font:[UIFont boldSystemFontOfSize:kSCRATIO(14)] Textcolor:Color333333 textAlignment:0];
        _titleLabel.numberOfLines=0;
    }
    return _titleLabel;
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
