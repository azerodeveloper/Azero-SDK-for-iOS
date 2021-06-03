//
//  SaiWeatherModel.h
//  
//  Created by  on 2020/04/01.
//  Copyright © 2020年 . All rights reserved.
//

#import <Foundation/Foundation.h>



@class SaiWeatherModelAirs;
@class SaiWeatherModelDaily;
@class SaiWeatherModelDailyDaily;
@class SaiWeatherModelWeatherForecast;
@class SaiWeatherModelWeatherForecastImage;
@class SaiWeatherModelWeatherForecastImageSources;
@class SaiWeatherModelTitle;
@class SaiWeatherModelLowTemperature;
@class SaiWeatherModelLowTemperatureArrow;
@class SaiWeatherModelLowTemperatureArrowSources;
@class SaiWeatherModelHighTemperature;
@class SaiWeatherModelHighTemperatureArrow;
@class SaiWeatherModelHighTemperatureArrowSources;
@class SaiWeatherModelSuggestion;
@class SaiWeatherModelSuggestionUmbrella;
@class SaiWeatherModelSuggestionDressing;
@class SaiWeatherModelSuggestionCarWashing;
@class SaiWeatherModelNow;
@class SaiWeatherModelAir;
@class SaiWeatherModelCurrentWeatherIcon;
@class SaiWeatherModelCurrentWeatherIconSources;
@class SaiWeatherModelCondition;
@class SaiWeatherModelSkillIcon;
@class SaiWeatherModelSkillIconSources;
@class SaiWeatherModelUv;
@class SaiWeatherModelWeather;

@interface SaiWeatherModel : NSObject

/** <#airs#>*/
@property (nonatomic, strong) NSArray<SaiWeatherModelAirs *> *airs;

/** <#week#>*/
@property (nonatomic, copy) NSString *week;

/** <#daily#>*/
@property (nonatomic, strong) SaiWeatherModelDaily *daily;

/** <#weatherForecast#>*/
@property (nonatomic, strong) NSArray<SaiWeatherModelWeatherForecast *> *weatherForecast;

/** <#title#>*/
@property (nonatomic, strong) SaiWeatherModelTitle *title;

/** <#lowTemperature#>*/
@property (nonatomic, strong) SaiWeatherModelLowTemperature *lowTemperature;

/** <#highTemperature#>*/
@property (nonatomic, strong) SaiWeatherModelHighTemperature *highTemperature;

/** <#suggestion#>*/
@property (nonatomic, strong) SaiWeatherModelSuggestion *suggestion;

/** <#city#>*/
@property (nonatomic, copy) NSString *city;

/** <#now#>*/
@property (nonatomic, strong) SaiWeatherModelNow *now;

/** <#ttsContent#>*/
@property (nonatomic, copy) NSString *ttsContent;

/** <#air#>*/
@property (nonatomic, strong) SaiWeatherModelAir *air;

/** <#type#>*/
@property (nonatomic, copy) NSString *type;

/** <#answer#>*/
@property (nonatomic, copy) NSString *answer;

/** <#date#>*/
@property (nonatomic, copy) NSString *date;

/** <#token#>*/
@property (nonatomic, copy) NSString *token;

/** <#currentWeatherIcon#>*/
@property (nonatomic, strong) SaiWeatherModelCurrentWeatherIcon *currentWeatherIcon;

/** <#condition#>*/
@property (nonatomic, strong) SaiWeatherModelCondition *condition;

/** <#skillIcon#>*/
@property (nonatomic, strong) SaiWeatherModelSkillIcon *skillIcon;

/** <#uv#>*/
@property (nonatomic, strong) SaiWeatherModelUv *uv;

/** <#weather#>*/
@property (nonatomic, strong) SaiWeatherModelWeather *weather;


+ (instancetype)modelWithJson:(id)json;

@end


@interface SaiWeatherModelAirs : NSObject

/** <#quality#>*/
@property (nonatomic, copy) NSString *quality;

/** <#no2#>*/
@property (nonatomic, copy) NSString *no2;

/** <#co#>*/
@property (nonatomic, copy) NSString *co;

/** <#maxLevel#>*/
@property (nonatomic, strong) NSNumber *maxLevel;

/** <#aqi#>*/
@property (nonatomic, copy) NSString *aqi;

/** <#so2#>*/
@property (nonatomic, copy) NSString *so2;

/** <#pm25#>*/
@property (nonatomic, copy) NSString *pm25;

/** <#date#>*/
@property (nonatomic, copy) NSString *date;

/** <#o3#>*/
@property (nonatomic, copy) NSString *o3;

/** <#level#>*/
@property (nonatomic, strong) NSNumber *level;

/** <#iconUrl#>*/
@property (nonatomic, copy) NSString *iconUrl;

/** <#pm10#>*/
@property (nonatomic, copy) NSString *pm10;

@end


@interface SaiWeatherModelDaily : NSObject

/** <#daily#>*/
@property (nonatomic, strong) NSArray<SaiWeatherModelDailyDaily *> *daily;

/** <#backgroundUrl#>*/
@property (nonatomic, copy) NSString *backgroundUrl;

@end


@interface SaiWeatherModelDailyDaily : NSObject

/** <#windDirection#>*/
@property (nonatomic, copy) NSString *windDirection;

/** <#codeNight#>*/
@property (nonatomic, copy) NSString *codeNight;

/** <#windSpeed#>*/
@property (nonatomic, copy) NSString *windSpeed;

/** <#high#>*/
@property (nonatomic, copy) NSString *high;

/** <#backgroundUrl#>*/
@property (nonatomic, copy) NSString *backgroundUrl;

/** <#textNight#>*/
@property (nonatomic, copy) NSString *textNight;

/** <#codeDay#>*/
@property (nonatomic, copy) NSString *codeDay;

/** <#windDirectionDegree#>*/
@property (nonatomic, copy) NSString *windDirectionDegree;

/** <#monthDay#>*/
@property (nonatomic, copy) NSString *monthDay;

/** <#windScale#>*/
@property (nonatomic, copy) NSString *windScale;

/** <#date#>*/
@property (nonatomic, copy) NSString *date;

/** <#low#>*/
@property (nonatomic, copy) NSString *low;

/** <#week#>*/
@property (nonatomic, copy) NSString *week;

/** <#iconUrl#>*/
@property (nonatomic, copy) NSString *iconUrl;

/** <#textDay#>*/
@property (nonatomic, copy) NSString *textDay;

@end


@interface SaiWeatherModelWeatherForecast : NSObject

/** <#day#>*/
@property (nonatomic, copy) NSString *day;

/** <#highTemperature#>*/
@property (nonatomic, copy) NSString *highTemperature;

/** <#image#>*/
@property (nonatomic, strong) SaiWeatherModelWeatherForecastImage *image;

/** <#lowTemperature#>*/
@property (nonatomic, copy) NSString *lowTemperature;

/** <#date#>*/
@property (nonatomic, copy) NSString *date;

@end


@interface SaiWeatherModelWeatherForecastImage : NSObject

/** <#sources#>*/
@property (nonatomic, strong) NSArray<SaiWeatherModelWeatherForecastImageSources *> *sources;

/** <#contentDescription#>*/
@property (nonatomic, copy) NSString *contentDescription;

@end


@interface SaiWeatherModelWeatherForecastImageSources : NSObject

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

/** <#darkBackgroundUrl#>*/
@property (nonatomic, copy) NSString *darkBackgroundUrl;

@end


@interface SaiWeatherModelTitle : NSObject

/** <#subTitle#>*/
@property (nonatomic, copy) NSString *subTitle;

/** <#mainTitle#>*/
@property (nonatomic, copy) NSString *mainTitle;

@end


@interface SaiWeatherModelLowTemperature : NSObject

/** <#arrow#>*/
@property (nonatomic, strong) SaiWeatherModelLowTemperatureArrow *arrow;

/** <#value#>*/
@property (nonatomic, copy) NSString *value;

@end


@interface SaiWeatherModelLowTemperatureArrow : NSObject

/** <#sources#>*/
@property (nonatomic, strong) NSArray<SaiWeatherModelLowTemperatureArrowSources *> *sources;

@end


@interface SaiWeatherModelLowTemperatureArrowSources : NSObject

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

/** <#darkBackgroundUrl#>*/
@property (nonatomic, copy) NSString *darkBackgroundUrl;

@end


@interface SaiWeatherModelHighTemperature : NSObject

/** <#arrow#>*/
@property (nonatomic, strong) SaiWeatherModelHighTemperatureArrow *arrow;

/** <#value#>*/
@property (nonatomic, copy) NSString *value;

@end


@interface SaiWeatherModelHighTemperatureArrow : NSObject

/** <#sources#>*/
@property (nonatomic, strong) NSArray<SaiWeatherModelHighTemperatureArrowSources *> *sources;

@end


@interface SaiWeatherModelHighTemperatureArrowSources : NSObject

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

/** <#darkBackgroundUrl#>*/
@property (nonatomic, copy) NSString *darkBackgroundUrl;

@end


@interface SaiWeatherModelSuggestion : NSObject

/** <#umbrella#>*/
@property (nonatomic, strong) SaiWeatherModelSuggestionUmbrella *umbrella;

/** <#backgroundUrl#>*/
@property (nonatomic, copy) NSString *backgroundUrl;

/** <#dressing#>*/
@property (nonatomic, strong) SaiWeatherModelSuggestionDressing *dressing;

/** <#carWashing#>*/
@property (nonatomic, strong) SaiWeatherModelSuggestionCarWashing *carWashing;

@end


@interface SaiWeatherModelSuggestionUmbrella : NSObject

/** <#details#>*/
@property (nonatomic, copy) NSString *details;

/** <#brief#>*/
@property (nonatomic, copy) NSString *brief;

/** <#iconUrl#>*/
@property (nonatomic, copy) NSString *iconUrl;

/** <#suggestion#>*/
@property (nonatomic, copy) NSString *suggestion;

@end


@interface SaiWeatherModelSuggestionDressing : NSObject

/** <#details#>*/
@property (nonatomic, copy) NSString *details;

/** <#brief#>*/
@property (nonatomic, copy) NSString *brief;

/** <#iconUrl#>*/
@property (nonatomic, copy) NSString *iconUrl;

/** <#suggestion#>*/
@property (nonatomic, copy) NSString *suggestion;

@end


@interface SaiWeatherModelSuggestionCarWashing : NSObject

/** <#details#>*/
@property (nonatomic, copy) NSString *details;

/** <#brief#>*/
@property (nonatomic, copy) NSString *brief;

/** <#iconUrl#>*/
@property (nonatomic, copy) NSString *iconUrl;

/** <#suggestion#>*/
@property (nonatomic, copy) NSString *suggestion;

@end


@interface SaiWeatherModelNow : NSObject

/** <#windDirection#>*/
@property (nonatomic, copy) NSString *windDirection;

/** <#temperature#>*/
@property (nonatomic, copy) NSString *temperature;

/** <#windSpeed#>*/
@property (nonatomic, copy) NSString *windSpeed;

/** <#humidity#>*/
@property (nonatomic, copy) NSString *humidity;

/** <#backgroundUrl#>*/
@property (nonatomic, copy) NSString *backgroundUrl;

/** <#windDirectionIcon#>*/
@property (nonatomic, copy) NSString *windDirectionIcon;

/** <#windDirectionDegree#>*/
@property (nonatomic, copy) NSString *windDirectionDegree;

/** <#windScale#>*/
@property (nonatomic, copy) NSString *windScale;

/** <#feelsLike#>*/
@property (nonatomic, copy) NSString *feelsLike;

/** <#code#>*/
@property (nonatomic, copy) NSString *code;

/** <#visibility#>*/
@property (nonatomic, copy) NSString *visibility;

/** <#text#>*/
@property (nonatomic, copy) NSString *text;

/** <#iconUrl#>*/
@property (nonatomic, copy) NSString *iconUrl;

/** <#pressure#>*/
@property (nonatomic, copy) NSString *pressure;

@end


@interface SaiWeatherModelAir : NSObject

/** <#pm25#>*/
@property (nonatomic, copy) NSString *pm25;

/** <#iconUrl#>*/
@property (nonatomic, copy) NSString *iconUrl;

/** <#aqi#>*/
@property (nonatomic, copy) NSString *aqi;

/** <#no2#>*/
@property (nonatomic, copy) NSString *no2;

/** <#o3#>*/
@property (nonatomic, copy) NSString *o3;

/** <#level#>*/
@property (nonatomic, strong) NSNumber *level;

/** <#so2#>*/
@property (nonatomic, copy) NSString *so2;

/** <#pm10#>*/
@property (nonatomic, copy) NSString *pm10;

/** <#co#>*/
@property (nonatomic, copy) NSString *co;

/** <#quality#>*/
@property (nonatomic, copy) NSString *quality;

/** <#maxLevel#>*/
@property (nonatomic, strong) NSNumber *maxLevel;

@end


@interface SaiWeatherModelCurrentWeatherIcon : NSObject

/** <#sources#>*/
@property (nonatomic, strong) NSArray<SaiWeatherModelCurrentWeatherIconSources *> *sources;

/** <#contentDescription#>*/
@property (nonatomic, copy) NSString *contentDescription;

@end


@interface SaiWeatherModelCurrentWeatherIconSources : NSObject

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

/** <#darkBackgroundUrl#>*/
@property (nonatomic, copy) NSString *darkBackgroundUrl;

@end


@interface SaiWeatherModelCondition : NSObject

/** <#text#>*/
@property (nonatomic, copy) NSString *text;

/** <#code#>*/
@property (nonatomic, copy) NSString *code;

@end


@interface SaiWeatherModelSkillIcon : NSObject

/** <#sources#>*/
@property (nonatomic, strong) NSArray<SaiWeatherModelSkillIconSources *> *sources;

/** <#contentDescription#>*/
@property (nonatomic, copy) NSString *contentDescription;

@end


@interface SaiWeatherModelSkillIconSources : NSObject

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

/** <#darkBackgroundUrl#>*/
@property (nonatomic, copy) NSString *darkBackgroundUrl;

@end


@interface SaiWeatherModelUv : NSObject

/** <#suggestion#>*/
@property (nonatomic, copy) NSString *suggestion;

/** <#details#>*/
@property (nonatomic, copy) NSString *details;

/** <#brief#>*/
@property (nonatomic, copy) NSString *brief;

/** <#level#>*/
@property (nonatomic, strong) NSNumber *level;

/** <#iconUrl#>*/
@property (nonatomic, copy) NSString *iconUrl;

/** <#maxLevel#>*/
@property (nonatomic, strong) NSNumber *maxLevel;

@end


@interface SaiWeatherModelWeather : NSObject

/** <#windDirection#>*/
@property (nonatomic, copy) NSString *windDirection;

/** <#codeNight#>*/
@property (nonatomic, copy) NSString *codeNight;

/** <#windSpeed#>*/
@property (nonatomic, copy) NSString *windSpeed;

/** <#high#>*/
@property (nonatomic, copy) NSString *high;

/** <#backgroundUrl#>*/
@property (nonatomic, copy) NSString *backgroundUrl;

/** <#textNight#>*/
@property (nonatomic, copy) NSString *textNight;

/** <#codeDay#>*/
@property (nonatomic, copy) NSString *codeDay;

/** <#windDirectionDegree#>*/
@property (nonatomic, copy) NSString *windDirectionDegree;

/** <#monthDay#>*/
@property (nonatomic, copy) NSString *monthDay;

/** <#windScale#>*/
@property (nonatomic, copy) NSString *windScale;

/** <#date#>*/
@property (nonatomic, copy) NSString *date;

/** <#low#>*/
@property (nonatomic, copy) NSString *low;

/** <#week#>*/
@property (nonatomic, copy) NSString *week;

/** <#iconUrl#>*/
@property (nonatomic, copy) NSString *iconUrl;

/** <#textDay#>*/
@property (nonatomic, copy) NSString *textDay;

@end

