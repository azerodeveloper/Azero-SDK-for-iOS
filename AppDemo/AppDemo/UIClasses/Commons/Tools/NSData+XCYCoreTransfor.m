//
//  XCYCoreTransfor
//  CMBCBaseCore
//
//  Created by XCYCoreTransfor on 15/7/22.
//  Copyright (c) 2015年 XCYCoreTransfor. All rights reserved.
//

#import "NSData+XCYCoreTransfor.h"
#include <zlib.h>


@implementation NSData (CMBCCoreTransfor)


- (uint32_t)CRC32Value_xcy {
    
    uLong crc = crc32(0L, Z_NULL, 0);
    crc = crc32(crc, [self bytes], (uInt)[self length]);
    return (uint32_t)crc;
}

@end
