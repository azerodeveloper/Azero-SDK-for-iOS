//
//  SaiPhoneCallController.m
//  HeIsComing
//
//  Created by silk on 2020/5/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiPhoneCallController.h"

@implementation SaiPhoneCallController
//virtual
-(bool) dial:(NSString *)payload{
    dispatch_async(dispatch_get_main_queue(), ^{
                       NSDictionary *dic=[SaiJsonConversionModel dictionaryWithJsonString:payload];
                         NSDictionary*jsonDic=[SaiJsonConversionModel dictionaryWithJsonString:dic[@"callee"][@"details"]];
                         [[UIApplication   sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",jsonDic[@"context"]]] options:@{} completionHandler:nil];
        TYLog(@"%@",jsonDic);
                   });
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
