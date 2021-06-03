//
//  SaiBrokenNetworkInterfaceView.h
//  HeIsComing
//
//  Created by mike on 2020/5/11.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiBrokenNetworkInterfaceView : UIView

+(SaiBrokenNetworkInterfaceView *)shareHud;

+(void)show:(NSString *)hudAni;

+(void)dismiss;

@end

NS_ASSUME_NONNULL_END
