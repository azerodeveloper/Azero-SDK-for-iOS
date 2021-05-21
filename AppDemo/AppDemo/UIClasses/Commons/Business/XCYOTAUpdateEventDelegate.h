//
//  XCYOTAUpdateEventDelegate.h
//  XCYBlueBox
//
//  Created by zhouaitao on 2017/7/18.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XCYOTAUpdateEventDelegate <NSObject>

@required

- (void)setProgress:(CGFloat)aProgress animated:(BOOL)animate;
- (void)otaUpdateSuccessd:(BOOL)laps;
- (void)otaUpdateFaildWithMsg:(NSString *)errorMsg;

- (void)writeInDataInfo:(NSString *)info;

@end
