//
//  SaiGameRulesModel.m
//  
//  Created by  on 2020/04/27.
//  Copyright © 2020年 . All rights reserved.
//

#import "SaiGameRulesModel.h"


@implementation SaiGameRulesModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"pageDisplay" : NSClassFromString(@"SaiGameRulesModelPageDisplay")};
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


@implementation SaiGameRulesModelPageDisplay

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"contents" : NSClassFromString(@"NSString")};
}


@end


@implementation SaiGameRulesModelPageDisplayContents

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{};
}


@end
