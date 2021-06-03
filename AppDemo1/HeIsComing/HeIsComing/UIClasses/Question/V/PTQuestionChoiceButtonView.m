//
//  PTQuestionChoiceButtonView.m
//  ProblemTest
//
//  Created by Celia on 2017/10/24.
//  Copyright © 2017年 Hopex. All rights reserved.
//

#import "PTQuestionChoiceButtonView.h"
#import "ZCAnimatedLabel.h"
#import "QQCorner.h"
#import "MessageAlertView.h"
@interface PTQuestionChoiceButtonView ()
@property (nonatomic, strong) UIButton *choiceBtn;      // 选项按钮
@property (nonatomic, strong) UILabel *answerLabel;     // 答案描述
@end

@implementation PTQuestionChoiceButtonView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, KScreenW, kSCRATIO(60));
        [self choiceCreateInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self choiceCreateInterface];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.choiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(kSCRATIO(-22));
        make.centerY.equalTo(self);
        make.width.mas_offset(kSCRATIO(22));
        make.height.mas_offset(kSCRATIO(16));
        
    }];
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.mas_offset(kSCRATIO(-42));
        make.left.mas_offset(kSCRATIO(42));
    }];
    [self.answerLabel layoutIfNeeded];
}

#pragma mark - 内部逻辑实现
- (void)tapChoiceBtnViewAction {
    
    if (self.status == ChoiceButtonStatusNormal) {
        self.status = ChoiceButtonStatusSelected;
    }else if (self.status == ChoiceButtonStatusSelected) {
        self.status = ChoiceButtonStatusNormal;
    }
    
    if ([self.delegate respondsToSelector:@selector(touchChoiceButton:)]) {
        [self.delegate touchChoiceButton:self];
    }
}

#pragma mark - 数据处理
- (void)setChoiceType:(NSInteger)ChoiceType {
    
    _ChoiceType = ChoiceType;
    switch (ChoiceType) {
        case 0:
            [self.choiceBtn setTitle:@"A" forState:UIControlStateNormal];
            break;
        case 1:
            [self.choiceBtn setTitle:@"B" forState:UIControlStateNormal];
            break;
        case 2:
            [self.choiceBtn setTitle:@"C" forState:UIControlStateNormal];
            break;
        case 3:
            [self.choiceBtn setTitle:@"D" forState:UIControlStateNormal];
            break;
        case 4:
            [self.choiceBtn setTitle:@"E" forState:UIControlStateNormal];
            break;
        case 5:
            [self.choiceBtn setTitle:@"F" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)setStatus:(ChoiceButtonStatus)status {
    
    _status = status;
    switch (status) {
        case ChoiceButtonStatusNormal:
        {
            self.backgroundColor=kColorFromRGBHex(0xF5F4F7);
            _choiceBtn.backgroundColor=UIColor.clearColor;
            _answerLabel.textColor=Color666666;
            _choiceBtn.hidden=YES;
            
        }
            break;
        case ChoiceButtonStatusError :{
            self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
                graColor.toColor = kColorFromRGBHex(0xEA7914);
                graColor.fromColor = kColorFromRGBHex(0xFFA664);
                graColor.type = QQGradualChangeTypeLeftToRight;
            } size:self.bounds.size cornerRadius:QQRadiusMakeSame(kSCRATIO(22.5))]];
            _choiceBtn.hidden=NO;
            [_choiceBtn setTitle:@"X" forState:0];
            
        }
            break;
        case ChoiceButtonStatusSelected:
        {
            
//            self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
//                graColor.toColor = kColorFromRGBHex(0x0EAD6E);
//                graColor.fromColor = kColorFromRGBHex(0x2BE1DF);
//                graColor.type = QQGradualChangeTypeLeftToRight;
//            } size:self.bounds.size cornerRadius:QQRadiusMakeSame(kSCRATIO(22.5))]];
//            _answerLabel.textColor=UIColor.whiteColor;
//            _choiceBtn.hidden=YES;
//            [MessageAlertView showHudMessage:@"答案提交中"];
            
        }
            break;
            case ChoiceButtonStatusServerSelected:
                  {
                      
                      self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
                          graColor.toColor = kColorFromRGBHex(0x0EAD6E);
                          graColor.fromColor = kColorFromRGBHex(0x2BE1DF);
                          graColor.type = QQGradualChangeTypeLeftToRight;
                      } size:self.bounds.size cornerRadius:QQRadiusMakeSame(kSCRATIO(22.5))]];
                      _answerLabel.textColor=UIColor.whiteColor;
                      _choiceBtn.hidden=YES;
                      
                      
                  }
                      break;
        case ChoiceButtonStatusCorrect:
        {
            self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
                graColor.toColor = kColorFromRGBHex(0x0EAD6E);
                graColor.fromColor = kColorFromRGBHex(0x2BE1DF);
                graColor.type = QQGradualChangeTypeLeftToRight;
            } size:self.bounds.size cornerRadius:QQRadiusMakeSame(kSCRATIO(22.5))]];
            _answerLabel.textColor=UIColor.whiteColor;
            _choiceBtn.hidden=NO;
            [_choiceBtn setTitle:@"√" forState:0];
            
        }
            break;
        case ChoiceButtonStatusScore:
        {
            self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
                graColor.toColor = kColorFromRGBHex(0x0EAD6E);
                graColor.fromColor = kColorFromRGBHex(0x2BE1DF);
                graColor.type = QQGradualChangeTypeLeftToRight;
            } size:self.bounds.size cornerRadius:QQRadiusMakeSame(kSCRATIO(22.5))]];
            _answerLabel.textColor=UIColor.whiteColor;
            _choiceBtn.hidden=YES;
            
        }
            break;
        case ChoiceButtonStatusRandom:
        {
            self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
                graColor.toColor = kColorFromRGBHex(0xEA7914);
                graColor.fromColor = kColorFromRGBHex(0xFFA664);
                graColor.type = QQGradualChangeTypeLeftToRight;
            } size:self.bounds.size cornerRadius:QQRadiusMakeSame(kSCRATIO(22.5))]];
            _answerLabel.textColor=UIColor.whiteColor;
            _choiceBtn.hidden=YES;
            
            
        }
            break;
        default:
            break;
    }
}

- (void)setChoiceDesc:(NSString *)choiceDesc {
    
    _choiceDesc = choiceDesc;
    
    //    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //    //         style.lineSpacing = 5;
    //    style.alignment = NSTextAlignmentCenter;
    //    NSMutableAttributedString *mutableString = [[[NSAttributedString alloc] initWithString:choiceDesc attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:kSCRATIO(18)], NSParagraphStyleAttributeName :style, NSForegroundColorAttributeName :Color666666}] mutableCopy];
    //    self.answerLabel.attributedString = mutableString;
    self.answerLabel.text=choiceDesc;
    //    [self.answerLabel startAppearAnimation];
    
}

#pragma mark - 视图布局
- (void)choiceCreateInterface {
    self.backgroundColor = kColorFromRGBHex(0xF5F4F7);
    [self addSubview:self.choiceBtn];
    [self addSubview: self.answerLabel];
    ViewRadius(self, self.height/2);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChoiceBtnViewAction)];
    [self addGestureRecognizer:tap];
    
}

#pragma mark - 懒加载
- (UIButton *)choiceBtn {
    
    if (!_choiceBtn) {
        _choiceBtn = [UIButton initButtonTitleFont:20 titleColor:UIColor.whiteColor titleName:@""];
        //        [_choiceBtn setBackgroundImage:GetImage(@"study_circle_white") forState:UIControlStateNormal];
        _choiceBtn.userInteractionEnabled = false;
        _choiceBtn.hidden=YES;
    }
    return _choiceBtn;
}

- (UILabel *)answerLabel {
    
    if (!_answerLabel) {
        _answerLabel = [UILabel CreatLabeltext:@"" Font:[UIFont fontWithName:@"PingFang-SC-Bold" size:kSCRATIO(14)] Textcolor:Color666666 textAlignment:NSTextAlignmentCenter];
        
    }
    return _answerLabel;
}

@end
