//
//  SaiVersionModel.h
//  
//  Created by  on 2020/11/27.
//  Copyright © 2020年 . All rights reserved.
//

#import <Foundation/Foundation.h>


@class SaiVersionModelCurrent_img_version;

@interface SaiVersionModel : NSObject

/** <#update#>*/
@property (nonatomic, copy) NSString *update;

/** <#current_img_version#>*/
@property (nonatomic, strong) NSArray<SaiVersionModelCurrent_img_version *> *current_img_version;

/** <#code#>*/
@property (nonatomic, strong) NSNumber *code;

/** <#message#>*/
@property (nonatomic, copy) NSString *message;

/** <#ios_update#>*/
@property (nonatomic, copy) NSString *ios_update;

/** <#current_version#>*/
@property (nonatomic, copy) NSString *current_version;

/** <#ios_current_version#>*/
@property (nonatomic, copy) NSString *ios_current_version;

/** <#current_version_code#>*/
@property (nonatomic, copy) NSString *current_version_code;

/** <#ios_current_version_code#>*/
@property (nonatomic, copy) NSString *ios_current_version_code;


+ (instancetype)modelWithJson:(id)json;

@end


@interface SaiVersionModelCurrent_img_version : NSObject

/** <#md5#>*/
@property (nonatomic, copy) NSString *md5;

/** <#ta_pro#>*/
@property (nonatomic, copy) NSString *SoundAI_TA_pro;

@end

