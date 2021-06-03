//
//  RootUser.h
//  xiaoyixiu
//
//  Created by 赵岩 on 16/6/22.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootUser : NSObject<NSCoding>

@property(nonatomic, strong)NSString *mobile;
@property(nonatomic, strong)NSString *token;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *validTime;
@property(nonatomic, strong)NSString *deviceId;
@property(nonatomic, strong)NSString *pictureUrl;
@property(nonatomic, strong)NSString *sex;
@property(nonatomic, strong)NSString *birthday;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *refresh_token;
@property(nonatomic, strong)NSString *email;




@end
