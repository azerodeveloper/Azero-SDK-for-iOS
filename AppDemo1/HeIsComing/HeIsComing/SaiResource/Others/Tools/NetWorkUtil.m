//
//  NetWorkUtil.m
//  xiaoyixiu
//
//  Created by hanzhanbing on 16/6/14.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import "NetWorkUtil.h"
#import "AppDelegate.h"
#import "SaiBrokenNetworkInterfaceView.h"
#import "MessageAlertView.h"
@implementation NetWorkUtil

static NetWorkUtil* _instance;
+ (NetWorkUtil *)sharedInstance
{
    static dispatch_once_t predicate ;
    dispatch_once(&predicate , ^{
        _instance = [[NetWorkUtil alloc] init];
    });
    return _instance;
}

+ (NetWorkType )currentNetWorkStatus
{
   __block NetWorkType nNetWorkType = NET_UNKNOWN; //默认无网
    
    switch ([RealReachability sharedInstance].currentReachabilityStatus) {
        case RealStatusViaWWAN:
            nNetWorkType=NET_WWAN;
            break;
        case RealStatusViaWiFi:
            nNetWorkType=NET_WIFI;
            break;
        case RealStatusNotReachable:
            nNetWorkType=NET_NotReachable;
            break;

        default:
            break;
    }

    return nNetWorkType;
}

- (void)listening
{
    [[RealReachability sharedInstance] startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
}

- (void)networkChanged:(NSNotification *)note
{
    switch ([NetWorkUtil currentNetWorkStatus]) {
        case NET_UNKNOWN:
            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetDisAppear" object:nil];
//            [MessageAlertView showHudMessage:@"断网了"];
                [SaiBrokenNetworkInterfaceView show:@"网络连接不可用，请检查您的网络设置"];
            }
            break;
        case   NET_WIFI:{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetAppear" object:nil];
            [MessageAlertView showHudMessage:@"连接Wifi了"];
            [SaiBrokenNetworkInterfaceView dismiss];
        }
            break;
        case NET_WWAN:{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetAppear" object:nil];
            [SaiBrokenNetworkInterfaceView dismiss];
            [MessageAlertView showHudMessage:@"当前为非WI-FI环境，注意流量哦"];
        }
            break;
            
        default:
            [SaiBrokenNetworkInterfaceView dismiss];

            break;
    }
 
}

- (void)dealloc
{
    [GLobalRealReachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
