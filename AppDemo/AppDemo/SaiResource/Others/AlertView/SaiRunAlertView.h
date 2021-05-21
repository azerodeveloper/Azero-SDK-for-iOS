//
//  SaiRunAlertView.h
//  HeIsComing
//
//  Created by mike on 2020/8/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiRunAlertView : UIView

@property (copy, nonatomic) void(^backblock)(void);
@property (copy, nonatomic) void(^shareblock)(void);
@property(nonatomic,strong)NSString *webString;

-(instancetype)initAlertView:(NSString *)mileage time:(NSString *)time calories:(NSString *)calories;
@end

NS_ASSUME_NONNULL_END
