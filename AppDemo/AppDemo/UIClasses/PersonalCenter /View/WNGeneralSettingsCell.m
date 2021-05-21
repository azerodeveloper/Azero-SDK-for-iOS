//
//  WNGeneralSettingsCell.m
//  WuNuo
//
//  Created by silk on 2019/5/21.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "WNGeneralSettingsCell.h"
@interface WNGeneralSettingsCell ()
@property (weak, nonatomic) IBOutlet UILabel *setTitleView;

@end
@implementation WNGeneralSettingsCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.pointView.layer.masksToBounds = YES;
    self.pointView.layer.cornerRadius = self.pointView.size.width/2.0;
    self.pointView.hidden = YES;
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(WNChooseTimeModel *)model{
    _model = model;
    self.setTitleView.text = model.selectTime;
    
}
@end
