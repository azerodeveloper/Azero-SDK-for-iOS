//
//  QKKeyChain.h
//  KeyChainProj
//
//  Created by silk on 2017/4/19.
//  Copyright © 2017年 水蓝 Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKKeyChain : NSObject
+ (void)saveKeyWith:(SecKeyRef)key andID:(NSString *)tag with:(id)keyType;
+ (BOOL )checkKeyExistingWith:(NSString *)tag with:(id)keyType;
+ (SecKeyRef)getKeyWith:(NSString *)tag with:(id)keyType;
+ (void)deleteKeyWith:(NSString *)tag with:(id)keyType;
+ (void)deleteAllKey;
+ (BOOL)updateKeyWith:(NSString *)tag withkey:(SecKeyRef)key with:(id)keyType;

//存储证书文件  和  uuid
+ (BOOL)saveCertificate:(NSString*)service data:(id)data;
+ (void)deleteCertificate:(NSString*)service;
+ (BOOL)checkCertificateWith:(NSString *)service;
+ (NSData *)getCertificateWith:(NSString *)service;

+ (SecKeyRef)getPrivateKeyWithEcc;
+ (SecKeyRef)getPublicKeyWithEcc;
+ (BOOL)checkPrivateKeyExisting;
+ (BOOL)deletePrivateKeyWithEcc;


+ (BOOL)keychainInsertValue:(NSString *)keyStr andService:(NSString *)service andAccount:(NSString *)account;
+ (BOOL)keychianDeleteValueWithService:(NSString *)service andAccount:(NSString *)account;
+ (BOOL)keychianUpdateValue:(NSString *)keyStr andService:(NSString *)service andAccount:(NSString *)account;
+ (NSString *)keychianQueryValueWithService:(NSString *)service andAccount:(NSString *)account;



@end
