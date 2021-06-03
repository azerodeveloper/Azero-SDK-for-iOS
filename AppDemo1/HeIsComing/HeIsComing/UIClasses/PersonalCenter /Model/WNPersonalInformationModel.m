//
//  WNPersonalInformationModel.m
//  WuNuo
//
//  Created by silk on 2019/4/5.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "WNPersonalInformationModel.h"

@implementation WNPersonalInformationModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.name = dict[@"name"];
        self.picture_url = dict[@"picture_url"];
        self.gender = [dict[@"gender"] intValue];
        self.birthday = dict[@"birthday"];
    }
    return self;
}
+ (instancetype)personalInformationModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.picture_url forKey:@"picture_url"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.picture_url = [aDecoder decodeObjectForKey:@"picture_url"];
    }
    return self;
}
@end
