//
//  SaiBallModel.m
//  
//  Created by  on 2020/04/01.
//  Copyright © 2020年 . All rights reserved.
//

#import "SaiBallModel.h"


@implementation SaiBallModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription",@"template":@"templateModel"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{};
}

+ (instancetype)modelWithJson:(id)json {

    id model = nil;
    if ([json isKindOfClass:[NSString class]] || [json isKindOfClass:[NSDictionary class]]){
        model = [self modelWithJSON:json];
    }else if([json isKindOfClass:[NSArray class]]){
        model = [NSArray modelArrayWithClass:self json:json].mutableCopy;
    }
    return model;
}


@end


@implementation SaiBallModelTemplate

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"items" : NSClassFromString(@"SaiBallModelTemplateItems")};
}


@end


@implementation SaiBallModelTemplateItems

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"query" : NSClassFromString(@"NSString")};
}


@end


@implementation SaiBallModelTemplateItemsQuery

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{};
}


@end
