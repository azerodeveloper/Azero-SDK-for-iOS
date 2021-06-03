//
//  SaiMusicListCellFrameModel.m
//  HeIsComing
//
//  Created by silk on 2020/4/18.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiMusicListCellFrameModel.h"

@implementation SaiMusicListCellFrameModel
+ (instancetype)createFrameModelWithListModel:(SaiMusicListModel *)listModel{
    SaiMusicListCellFrameModel *musicListFrameModel = [[SaiMusicListCellFrameModel alloc]init];
    musicListFrameModel.listModel = listModel;
    return musicListFrameModel;
}

- (void)setListModel:(SaiMusicListModel *)listModel{
    _listModel = listModel;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 6;
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    UIFont *textFont = [UIFont qk_PingFangSCRegularBoldFontwithSize:kSCRATIO(13)];
    NSDictionary *attributesDic = @{NSFontAttributeName:textFont,NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [listModel.title boundingRectWithSize:CGSizeMake(kSCRATIO(170), MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil].size;
//    TYLog(@"%@ -------的高度是-------- %f",listModel.title,size.height);
    _cellHeight = size.height + kSCRATIO(60) ;
}

/**
 * 如果没有其他的属性, 则给一个默认的这个属性值.cellHeight为0
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 默认设置cell的高度是0.
        _cellHeight = 0;
    }
    return self;
}
@end
