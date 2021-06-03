//
//  SaiWeatherMorringModel.h
//  
//  Created by  on 2020/04/27.
//  Copyright © 2020年 . All rights reserved.
//

#import <Foundation/Foundation.h>


@class SaiWeatherMorringModelCurrentWeatherIcon;
@class SaiWeatherMorringModelCurrentWeatherIconSources;
@class SaiWeatherMorringModelCondition;
@class SaiWeatherMorringModelSkillIcon;
@class SaiWeatherMorringModelSkillIconSources;
@class SaiWeatherMorringModelAir;
@class SaiWeatherMorringModelSuggestion;
@class SaiWeatherMorringModelSuggestionDressing;

@interface SaiWeatherMorringModel : NSObject

/** <#answer#>*/
@property (nonatomic, copy) NSString *answer;

/** <#currentWeatherIcon#>*/
@property (nonatomic, strong) SaiWeatherMorringModelCurrentWeatherIcon *currentWeatherIcon;

/** <#condition#>*/
@property (nonatomic, strong) SaiWeatherMorringModelCondition *condition;

/** <#skillIcon#>*/
@property (nonatomic, strong) SaiWeatherMorringModelSkillIcon *skillIcon;

/** <#air#>*/
@property (nonatomic, strong) SaiWeatherMorringModelAir *air;

/** <#week#>*/
@property (nonatomic, copy) NSString *week;

/** <#date#>*/
@property (nonatomic, copy) NSString *date;

/** <#type#>*/
@property (nonatomic, copy) NSString *type;

/** <#suggestion#>*/
@property (nonatomic, strong) SaiWeatherMorringModelSuggestion *suggestion;


+ (instancetype)modelWithJson:(id)json;

@end


@interface SaiWeatherMorringModelCurrentWeatherIcon : NSObject

/** <#sources#>*/
@property (nonatomic, strong) NSArray<SaiWeatherMorringModelCurrentWeatherIconSources *> *sources;

/** <#contentDescription#>*/
@property (nonatomic, copy) NSString *contentDescription;

@end


@interface SaiWeatherMorringModelCurrentWeatherIconSources : NSObject

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

/** <#darkBackgroundUrl#>*/
@property (nonatomic, copy) NSString *darkBackgroundUrl;

@end


@interface SaiWeatherMorringModelCondition : NSObject

/** <#code#>*/
@property (nonatomic, copy) NSString *code;

/** <#temperature#>*/
@property (nonatomic, copy) NSString *temperature;

/** <#windDirection#>*/
@property (nonatomic, copy) NSString *windDirection;

/** <#windScale#>*/
@property (nonatomic, copy) NSString *windScale;

/** <#text#>*/
@property (nonatomic, copy) NSString *text;

@end


@interface SaiWeatherMorringModelSkillIcon : NSObject

/** <#sources#>*/
@property (nonatomic, strong) NSArray<SaiWeatherMorringModelSkillIconSources *> *sources;

/** <#contentDescription#>*/
@property (nonatomic, copy) NSString *contentDescription;

@end


@interface SaiWeatherMorringModelSkillIconSources : NSObject

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

/** <#darkBackgroundUrl#>*/
@property (nonatomic, copy) NSString *darkBackgroundUrl;

@end


@interface SaiWeatherMorringModelAir : NSObject

/** <#aqi#>*/
@property (nonatomic, copy) NSString *aqi;

/** <#iconUrl#>*/
@property (nonatomic, copy) NSString *iconUrl;

/** <#quality#>*/
@property (nonatomic, copy) NSString *quality;

@end


@interface SaiWeatherMorringModelSuggestion : NSObject

/** <#dressing#>*/
@property (nonatomic, strong) SaiWeatherMorringModelSuggestionDressing *dressing;

/** <#backgroundUrl#>*/
@property (nonatomic, copy) NSString *backgroundUrl;

@end


@interface SaiWeatherMorringModelSuggestionDressing : NSObject

/** <#details#>*/
@property (nonatomic, copy) NSString *details;

/** <#brief#>*/
@property (nonatomic, copy) NSString *brief;

/** <#iconUrl#>*/
@property (nonatomic, copy) NSString *iconUrl;

/** <#suggestion#>*/
@property (nonatomic, copy) NSString *suggestion;

@end

