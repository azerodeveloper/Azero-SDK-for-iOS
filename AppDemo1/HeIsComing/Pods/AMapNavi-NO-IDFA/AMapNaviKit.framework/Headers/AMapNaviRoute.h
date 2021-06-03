//
//  AMapNaviRoute.h
//  AMapNaviKit
//
//  Created by AutoNavi on 14-7-11.
//  Copyright (c) 2014年 Amap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMapNaviCommonObj.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - AMapNaviRouteGuideSegment

///路线详情的分段信息. since 7.5.0
@interface AMapNaviRouteGuideSegment : NSObject<NSCopying>

///分段的转向类型
@property (nonatomic, assign) AMapNaviIconType iconType;

///分段的详细描述
@property (nonatomic, strong, nullable) NSString *detailedDescription;

///分段是否到达途径点
@property (nonatomic, assign) BOOL isArriveWayPoint;

@end

#pragma mark - AMapNaviRouteGuideGroup

///路线详情的分组信息. since 7.5.0
@interface AMapNaviRouteGuideGroup : NSObject<NSCopying>

///分组的名称描述
@property (nonatomic, strong, nullable) NSString *groupName;

///分组的长度(单位:米)
@property (nonatomic, assign) NSInteger distance;

///分组的转向类型和该组中分段的第一个转向类型一致
@property (nonatomic, assign) AMapNaviIconType iconType;

///分组的预估时间(单位:秒)
@property (nonatomic, assign) NSInteger time;

///分组导航段路口点的坐标
@property (nonatomic, strong) AMapNaviPoint *coordinate;

///分组中的所有分段
@property (nonatomic, strong) NSArray <AMapNaviRouteGuideSegment *> *guideSegments;

///分组的红绿灯数量，注意:只针对驾车.
@property (nonatomic, assign) NSInteger trafficLightCount;

@end


// AMapNaviLink --组成--> AMapNaviSegment --组成--> AMapNaviRoute

#pragma mark - AMapNaviLink

///分段的Link信息
@interface AMapNaviLink : NSObject<NSCopying>

///Link的所有坐标
@property (nonatomic, strong) NSArray<AMapNaviPoint *> *coordinates;

///Link的长度(单位:米)
@property (nonatomic, assign) NSInteger length;

///Link的预估时间(单位:秒)
@property (nonatomic, assign) NSInteger time;

///Link的道路名称
@property (nonatomic, strong, nullable) NSString *roadName;

///Link的道路类型
@property (nonatomic, assign) AMapNaviRoadClass roadClass;

///Link的FormWay信息
@property (nonatomic, assign) AMapNaviFormWay formWay;

///Link是否有红绿灯
@property (nonatomic, assign) BOOL isHadTrafficLights;

///Link的路况信息. 注意:只针对驾车. since 6.3.0
@property (nonatomic, assign) AMapNaviRouteStatus trafficStatus;

///Link的类型. 注意:只针对驾车. since 6.3.0
@property (nonatomic, assign) AMapNaviLinkType linkType;

@end

#pragma mark - AMapNaviSegment

///路径的分段信息
@interface AMapNaviSegment : NSObject<NSCopying>

///分段的所有坐标
@property (nonatomic, strong) NSArray<AMapNaviPoint *> *coordinates;

///分段的所有Link
@property (nonatomic, strong) NSArray<AMapNaviLink *> *links;

///分段的长度(单位:米)
@property (nonatomic, assign) NSInteger length;

///分段的预估时间(单位:秒)
@property (nonatomic, assign) NSInteger time;

///分段的转向类型
@property (nonatomic, assign) AMapNaviIconType iconType;

///分段的收费路长度(单位:米). 注意:只针对驾车.
@property (nonatomic, assign) NSInteger chargeLength;

///分段的收费金额. 注意:只针对驾车.
@property (nonatomic, assign) NSInteger tollCost;

///分段的红绿灯数量
@property (nonatomic, assign) NSInteger trafficLightCount;

///分段是否到达途经点. 注意:只针对驾车.
@property (nonatomic, assign) BOOL isArriveWayPoint;

@end

#pragma mark - AMapNaviRoute

///导航路径信息
@interface AMapNaviRoute : NSObject<NSCopying>

///导航路径总长度(单位:米)
@property (nonatomic, assign) NSInteger routeLength;

///导航路径所需的时间(单位:秒)
@property (nonatomic, assign) NSInteger routeTime;

///导航路线最小坐标点和最大坐标点围成的矩形区域
@property (nonatomic, strong) AMapNaviPointBounds *routeBounds;

///导航路线的中心点，即导航路径的最小外接矩形对角线的交点
@property (nonatomic, strong) AMapNaviPoint *routeCenterPoint;

///导航路线的所有形状点
@property (nonatomic, strong) NSArray<AMapNaviPoint *> *routeCoordinates;

///路线方案的起点坐标
@property (nonatomic, strong) AMapNaviPoint *routeStartPoint;

///路线方案的终点坐标
@property (nonatomic, strong) AMapNaviPoint *routeEndPoint;

///导航路线的所有分段
@property (nonatomic, strong) NSArray<AMapNaviSegment *> *routeSegments;

///导航路线上分段的总数
@property (nonatomic, assign) NSInteger routeSegmentCount;

///导航路线上的所有电子眼. 注意:只针对驾车.
@property (nonatomic, strong, nullable) NSArray<AMapNaviCameraInfo *> *routeCameras;

///导航路线上红绿灯的总数
@property (nonatomic, assign) NSInteger routeTrafficLightCount;

///导航路线上的标签信息. 注意:只针对驾车. since 5.0.0
@property (nonatomic, strong, nullable) NSArray<AMapNaviRouteLabel *> *routeLabels;

///导航路线的花费金额(单位:元). 注意:只针对驾车.
@property (nonatomic, assign) NSInteger routeTollCost;

///路径的途经点坐标
@property (nonatomic, strong, nullable) NSArray<AMapNaviPoint *> *wayPoints __attribute__((deprecated("该字段已废弃，使用wayPointsInfo替代，since 6.7.0")));

///路径的途经点所在segment段的index
@property (nonatomic, strong, nullable) NSIndexPath *wayPointsIndexes __attribute__((deprecated("该字段已废弃，使用wayPointsInfo替代，since 6.7.0")));

///路径的途经点在routeCoordinates上对应的index
@property (nonatomic, strong, nullable) NSArray<NSNumber *> *wayPointCoordIndexes __attribute__((deprecated("该字段已废弃，使用wayPointsInfo替代，since 6.7.0")));

///路径限行信息. 注意:只针对驾车. since 5.0.0
@property (nonatomic, strong, nullable) AMapNaviRestrictionInfo *restrictionInfo;

///路径的路况信息. 注意:只针对驾车. since 5.1.0
@property (nonatomic, strong, nullable) NSArray<AMapNaviTrafficStatus *> *routeTrafficStatuses;

///路径的聚合段信息. 注意:只针对驾车. since 5.1.0
@property (nonatomic, strong, nullable) NSArray<AMapNaviGroupSegment *> *routeGroupSegments;

///路径经过的城市的adcode列表. 注意:只针对驾车. since 5.1.0
@property (nonatomic, strong, nullable) NSArray<NSNumber *> *routeCityAdcodes;

///路径的所有红绿灯坐标. 注意:只针对驾车. since 5.3.0
@property (nonatomic, strong, nullable) NSArray<AMapNaviPoint *> *routeTrafficLights;

///路径上的禁行标示信息. 注意:只针对驾车. since 6.0.0
@property (nonatomic, strong, nullable) NSArray<AMapNaviRouteForbiddenInfo *> *forbiddenInfo;

///道路设施信息. 注意:只针对驾车. since 6.0.0
@property (nonatomic, strong, nullable) NSArray<AMapNaviRoadFacilityInfo *> *roadFacilityInfo;

///路径的扎点. 注意:只针对驾车. since 6.3.0
@property (nonatomic, strong, nullable) NSArray<AMapNaviRouteIconPoint *> *routeIconPoints;

///道路交通事件信息. 注意:只针对驾车. since 6.4.0
@property (nonatomic, strong, nullable) NSArray<AMapNaviTrafficIncidentInfo *> *trafficIncidentInfo;

///路径的途径点相关信息, 具体参考 AMapNaviRouteWayPointInfo . 注意:只针对驾车. since 6.7.0
@property (nonatomic, strong, nullable) NSArray <AMapNaviRouteWayPointInfo *> *wayPointsInfo;

///根据路况生成的纹理索引数组, 可直接用于路线多彩线 MAMultiPolyline 的创建 .注意:只针对驾车. since 6.7.0
@property (nonatomic, strong, nullable) NSArray <NSNumber *> *drawStyleIndexes;

///当前路线的唯一标识ID . since 6.7.0
@property (nonatomic, assign) NSUInteger routeUID;

///路线详情信息.  since 7.5.0
@property (nonatomic, strong) NSArray <AMapNaviRouteGuideGroup *> *guideGroups;

@end

///导航路径信息集合.  since 7.7.0
@interface AMapNaviRouteGroup : NSObject<NSCopying>

- (nullable instancetype)init NS_UNAVAILABLE;

///当前默认选中导航路径的ID
@property (nonatomic, readonly) NSInteger naviRouteID;

///当前默认导航路径的信息,参考 AMapNaviRoute 类.
@property (nonatomic, readonly, nullable) AMapNaviRoute *naviRoute;

///多路径规划时的所有路径ID,路径ID为 NSInteger 类型.
@property (nonatomic, readonly, nullable) NSArray<NSNumber *> *naviRouteIDs;

///多路径规划时的所有路径信息,参考 AMapNaviRoute 类.
@property (nonatomic, readonly, nullable) NSDictionary<NSNumber *, AMapNaviRoute *> *naviRoutes;

/**
 * @brief 多路径规划时选择路径.注意:该方法仅限于在开始导航前使用,开始导航后该方法无效.
 * @param routeID 路径ID
 * @return 是否选择路径成功
 */
- (BOOL)selectNaviRouteWithRouteID:(NSInteger)routeID;

@end

NS_ASSUME_NONNULL_END
