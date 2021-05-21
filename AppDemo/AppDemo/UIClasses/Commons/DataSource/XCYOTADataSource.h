//
//  XCYOTADataSource.h
//  XCYBlueBox
//
//  Created by XCY on 2017/5/10.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCYOTADataSource : NSObject

- (NSData *)getOtaEntryData;

//The bluetooth address
- (NSData *)getOTABLEData;

//Get the bin file data that the customer copies to the app
- (NSData *)getDocumentDataWithDataName:(NSString *)name;

//The last four bytes of data
- (NSData *)getLastFourSizeDataWithDataName:(NSString *)name;

- (NSData *)chocieOTATypeData:(NSData *)totalData;

// Get current version
- (NSData *)getCurrentVersion;

// new image side
- (NSData *)getImageSideWithIndex:(NSInteger)type;

// Image OverWriting Confirmation
- (NSData *)getImageOverWritingConfirmation;

// break point check
- (NSData *)breakcCheckPoint:(NSData *)totalData type:(NSString *)type;

@end
