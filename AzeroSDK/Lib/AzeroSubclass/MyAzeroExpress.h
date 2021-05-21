//
//  MyAzeroExpress.h
//  AzeroDemo
//
//  Created by silk on 2020/4/1.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiAzeroExpress.h"
typedef void(^myAzeroExpressBlcok)(NSString *type,NSString *content);
@interface MyAzeroExpress : SaiAzeroExpress
- (void)saiAzeroExpressObtainData:(myAzeroExpressBlcok )azeroExpress;
@end

