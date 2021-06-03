//
//  SaiSkillListTipsTemplateModel.h
//  
//  Created by  on 2020/05/14.
//  Copyright © 2020年 . All rights reserved.
//

#import <Foundation/Foundation.h>


@class SaiSkillListTipsTemplateModelItems;
@class SaiSkillListTipsTemplateModelItemsTips;

@interface SaiSkillListTipsTemplateModel : NSObject

/** <#type#>*/
@property (nonatomic, copy) NSString *type;

/** <#items#>*/
@property (nonatomic, strong) NSArray<SaiSkillListTipsTemplateModelItems *> *items;


+ (instancetype)modelWithJson:(id)json;

@end


@interface SaiSkillListTipsTemplateModelItems : NSObject

/** <#title#>*/
@property (nonatomic, copy) NSString *title;

/** <#tips#>*/
@property (nonatomic, copy) NSArray<NSString *> *tips;

@end


@interface SaiSkillListTipsTemplateModelItemsTips : NSObject

@end

