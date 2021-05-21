//
//  CoreBluetoothManager.h
//  DMRentEnterprise
//
//  Created by Jone on 01/12/2016.
//  Copyright © 2016 Jone. All rights reserved.
//

#import <Foundation/Foundation.h>



@class CBPeripheral;


typedef void(^HeadsetModelBlock)(NSString *headsetModel);
typedef void(^HeadsetBatteryBlock)(NSString *headsetBattery);

@interface CoreBluetoothManager : NSObject

singleton_h(CoreBluetoothManager);

@property (nonatomic, strong, readonly) NSArray<CBPeripheral *> *peripherals;

@property (nonatomic, strong)HeadsetModelBlock headsetModelBlock;
@property (nonatomic, strong)HeadsetBatteryBlock headsetBatteryBlock;


@property (nonatomic, strong)void (^nextBlock) (void);



-(void)setUp;
-(void)getdata;


-(void)setHeadsetModel:(NSString *)headsetModel ;

-(void)cancelPeripheralConnection;
- (void)scanForPeripherals;

@end
