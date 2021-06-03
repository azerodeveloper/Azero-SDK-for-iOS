//
//  EOTimerPicker.h
//  EastOffice2.0
//
//  Created by YLY on 2017/11/28.
//  Copyright © 2017年 EO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EOTimerPicker : UIView

@property (strong, nonatomic) NSDate *minDate;
@property (strong, nonatomic) NSDate *maxDate;
@property (strong, nonatomic) NSDate *currentDate;

@property (copy, nonatomic) void(^sureblock)(NSDate *date);

@end
