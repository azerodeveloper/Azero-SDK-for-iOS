//
//  SaiMusicControlView.h
//  HeIsComing
//
//  Created by silk on 2020/3/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKSliderView.h"
@class SaiMusicControlView;

NS_ASSUME_NONNULL_BEGIN
@protocol SaiMusicControlViewDelegate <NSObject>
// 滑杆滑动及点击
- (void)saiControlView:(SaiMusicControlView *)controlView didSliderTouchBegan:(float)value;
- (void)saiControlView:(SaiMusicControlView *)controlView didSliderTouchEnded:(float)value;
- (void)saiControlView:(SaiMusicControlView *)controlView didSliderValueChange:(float)value;
- (void)saiControlView:(SaiMusicControlView *)controlView didSliderTapped:(float)value;
@end

@interface SaiMusicControlView : UIView
@property (nonatomic, weak) id<SaiMusicControlViewDelegate>    delegate;
// slider
@property (nonatomic, strong) GKSliderView                      *slider;

@property (nonatomic, copy) NSString                            *currentTime;
@property (nonatomic, copy) NSString                            *totalTime;
@property (nonatomic, assign) float                             progress;
@property (nonatomic, assign) float                             bufferProgress;



- (void)initialData;

- (void)showLoadingAnim;
- (void)hideLoadingAnim;
@end

NS_ASSUME_NONNULL_END
