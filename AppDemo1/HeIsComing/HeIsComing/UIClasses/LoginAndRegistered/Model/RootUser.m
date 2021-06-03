//
//  RootUser.m
//  xiaoyixiu
//
//  Created by 赵岩 on 16/6/22.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import "RootUser.h"

@implementation RootUser

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.validTime forKey:@"validTime"];
    [aCoder encodeObject:self.deviceId forKey:@"deviceId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.pictureUrl forKey:@"pictureUrl"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.email forKey:@"email"];


}

//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.validTime = [aDecoder decodeObjectForKey:@"validTime"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.deviceId = [aDecoder decodeObjectForKey:@"deviceId"];
        self.pictureUrl = [aDecoder decodeObjectForKey:@"pictureUrl"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.email  = [aDecoder decodeObjectForKey:@"email"];

        
    }
    return self;
}

@end
