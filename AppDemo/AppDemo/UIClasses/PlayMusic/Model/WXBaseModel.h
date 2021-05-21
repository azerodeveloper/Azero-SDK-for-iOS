//
//  WXBaseModel.h
//
//  Created by  on 2020/11/06.
//  Copyright © 2020年 . All rights reserved.
//

#import <Foundation/Foundation.h>



@class WXBaseModelState;
@class WXBaseModelContent;
@class WXBaseModelContentProvider;
@class WXBaseModelContentProviderLogo;
@class WXBaseModelContentProviderLogoSources;
@class WXBaseModelContentArt;
@class WXBaseModelContentArtSources;
@class WXBaseModelContentTags;
@class WXBaseModelContentExt;
@class WXBaseModelContentExtLike;
@class WXBaseModelContentExtComment;
@class WXBaseModelContentExtCommentFirstPage;
@class WXBaseModelContentExtCommentFirstPageRepliedComments;
@class WXBaseModelContentExtCommentFirstPageRepliedCommentsUser;
@class WXBaseModelContentExtCommentFirstPageUser;
@class WXBaseModelContents;
@class WXBaseModelContentsProvider;
@class WXBaseModelContentsProviderLogo;
@class WXBaseModelContentsProviderLogoSources;
@class WXBaseModelContentsTags;
@class WXBaseModelContentsExt;
@class WXBaseModelContentsExtLike;
@class WXBaseModelContentsExtComment;
@class WXBaseModelContentsExtCommentFirstPage;
@class WXBaseModelContentsExtCommentFirstPageRepliedComments;
@class WXBaseModelContentsExtCommentFirstPageRepliedCommentsUser;
@class WXBaseModelContentsExtCommentFirstPageUser;
@class WXBaseModelContentsArt;
@class WXBaseModelContentsArtSources;
@class WXBaseModelTitle;

@class WXBaseModelControls;

@interface WXBaseModel : NSObject

/** <#action#>*/
@property (nonatomic, copy) NSString *action;

/** <#state#>*/
@property (nonatomic, strong) WXBaseModelState *state;

/** <#content#>*/
@property (nonatomic, strong) WXBaseModelContent *content;

/** <#contents#>*/
@property (nonatomic, strong) NSArray<WXBaseModelContents *> *contents;



/** <#Description#>*/
@property (nonatomic, strong) WXBaseModelTitle *title;

/** <#move#>*/
@property (nonatomic, strong) NSNumber *move;

@property (nonatomic, strong) NSNumber *acquireTarget;

@property (nonatomic, copy) NSString *ttsText;


@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *content2;


/** <#type#>*/
@property (nonatomic, copy) NSString *type;

/** <#audioItemId#>*/
@property (nonatomic, copy) NSString *audioItemId;

/** <#controls#>*/
@property (nonatomic, strong) NSArray<WXBaseModelControls *> *controls;


+ (instancetype)modelWithJson:(id)json;

@end


@interface WXBaseModelState : NSObject

/** <#resourceId#>*/
@property (nonatomic, copy) NSString *resourceId;

/** <#targetPosition#>*/
@property (nonatomic, strong) NSNumber *targetPosition;

@end


@interface WXBaseModelContent : NSObject

/** <#resourceId#>*/
@property (nonatomic, copy) NSString *resourceId;

/** <#provider#>*/
@property (nonatomic, strong) WXBaseModelContentProvider *provider;

/** <#position#>*/
@property (nonatomic, strong) NSNumber *position;

/** <#art#>*/
@property (nonatomic, strong) WXBaseModelContentArt *art;

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

/** <#tags#>*/
@property (nonatomic, strong) NSArray<WXBaseModelContentTags *> *tags;

/** <#title#>*/
@property (nonatomic, copy) NSString *title;

/** <#header#>*/
@property (nonatomic, copy) NSString *header;

/** <#token#>*/
@property (nonatomic, copy) NSString *token;

/** <#ext#>*/
@property (nonatomic, strong) WXBaseModelContentExt *ext;

/** <#mediaLengthInMilliseconds#>*/
@property (nonatomic, copy) NSString *mediaLengthInMilliseconds;

/** <#showDetails#>*/
@property (nonatomic, strong) NSNumber *showDetails;

@end


@interface WXBaseModelContentProvider : NSObject

/** <#album#>*/
@property (nonatomic, copy) NSString *album;

/** <#lyric#>*/
@property (nonatomic, copy) NSString *lyric;

/** <#name#>*/
@property (nonatomic, copy) NSString *name;

/** <#logo#>*/
@property (nonatomic, strong) WXBaseModelContentProviderLogo *logo;

@end


@interface WXBaseModelContentProviderLogo : NSObject

/** <#sources#>*/
@property (nonatomic, strong) NSArray<WXBaseModelContentProviderLogoSources *> *sources;

/** <#contentDescription#>*/
@property (nonatomic, copy) NSString *contentDescription;

@end


@interface WXBaseModelContentProviderLogoSources : NSObject

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

@end


@interface WXBaseModelContentArt : NSObject

/** <#sources#>*/
@property (nonatomic, strong) NSArray<WXBaseModelContentArtSources *> *sources;

/** <#contentDescription#>*/
@property (nonatomic, copy) NSString *contentDescription;

@end


@interface WXBaseModelContentArtSources : NSObject

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

@end


@interface WXBaseModelContentTags : NSObject

/** <#feedback#>*/
@property (nonatomic, copy) NSString *feedback;

/** <#title#>*/
@property (nonatomic, copy) NSString *title;

@end


@interface WXBaseModelContentExt : NSObject

/** <#like#>*/
@property (nonatomic, strong) WXBaseModelContentExtLike *like;

/** <#comment#>*/
@property (nonatomic, strong) WXBaseModelContentExtComment *comment;

@end


@interface WXBaseModelContentExtLike : NSObject

/** <#isLike#>*/
@property (nonatomic, strong) NSNumber *isLike;

/** <#num#>*/
@property (nonatomic, strong) NSNumber *num;

@end


@interface WXBaseModelContentExtComment : NSObject

/** <#firstPage#>*/
@property (nonatomic, strong) NSArray<WXBaseModelContentExtCommentFirstPage *> *firstPage;

/** <#num#>*/
@property (nonatomic, strong) NSNumber *num;

@end


@interface WXBaseModelContentExtCommentFirstPage : NSObject

/** <#content#>*/
@property (nonatomic, copy) NSString *content;

/** <#repliedCommentId#>*/
@property (nonatomic, copy) NSString *repliedCommentId;

/** <#repliedComments#>*/
@property (nonatomic, strong) NSArray<WXBaseModelContentExtCommentFirstPageRepliedComments *> *repliedComments;

/** <#commentId#>*/
@property (nonatomic, copy) NSString *commentId;

/** <#time#>*/
@property (nonatomic, strong) NSNumber *time;

/** <#user#>*/
@property (nonatomic, strong) WXBaseModelContentExtCommentFirstPageUser *user;

@end


@interface WXBaseModelContentExtCommentFirstPageRepliedComments : NSObject

/** <#repliedCommentId#>*/
@property (nonatomic, copy) NSString *repliedCommentId;

/** <#content#>*/
@property (nonatomic, copy) NSString *content;

/** <#commentId#>*/
@property (nonatomic, copy) NSString *commentId;

/** <#time#>*/
@property (nonatomic, strong) NSNumber *time;

/** <#user#>*/
@property (nonatomic, strong) WXBaseModelContentExtCommentFirstPageRepliedCommentsUser *user;

@end


@interface WXBaseModelContentExtCommentFirstPageRepliedCommentsUser : NSObject

/** <#name#>*/
@property (nonatomic, copy) NSString *name;

/** <#userId#>*/
@property (nonatomic, copy) NSString *userId;

@end


@interface WXBaseModelContentExtCommentFirstPageUser : NSObject

/** <#name#>*/
@property (nonatomic, copy) NSString *name;

/** <#userId#>*/
@property (nonatomic, copy) NSString *userId;

@end


@interface WXBaseModelContents : NSObject

/** <#header#>*/
@property (nonatomic, copy) NSString *header;

/** <#provider#>*/
@property (nonatomic, strong) WXBaseModelContentsProvider *provider;

/** <#position#>*/
@property (nonatomic, strong) NSNumber *position;

/** <#tags#>*/
@property (nonatomic, strong) NSArray<WXBaseModelContentsTags *> *tags;

@property (nonatomic, strong) NSArray<NSString *> *guideWords;

/** <#ext#>*/
@property (nonatomic, strong) WXBaseModelContentsExt *ext;

/** <#title#>*/
@property (nonatomic, copy) NSString *title;

/** <#showDetails#>*/
@property (nonatomic, strong) NSNumber *showDetails;

/** <#resourceId#>*/
@property (nonatomic, copy) NSString *resourceId;

/** <#token#>*/
@property (nonatomic, copy) NSString *token;

/** <#art#>*/
@property (nonatomic, strong) WXBaseModelContentsArt *art;

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

@end


@interface WXBaseModelContentsProvider : NSObject

/** <#type#>*/
@property (nonatomic, copy) NSString *type;

/** <#album#>*/
@property (nonatomic, copy) NSString *album;

/** <#lyric#>*/
@property (nonatomic, copy) NSString *lyric;

/** <#name#>*/
@property (nonatomic, copy) NSString *name;

/** <#logo#>*/
@property (nonatomic, strong) WXBaseModelContentsProviderLogo *logo;

@end


@interface WXBaseModelContentsProviderLogo : NSObject

/** <#sources#>*/
@property (nonatomic, strong) NSArray<WXBaseModelContentsProviderLogoSources *> *sources;

/** <#contentDescription#>*/
@property (nonatomic, copy) NSString *contentDescription;

@end


@interface WXBaseModelContentsProviderLogoSources : NSObject

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

@end


@interface WXBaseModelContentsTags : NSObject

/** <#feedback#>*/
@property (nonatomic, copy) NSString *feedback;

/** <#title#>*/
@property (nonatomic, copy) NSString *title;

@end


@interface WXBaseModelContentsExt : NSObject

/** <#like#>*/
@property (nonatomic, strong) WXBaseModelContentsExtLike *like;

/** <#comment#>*/
@property (nonatomic, strong) WXBaseModelContentsExtComment *comment;

@end


@interface WXBaseModelContentsExtLike : NSObject

/** <#isLike#>*/
@property (nonatomic, strong) NSNumber *isLike;

/** <#num#>*/
@property (nonatomic, strong) NSNumber *num;

@end


@interface WXBaseModelContentsExtComment : NSObject

/** <#firstPage#>*/
@property (nonatomic, strong) NSArray<WXBaseModelContentsExtCommentFirstPage *> *firstPage;

/** <#num#>*/
@property (nonatomic, strong) NSNumber *num;

@end


@interface WXBaseModelContentsExtCommentFirstPage : NSObject

/** <#content#>*/
@property (nonatomic, copy) NSString *content;

/** <#repliedCommentId#>*/
@property (nonatomic, copy) NSString *repliedCommentId;

/** <#repliedComments#>*/
@property (nonatomic, strong) NSArray<WXBaseModelContentsExtCommentFirstPageRepliedComments *> *repliedComments;

/** <#commentId#>*/
@property (nonatomic, copy) NSString *commentId;

/** <#time#>*/
@property (nonatomic, strong) NSNumber *time;

/** <#user#>*/
@property (nonatomic, strong) WXBaseModelContentsExtCommentFirstPageUser *user;

@end


@interface WXBaseModelContentsExtCommentFirstPageRepliedComments : NSObject

/** <#repliedCommentId#>*/
@property (nonatomic, copy) NSString *repliedCommentId;

/** <#content#>*/
@property (nonatomic, copy) NSString *content;

/** <#commentId#>*/
@property (nonatomic, copy) NSString *commentId;

/** <#time#>*/
@property (nonatomic, strong) NSNumber *time;

/** <#user#>*/
@property (nonatomic, strong) WXBaseModelContentsExtCommentFirstPageRepliedCommentsUser *user;

@end


@interface WXBaseModelContentsExtCommentFirstPageRepliedCommentsUser : NSObject

/** <#name#>*/
@property (nonatomic, copy) NSString *name;

/** <#userId#>*/
@property (nonatomic, copy) NSString *userId;

@end


@interface WXBaseModelContentsExtCommentFirstPageUser : NSObject

/** <#name#>*/
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *pictureUrl;


/** <#userId#>*/
@property (nonatomic, copy) NSString *userId;

@end


@interface WXBaseModelContentsArt : NSObject

/** <#sources#>*/
@property (nonatomic, strong) NSArray<WXBaseModelContentsArtSources *> *sources;

/** <#contentDescription#>*/
@property (nonatomic, copy) NSString *contentDescription;

@end

@interface WXBaseModelTitle : NSObject

/** <#notes#>*/
@property (nonatomic, copy) NSString *notes;

/** <#title#>*/
@property (nonatomic, copy) NSString *url;

/** <#url#>*/
@property (nonatomic, copy) NSString *headline;

@end

@interface WXBaseModelContentsArtSources : NSObject

/** <#url#>*/
@property (nonatomic, copy) NSString *url;

@end


@interface WXBaseModelControls : NSObject

/** <#enabled#>*/
@property (nonatomic, strong) NSNumber *enabled;

/** <#name#>*/
@property (nonatomic, copy) NSString *name;

/** <#type#>*/
@property (nonatomic, copy) NSString *type;

/** <#selected#>*/
@property (nonatomic, strong) NSNumber *selected;

@end

