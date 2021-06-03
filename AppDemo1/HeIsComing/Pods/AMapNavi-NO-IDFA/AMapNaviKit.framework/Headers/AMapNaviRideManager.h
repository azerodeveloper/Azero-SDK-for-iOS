//
//  AMapNaviRideManager.h
//  AMapNaviKit
//
//  Created by liubo on 9/19/16.
//  Copyright © 2016 Amap. All rights reserved.
//

#import "AMapNaviTravelManager.h"
#import "AMapNaviRideDataRepresentable.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AMapNaviRideManagerDelegate;

#pragma mark - AMapNaviRideManager

///骑行导航管理类
@interface AMapNaviRideManager : AMapNaviTravelManager

#pragma mark - Singleton

/**
 * @brief AMapNaviRideManager单例. since 7.4.0
 * @return AMapNaviRideManager实例
 */
+ (AMapNaviRideManager *)sharedInstance;

/**
 * @brief 销毁AMapNaviRideManager单例. since 7.4.0
 * @return 是否销毁成功. 如果返回NO，请检查单例是否被强引用
 */
+ (BOOL)destroyInstance;

/**
 * @brief 请使用单例替代. since 7.4.0 init已被禁止使用，请使用单例 [AMapNaviRideManager sharedInstance] 替代
 */
- (instancetype)init __attribute__((unavailable("since 7.4.0 init 已被禁止使用，请使用单例 [AMapNaviRideManager sharedInstance] 替代")));

#pragma mark - Delegate

///实现了 AMapNaviRideManagerDelegate 协议的类指针
@property (nonatomic, weak) id<AMapNaviRideManagerDelegate> delegate;

#pragma mark - Data Representative

/**
 * @brief 增加用于展示导航数据的DataRepresentative.注意:该方法不会增加实例对象的引用计数(Weak Reference)
 * @param aRepresentative 实现了 AMapNaviRideDataRepresentable 协议的实例
 */
- (void)addDataRepresentative:(id<AMapNaviRideDataRepresentable>)aRepresentative;

/**
 * @brief 移除用于展示导航数据的DataRepresentative
 * @param aRepresentative 实现了 AMapNaviRideDataRepresentable 协议的实例
 */
- (void)removeDataRepresentative:(id<AMapNaviRideDataRepresentable>)aRepresentative;

#pragma mark - Navi Route

///当前导航路径的ID
@property (nonatomic, readonly) NSInteger naviRouteID;

///当前导航路径的信息,参考 AMapNaviRoute 类.
@property (nonatomic, readonly, nullable) AMapNaviRoute *naviRoute;

/**
 * @brief 多路径规划时的所有路径信息 since 7.5.0
 * @return 返回多路径规划时的所有路径ID和路线信息
 */
- (NSDictionary<NSNumber *,AMapNaviRoute *> *)naviRoutes;


/**
 * @brief 多路径规划时的所有路径ID,路径ID为 NSInteger 类型 since 7.5.0
 * @return 返回多路径规划时的所有路径ID
 */
- (NSArray<NSNumber *> *)naviRouteIDs;

/**
 * @brief 多路径规划时选择路径.注意:该方法仅限于在开始导航前使用,开始导航后该方法无效 since 7.5.0
 * @param routeID 路径ID
 * @return 是否选择路径成功
 */
- (BOOL)selectNaviRouteWithRouteID:(NSInteger)routeID;

#pragma mark - Options

///偏航时是否重新计算路径,默认YES(需要联网).
@property (nonatomic, assign) BOOL isRecalculateRouteForYaw __attribute__((deprecated("已废弃，默认进行重算，since 7.4.0")));

///卫星定位信号强度类型, 参考 AMapNaviGPSSignalStrength . since 7.4.0
@property (nonatomic, assign, readonly) AMapNaviGPSSignalStrength gpsSignalStrength;

#pragma mark - Calculate Route

// 以下算路方法需要高德坐标(GCJ02)

/**
 * @brief 不带起点的骑行路径规划
 * @param endPoint 终点坐标.
 * @return 规划路径所需条件和参数校验是否成功，不代表算路成功与否
 */
- (BOOL)calculateRideRouteWithEndPoint:(AMapNaviPoint *)endPoint;

/**
 * @brief 带起点的骑行路径规划
 * @param startPoint   起点坐标.
 * @param endPoint     终点坐标.
 * @return 规划路径所需条件和参数校验是否成功，不代表算路成功与否
 */
- (BOOL)calculateRideRouteWithStartPoint:(AMapNaviPoint *)startPoint
                                endPoint:(AMapNaviPoint *)endPoint;

/**
 * @brief 根据高德POIInfo进行骑行路径规划. since 7.5.0
 * @param startPOIInfo  起点POIInfo, 参考 AMapNaviPOIInfo. 如果以“我的位置”作为起点,请传nil. 如果startPOIInfo不为nil,那么POIID合法,优先使用ID参与算路,否则使用坐标点
 * @param endPOIInfo  终点POIInfo, 参考 AMapNaviPOIInfo. 如果POIID合法,优先使用ID参与算路,否则使用坐标点. 注意:POIID和坐标点不能同时为空
 * @param strategy  路径的计算策略，参考 AMapNaviTravelStrategy.
 * @return 规划路径所需条件和参数校验是否成功，不代表算路成功与否
*/
- (BOOL)calculateRideRouteWithStartPOIInfo:(nullable AMapNaviPOIInfo *)startPOIInfo
                                endPOIInfo:(nonnull AMapNaviPOIInfo *)endPOIInfo
                                  strategy:(AMapNaviTravelStrategy)strategy;
/**
 * @brief 独立算路能力接口，可用于不干扰本次导航的单独算路场景. since 7.7.0
 * @param startPOIInfo  起点POIInfo, 参考 AMapNaviPOIInfo. 如果以“我的位置”作为起点,请传nil. 如果startPOIInfo不为nil,那么POIID合法,优先使用ID参与算路,否则使用坐标点
 * @param endPOIInfo  终点POIInfo, 参考 AMapNaviPOIInfo. 如果POIID合法,优先使用ID参与算路,否则使用坐标点. 注意:POIID和坐标点不能同时为空
 * @param strategy  路径的计算策略，参考 AMapNaviTravelStrategy.
 * @callback 算路完成的回调.  算路成功时，routeGroup 不为空；算路失败时，error 不为空，error.code参照 AMapNaviCalcRouteState.
 * @return 规划路径所需条件和参数校验是否成功，不代表算路成功与否
 */
- (BOOL)independentCalculateRideRouteWithStartPOIInfo:(nullable AMapNaviPOIInfo *)startPOIInfo
                                           endPOIInfo:(nonnull AMapNaviPOIInfo *)endPOIInfo
                                             strategy:(AMapNaviTravelStrategy)strategy
                                             callback:(nullable void (^)(AMapNaviRouteGroup *_Nullable routeGroup, NSError *_Nullable error))callback;
/**
 * @brief 导航过程中重新规划路径(起点为当前位置,终点位置不变)
 * @return 重新规划路径所需条件和参数校验是否成功， 不代表算路成功与否，如非导航状态下调用此方法会返回NO.
 */
- (BOOL)recalculateRideRoute;

#pragma mark - Manual

/**
 * @brief 设置TTS语音播报每播报一个字需要的时间.根据播报一个字的时间和运行的速度,可以更改语音播报的触发时机.
 * @param time 每个字的播放时间(范围:[250,500]; 单位:毫秒)
 */
- (void)setTimeForOneWord:(int)time __attribute__((deprecated("已废弃，使用 setIsPlayingTTS: 替代，since 7.4.0")));

/**
 * @brief 开发者请根据实际情况设置外界此时是否正在进行语音播报. since 7.4.0
 * @param playing  如果外界正在播报语音，传入YES，否则传入NO.
*/
- (void)setTTSPlaying:(BOOL)playing;

#pragma mark - Statistics Information

/**
 * @brief 获取导航统计信息
 * @return 导航统计信息,参考 AMapNaviStatisticsInfo 类.
 */
- (nullable AMapNaviStatisticsInfo *)getNaviStatisticsInfo __attribute__((deprecated("已废弃，since 7.4.0")));

@end

#pragma mark - AMapNaviRideManagerDelegate

@protocol AMapNaviRideManagerDelegate <NSObject>
@optional

/**
 * @brief 发生错误时,会调用代理的此方法
 * @param rideManager 骑行导航管理类
 * @param error 错误信息
 */
- (void)rideManager:(AMapNaviRideManager *)rideManager error:(NSError *)error;

/**
 * @brief 骑行路径规划成功后的回调函数
 * @param rideManager 骑行导航管理类
 */
- (void)rideManagerOnCalculateRouteSuccess:(AMapNaviRideManager *)rideManager;

/**
 * @brief 骑行路径规划失败后的回调函数. 从6.1.0版本起,算路失败后导航SDK只对外通知算路失败,SDK内部不再执行停止导航的相关逻辑.因此,当算路失败后,不会收到 driveManager:updateNaviMode: 回调; AMapNaviRideManager.naviMode 不会切换到 AMapNaviModeNone 状态, 而是会保持在 AMapNaviModeGPS or AMapNaviModeEmulator 状态
 * @param rideManager 骑行导航管理类
 * @param error 错误信息,error.code参照AMapNaviCalcRouteState
 */
- (void)rideManager:(AMapNaviRideManager *)rideManager onCalculateRouteFailure:(NSError *)error;

/**
 * @brief 启动导航后回调函数
 * @param rideManager 骑行导航管理类
 * @param naviMode 导航类型，参考AMapNaviMode
 */
- (void)rideManager:(AMapNaviRideManager *)rideManager didStartNavi:(AMapNaviMode)naviMode;

/**
 * @brief 出现偏航需要重新计算路径时的回调函数.偏航后将自动重新路径规划,该方法将在自动重新路径规划前通知您进行额外的处理.
 * @param rideManager 骑行导航管理类
 */
- (void)rideManagerNeedRecalculateRouteForYaw:(AMapNaviRideManager *)rideManager;

/**
 * @brief 导航播报信息回调函数
 * @param rideManager 骑行导航管理类
 * @param soundString 播报文字
 * @param soundStringType 播报类型,参考 AMapNaviSoundType. 注意：since 6.0.0 AMapNaviSoundType 只返回 AMapNaviSoundTypeDefault
 */
- (void)rideManager:(AMapNaviRideManager *)rideManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType;

/**
 * @brief 模拟导航到达目的地停止导航后的回调函数
 * @param rideManager 骑行导航管理类
 */
- (void)rideManagerDidEndEmulatorNavi:(AMapNaviRideManager *)rideManager;

/**
 * @brief 导航到达目的地后的回调函数
 * @param rideManager 骑行导航管理类
 */
- (void)rideManagerOnArrivedDestination:(AMapNaviRideManager *)rideManager;

/**
 * @brief 卫星定位信号强弱回调函数. since 7.4.0
 * @param rideManager 骑行导航管理类
 * @param gpsSignalStrength 卫星定位信号强度类型,参考 AMapNaviGPSSignalStrength .
 */
- (void)rideManager:(AMapNaviRideManager *)rideManager updateGPSSignalStrength:(AMapNaviGPSSignalStrength)gpsSignalStrength;

@end

NS_ASSUME_NONNULL_END
