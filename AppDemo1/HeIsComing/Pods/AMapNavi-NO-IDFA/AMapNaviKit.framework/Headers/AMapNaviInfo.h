//
//  AMapNaviInfo.h
//  AMapNaviKit
//
//  Created by AutoNavi on 14-8-22.
//  Copyright (c) 2014年 Amap. All rights reserved.
//

#import "AMapNaviCommonObj.h"

///导航过程中的导航信息
@interface AMapNaviInfo : NSObject<NSCopying,NSCoding>

///导航信息更新类型
@property (nonatomic, assign) AMapNaviMode naviMode;

///导航段转向图标类型
@property (nonatomic, assign) AMapNaviIconType iconType;

///当前道路名称
@property (nonatomic, strong) NSString *currentRoadName;

///下条道路名称
@property (nonatomic, strong) NSString *nextRoadName;

///离终点剩余距离(单位:米)
@property (nonatomic, assign) NSInteger routeRemainDistance;

///离终点预估剩余时间(单位:秒)
@property (nonatomic, assign) NSInteger routeRemainTime;

///当前所在的segment段的index,从0开始
@property (nonatomic, assign) NSInteger currentSegmentIndex;

///当前路段剩余距离(单位:米)
@property (nonatomic, assign) NSInteger segmentRemainDistance;

///当前路段预估剩余时间(单位:秒)
@property (nonatomic, assign) NSInteger segmentRemainTime;

///当前所在的link段的index,从0开始
@property (nonatomic, assign) NSInteger currentLinkIndex;

///当前自车位置在当前link段所在的point的index,从0开始 since 6.0.0
@property (nonatomic, assign) NSInteger currentPointIndex;

///已经行驶的里程(单位:米). 注意:只在驾车的实时导航下才有效. since 6.0.0
@property (nonatomic, assign) NSInteger routeDriveDistance;

///已经行驶的用时,包括中途停车时间在内(单位:秒). 注意:只在驾车的实时导航下才有效. since 6.0.0
@property (nonatomic, assign) NSInteger routeDriveTime;

///没有避开的设施、禁行标志等信息, 如限高. 注意:只针对驾车. since 6.0.0
@property (nonatomic, strong) AMapNaviNotAvoidFacilityAndForbiddenInfo *notAvoidInfo;

///当前路径剩余的红绿灯数量. 注意:只针对驾车. since 6.3.0
@property (nonatomic, assign) NSInteger routeRemainTrafficLightCount;

///当前自车位置到各途经点的信息. 注意:只针对驾车. since 6.7.0
@property (nonatomic, strong) NSArray <AMapNaviToWayPointInfo *> *toWayPointInfos;

///当前自车所在的高速或城市快速路的出口路牌信息. 注意:只针对驾车. since 6.8.0
@property (nonatomic, strong) AMapNaviExitBoardInfo *exitBoardInfo;

@end
