//
//  SaiPhoneCallController.m
//  AzeroDemo
//
//  Created by silk on 2020/5/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiPhoneCallController.h"

@implementation SaiPhoneCallController
//virtual
-(bool) dial:(NSString *)payload{
    //在此处处理打电话意图（payload为打电话的json信息）
    return true;
}
//virtual
-(bool) redial:(NSString *)payload{
    
    return true;
}
//virtual
-(void) answer:(NSString *)payload{
    
}
//virtual
-(void) stop:(NSString *)payload{
    
}
//virtual
-(void) sendDTMF:(NSString *)payload{
    
}
@end
