//
//  MyAzeroExpress.m
//  AzeroDemo
//
//  Created by silk on 2020/4/1.
//  Copyright © 2020 soundai. All rights reserved.
// 

#import "MyAzeroExpress.h"

@interface MyAzeroExpress ()
@property (nonatomic ,copy) myAzeroExpressBlcok azeroExpressHandle;
@end
@implementation MyAzeroExpress
-(void) handleExpressDirectiveFor:(NSString *)name withPayload:(NSString *)payload{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"AzeroSubclass -------name:%@ ------- payload:%@ ",name,payload);
        if (self.azeroExpressHandle) {
            self.azeroExpressHandle(name, payload);
        }
    });
}
- (void)saiAzeroExpressObtainData:(myAzeroExpressBlcok )azeroExpress{
    if (azeroExpress) {
        self.azeroExpressHandle = azeroExpress;
    }
}
@end
