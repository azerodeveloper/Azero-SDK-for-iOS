//
//  SaiChooseView.m
//  HeIsComing
//
//  Created by mike on 2020/3/25.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiChooseView.h"

@implementation SaiChooseView
-(instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)array{
    self=[super initWithFrame:frame];
      if (self) {
          UIView * backView=[[UIView alloc]init];
          [self addSubview:backView];
          [backView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.edges.equalTo(self);
          }];
          backView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
          [self addSubview:backView];
          __weak typeof(self)weakSelf=self;
          UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
              [UIView animateWithDuration:5 animations:^{
                  [weakSelf mas_updateConstraints:^(MASConstraintMaker *make) {
                      make.top.mas_offset(ScreenHeight);
                  }];
              } completion:^(BOOL finished) {
                  
              }];
          }];
          backView.userInteractionEnabled=YES;
          [backView addGestureRecognizer:tap];
          [self initWhiteView];
          
      }
      return self;
}
-(void)initWhiteView{
    UIView * whitView=[[UIView alloc]init];
    whitView.backgroundColor=kColorFromRGBHex(0xE3E3E3);
    [self addSubview:whitView];
    [whitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_offset(0);
        make.height.mas_offset(kSCRATIO(165)+BOTTOM_HEIGHT);
        
    }];
    [whitView layoutIfNeeded];
    
    //切左上右上圆角
    UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:whitView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(kSCRATIO(20), kSCRATIO(20))];
    
    CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ] init];
    cornerRadiusLayer.frame = whitView.bounds;
    cornerRadiusLayer.path = cornerRadiusPath.CGPath;
    whitView.layer.mask = cornerRadiusLayer;
    UIButton * canleBtn=[UIButton CreatButtontext:@"取消" image:nil Font:[UIFont fontWithName:@"PingFang-SC-Bold" size: kSCRATIO(17)] Textcolor:Color333333];
    [canleBtn addTarget:self action:@selector(hiddenAnimation) forControlEvents:UIControlEventTouchUpInside];
    [whitView addSubview:canleBtn];
    [canleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.mas_offset(0);
        make.height.mas_offset(kSCRATIO(55));
        make.bottom.mas_offset(-BOTTOM_HEIGHT);
    }];
  
    canleBtn.backgroundColor=UIColor.whiteColor;
    UIButton * chooseBtn=[UIButton CreatButtontext:@"从手机相册选择" image:nil Font:[UIFont fontWithName:@"PingFang-SC-Bold" size: kSCRATIO(17)] Textcolor:Color333333];
       [chooseBtn addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
       [whitView addSubview:chooseBtn];
       [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.left.right.mas_offset(0);

           make.height.mas_offset(kSCRATIO(55));
           make.bottom.equalTo(canleBtn.mas_top).offset(-kSCRATIO(6));
       }];
     
       chooseBtn.backgroundColor=UIColor.whiteColor;
    UIButton * photoBtn=[UIButton CreatButtontext:@"拍摄" image:nil Font:[UIFont fontWithName:@"PingFang-SC-Bold" size: kSCRATIO(17)] Textcolor:Color333333];
          [photoBtn addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
          [whitView addSubview:photoBtn];
          [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.left.right.mas_offset(0);

              make.height.mas_offset(kSCRATIO(55));
              make.bottom.equalTo(chooseBtn.mas_top).offset(-1);
          }];
        
          photoBtn.backgroundColor=UIColor.whiteColor;
}
-(void)chooseClick:(UIButton *)sender{
    if ([sender.currentTitle isEqualToString:@"拍摄"]) {
        self.tableViewSelectBlock(0);
    }else{
        self.tableViewSelectBlock(1);

    }
    [self hiddenAnimation];
}
- (void)hiddenAnimation{
    [UIView animateWithDuration:3.0 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(ScreenHeight);
        }];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
