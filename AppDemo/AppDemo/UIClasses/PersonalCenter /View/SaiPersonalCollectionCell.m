//
//  SaiPersonalCollectionCell.m
//  HeIsComing
//
//  Created by silk on 2020/7/18.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiPersonalCollectionCell.h"
#import "UIImageView+WebCache.h"

#define ItemSizeW        122
#define IgImageViewH       78
#define DeviceLabelH       28
#define DeviceIamgeViewW   30
@interface SaiPersonalCollectionCell ()
@property (nonatomic ,strong) UIImageView *bgImageView;
@property (nonatomic ,strong) UILabel *deviceLabel;
@property (nonatomic ,strong) UIImageView *deviceIamgeView;
@property (nonatomic ,strong) UILabel *detailLabel;

@end
@implementation SaiPersonalCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)  {
        [self setupAllChildView];
    }
    return self;
}
- (void)setupAllChildView{
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(0, 0, ItemSizeW, IgImageViewH);
    [self.contentView addSubview:bgImageView];
    self.bgImageView = bgImageView;
    UILabel *deviceLabel = [[UILabel alloc] init];
    deviceLabel.frame = CGRectMake(0, CGRectGetMaxY(bgImageView.frame)+kSCRATIO(2), ItemSizeW, DeviceLabelH);
    deviceLabel.textAlignment = NSTextAlignmentCenter;
    deviceLabel.font = [UIFont qk_PingFangSCRegularBoldFontwithSize:16.0f];
    deviceLabel.textColor = Color333333;
    [self.contentView addSubview:deviceLabel];
    self.deviceLabel = deviceLabel;
//    UIImageView *deviceIamgeView = [[UIImageView alloc] init];
//    deviceIamgeView.frame = CGRectMake((ItemSizeW-DeviceIamgeViewW)/2, (IgImageViewH-DeviceIamgeViewW)/2, DeviceIamgeViewW, DeviceIamgeViewW);
//    deviceIamgeView.image = [UIImage imageNamed:@""];
//    [bgImageView addSubview:deviceIamgeView];
//    UILabel *detailLabel = [[UILabel alloc] init];
//    detailLabel.frame = CGRectMake(0, CGRectGetMaxY(deviceIamgeView.frame), ItemSizeW, IgImageViewH-CGRectGetMaxY(deviceIamgeView.frame));
//    detailLabel.textAlignment = NSTextAlignmentCenter;
//    detailLabel.textColor = [UIColor whiteColor];
//    [self.contentView addSubview:detailLabel];
}
- (void)setListModel:(SaiPersonalListModel *)listModel{
    _listModel = listModel;
    self.bgImageView.image = [UIImage imageNamed:listModel.bgImage];
    self.deviceLabel.text = listModel.deviceText;
}
@end
