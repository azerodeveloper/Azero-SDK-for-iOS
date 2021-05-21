//
//  XCYBleOutgoingService.h
//  BleDemo
//
//  Created by XCY on 16/5/4.
//  Copyright © 2016年 XCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCYSDKBleCentralManagerInterface.h"

@interface XCYSDKBleOutgoingService : NSObject

+ (id<XCYSDKBleCentralManagerInterface>)getBleCentralManager;
@end
