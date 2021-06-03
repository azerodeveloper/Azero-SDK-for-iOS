//
//  SaiWikipediaModel.h
//  
//  Created by  on 2020/04/02.
//  Copyright © 2020年 . All rights reserved.
//

#import <Foundation/Foundation.h>



@class SaiWikipediaModelExtField;
@class SaiWikipediaModelTitle;
@class SaiWikipediaModelBackgroundImage;
@class SaiWikipediaModelBackgroundImageSources;

@interface SaiWikipediaModel : NSObject

/** <#extField#>*/
@property (nonatomic, strong) SaiWikipediaModelExtField *extField;

/** <#textField#>*/
@property (nonatomic, copy) NSString *textField;

/** <#title#>*/
@property (nonatomic, strong) SaiWikipediaModelTitle *title;

/** <#backButton#>*/
@property (nonatomic, copy) NSString *backButton;

/** <#type#>*/
@property (nonatomic, copy) NSString *type;

/** <#backgroundImage#>*/
@property (nonatomic, strong) SaiWikipediaModelBackgroundImage *backgroundImage;


+ (instancetype)modelWithJson:(id)json;

@end


@interface SaiWikipediaModelExtField : NSObject

/** <#type#>*/
@property (nonatomic, copy) NSString *type;

/** <#ASRText#>*/
@property (nonatomic, copy) NSString *ASRText;

@end


@interface SaiWikipediaModelTitle : NSObject

/** <#subTitle#>*/
@property (nonatomic, copy) NSString *subTitle;

/** <#mainTitle#>*/
@property (nonatomic, copy) NSString *mainTitle;

@end


@interface SaiWikipediaModelBackgroundImage : NSObject

/** <#sources#>*/
@property (nonatomic, strong) NSArray<SaiWikipediaModelBackgroundImageSources *> *sources;

@end


@interface SaiWikipediaModelBackgroundImageSources : NSObject

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

@end

