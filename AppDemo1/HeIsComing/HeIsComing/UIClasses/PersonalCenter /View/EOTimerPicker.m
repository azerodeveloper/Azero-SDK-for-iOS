//
//  EOTimerPicker.m timepicker
//  EastOffice2.0
//
//  Created by YLY on 2017/11/28.
//  Copyright © 2017年 EO. All rights reserved.
//

#import "EOTimerPicker.h"

@interface EOTimerPicker ()

@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation EOTimerPicker

- (void)sureAction {
    NSDate *date = self.datePicker.date;
    !self.sureblock ? : self.sureblock(date);
}

- (void)setMaxDate:(NSDate *)maxDate {
    self.datePicker.maximumDate = maxDate;
}
-(void)setCurrentDate:(NSDate *)currentDate
{
    [self.datePicker setDate:currentDate];
}
- (void)setMinDate:(NSDate *)minDate {
    self.datePicker.minimumDate = minDate;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor ;
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, KScreenW, self.height - kSCRATIO(44) - BOTTOM_HEIGHT)];
        self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"]; 
        self.datePicker.timeZone = [NSTimeZone defaultTimeZone];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self addSubview:self.datePicker];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        sureBtn.frame = CGRectMake(0, self.height - kSCRATIO(44) - BOTTOM_HEIGHT, KScreenW, kSCRATIO(44));
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:kSCRATIO(17)];
        [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
    }
    return self;
}

@end
