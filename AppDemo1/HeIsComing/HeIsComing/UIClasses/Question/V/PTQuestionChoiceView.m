//
//  PTTestChoiceButtonView.m
//  ProblemTest
//
//  Created by Celia on 2017/10/24.
//  Copyright © 2017年 Hopex. All rights reserved.
//

#import "PTQuestionChoiceView.h"
#import "PTQuestionChoiceButtonView.h"

@interface PTQuestionChoiceView () <ChoiceButtonViewDelegate>
@property (nonatomic, assign) NSInteger itemIndex;
/** 选项数据 */
@property (nonatomic, strong) NSArray *choiceData;
@end

@implementation PTQuestionChoiceView

#pragma mark - 代理协议
- (void)touchChoiceButton:(PTQuestionChoiceButtonView *)btnView {
    
    // 多选
    //    if (self.type == 1) {
    //
    //        NSMutableArray *selectChoiceArr = [NSMutableArray array];
    //        for (int i = 0; i < self.choiceData.count; i++) {
    //            PTQuestionChoiceButtonView *tempBtnV = [self viewWithTag:1000*self.itemIndex + i];
    //            if (tempBtnV.status == ChoiceButtonStatusSelected) {
    //               NSString *choiceS = [NSString stringWithFormat:@"%C",(unichar)(tempBtnV.tag - 1000*self.itemIndex + 65)];
    //                [selectChoiceArr addObject:choiceS];
    //            }
    //        }
    //        if ([self.delegate respondsToSelector:@selector(updateTheSelectChoice:)]) {
    //            [self.delegate updateTheSelectChoice:selectChoiceArr];
    //        }
    //
    //        return;
    //    }
    
    // 单选： 点中一个选项，将其他选项取消选中
    if (btnView.status == ChoiceButtonStatusSelected) {
        for (int i = 0; i<self.choiceData.count; i++) {
            
            PTQuestionChoiceButtonView *tempBtnV = [self viewWithTag:1000*self.itemIndex + i];
            if (tempBtnV != btnView) {
                tempBtnV.status = ChoiceButtonStatusNormal;
            }
            tempBtnV.userInteractionEnabled=NO;

        }
        //        NSString *choiceS = [NSString stringWithFormat:@"%C",(unichar)(btnView.tag - 1000*self.itemIndex+65 )];
        NSString *choiceS = [NSString stringWithFormat:@"%ld",(btnView.tag - 1000*self.itemIndex)];
        
        if ([self.delegate respondsToSelector:@selector(updateTheSelectChoice:)]) {
            [self.delegate updateTheSelectChoice:@[choiceS]];
        }
        //        [self setCorrectChoice:@[choiceS]];
        
    }else {
        if ([self.delegate respondsToSelector:@selector(updateTheSelectChoice:)]) {
            [self.delegate updateTheSelectChoice:@[]];
        }
    }
    
}

#pragma mark - 数据处理
- (void)setChoiceData:(NSArray *)array index:(NSInteger)index isVote:(BOOL)isVote {
    self.itemIndex = index;
    self.choiceData = array;
    // 创建答案选项
    if (index==21) {
    for (UIView *view1  in self.subviews) {
        if (view1.superview&&[view1 isMemberOfClass:[PTQuestionChoiceButtonView class]]) {
               [view1 removeFromSuperview];
               
           }
       }
        
    }
    for (int i = 0; i<array.count; i++) {
        
        PTQuestionChoiceButtonView *btnView =(PTQuestionChoiceButtonView *) [self viewWithTag:1000*index + i];
        
        if (!btnView) {
            btnView = [[PTQuestionChoiceButtonView alloc] initWithFrame:CGRectMake(0, kSCRATIO(65)*i, kSCRATIO(240), kSCRATIO(45))];
            //            btnView.ChoiceType = i;
            btnView.tag = 1000*index + i;
            btnView.delegate = self;
            // 选项如果 前两个包含A: B: 要移除
            NSString *choiceString = array[i];
            
            btnView.choiceDesc = [NSString stringWithFormat:@"%@",choiceString];
            [self addSubview:btnView];
        }else {
            //            btnView.ChoiceType = i;
            // 选项如果 前两个包含A: B: 要移除
            NSString *choiceString = array[i];
            
            //
            btnView.choiceDesc = [NSString stringWithFormat:@"%@",choiceString];
            
        }
        if (isVote) {
            switch (i) {
                case 0:
                {
                    btnView.status=ChoiceButtonStatusScore;
                    
                }
                    break;
                case 1:
                {
                    btnView.status=ChoiceButtonStatusRandom;
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
    }
}

- (void)setHaveSelectChoice:(NSArray *)haveSelectChoice {
    
    for (NSString *Charac in haveSelectChoice) {
        if (Charac.length > 0 && [Charac characterAtIndex:0] >=65) {
            NSInteger charInte = [Charac characterAtIndex:0];
            PTQuestionChoiceButtonView *btnView = [self viewWithTag:1000*self.itemIndex + (charInte -65)];
            if (btnView.tag!=0) {
                btnView.status = ChoiceButtonStatusServerSelected;
            }
        }
        
    }
    //让按钮不可点击
    for (int i = 0; i<self.choiceData.count; i++) {
             
             PTQuestionChoiceButtonView *tempBtnV = [self viewWithTag:1000*self.itemIndex + i];
             tempBtnV.userInteractionEnabled=NO;

         }
    
}
-(void)setErrorChoice:(NSArray *)errorChoice{
    for (NSString *Charac in errorChoice) {
        if (Charac.length > 0 && [Charac characterAtIndex:0] >=65) {
            NSInteger charInte = [Charac characterAtIndex:0];
            PTQuestionChoiceButtonView *btnView = [self viewWithTag:1000*self.itemIndex + (charInte -65)];
            if (btnView.tag!=0) {
                btnView.status = ChoiceButtonStatusError;
            }
        }
        
    }
}
- (void)setCorrectChoice:(NSArray *)correctChoice {
    
    for (NSString *Charac in correctChoice) {
        if (Charac.length > 0 && [Charac characterAtIndex:0] >=65) {
            NSInteger charInte = [Charac characterAtIndex:0];
            PTQuestionChoiceButtonView *btnView = [self viewWithTag:1000*self.itemIndex + (charInte-65)];
            if (btnView.tag!=0)// 暂时这样判断
            {
                btnView.status = ChoiceButtonStatusCorrect;
            }
        }
    }
}


@end
