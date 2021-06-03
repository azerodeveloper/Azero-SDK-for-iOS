//
//  SaiAlertView.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/12/10.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "JySaiAlertView.h"
@interface JySaiAlertView ()<UIAlertViewDelegate>
@property (nonatomic ,copy) cancelButtonCallBack cancelButtonHandle;
@property (nonatomic ,copy) otherButtonCallBack otherButtonHandle;
@end
@implementation JySaiAlertView

// 自定义 确定 和 取消按钮
-(instancetype)initMessageWithTitle:(NSString * __nullable)title message:(NSString* __nullable)message OKButtonText:( NSString *__nullable)okText cancelButtonText:( NSString  * __nullable)cancelText otherBlock:(otherButtonCallBack)otherCallback cancelBlock:(cancelButtonCallBack)cancelCallBack {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelText otherButtonTitles:okText, nil];//注意这里初始化父类的
    
    if (self) {
        if (cancelCallBack) {
            self.cancelButtonHandle = cancelCallBack;
        }
        
        if (otherCallback) {
            self.otherButtonHandle = otherCallback;
        }
        
    }
    return self;
}

// 自定义 确定按钮
- (instancetype)initMessageWithTitle:(NSString *)title OKButtonText:(NSString *)okText otherBlock:(otherButtonCallBack)otherCallback cancelBlock:(cancelButtonCallBack)cancelCallBack {
    return [self initMessageWithTitle:title message:@"" OKButtonText:okText cancelButtonText:@"取消" otherBlock:otherCallback cancelBlock:cancelCallBack];
}

// 不自定义按钮
-(instancetype)initMessageWithTitle:(NSString *)title otherBlock:(otherButtonCallBack)otherCallback cancelBlock:(cancelButtonCallBack)cancelCallBack {
    
    return [self initMessageWithTitle:title  OKButtonText:@"确定" otherBlock:otherCallback cancelBlock:cancelCallBack];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        if (self.cancelButtonHandle) {
            self.cancelButtonHandle();
        }
        
    } else {
        
        if (self.otherButtonHandle) {
            self.otherButtonHandle();
        }
    }
}

@end
