//
//  AzeroContactUploader.m
//  AzeroDemo
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroContactUploader.h"

class ContactUploaderWrapper : public aace::contactUploader::ContactUploader {
public:
    ContactUploaderWrapper(AzeroContactUploader *imp)
    : w (imp) {};
    
    void contactsUploaderStatusChanged( ContactUploaderStatus status, const std::string& info ) override {
        [w contactsUploaderStatusChanged:status withInfo:[[NSString alloc] initWithUTF8String:info.c_str()]];
    }
    
private:
    __weak AzeroContactUploader *w;
};


@implementation AzeroContactUploader
{
    std::shared_ptr<aace::contactUploader::ContactUploader> wrapper;
}

-(AzeroContactUploader *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<ContactUploaderWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(bool) addContactsBegin {
    return wrapper->addContactsBegin();
}

-(bool) addContactsEnd {
    return wrapper->addContactsEnd();
}

-(bool) addContactsCancel {
    return  wrapper->addContactsCancel();
}

-(bool) addContact:(NSString *)contact {
    return wrapper->addContact( [contact cStringUsingEncoding:NSUTF8StringEncoding] );
}

-(bool) removeUploadedContacts {
    return wrapper->removeUploadedContacts();
}

-(bool) updateContact:(NSString *)contact {
        return wrapper->updateContact( [contact cStringUsingEncoding:NSUTF8StringEncoding] );
}

-(NSString *) queryContact {
    auto str = wrapper->queryContact();
    return [[NSString alloc] initWithUTF8String:str.c_str()];
}

-(bool) deleteContact:(NSString *)contactId {
    return wrapper->deleteContact( [contactId cStringUsingEncoding:NSUTF8StringEncoding] );
}

-(bool) clearContacts {
    return wrapper->clearContacts();
}

-(void) contactsUploaderStatusChanged:(aace::contactUploader::ContactUploader::ContactUploaderStatus) status withInfo:(NSString *)info{
    
}
@end
