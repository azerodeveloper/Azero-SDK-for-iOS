//
//  PPDataHandle.h
//  PPAddressBook
//
//  Created by AndyPang on 16/8/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import "PPPersonModel.h"


/** 一个联系人的相关信息*/
typedef void(^PPPersonModelBlock)(PPPersonModel *model);
/** 授权失败的Block*/
typedef void(^AuthorizationFailure)(void);
/** 联系人获取是否停止*/
typedef void(^AuthorizationWhetherOrNotToStop)(BOOL stop);




@interface PPAddressBookHandle : NSObject

singleton_h(AddressBookHandle)


/**
 请求用户通讯录授权

 @param success 授权成功的回调
 */
- (void)requestAuthorizationWithSuccessBlock:(void(^)(bool authorization))success;

/**
 *  返回每个联系人的模型
 *
 *  @param personModel 单个联系人模型
 *  @param failure     授权失败的Block
 */
- (void)getAddressBookDataSource:(PPPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure authorizationWhetherOrNotToStop:(AuthorizationWhetherOrNotToStop)whetherOrNotToStop;

@end
