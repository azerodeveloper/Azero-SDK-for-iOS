//
//  SaiTagsCollectionViewCell.m
//  HeIsComing
//
//  Created by mike on 2020/11/4.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiTagsCollectionViewCell.h"

@implementation SaiTagsCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.75];
        UILabel *cellLabel=[UILabel CreatLabeltext:@"" Font:[UIFont systemFontOfSize:kSCRATIO(14)] Textcolor:kColorFromRGBHex(0x72806D) textAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:cellLabel];
        self.cellLabel=cellLabel;

        [cellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(kSCRATIO(1.5), kSCRATIO(10), kSCRATIO(1.5), kSCRATIO(10)));
        }];
    }
    return self;
    
}
@end
