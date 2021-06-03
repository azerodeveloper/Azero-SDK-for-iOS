//
//  SaiASMRModel.h
//  
//  Created by  on 2020/07/16.
//  Copyright © 2020年 . All rights reserved.
//

#import <Foundation/Foundation.h>



@class SaiASMRModelListItems;
@class SaiASMRModelListItemsArt;
@class SaiASMRModelListItemsArtSources;

@interface SaiASMRModel : NSObject

/** <#type#>*/
@property (nonatomic, copy) NSString *prompt;
/** <#type#>*/
@property (nonatomic, copy) NSString *type;

/** <#position#>*/
@property (nonatomic, strong) NSNumber *position;



@property (nonatomic, strong) NSNumber *visible;

/** <#listItems#>*/
@property (nonatomic, strong) NSArray<SaiASMRModelListItems *> *listItems;


+ (instancetype)modelWithJson:(id)json;

@end


@interface SaiASMRModelListItems : NSObject

/** <#token#>*/
@property (nonatomic, copy) NSString *token;

/** <#title#>*/
@property (nonatomic, copy) NSString *title;

/** <#art#>*/
@property (nonatomic, strong) SaiASMRModelListItemsArt *image;

@end


@interface SaiASMRModelListItemsArt : NSObject

/** <#sources#>*/
@property (nonatomic, strong) NSArray<SaiASMRModelListItemsArtSources *> *sources;

/** <#contentDescription#>*/
@property (nonatomic, copy) NSString *contentDescription;

@end


@interface SaiASMRModelListItemsArtSources : NSObject

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

@end

