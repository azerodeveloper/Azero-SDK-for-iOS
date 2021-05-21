//
//  SaiAzeroClient.h
//  HeIsComing
//
//  Created by silk on 2020/5/13.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroClient.h"
typedef enum{
    NetworkTypeDISCONNECTED = 0,
    NetworkTypePENDING    = 1,
    NetworkTypeCONNECTED    = 2,
}NetworkType;
typedef void(^saiAzeroClientBlock)(NetworkType type);
@interface SaiAzeroClient : AzeroClient
- (void)saiAzeroClientConnectionStatusChangedWithStatus:(saiAzeroClientBlock )clientBlcok;
@end

