//
//  SaiBlueManager.h
//  HeIsComing
//
//  Created by mike on 2020/11/18.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCYBlueToothPeripheralBusinessInterface.h"
#import "XCYOTABusiness.h"
#import "XCYOTADataSource.h"
#import "XCYOTAFileBusiness.h"
#import "XCYOTASettingDataDo.h"
#import "XCYOTAInHouseFactory.h"
#import "XCYOTANewUpdateBusiness.h"
#import "BESCurrentVersionType.h"

#import "LDDownloadManager.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^HeadsetModelBlock)(NSString *headsetModel);
typedef void(^HeadsetBatteryBlock)(NSString *headsetBattery);


@interface SaiBlueManager : NSObject<XCYOTAUpdateEventDelegate>

singleton_h(SaiBlueManager);
@property (strong, nonatomic) XCYOTABusiness *otaBusiness;
@property (strong, nonatomic) CBPeripheral *curPeripheral;
@property (strong, nonatomic) XCYOTADataSource *otaDataSource;
@property (strong, nonatomic) NSString *currentVersionStr;
@property (assign, nonatomic) BESCurrentVersionType currentVersionType;
@property (strong, nonatomic) XCYOTAFileBusiness *fileBusiness;
@property (strong, nonatomic) NSArray<NSString *> *tableList;
//@property (assign, nonatomic) BesFileSelectViewType fileType;
@property (strong, nonatomic) NSString *left_curUpgradeFilePath;
@property (strong, nonatomic) XCYOTASettingDataDo *curSettingData;
@property (assign, nonatomic) BOOL isSecondLap;
@property (strong, nonatomic) NSData *curTotalData;
@property (assign, nonatomic) NSUInteger value_segment;
@property (assign, nonatomic) NSUInteger FileSelectSame_Count;
@property (strong, nonatomic) NSString *left_breakpoint;
@property (strong, nonatomic) NSString *right_breakpoint;
@property (strong, nonatomic) id<XCYBlueToothPeripheralBusinessInterface> peripheralBusiness;
@property (strong, nonatomic) id<XCYOTAUpdateBusinessInterface> updateBusiness;

@property (nonatomic, strong)HeadsetModelBlock headsetModelBlock;
@property (nonatomic, strong)HeadsetBatteryBlock headsetBatteryBlock;
@property (nonatomic, strong)void(^proccessBlock)(CGFloat aProgress);
@property (nonatomic, strong)void(^versionBlock)(NSString * version);
@property (nonatomic, strong)void(^otaUpdateSuccessdBlock)(void);

-(void)setUp;
//开始升级
- (void)choiceUpgradeFile ;

-(void)disConnect;

@end

NS_ASSUME_NONNULL_END
