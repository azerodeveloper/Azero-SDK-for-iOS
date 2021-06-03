//
//  SaiQuestionView.m
//  HeIsComing
//
//  Created by mike on 2020/4/7.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiQuestionView.h"
#import "ZCAnimatedLabel.h"

@interface SaiQuestionView()<PTQuestionChoiceViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollV;

@property (nonatomic, strong) UIView *backView;                     // 白背景


@property (nonatomic, strong) ZCAnimatedLabel *titleLabel;                  // 题目


@property (nonatomic, strong) UILabel *typeLabel;                   // 题目类型

@property (nonatomic, strong) NSArray *choiceDesc;


@end
@implementation SaiQuestionView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        ViewRadius(self, kSCRATIO(6));
        
        [self createInterface];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self setConstraints];
}

#pragma mark - 视图布局
- (void)createInterface {
    
    [self addSubview:self.scrollV];
    [self.scrollV addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.typeLabel];
    
}

- (void)setConstraints {
    
    [self.scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_offset(kSCRATIO(35));
        make.bottom.mas_offset(kSCRATIO(-25));
    }];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollV);
        make.width.equalTo(self.scrollV);
        
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollV);
        make.height.mas_offset(kSCRATIO(18));
        make.top.mas_offset(kSCRATIO(20));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom).offset(kSCRATIO(15));
        make.centerX.equalTo(self.scrollV);
        make.width.mas_offset(kSCRATIO(240));
    }];
    
    
    if (_choiceView &&_choiceView.superview) {
        
        [self.choiceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kSCRATIO(20));
            make.width.mas_offset(kSCRATIO(240));
            make.height.mas_offset(kSCRATIO(60) * _choiceDesc.count);
            make.bottom.mas_offset(kSCRATIO(-20));
            
        }];
        
        
    }else {
        
        
    }
    
    
    
    
    
    
}
- (void)setModel:(SaiQuestionModel *)model {
    
    _model = model;
    
    self.choiceView.hidden=YES;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterSpellOutStyle;
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString *spellOutStr = [formatter stringFromNumber:[NSNumber numberWithInteger:[model.questionIndex intValue]+1]];
    self.typeLabel.text=[NSString stringWithFormat:@"第%@题",spellOutStr];
    if ([model.questionIndex intValue]==20) {
        [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
    }
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = kSCRATIO(3);
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *mutableString = [[[NSAttributedString alloc] initWithString:model.title attributes:@{NSFontAttributeName : [[UIFont systemFontOfSize:kSCRATIO(16)] fontWithBold], NSParagraphStyleAttributeName :style, NSForegroundColorAttributeName :Color333333}] mutableCopy];
    if ([QKUITools isBlankString:[model.showTitleTime stringValue]]) {
        self.titleLabel.attributedString = mutableString;
        [self.titleLabel startAppearAnimation];
        [self.titleLabel sizeToFit];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.typeLabel.mas_bottom).offset([model.questionIndex intValue]==20?0:kSCRATIO(15));
            make.centerX.equalTo(self.scrollV);
            make.width.mas_offset(kSCRATIO(240));
            make.height.mas_offset(self.titleLabel.height+kSCRATIO(10));
        }];
        [self.titleLabel layoutIfNeeded];
        if (_choiceView && [self.backView.subviews containsObject:_choiceView]) {
            [self.choiceView removeFromSuperview];
        }
        [self.backView addSubview:self.choiceView];
        [self.choiceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kSCRATIO(20));
            make.width.mas_offset(kSCRATIO(240));
            make.height.mas_offset(kSCRATIO(60) * _choiceDesc.count);
            make.bottom.mas_offset(kSCRATIO(-20));
            
        }];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([model.showTitleTime doubleValue]/1000 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.titleLabel.attributedString = mutableString;
            [self.titleLabel startAppearAnimation];
            [self.titleLabel sizeToFit];
            
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.typeLabel.mas_bottom).offset([model.questionIndex intValue]==20?0:kSCRATIO(15));
                make.centerX.equalTo(self.scrollV);
                make.width.mas_offset(kSCRATIO(240));
                make.height.mas_offset(self.titleLabel.height+kSCRATIO(10));
            }];
            [self.titleLabel layoutIfNeeded];
            if (_choiceView && [self.backView.subviews containsObject:_choiceView]) {
                [self.choiceView removeFromSuperview];
            }
            [self.backView addSubview:self.choiceView];
            [self.choiceView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(kSCRATIO(20));
                make.width.mas_offset(kSCRATIO(240));
                make.height.mas_offset(kSCRATIO(60) * _choiceDesc.count);
                make.bottom.mas_offset(kSCRATIO(-20));
                
            }];
        });
    }
    
    // 选项拆分
    NSMutableArray *choiceArr = [NSMutableArray array];
    for (int i=0; i<model.answers.count; i++) {
        SaiQuestionModelAnswers *opArr=model.answers[i];
        [choiceArr addObject:[NSString stringWithFormat:@"%@.%@",[NSNumber numberWithInt:i+1],opArr.content]];
        
    }
    
    
    
    self.choiceDesc = choiceArr.copy;
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([model.showOptionTime doubleValue]/1000 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.choiceView.hidden=NO;
        
        [self.choiceView setChoiceData:self.choiceDesc index:[model.questionIndex integerValue]+1 isVote:NO];
        if (self.animationEndblock) {
            self.animationEndblock();
        }
        
    });
    
}
#pragma mark - 代理协议
- (void)updateTheSelectChoice:(NSArray *)choiceArray {
    if (self.answerblock) {
        self.answerblock(choiceArray.firstObject);
    }
    
}
#pragma mark - 懒加载
- (UIScrollView *)scrollV {
    
    if (!_scrollV) {
        _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _scrollV.backgroundColor = UIColor.whiteColor;
        _scrollV.scrollEnabled = true;
        _scrollV.showsVerticalScrollIndicator=NO;
    }
    return _scrollV;
}

- (UIView *)backView {
    
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor=UIColor.whiteColor;
    }
    return _backView;
}

- (ZCAnimatedLabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel=[[ZCAnimatedLabel alloc ] initWithFrame:CGRectMake(0, 0, kSCRATIO(240), 0)];
    }
    return _titleLabel;
}

- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        _typeLabel = [UILabel CreatLabeltext:@"第一题" Font:[UIFont boldSystemFontOfSize:kSCRATIO(19)] Textcolor:Color333333 textAlignment:NSTextAlignmentCenter];
    }
    return _typeLabel;
}

- (PTQuestionChoiceView *)choiceView {
    
    if (!_choiceView) {
        _choiceView = [[PTQuestionChoiceView alloc] init];
        _choiceView.delegate = self;
    }
    return _choiceView;
}



@end
