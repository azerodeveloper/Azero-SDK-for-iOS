//
//  XCYBlueToothInHouseFactory.h
//  XCYBlueBox
//
//  Created by XCY on 2017/5/9.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XCYBlueToothPeripheralBusinessInterface;


@interface XCYBlueToothInHouseFactory : NSObject

+ (id<XCYBlueToothPeripheralBusinessInterface>)getPeripheralBusiness;

@end
