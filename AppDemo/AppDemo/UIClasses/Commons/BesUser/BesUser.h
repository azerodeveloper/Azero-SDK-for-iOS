//
//  BesUser.h
//  XCYBlueBox
//
//  Created by max on 2019/3/22.
//  Copyright © 2019 XCY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BesUser : NSObject

@property (nonatomic, strong) NSString* selected_left_filePath; // 上一次选择的升级文件路径
@property (nonatomic, strong) NSString* selected_right_filePath; // 上一次选择的升级文件路径
@property (nonatomic, assign) BOOL is_secondLap; // 是否第二圈升级
@property (nonatomic, assign) NSInteger user_fileType; // 升级方式
@property (nonatomic, assign) NSUInteger MTU_Exchange;

+ (BesUser*)sharedUser;

@end

NS_ASSUME_NONNULL_END
