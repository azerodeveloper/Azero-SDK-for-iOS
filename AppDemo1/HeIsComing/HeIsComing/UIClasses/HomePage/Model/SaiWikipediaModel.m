//
//  SaiWikipediaModel.m
//  
//  Created by  on 2020/04/02.
//  Copyright © 2020年 . All rights reserved.
//

#import "SaiWikipediaModel.h"


@implementation SaiWikipediaModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
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


@implementation SaiWikipediaModelExtField

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{};
}


@end


@implementation SaiWikipediaModelTitle

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{};
}


@end


@implementation SaiWikipediaModelBackgroundImage

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"sources" : NSClassFromString(@"SaiWikipediaModelBackgroundImageSources")};
}


@end


@implementation SaiWikipediaModelBackgroundImageSources

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {

    return @{@"Id":@"id",@"Discription":@"discription"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{};
}


@end
