#import "AzeroVersionHandler.h"

@implementation AzeroVersionHandler

-(NSString *) getAzeroSDKVersion {
    auto str = getAzeroVersion();
    return [[NSString alloc] initWithUTF8String:str];
}

@end