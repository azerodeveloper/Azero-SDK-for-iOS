//
//  AwemeListCell.h
//  AwemeDemo
//
//  Created by sunyazhou on 2018/10/18.
//  Copyright © 2018 sunyazhou.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMarqueeView.h"
#import "FavoriteView.h"
#import "SharePopView.h"
#import "GKWYMusicCoverView.h"
#import "GKWYMusicLyricView.h"
#import "WXBaseModel.h"
#import "SaiTagsCollectionViewCell.h"
#import "ZCircleSlider.h"
#import "QQCorner.h"

static const NSInteger kAwemeListLikeCommentTag = 0x01;
static const NSInteger kAwemeListLikeShareTag   = 0x02;
static const NSInteger kAwemeListLikeHeartTag   = 0x03;
static const NSInteger kAwemeListLikeCollectionTag   = 0x04;

NS_ASSUME_NONNULL_BEGIN

@interface AwemeListCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UIImageView    *coverView;
@property (nonatomic, strong) UIView    *coverBackgroundView;

@property (nonatomic, strong) UIView    *newsView;
@property (nonatomic, strong) UIImageView    *newsImageView ;
@property (nonatomic, strong) UITextView    *newsTextView;
@property (nonatomic, strong) UIButton    *playButton;
@property (nonatomic, strong) UILabel    *progressLabel;

/** 歌词视图 */
@property (nonatomic, strong) GKWYMusicLyricView    *lyricView;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic ,strong) WXBaseModelContents *baseModelContents;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic, strong) UUMarqueeView *upwardDynamicHeightMarqueeView;
@property(nonatomic,strong)NSMutableArray *chatContentList;
@property (nonatomic, strong) UILabel          *desc;
@property (nonatomic, strong) UILabel          *nickName;
@property(nonatomic,strong)UILabel *newsLabel ;
@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong) UIImageView      *avatar;
@property(nonatomic,strong)UIButton * upwardDynamicHeightMarqueeViewButton;
@property(nonatomic,strong)ZCircleSlider *circleSlider ;

@property (nonatomic, strong) UIImageView      *share;
@property (nonatomic, strong) UIImageView      *comment;
@property (nonatomic, strong) UIImageView      *headsetImageView;
@property (nonatomic, strong) UIImageView      *collectionImageView;


@property (nonatomic, strong) FavoriteView     *favorite;
@property(nonatomic,strong)UIButton *cycleButton ;

@property (nonatomic, strong) UILabel          *shareNum;
@property (nonatomic, strong) UILabel          *commentNum;
@property (nonatomic, strong) UILabel          *favoriteNum;
@property (nonatomic, strong) NSArray               *playList;
@property (nonatomic, copy) NSString *song_name;
@property (nonatomic, strong) GKWYMusicModel        *model;
@property (nonatomic, assign) BOOL             isPlayerReady;
@property (nonatomic, strong) UIView                   *container;
@property (nonatomic, strong) UITapGestureRecognizer   *singleTapGesture;

@property (nonatomic, assign) NSTimeInterval           lastTapTime;
@property (nonatomic, assign) CGPoint                  lastTapPoint;

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *mtArray;
@property (nonatomic, strong) id timer;

@property(nonatomic,copy)void (^clickBlock)(NSInteger integer, WXBaseModelContents *baseModelContents) ;
@property(nonatomic,copy)void (^isFavoriteBlock)(BOOL isFavorite, WXBaseModelContents *baseModelContents) ;
@property(nonatomic,copy)void (^textClick)(NSString * text, WXBaseModelContents *baseModelContents) ;


-(void)initSubViews;


@end

NS_ASSUME_NONNULL_END
