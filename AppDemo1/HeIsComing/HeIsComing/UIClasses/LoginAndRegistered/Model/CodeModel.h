//
//  CodeModel.h
//  HeIsComing
//
//  Created by mike on 2020/3/24.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DataModel;
@interface CodeModel : NSObject
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , copy) NSString              * message;
@property (nonatomic , strong) DataModel              * data;

@end
@interface DataModel :NSObject
@property (nonatomic , assign) NSInteger              expiresIn;
@property (nonatomic , assign) BOOL              registered;
@property (nonatomic , copy) NSString              * verificationId;

@end




NS_ASSUME_NONNULL_END
