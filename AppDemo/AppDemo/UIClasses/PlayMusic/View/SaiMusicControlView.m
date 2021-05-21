//
//  SaiMusicControlView.m
//  HeIsComing
//
//  Created by silk on 2020/3/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiMusicControlView.h"
@interface SaiMusicControlView ()<GKSliderViewDelegate>
@property (nonatomic, strong) UIView    *sliderView;
@property (nonatomic, strong) UILabel   *currentLabel;
@property (nonatomic, strong) UILabel   *totalLabel;
@property (nonatomic, assign) BOOL      isLoading;

@end
@implementation SaiMusicControlView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        // 滑杆
        [self addSubview:self.sliderView];
        [self.sliderView addSubview:self.currentLabel];
        [self.sliderView addSubview:self.slider];
        [self.sliderView addSubview:self.totalLabel];
    
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(40);
        }];
        
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sliderView).offset(0);
            make.left.equalTo(self.sliderView).offset(20);
            make.right.equalTo(self.sliderView).offset(-20);
            make.height.mas_equalTo(20);
        }];
        
        [self.currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.slider).offset(0);
            make.width.mas_equalTo(100);
            make.top.equalTo(self.slider.mas_bottom);
            make.bottom.equalTo(self.sliderView.mas_bottom);
        }];
        
        [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.slider).offset(0);
            make.width.mas_equalTo(100);
            make.top.equalTo(self.slider.mas_bottom);
            make.bottom.equalTo(self.sliderView.mas_bottom);
        }];
    }
    return self;
}
#pragma mark - Setters

- (void)setCurrentTime:(NSString *)currentTime {
    _currentTime = currentTime;
    
    self.currentLabel.text = currentTime;
}

- (void)setTotalTime:(NSString *)totalTime {
    _totalTime = totalTime;
    
    self.totalLabel.text = totalTime;
}

- (void)setProgress:(float)progress {
    _progress = progress;
    
    self.slider.value = progress;
    
    [self.slider layoutIfNeeded];
}

- (void)setBufferProgress:(float)bufferProgress {
    _bufferProgress = bufferProgress;
    
    self.slider.bufferValue = bufferProgress;
    
    [self.slider layoutIfNeeded];
}


#pragma mark - Public Methods
- (void)initialData {
    self.progress       = 0;
    self.bufferProgress = 0;
    self.currentTime    = @"00:00";
    self.totalTime      = @"00:00";
}

- (void)showLoadingAnim {
    if (self.isLoading) return;
    self.isLoading = YES;
    [self.slider showLoading];
}

- (void)hideLoadingAnim {
    if (!self.isLoading) return;
    self.isLoading = NO;
    [self.slider hideLoading];
}



#pragma mark - UserAction

#pragma mark - GKSliderViewDelegate
- (void)sliderTouchBegin:(float)value {
    if ([self.delegate respondsToSelector:@selector(saiControlView:didSliderTouchBegan:)]) {
        [self.delegate saiControlView:self didSliderTouchBegan:value];
    }
}

- (void)sliderTouchEnded:(float)value {
    if ([self.delegate respondsToSelector:@selector(saiControlView:didSliderTouchEnded:)]) {
        [self.delegate saiControlView:self didSliderTouchEnded:value];
    }
}

- (void)sliderTapped:(float)value {
    if ([self.delegate respondsToSelector:@selector(saiControlView:didSliderTapped:)]) {
        [self.delegate saiControlView:self didSliderTapped:value];
    }
}

- (void)sliderValueChanged:(float)value {
    if ([self.delegate respondsToSelector:@selector(saiControlView:didSliderValueChange:)]) {
        [self.delegate saiControlView:self didSliderValueChange:value];
    }
}

#pragma mark - 懒加载

- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [UIView new];
        _sliderView.backgroundColor = [UIColor clearColor];
    }
    return _sliderView;
}

- (UILabel *)currentLabel {
    if (!_currentLabel) {
        _currentLabel = [UILabel new];
        _currentLabel.textColor = SaiColor(153, 153, 153);
        _currentLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _currentLabel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [UILabel new];
        _totalLabel.textColor = SaiColor(153, 153, 153);
        _totalLabel.font = [UIFont systemFontOfSize:16.0];
        _totalLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totalLabel;
}

- (GKSliderView *)slider {
    if (!_slider) {
        _slider = [[GKSliderView alloc]initWithFrame:CGRectMake(0, 0, kSCRATIO(275), 1)];
        [_slider setBackgroundImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot_blue"] forState:UIControlStateNormal];
        [_slider setBackgroundImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot_blue"] forState:UIControlStateSelected];
        [_slider setBackgroundImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot_blue"] forState:UIControlStateHighlighted];
        
        [_slider setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot_blue"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot_blue"] forState:UIControlStateSelected];
        [_slider setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot_blue"] forState:UIControlStateHighlighted];
        _slider.maximumTrackImage = [UIImage imageNamed:@"cm2_fm_playbar_curr_dray"];
        _slider.minimumTrackImage = [UIImage imageNamed:@"cm2_fm_playbar_curr_blue"];
        _slider.bufferTrackImage  = [UIImage imageNamed:@"cm2_fm_playbar_ready"];
        _slider.minimumTrackTintColor = SaiColor(35, 101, 230);
        _slider.bufferTrackTintColor = [UIColor blueColor];
        _slider.delegate = self;
        _slider.sliderHeight = 2;
        _slider.allowTapped = NO;
    }
    return _slider;
}


@end
