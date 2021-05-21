//
//  AzeroContactUploader.h
//  AzeroDemo
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"

#include <AACE/ContactUploader/ContactUploader.h>

NS_ASSUME_NONNULL_BEGIN

@interface AzeroContactUploader : AzeroPlatformInterface

-(void) contactsUploaderStatusChanged:(aace::contactUploader::ContactUploader::ContactUploaderStatus) status withInfo:(NSString *)info;

-(bool) addContactsBegin;//1
-(bool) addContactsEnd;//3
-(bool) addContactsCancel;
-(bool) addContact:(NSString *)contact;//2
-(bool) removeUploadedContacts;
-(bool) updateContact:(NSString *)contact;
-(NSString *) queryContact;
-(bool) deleteContact:(NSString *)contactId;
-(bool) clearContacts;

@end

NS_ASSUME_NONNULL_END
