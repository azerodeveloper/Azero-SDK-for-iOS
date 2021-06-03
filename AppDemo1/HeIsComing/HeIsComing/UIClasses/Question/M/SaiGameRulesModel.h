//
//  SaiGameRulesModel.h
//  
//  Created by  on 2020/04/27.
//  Copyright © 2020年 . All rights reserved.
//

#import <Foundation/Foundation.h>



@class SaiGameRulesModelPageDisplay;
@class SaiGameRulesModelPageDisplayContents;

@interface SaiGameRulesModel : NSObject

/** <#joinPeopleAmount#>*/
@property (nonatomic, strong) NSNumber *joinPeopleAmount;

/** <#scene#>*/
@property (nonatomic, copy) NSString *scene;

/** <#time#>*/
@property (nonatomic, copy) NSString *time;

/** <#prologue#>*/
@property (nonatomic, copy) NSString *prologue;

/** <#totalBonus#>*/
@property (nonatomic, strong) NSNumber *totalBonus;

/** <#type#>*/
@property (nonatomic, copy) NSString *type;

/** <#pageDisplay#>*/
@property (nonatomic, strong) NSArray<SaiGameRulesModelPageDisplay *> *pageDisplay;

/** <#index#>*/
@property (nonatomic, strong) NSNumber *index;


+ (instancetype)modelWithJson:(id)json;

@end


@interface SaiGameRulesModelPageDisplay : NSObject

/** <#title#>*/
@property (nonatomic, copy) NSString *title;

/** <#contents#>*/
@property (nonatomic, copy) NSArray<NSString *> *contents;

@end


@interface SaiGameRulesModelPageDisplayContents : NSObject

@end

