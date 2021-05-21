//
//  XCYBlueToothInHouseFactory.m
//  XCYBlueBox
//
//  Created by XCY on 2017/5/9.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import "XCYBlueToothInHouseFactory.h"
#import "XCYBlueToothPeripheralBusiness.h"

@implementation XCYBlueToothInHouseFactory


+ (id<XCYBlueToothPeripheralBusinessInterface>)getPeripheralBusiness
{
    XCYBlueToothPeripheralBusiness *business = [[XCYBlueToothPeripheralBusiness alloc] init];
    
    return business;
}
@end
