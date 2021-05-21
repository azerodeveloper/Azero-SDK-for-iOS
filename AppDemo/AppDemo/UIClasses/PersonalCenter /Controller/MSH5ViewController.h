//
//  MSH5ViewController.h
//  WuNuo
//
//  Created by silk on 2019/7/16.  
//  Copyright © 2019 soundai. All rights reserved.
//

#import "SaiPersonalRootController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSH5ViewController : SaiPersonalRootController
@property (nonatomic ,copy) NSString *h5Title;
/**
 *  加载的H5地址
 */
@property (nonatomic, copy) NSString *H5Url;

@property (nonatomic ,assign) BOOL isRegister;

@end

NS_ASSUME_NONNULL_END
