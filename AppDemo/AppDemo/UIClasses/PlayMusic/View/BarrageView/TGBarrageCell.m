//
//  TGBarrageCell.m
//  TGBarrageViewDemo
//
//  Created by tsaievan on 21/10/2018.
//  Copyright © 2018 tsaievan. All rights reserved.
//

#import "TGBarrageCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface TGBarrageCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *rangeLabel;

@end

@implementation TGBarrageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
//    UIImage *image = [UIImage imageNamed:@"barrage_gradient.png"];
//    [image drawInRect:rect];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(kSCRATIO(10), kSCRATIO(10))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setupUI {
    self.backgroundColor = Color313944;
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.rangeLabel];
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self).offset(kSCRATIO(7));
//        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(3);
        make.centerY.equalTo(self.iconImageView);
    }];
    [self.rangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(kSCRATIO(4));
        make.width.mas_lessThanOrEqualTo(kSCRATIO(220));
        make.bottom.mas_offset(kSCRATIO(-5));
    }];
  
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 10;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel CreatLabeltext:@"" Font:[UIFont systemFontOfSize:kSCRATIO(14)] Textcolor:UIColor.whiteColor textAlignment:0];
      
    }
    return _nameLabel;
}

- (UILabel *)rangeLabel {
    if (!_rangeLabel) {
        _rangeLabel = [UILabel CreatLabeltext:@"" Font:[UIFont systemFontOfSize:kSCRATIO(14)] Textcolor:UIColor.whiteColor textAlignment:0];
        _rangeLabel.numberOfLines=2;
    }
    return _rangeLabel;
}
-(void)setBaseModelContents:(WXBaseModelContentsExtCommentFirstPage *)baseModelContents{
    _baseModelContents = baseModelContents;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:baseModelContents.user.pictureUrl] placeholderImage:[UIImage imageNamed:@"placeHolderPerson"]];
    NSString *nameString = [QKUITools isBlankString:baseModelContents.user.name]?@"匿名用户":baseModelContents.user.name;
//    if (name.length <= 0) {
//        name = @"* * * *";
//    }else if (name.length == 1) {
//        name = [NSString stringWithFormat:@"%@ * * *", [name substringWithRange:NSMakeRange(0, 1)]];
//    }else {
//        name = [NSString stringWithFormat:@"%@ * * %@", [name substringWithRange:NSMakeRange(0, 1)], [name substringWithRange:NSMakeRange(name.length - 1, 1)]];
//    }
    self.nameLabel.text = nameString;
    NSString *range = baseModelContents.content;
    self.rangeLabel.text=range;
    CGFloat cellWidth = 0.f;
    CGSize size1=[QKUITools getTextHeight:nameString width:kSCRATIO(220) font:[UIFont systemFontOfSize:kSCRATIO(14)]];

    CGSize size=[QKUITools getTextHeight:baseModelContents.content width:kSCRATIO(220) font:[UIFont systemFontOfSize:kSCRATIO(14)]];
    
    size.height=size.height<kSCRATIO(50)?size.height:kSCRATIO(50);
   
    CGFloat endMargin = 7;
    CGFloat margin = 3;
    CGFloat iconWidth = 20;
    
    cellWidth = endMargin + iconWidth + margin   + margin + (size1.width>size.width?size1.width:size.width) + endMargin;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(barrageCell:updateConstraintsWithWidth:)]) {
        [self.delegate barrageCell:self updateConstraintsWithWidth:CGSizeMake(cellWidth, size.height)];
    }
}

@end
