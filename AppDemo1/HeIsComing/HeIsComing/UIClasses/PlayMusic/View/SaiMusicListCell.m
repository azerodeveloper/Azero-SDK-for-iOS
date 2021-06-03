//
//  SaiMusicListCell.m
//  HeIsComing
//
//  Created by silk on 2020/2/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiMusicListCell.h"
@interface SaiMusicListCell  ()
@property (weak, nonatomic) IBOutlet UILabel *numView;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singerView;
@property (weak, nonatomic) IBOutlet UIButton *logoButton;

@end
@implementation SaiMusicListCell  

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 6.0;
//    self.numView.textColor = [UIColor whiteColor];
//    self.songName.textColor = [UIColor blackColor];
//    self.singerView.textColor = SaiColor(153, 153, 153);
//    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

//- (void)setModel:(SaiMusicListModel *)model{
//    _model = model;
//    self.songName.text = model.title;
//    self.singerView.text = model.provider[@"name"];
//}
- (void)setNum:(NSInteger)num{
    _num = num;
    self.numView.text = [NSString stringWithFormat:@"%ld",num];
}

- (void)setFrameModel:(SaiMusicListCellFrameModel *)frameModel{
    _frameModel = frameModel;
    SaiMusicListModel *model = frameModel.listModel;
    self.songName.text = model.title;
     self.singerView.text = model.provider[@"name"];
    NSArray *sourcesArray=model.provider[@"logo"][@"sources"];
    NSDictionary *urlDic=sourcesArray.firstObject;
    [self.logoButton setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlDic[@"url"]]] forState:0 placeholder:nil];

}

@end
