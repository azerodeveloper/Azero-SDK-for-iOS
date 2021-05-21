//
//  SaiDigitalCharacterCell.h
//  HeIsComing
//
//  Created by mike on 2020/10/28.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMarqueeView.h"
#import "FavoriteView.h"
#import "SharePopView.h"
#import "WXBaseModel.h"
#import "LLGifImageView.h"
#import "CommentsPopView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SaiDigitalCharacterCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource>

@property(strong,nonatomic)LLGifImageView *backImageView;
@property (nonatomic, strong)NSMutableArray * animatingArray;
@property (nonatomic, strong)NSMutableArray * breathAnimatingArray;

@property (nonatomic, strong)UIView *descBackView;
@property (nonatomic, strong) UUMarqueeView *upwardDynamicHeightMarqueeView;
@property(nonatomic,strong)NSMutableArray *chatContentList;
@property (nonatomic, strong) UILabel          *desc;
@property (nonatomic, strong) UILabel          *nickName;
@property (nonatomic, strong) UIImageView      *avatar;
@property(nonatomic,strong)UIButton * upwardDynamicHeightMarqueeViewButton;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic ,strong) UITableView *newFeaturesTableView;
@property (nonatomic ,strong) NSMutableArray *messagesArray;

@property (nonatomic, strong) UIImageView      *share;
@property (nonatomic, strong) UIImageView      *comment;
@property (nonatomic, strong) FavoriteView     *favorite;
@property (nonatomic, strong) UIView                   *container;
@property (nonatomic, strong) UITapGestureRecognizer   *singleTapGesture;
@property (nonatomic, assign) NSInteger           indexPath;
@property (nonatomic, strong) UIImageView      *headsetImageView;

@property (nonatomic, assign) NSTimeInterval           lastTapTime;
@property (nonatomic, assign) CGPoint                  lastTapPoint;
@property (nonatomic, strong) UILabel          *shareNum;
@property (nonatomic, strong) UILabel          *commentNum;
@property (nonatomic, strong) UILabel          *favoriteNum;
@property(nonatomic,strong)WXBaseModelContents *baseModelContents ;

@property (nonatomic, strong)NSMutableArray *mtArray;


@property(nonatomic,copy)void (^clickBlock)(NSInteger integer, WXBaseModelContents *baseModelContents) ;
@property(nonatomic,copy)void (^isFavoriteBlock)(BOOL isFavorite, WXBaseModelContents *baseModelContents) ;

@property(nonatomic,copy)void (^textClick)(NSString * text, WXBaseModelContents *baseModelContents) ;

@property (nonatomic, strong) id timer;

@property (nonatomic, assign) BOOL             isPlayerReady;


@property (nonatomic ,assign) BOOL isBoy;

- (void)initSubViews ;


-(void)startAnimation;
@end

NS_ASSUME_NONNULL_END
