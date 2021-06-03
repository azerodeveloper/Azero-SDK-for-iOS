//
//  CodeViewController.h
//  HeIsComing
//
//  Created by mike on 2020/3/24.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiBaseRootController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CodeViewController : UIViewController

@property(nonatomic,copy)NSString *verificationId;
@property(nonatomic,copy)NSString *phoneString;
@property(nonatomic,copy)NSString *codeString;

@end

NS_ASSUME_NONNULL_END
