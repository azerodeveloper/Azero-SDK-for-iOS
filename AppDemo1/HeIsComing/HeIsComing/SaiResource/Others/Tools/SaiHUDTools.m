//
//  SaiHUDTools.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/12/10.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "SaiHUDTools.h"

@implementation SaiHUDTools

+ (void)load{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
}

+ (void)setDefaultMaskType:(SaiProgressHUDMaskType)type{
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskType)type];
}

+ (void)showMessage:(NSString *)msg{
    [SVProgressHUD showWithStatus:msg];
}

+ (void)hideHUD{
    [SVProgressHUD dismiss];
}

+ (void)showSuccess:(NSString *)msg{
    [SVProgressHUD showSuccessWithStatus:msg];
}

+ (void)showError:(NSString *)msg{
    [SVProgressHUD showErrorWithStatus:msg];
}



@end
