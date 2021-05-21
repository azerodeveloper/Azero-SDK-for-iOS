//
//  XCYOTAInHouseFactory.m
//  XCYBlueBox
//
//  Created by zhouaitao on 2017/7/18.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import "XCYOTAInHouseFactory.h"
#import "XCYOTAOldUpdateBusiness.h"
#import "XCYOTANewUpdateBusiness.h"

@implementation XCYOTAInHouseFactory


+ (id<XCYOTAUpdateBusinessInterface>)getUpdateBusinessWithType:(XCYOTAUpdateType)aType
{
    if (aType == XCYOTAUpdateType_Old) {
        
        XCYOTAOldUpdateBusiness *business = [[XCYOTAOldUpdateBusiness alloc] init];
        return business;
    }
    else
    {
        XCYOTANewUpdateBusiness *business = [[XCYOTANewUpdateBusiness alloc] init];
        return business;
    }
}
@end
