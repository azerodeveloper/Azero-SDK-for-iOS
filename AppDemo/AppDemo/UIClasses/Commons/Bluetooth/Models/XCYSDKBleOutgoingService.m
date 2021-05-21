//
//  XCYBleOutgoingService.m
//  BleDemo
//
//  Created by XCY on 16/5/4.
//  Copyright © 2016年 XCY. All rights reserved.
//

#import "XCYSDKBleOutgoingService.h"
#import "XCYSDKBleCentralManager.h"

@implementation XCYSDKBleOutgoingService
+ (id<XCYSDKBleCentralManagerInterface>)getBleCentralManager
{
    XCYSDKBleCentralManager *manager = [[XCYSDKBleCentralManager alloc]init];
    return manager;
}
@end
