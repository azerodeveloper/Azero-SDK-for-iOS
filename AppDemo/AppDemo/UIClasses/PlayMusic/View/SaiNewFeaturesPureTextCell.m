//
//  SaiNewFeaturesPureTextCell.m
//  HeIsComing
//
//  Created by silk on 2020/11/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiNewFeaturesPureTextCell.h"
#import "FTCoreTextView.h"
#import "FTCoreTextCommon.h"
@interface SaiNewFeaturesPureTextCell ()<FTCoreTextViewDelegate>
@property (nonatomic ,strong) FTCoreTextView *textView;

@end
@implementation SaiNewFeaturesPureTextCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"SaiNewFeaturesPureTextCell";
    SaiNewFeaturesPureTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SaiNewFeaturesPureTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.bubbleImageView];
        [self.bubbleImageView addSubview:self.textView];
        self.backgroundColor=UIColor.clearColor;
    }
    return self;
}
- (void)setFrameModel:(SaiNewFeaturesCellFrameModel *)frameModel{
    _frameModel = frameModel;
    self.bubbleImageView.frame = frameModel.bubbleImageViewFrame;
    self.textView.frame = frameModel.textRectFrame;
    self.bubbleImageView.backgroundColor = Color313944;
    ViewRadius(self.bubbleImageView, kSCRATIO(6));

//    self.bubbleImageView.image = [self bulleiImageWithNormelName:@"dialog_bubble_other"];
    NSString *drawText = [[FTCoreTextCommon sharedFTCoreTextCommon] getDrawTextByNormalText:frameModel.featuresText];
    [self.textView setText:drawText];
    FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
    defaultStyle.name = FTCoreTextTagDefault;    //thought the default name is already set to FTCoreTextTagDefault
    defaultStyle.textAlignment = FTCoreTextAlignementCenter;
    defaultStyle.color=UIColor.whiteColor;
    [self.textView addStyle:defaultStyle];
}
- (UIImage *)bulleiImageWithNormelName:(NSString*)normelName{
    
    return [[UIImage imageNamed:normelName] stretchableImageWithLeftCapWidth:15 topCapHeight:30];
}

/**
 *  气泡背景
 */
- (UIImageView *)bubbleImageView {
    if (_bubbleImageView == nil) {
        _bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bubbleImageView.userInteractionEnabled = YES;
        _bubbleImageView.backgroundColor = [UIColor clearColor];
    }
    return _bubbleImageView;
}
- (FTCoreTextView *)textView {
    if (_textView == nil) {
        _textView = [[FTCoreTextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor clearColor];
        [_textView setDelegate:self];
    }
    return _textView;
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
