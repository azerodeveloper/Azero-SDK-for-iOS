//
//  SaiQuestionModel.h
//  
//  Created by  on 2020/04/07.
//  Copyright © 2020年 . All rights reserved.
//

#import <Foundation/Foundation.h>


@class SaiQuestionModelAnswersVoteItem;
@class SaiQuestionModelAnswers;

@interface SaiQuestionModel : NSObject

/** <#Description#>*/
@property (nonatomic, copy) NSString *Description;

@property (nonatomic, copy) NSString *correctAnswer;



/** 延迟多久开始展示标题,单位ms*/
@property (nonatomic, strong) NSNumber *showTitleTime;

/** <#totalQuestionNumber#>*/
@property (nonatomic, strong) NSNumber *totalQuestionNumber;

@property (nonatomic, strong) NSNumber *winPeopleAmount;

@property (nonatomic, strong) NSNumber *averagePeopleAmount;

@property (nonatomic, strong) NSNumber *randomPeopleAmount;
@property (nonatomic, strong) NSNumber *win;
@property (nonatomic, strong) NSNumber *totalUseTime;


@property (nonatomic, strong) NSArray<NSString *> *winner;

@property (nonatomic, strong) NSArray<NSString *> *awardsWinner;


/** <#answers#>*/
@property (nonatomic, strong) NSArray<SaiQuestionModelAnswers *> *answers;


@property (nonatomic, strong) NSArray<SaiQuestionModelAnswersVoteItem *> *voteEnum;

/** <#scene#>*/
@property (nonatomic, copy) NSString *scene;

@property (nonatomic, copy) NSString *totalBonus;

@property (nonatomic, copy) NSString *vote;

@property (nonatomic, copy) NSString *ownBonus;

@property (nonatomic, copy) NSString *ownTotalBonus;

/** <#type#>*/
@property (nonatomic, copy) NSString *type;

/** <#title#>*/
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *status;

/** <#userStatus#>*/
@property (nonatomic, copy) NSString *userStatus;

/** 延迟多久展示选项,单位ms*/
@property (nonatomic, strong) NSNumber *showOptionTime;

/** <#joinPeopleAmount#>*/
@property (nonatomic, strong) NSNumber *joinPeopleAmount;

/** <#remainPeopleAmount#>*/
@property (nonatomic, strong) NSNumber *remainPeopleAmount;

/** <#prologue#>*/
@property (nonatomic, copy) NSString *prologue;

/** <#prologue#>*/
@property (nonatomic, copy) NSString *result;
/** <#prologue#>*/
@property (nonatomic, copy) NSString *submitAnswer;

/** <#prologue#>*/
@property (nonatomic, copy) NSString *submitTime;

/** <#countDown#>*/
@property (nonatomic, strong) NSNumber *countDown;

/** <#questionIndex#>*/
@property (nonatomic, strong) NSNumber *questionIndex;


+ (instancetype)modelWithJson:(id)json;

@end


@interface SaiQuestionModelAnswers : NSObject

/** <#content#>*/
@property (nonatomic, copy) NSString *content;

/** <#option#>*/
@property (nonatomic, copy) NSString *option;

@end


@interface SaiQuestionModelAnswersVoteItem : NSObject

/** <#content#>*/
@property (nonatomic, copy) NSString *content;

/** <#option#>*/
@property (nonatomic, copy) NSString *option;

@end

