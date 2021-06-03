//
//  SaiHomePageBallModel.m
//  
//  Created by  on 2020/04/02.
//  Copyright © 2020年 . All rights reserved.
//

#import "SaiHomePageBallModel.h"


@implementation SaiHomePageBallModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"items" : NSClassFromString(@"SaiHomePageBallModelItems"),@"controls" : NSClassFromString(@"SaiHomePageBallModelControls")};
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


@implementation SaiHomePageBallModelItems

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"query" : NSClassFromString(@"NSString")};
}


@end


@implementation SaiHomePageBallModelItemsQuery

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{};
}


@end
@implementation SaiHomePageBallModelControls

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{};
}


@end

@implementation SaiHomePageBallModelContent

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{};
}


@end

