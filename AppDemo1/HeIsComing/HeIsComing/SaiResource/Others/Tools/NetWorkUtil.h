//
//  NetWorkUtil.h
//  xiaoyixiu
//
//  Created by hanzhanbing on 16/6/14.
//  Copyright © 2016年 柯南. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Reachability/Reachability.h>
#import "RealReachability.h"
typedef enum
{
    NET_UNKNOWN = 0,    // 未知,无网络
    NET_WIFI    = 1,    // WIFI
    NET_WWAN    = 2,    // 移动网络
    NET_2G      = 3,    // 2G
    NET_3G      = 4,    // 3G
    NET_4G      = 5,    // 4G
    NET_NotReachable = 6,    // 未知

}NetWorkType;


@interface NetWorkUtil : NSObject

/**
 *  判断当前网络状态
 *
 *  @return 网络状态
 */
+ (NetWorkType )currentNetWorkStatus;

/**
 *  网络实时监听
 */
- (void)listening;

+ (NetWorkUtil *)sharedInstance;

@end
