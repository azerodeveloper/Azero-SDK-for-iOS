//
//  MSSpakerDeviceLightCell.m
//  WuNuo
//
//  Created by silk on 2019/8/8.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "MSSpakerDeviceLightCell.h"
@interface MSSpakerDeviceLightCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation MSSpakerDeviceLightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5.0;
    self.backgroundColor = [UIColor clearColor];
    // Initialization code
}

@end
