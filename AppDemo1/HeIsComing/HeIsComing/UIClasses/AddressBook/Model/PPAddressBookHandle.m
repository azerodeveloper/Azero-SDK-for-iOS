//
//  PPDataHandle.m
//  PPAddressBook
//
//  Created by AndyPang on 16/8/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import "PPAddressBookHandle.h"


@interface PPAddressBookHandle ()

#ifdef __IPHONE_9_0
/** iOS9之后的通讯录对象*/
@property (nonatomic, strong) CNContactStore *contactStore;
#endif

@end

@implementation PPAddressBookHandle

singleton_m(AddressBookHandle)

- (void)requestAuthorizationWithSuccessBlock:(void(^)(bool authorization))success{
    // 1.判断是否授权成功,若授权成功直接return
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized){
        success(YES);
        return;
    }
    // 2.创建通讯录
    //CNContactStore *store = [[CNContactStore alloc] init];
    // 3.授权
    [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            success(YES);
            NSLog(@"授权成功");
        }else{
            success(NO);
            NSLog(@"授权失败");
        }
    }];
}


- (void)getAddressBookDataSource:(PPPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure authorizationWhetherOrNotToStop:(AuthorizationWhetherOrNotToStop)whetherOrNotToStop
{
    [self getDataSourceFrom_IOS9_Later:personModel authorizationFailure:failure authorizationWhetherOrNotToStop:whetherOrNotToStop];
}
#pragma mark - IOS9之后获取通讯录的方法
- (void)getDataSourceFrom_IOS9_Later:(PPPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure authorizationWhetherOrNotToStop:(AuthorizationWhetherOrNotToStop)whetherOrNotToStop
{
#ifdef __IPHONE_9_0
    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    // 2.如果没有授权,先执行授权失败的block后return
    if (status != CNAuthorizationStatusAuthorized)
    {
        failure ? failure() : nil;
        return;
    }
    // 3.获取联系人
    // 3.1.创建联系人仓库
    //CNContactStore *store = [[CNContactStore alloc] init];
    
    // 3.2.创建联系人的请求对象
    // keys决定能获取联系人哪些信息,例:姓名,电话,头像等
    NSArray *fetchKeys = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:fetchKeys];
    
    // 3.3.请求联系人
    [self.contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact,BOOL * _Nonnull stop) {
        
        // 获取联系人全名
        NSString *name = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
        
        // 创建联系人模型
        PPPersonModel *model = [PPPersonModel new];
        model.name = name.length > 0 ? name : @"无名氏" ;
        
        // 联系人头像
        model.headerImage = [UIImage imageWithData:contact.thumbnailImageData];
        
        // 获取一个人的所有电话号码
        NSArray *phones = contact.phoneNumbers;
        
        for (CNLabeledValue *labelValue in phones)
        {
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSString *mobile = [self removeSpecialSubString:phoneNumber.stringValue];
            [model.mobileArray addObject: mobile ? mobile : @"空号"];
        }
        
        //将联系人模型回调出去
        personModel ? personModel(model) : nil;
        
        if (whetherOrNotToStop) {
            whetherOrNotToStop(stop);
        }
    }];
#endif
    
}

//过滤指定字符串(可自定义添加自己过滤的字符串)
- (NSString *)removeSpecialSubString: (NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}

#pragma mark - lazy

#ifdef __IPHONE_9_0
- (CNContactStore *)contactStore
{
    if(!_contactStore)
    {
        _contactStore = [[CNContactStore alloc] init];
    }
    return _contactStore;
}
#endif

@end
