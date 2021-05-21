//
//  XCYBlueToothPeripheralBusinessInterface.h
//  XCYBlueBox
//
//  Created by XCY on 2017/5/9.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol XCYBlueToothPeripheralBusinessInterface <NSObject>

@required

- (void)setMenufacture:(NSString *)facture;
/**
 Find equipment

 @param finishedHandler Return device list
 */
- (void)scanForPeripheralsComplectionHandler:(void(^)(NSArray<CBPeripheral*> *peripheralList, BOOL isScanSuccess))finishedHandler;

@optional

- (void)stopScan;


@end
