//
//  XCYOTAFileBusiness.h
//  XCYBlueBox
//
//  Created by XCY on 2017/4/23.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCYOTAFileBusiness : NSObject

- (NSArray<NSString *> *)getOTAOtherFileListWithType:(NSString *)type;
- (NSArray<NSString *> *)getOTAbinFileList;
@end
