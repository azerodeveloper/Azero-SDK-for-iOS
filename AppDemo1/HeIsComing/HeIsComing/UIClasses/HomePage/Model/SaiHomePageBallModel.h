//
//  SaiHomePageBallModel.h
//  
//  Created by  on 2020/04/02.
//  Copyright © 2020年 . All rights reserved.
//

#import <Foundation/Foundation.h>



@class SaiHomePageBallModelItems;
@class SaiHomePageBallModelItemsQuery;
@class SaiHomePageBallModelControls;
@class SaiHomePageBallModelContent;
@interface SaiHomePageBallModel : NSObject

/** <#type#>*/
@property (nonatomic, copy) NSString *type;

/** <#type#>*/
@property (nonatomic, copy) NSString *scene;

@property (nonatomic, copy) NSNumber *isFirst;

/** <#items#>*/
@property (nonatomic, strong) NSArray<SaiHomePageBallModelItems *> *items;


@property (nonatomic, strong) NSArray<SaiHomePageBallModelControls *> *controls;

@property (nonatomic ,strong) SaiHomePageBallModelContent  *content;


+ (instancetype)modelWithJson:(id)json;

@end


@interface SaiHomePageBallModelItems : NSObject

/** <#skill#>*/
@property (nonatomic, copy) NSString *skill;

/** <#ic_url#>*/
@property (nonatomic, copy) NSString *ic_url;

/** <#query#>*/
@property (nonatomic, copy) NSArray<NSString *> *query;

/** <#intent#>*/
@property (nonatomic, copy) NSString *intent;

@end
@interface SaiHomePageBallModelControls : NSObject

/** <#skill#>*/
@property (nonatomic, copy) NSString *name;

/** <#ic_url#>*/
@property (nonatomic, copy) NSString *type;

/** <#query#>*/
@property (nonatomic, copy) NSNumber *enabled;

/** <#intent#>*/
@property (nonatomic, copy) NSNumber *selected;

@end


@interface SaiHomePageBallModelItemsQuery : NSObject

@end

@interface SaiHomePageBallModelContent : NSObject
@property (nonatomic ,strong) NSDictionary *art;
@property (nonatomic ,strong) NSDictionary *provider;
@property (nonatomic ,copy) NSString *header;
@property (nonatomic ,copy) NSString *mediaLengthInMilliseconds;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,assign) NSInteger position;
@property (nonatomic ,assign) BOOL showDetails;




@end

