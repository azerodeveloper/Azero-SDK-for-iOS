//
//  WNMySoundEquipmentCell.m
//  WuNuo
//
//  Created by silk on 2019/5/20.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "WNMySoundEquipmentCell.h"

#define labelH   39
@interface WNMySoundEquipmentCell ()
@property (nonatomic ,strong) UILabel *speakersNameLabel;

@end

@implementation WNMySoundEquipmentCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = labelH/2.0;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = SaiColor(51, 51, 51);
        label.font = [UIFont qk_PingFangSCRegularFontwithSize:15.0f];
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 0, 100, labelH);
        bgView.layer.cornerRadius = labelH/2;
        bgView.layer.masksToBounds = YES;
        [self addShadowToView:bgView withColor:[UIColor blackColor]];
        [bgView addSubview:label];
        [self.contentView addSubview:bgView];
        self.speakersNameLabel = label;
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            // make 代表约束:
            make.top.equalTo(self.contentView).with.offset(0);   // 对当前view的top进行约束,距离参照view的上边界是 :
            make.left.equalTo(self.contentView).with.offset(0);  // 对当前view的left进行约束,距离参照view的左边界是 :
            make.height.equalTo(@39);                // 高度
            make.right.equalTo(self.contentView).with.offset(0); // 对当前view的right进行约束,距离参照view的右边界是 :
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            // make 代表约束:
            make.top.equalTo(bgView).with.offset(0);   // 对当前view的top进行约束,距离参照view的上边界是 :
            make.left.equalTo(bgView).with.offset(0);  // 对当前view的left进行约束,距离参照view的左边界是 :
            make.height.equalTo(@39);                // 高度
            make.right.equalTo(bgView).with.offset(0); // 对当前view的right进行约束,距离参照view的右边界是 :
        }];
    }
    return self;
}


- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGRect rect = [self.soundEquipmentModelV2.name boundingRectWithSize:CGSizeMake(MAXFLOAT, 39) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont qk_PingFangSCRegularFontwithSize:15]} context:nil];
    float width = rect.size.width+40;
    attributes.frame = CGRectMake(0, 0, width, 39);
    return attributes;
}


- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(2,2);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.2;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 3;
    theView.clipsToBounds = NO;
}

- (void)setSoundEquipmentModelV2:(WNSoundEquipmentModelV2 *)soundEquipmentModelV2{
    _soundEquipmentModelV2 = soundEquipmentModelV2;
    self.speakersNameLabel.text = soundEquipmentModelV2.name;
    if (soundEquipmentModelV2.active) {
        self.speakersNameLabel.backgroundColor = SaiColor(245, 245, 245);
    }else{
        self.speakersNameLabel.backgroundColor = [UIColor whiteColor];
    }
}
@end
