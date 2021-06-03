//
//  SaiQuestionView.h
//  HeIsComing
//
//  Created by mike on 2020/4/7.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaiQuestionModel.h"
#import "PTQuestionChoiceView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SaiQuestionView : UIView

@property(nonatomic,strong)SaiQuestionModel *model;
@property (copy, nonatomic) void(^answerblock)(NSString *answer);
@property (copy, nonatomic) void(^animationEndblock)(void);
@property (nonatomic, strong) PTQuestionChoiceView *choiceView;     // 选项视图

@end

NS_ASSUME_NONNULL_END
