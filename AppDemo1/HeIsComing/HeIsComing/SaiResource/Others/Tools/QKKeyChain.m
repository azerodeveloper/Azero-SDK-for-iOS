//
//  QKKeyChain.m
//  KeyChainProj
//
//  Created by silk on 2017/4/19.
//  Copyright © 2017年 水蓝 Tech. All rights reserved.
//

#import "QKKeyChain.h"

@implementation QKKeyChain
//存
+ (void)saveKeyWith:(SecKeyRef)key andID:(NSString *)tag with:(id)keyType{
    NSData *dataTag = [tag dataUsingEncoding:NSUTF8StringEncoding];;
    NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:dataTag forKey:(__bridge id)kSecAttrApplicationTag];
    if ([keyType isEqual:(id)kSecAttrKeyTypeRSA]) {
        [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    }else{
        [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeEC forKey:(__bridge id)kSecAttrKeyType];
    }
    NSMutableDictionary * attributes = [queryPublicKey mutableCopy];
    [attributes setObject:(__bridge id)key forKey:(__bridge id)kSecValueRef];
    [attributes setObject:@YES forKey:(__bridge id)kSecReturnData];
    CFTypeRef result;
    OSStatus sanityCheck = noErr;
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) attributes, &result);
    if (sanityCheck == errSecSuccess) {
        TYLog(@"在keychian中存key成功");
    }else{
        TYLog(@"在keychian中存key失败");
    }
}

//检查是否存在
+ (BOOL )checkKeyExistingWith:(NSString *)tag with:(id)keyType{
    NSData *dataTag = [tag dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
    //    [queryPublicKey setObject:(__bridge id)kSecAttrTokenID forKey:(__bridge id)kSecAttrTokenIDSecureEnclave];
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:dataTag forKey:(__bridge id)kSecAttrApplicationTag];
    if ([keyType isEqual:(id)kSecAttrKeyTypeRSA]) {
        [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];                                              /// ---------RSA
    }else{
        [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeEC forKey:(__bridge id)kSecAttrKeyType];
    }
    OSStatus sanityCheck = noErr;
    SecKeyRef result = NULL;
    sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&result);
    if (sanityCheck == errSecSuccess) {
        return YES;
    }else{
        return NO;
    }
}
//取
+ (SecKeyRef)getKeyWith:(NSString *)tag with:(id)keyType{
    NSData *dataTag = [tag dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:dataTag forKey:(__bridge id)kSecAttrApplicationTag];
    if ([keyType isEqual:(id)kSecAttrKeyTypeRSA]) {
        [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];                                                    /// ---------RSA
    }else{
        [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeEC forKey:(__bridge id)kSecAttrKeyType];
    }
    [queryPublicKey setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnRef];
    OSStatus sanityCheck = noErr;
    SecKeyRef result = NULL;
    sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&result);
    if (sanityCheck == errSecSuccess) {
        return result;
    }else{
        return nil;
    }
}

//清除
+ (void)deleteKeyWith:(NSString *)tag with:(id)keyType{
    NSData *dataTag = [tag dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:dataTag forKey:(__bridge id)kSecAttrApplicationTag];
    if ([keyType isEqual:(id)kSecAttrKeyTypeRSA]) {
        [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];                                                            /// ---------RSA
    }else{
        [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeEC forKey:(__bridge id)kSecAttrKeyType];
    }
    OSStatus sanityCheck = noErr;
    sanityCheck = SecItemDelete((__bridge CFDictionaryRef)queryPublicKey);
    if (sanityCheck == errSecSuccess) {
        TYLog(@"在keychain中删除某个key成功");
    }else{
        TYLog(@"在keychain中删除某个key失败");
    }
}
//清除所有
+ (void)deleteAllKey{
    NSArray *secItemClasses = @[(__bridge id)kSecClassGenericPassword,
                                (__bridge id)kSecClassInternetPassword,
                                (__bridge id)kSecClassCertificate,
                                (__bridge id)kSecClassKey,
                                (__bridge id)kSecClassIdentity];
    for (id secItemClass in secItemClasses) {
        NSDictionary *spec = @{(__bridge id)kSecClass: secItemClass};
        SecItemDelete((__bridge CFDictionaryRef)spec);
    }
}
//更新某一个key
+ (BOOL)updateKeyWith:(NSString *)tag withkey:(SecKeyRef)key with:(id)keyType{
    //首先查找有没有
    if ([self checkKeyExistingWith:tag with:keyType]) {
        NSData *dataTag = [tag dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
        //        [queryPublicKey setObject:(__bridge id)kSecAttrTokenID forKey:(__bridge id)kSecAttrTokenIDSecureEnclave];
        [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
        [queryPublicKey setObject:dataTag forKey:(__bridge id)kSecAttrApplicationTag];
        if ([keyType isEqual:(id)kSecAttrKeyTypeRSA]) {
            [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];                                              /// ---------RSA
        }else{
            [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeEC forKey:(__bridge id)kSecAttrKeyType];
        }
        //    [queryPublicKey setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnRef];
//        OSStatus sanityCheck = noErr;
//        SecKeyRef result = NULL;
//        sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&result);
        
        NSMutableDictionary* update = [[NSMutableDictionary alloc]init];
//        [update setObject:(__bridge id)result forKey:(__bridge id)kSecValueRef];
        [update setObject:@YES forKey:(__bridge id)kSecReturnData];
        [update removeObjectForKey:(__bridge id)kSecClass];
        
        NSMutableDictionary* updateItem = [[NSMutableDictionary alloc] init];
        [updateItem setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
        [updateItem setObject:(__bridge id)key forKey:(__bridge id)kSecValueRef];
        [update setObject:@YES forKey:(__bridge id)kSecReturnData];
        
        OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)updateItem, (__bridge CFDictionaryRef)update);
        if (status == errSecSuccess) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

#pragma  mark ----------- 存储证书文件
//获取属性字典
+ (NSMutableDictionary*)getKeychainQuery: (NSString*)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword, (id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            nil];
}
/**
 *  存某一个数据并给它定义一个标记
 */
+ (BOOL)saveCertificate:(NSString*)service data:(id)data {
    NSMutableDictionary *keychainQueryDelete = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                (id)kSecClassGenericPassword, (id)kSecClass,
                                                service, (id)kSecAttrService,
                                                service, (id)kSecAttrAccount,
                                                nil];
    OSStatus sanityCheck = noErr;
    sanityCheck = SecItemDelete((__bridge CFDictionaryRef)keychainQueryDelete);
    if (sanityCheck == errSecSuccess) {
        TYLog(@"在keychian中删key成功");
    }else{
        TYLog(@"在keychian中删key失败: %d", (int)sanityCheck);
    }
    
    
    NSMutableDictionary *keychainQueryAdd = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             (id)kSecClassGenericPassword, (id)kSecClass,
                                             service, (id)kSecAttrService,
                                             service, (id)kSecAttrAccount,
                                             (id)kSecAttrAccessibleAlwaysThisDeviceOnly, (id)kSecAttrAccessible,
                                             nil];
    [keychainQueryAdd setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    CFTypeRef result;
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) keychainQueryAdd, &result);
    if (sanityCheck == errSecSuccess) {
        TYLog(@"在keychian中存key成功");
        return YES;
    }else{
        TYLog(@"在keychian中存key失败");
        return NO;
    }
}
/**
 *  删除证书数据
 */
+ (void)deleteCertificate:(NSString*)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}
/**
 *  查找某一个证书
 */
+ (BOOL)checkCertificateWith:(NSString *)service{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    OSStatus sanityCheck = noErr;
    SecKeyRef result = NULL;
    sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&result);
    if (sanityCheck == errSecSuccess) {
        TYLog(@"检测钥匙串中的%@ -------- 存在",service);
        return YES;
    }else{
        TYLog(@"检测钥匙串中的%@ -------- 没有",service);
        return NO;
    }
}
/**
 *  取得某一个证书
 */
+ (NSData *)getCertificateWith:(NSString *)service{
    id ret = NULL;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    OSStatus sanityCheck = noErr;
    NSData *result = NULL;
    sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef*)(void*)&result);
    if (sanityCheck == errSecSuccess) {
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:result];
        return ret;
    }else{
        return nil;
    }
}

+ (SecKeyRef)getPrivateKeyWithEcc{
    NSDictionary* attributes =
    @{ (id)kSecAttrKeyType:             (id)kSecAttrKeyTypeECSECPrimeRandom,
       (id)kSecReturnRef:       (id)kCFBooleanTrue,
       (id)kSecClass:             (id)kSecClassKey,
//       (id)kSecAttrApplicationTag: tagPrivate
       };
    SecKeyRef key = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)attributes,
                                          (CFTypeRef *)&key);
    if (status!=errSecSuccess) {
        return nil;
    }else{
        return key;
    }
}
+ (SecKeyRef)getPublicKeyWithEcc{
    NSDictionary* attributes =
    @{ (id)kSecAttrKeyType:             (id)kSecAttrKeyTypeECSECPrimeRandom,
       (id)kSecReturnRef:       (id)kCFBooleanTrue,
       (id)kSecClass:             (id)kSecClassKey,
//       (id)kSecAttrApplicationTag: tagPrivate
       };
    SecKeyRef key = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)attributes,
                                          (CFTypeRef *)&key);
    if (status!=errSecSuccess) {
        return nil;
    }else{
        SecKeyRef publicKey = SecKeyCopyPublicKey(key);
        return publicKey;
    }
}

+ (BOOL )checkPrivateKeyExisting{
    NSDictionary* attributes =
    @{ (id)kSecAttrKeyType:(id)kSecAttrKeyTypeECSECPrimeRandom,
       (id)kSecReturnRef:(id)kCFBooleanTrue,
       (id)kSecClass:(id)kSecClassKey,
//       (id)kSecAttrApplicationTag: tagPrivate
       };
    SecKeyRef key = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)attributes,
                                          (CFTypeRef *)&key);
    if (key) {
        CFRelease(key);
    }
    if (status!=errSecSuccess) {
        return NO;
    }else{
        return YES;
    }
}
+ (BOOL)deletePrivateKeyWithEcc{
    NSDictionary* attributes =
    @{ (id)kSecAttrKeyType:(id)kSecAttrKeyTypeECSECPrimeRandom,
       (id)kSecReturnRef:(id)kCFBooleanTrue,
       (id)kSecClass:(id)kSecClassKey,
//       (id)kSecAttrApplicationTag: tagPrivate
       };
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)attributes);
    if (status == 0) {
        return YES;
    }else{
        return NO;
    }
}

//AES加的 
+ (BOOL)keychainInsertValue:(NSString *)keyStr andService:(NSString *)service andAccount:(NSString *)account{
    NSDictionary *query = @{
                            (__bridge id)kSecAttrAccessible :(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly,
                            (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecValueData : [keyStr dataUsingEncoding:NSUTF8StringEncoding],
                            (__bridge id)kSecAttrAccount : account,
                            (__bridge id)kSecAttrService : service,
                            };
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query,nil);
    if (status == errSecSuccess) {
        TYLog(@"keychain添加成功--%d ------ %@",(int)status,account);
        return YES;
    }else{
        TYLog(@"keychain添加失败--%d ------ %@",(int)status,account);
        return NO;
    }
}
+ (BOOL)keychianDeleteValueWithService:(NSString *)service andAccount:(NSString *)account{
    NSDictionary *query = @{
                            (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService : service,
                            (__bridge id)kSecAttrAccount : account
                            };
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    if (status == errSecSuccess || status == errSecItemNotFound) {
        return YES;
    }else{
        TYLog(@"keychain删除失败--%d",(int)status);
        return NO;
    }
}
+ (BOOL)keychianUpdateValue:(NSString *)keyStr andService:(NSString *)service andAccount:(NSString *)account{
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount : account,
                            (__bridge id)kSecAttrService : service,
                            };
    NSDictionary *update = @{
                             (__bridge id)kSecValueData : [keyStr dataUsingEncoding:NSUTF8StringEncoding],
                             };
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)update);
    if (status == errSecSuccess) {
        return YES;
    }else{
        TYLog(@"keychain更新失败--%d",(int)status);
        return NO;
    }
}

+ (NSString *)keychianQueryValueWithService:(NSString *)service andAccount:(NSString *)account{
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecReturnData : @YES,
                            (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne,
                            (__bridge id)kSecAttrAccount : account,
                            (__bridge id)kSecAttrService : service,
                            };
    CFTypeRef dataTypeRef = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &dataTypeRef);
    if (status == errSecSuccess) {
        NSString *keyStr = [[NSString alloc] initWithData:(__bridge NSData * _Nonnull)(dataTypeRef) encoding:NSUTF8StringEncoding];
        return keyStr;
    }else{
        TYLog(@"keychain 读取失败 -- %d", (int)status);
        return nil;
    }
}


@end
