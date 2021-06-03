//
//  SaiBallModel.h
//  
//  Created by  on 2020/04/01.
//  Copyright © 2020年 . All rights reserved.
//

#import <Foundation/Foundation.h>


@class SaiBallModelTemplate;
@class SaiBallModelTemplateItems;
@class SaiBallModelTemplateItemsQuery;

@interface SaiBallModel : NSObject

/** <#template#>*/
@property (nonatomic, strong) SaiBallModelTemplate *templateModel;

/** <#type#>*/
@property (nonatomic, copy) NSString *type;


+ (instancetype)modelWithJson:(id)json;

@end


@interface SaiBallModelTemplate : NSObject

/** <#items#>*/
@property (nonatomic, strong) NSArray<SaiBallModelTemplateItems *> *items;

/** <#type#>*/
@property (nonatomic, copy) NSString *type;

@end


@interface SaiBallModelTemplateItems : NSObject

/** <#skill#>*/
@property (nonatomic, copy) NSString *skill;

/** <#ic_url#>*/
@property (nonatomic, copy) NSString *ic_url;

/** <#query#>*/
@property (nonatomic, copy) NSArray<NSString *> *query;

/** <#intent#>*/
@property (nonatomic, copy) NSString *intent;

@end


@interface SaiBallModelTemplateItemsQuery : NSObject

@end

