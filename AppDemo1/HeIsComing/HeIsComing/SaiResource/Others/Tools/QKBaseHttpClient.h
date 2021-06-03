//
//  QKBaseHttpClient.h
//  Sekey
//
//  Created by silk on 2017/4/1.
//  Copyright © 2017年 silk. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 实现的功能：对第三方网络请求AFNetworking做封装 提供公用的方法 可以进行不同类型的请求
 
 实现的原理：把当前类抽象成一个单例 在类的属性里 抽象一个session 主要通过session进行网络请求
 
 封装的优点：接口更加规范整洁 在封装的方法中 可以对请求的相关信息做验证并提示
 
 例如发起一个请求 调用请求方法 在方法内部 先检查当前的当前的网络状态 如果没有网络 直接回调错误的信息
 
 
 block进行回调
 枚举 区分不同类型的请求
 GCD 多线程处理 （AF中的方法也封装有）
 reachability 网络状态监测
 JSON解析 （XML解析）
 
 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"
// GET POST PUT DELETE 枚举值表示不同的请求类型
typedef enum {
    GET = 1,
    POST,
    PUT,
    DELETE,
}BASE_HTTP_TYPE;

//typedef block类型 方便表示一个block
typedef void(^httpSuccessBlock)(NSURL *URL, id data);
//成功时回调用的block 参数：请求的地址  回调的数据 id可以使字典也可以是数组
typedef void(^httpFailBlock)(NSURL *URL, NSError *error);
//失败时回调用的block 参数：请求的地址  失败的错误信息


@interface QKBaseHttpClient : NSObject
//属性的抽象

@property (nonatomic,strong)AFHTTPSessionManager *manager;
//AF 中的sessionManager 用于发起请求

@property (nonatomic,copy)NSString *baseURL;
//服务器地址 请求的“头”
//方法的抽象
//单例方法
+ (QKBaseHttpClient *)sharedClient;

+ (instancetype)sharedManager;
//公共的请求方法
+ (NSURL *)httpType:(BASE_HTTP_TYPE)type andURL:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucBlock andFailBlock:(httpFailBlock)failBlock;
//type：请求的方式
//url：请求的地址
//param：请求的参数
//block：成功或者失败回调的block
//返回值：目的是调用方式 可以通过返回值 知道是哪一个接口

//取消请求的方法
+ (void)cancelHTTPRequestOperations;

+ (NSURL *)updateHttpType:(BASE_HTTP_TYPE)type andURL:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucBlock andFailBlock:(httpFailBlock)failBlock;

@end
