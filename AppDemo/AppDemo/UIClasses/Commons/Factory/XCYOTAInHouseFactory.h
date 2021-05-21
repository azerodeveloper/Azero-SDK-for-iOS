//
//  XCYOTAInHouseFactory.h
//  XCYBlueBox
//
//  Created by zhouaitao on 2017/7/18.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCYOTAConfig.h"

@protocol XCYOTAUpdateBusinessInterface;

@interface XCYOTAInHouseFactory : NSObject


+ (id<XCYOTAUpdateBusinessInterface>)getUpdateBusinessWithType:(XCYOTAUpdateType)aType;
@end
