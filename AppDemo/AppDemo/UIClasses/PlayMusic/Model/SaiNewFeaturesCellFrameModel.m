//
//  SaiNewFeaturesCellFrameModel.m
//  HeIsComing
//
//  Created by silk on 2020/11/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiNewFeaturesCellFrameModel.h"
#import "FTCoreTextView.h"
#import "FTCoreTextCommon.h"
@implementation SaiNewFeaturesCellFrameModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _bubbleImageViewFrame = CGRectZero;
        _textRectFrame = CGRectZero;
    }
    return self;
}

//获取文本显示尺寸
- (CGSize)getContentSizeWith:(NSString *)text {
    
    //过滤转化成TYCoreView能识别的字符
    FTCoreTextView *textView = [[FTCoreTextView alloc] initWithFrame:CGRectZero];
    
    NSString *drawText = [[FTCoreTextCommon sharedFTCoreTextCommon] getDrawTextByNormalText:text];
    [textView setText:drawText];
    [textView addStyles:[[FTCoreTextCommon sharedFTCoreTextCommon] getCorePureTextStyle]];
    CGSize size = [textView suggestedSizeConstrainedToSize:CGSizeMake(100-2*6-5*2, CGFLOAT_MAX)];
    textView.frame = (CGRect){{0,0},size};
    [textView fitToSuggestedHeight];
    return textView.frame.size;
    
}
- (void)setFeaturesText:(NSString *)featuresText{
    _featuresText = featuresText;
    CGSize textSize = [self getContentSizeWith:featuresText];
    _textRectFrame = CGRectMake(6, 3, 78, textSize.height);
    CGSize textWithBubbleSize;
    textWithBubbleSize = CGSizeMake(textSize.width + 2*6, textSize.height + 2*3);
//    CGFloat textBubleW = textWithBubbleSize.width;
    CGFloat textBubleH = textWithBubbleSize.height;
    _bubbleImageViewFrame = CGRectMake(5, 3, 90, textBubleH);
    self.cellHeight = CGRectGetMaxY(_bubbleImageViewFrame);
}




@end
