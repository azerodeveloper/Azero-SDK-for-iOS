//
//  WNSpakerDeviceCell.m
//  WuNuo
//
//  Created by silk on 2019/5/7.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "WNSpakerDeviceCell.h"
@interface WNSpakerDeviceCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation WNSpakerDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5.0;
    self.backgroundColor = [UIColor clearColor];
}

@end
