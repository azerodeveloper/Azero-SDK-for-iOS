//
//  AwemeListCell+SaiElement.m
//  HeIsComing
//
//  Created by mike on 2020/10/29.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AwemeListCell+SaiElement.h"
#import <objc/runtime.h>
#import "CommentsPopView.h"
#import "JYEqualCellSpaceFlowLayout.h"

@implementation AwemeListCell (SaiElement)
+ (void)load{
    [AwemeListCell swizzleInstanceMethodWithClass:[AwemeListCell class] originalSel:@selector(initSubViews) replacementSel:@selector(initSubViewsReplace)];
}
+ (void)swizzleInstanceMethodWithClass:(Class)clazz originalSel:(SEL)original replacementSel:(SEL)replacement {
    Method originalMethod = class_getInstanceMethod(clazz, original);// Note that this function searches superclasses for implementations, whereas class_copyMethodList does not!!如果子类没有实现该方法则返回的是父类的方法
    Method replacementMethod = class_getInstanceMethod(clazz, replacement);
    if (class_addMethod(clazz, original, method_getImplementation(replacementMethod), method_getTypeEncoding(replacementMethod))) {
        class_replaceMethod(clazz, replacement, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, replacementMethod);
    }
}
- (void)initSubViewsReplace {
    //init player view;
    
    //init hover on player view container
    self.container = [UIView new];
    self.container.backgroundColor=Color222B36;
    [self.contentView addSubview: self.container];
    
    [self.container addSubview:self.newsView];
    
    [self.container addSubview:self.lyricView];
    
    
    
    
    self.desc = [UILabel CreatLabeltext:@"Someone Like You" Font:[UIFont boldSystemFontOfSize:kSCRATIO(18)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    
    [ self.container addSubview:self.desc];
    
    
    self.nickName = [UILabel CreatLabeltext:@"Someone Like You" Font:[UIFont systemFontOfSize:kSCRATIO(14)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    [self.container addSubview:self.nickName];
    [self.container addSubview:self.collectionView];
    
    self.coverBackgroundView=[UIView new];
    [self.contentView addSubview:self.coverBackgroundView];
    
    [self.coverBackgroundView addSubview:self.coverView];
    
    
    self.coverView.userInteractionEnabled=YES;
    UIImageView *coverBackView=[UIImageView new];
    coverBackView.userInteractionEnabled=YES;
    [self.coverBackgroundView addSubview:coverBackView];
    
    
    
    self.playButton = [[UIButton alloc]init];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"play_icon"] forState:UIControlStateSelected];
    self.playButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.playButton setBackgroundImage:nil forState:0];
    [self.playButton  addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView=[UIView new];
    lineView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5];
    [self.contentView addSubview:lineView];
    self.cycleButton = [[UIButton alloc]init];
    [ self.container addSubview:self.cycleButton];
    [self.cycleButton setImage:[UIImage imageNamed:@"cycleOrder"] forState:0];
    [self.cycleButton setImage:[UIImage imageNamed:@"cycleSingle"] forState:UIControlStateSelected];
    [self.cycleButton  addTarget:self action:@selector(cycleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.share = [[UIImageView alloc]init];
    self.share.contentMode = UIViewContentModeCenter;
    self.share.image = [UIImage imageNamed:@"shareImage"];
    self.share.userInteractionEnabled = YES;
    self.share.tag = kAwemeListLikeShareTag;
    [self.share addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [ self.container addSubview:self.share];
        
    self.comment = [[UIImageView alloc]init];
    self.comment.contentMode = UIViewContentModeCenter;
    self.comment.image = [UIImage imageNamed:@"commits"];
    self.comment.userInteractionEnabled = YES;
    self.comment.tag = kAwemeListLikeCommentTag;
    [self.comment addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [ self.container addSubview:self.comment];
    
    self.collectionImageView = [[UIImageView alloc] init];
    self.collectionImageView.contentMode = UIViewContentModeCenter;
    self.collectionImageView.image = [UIImage imageNamed:@"collectionTag"];
    self.collectionImageView.userInteractionEnabled = YES;
    self.collectionImageView.tag = kAwemeListLikeCollectionTag;
    [self.collectionImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [ self.container addSubview:self.collectionImageView];
    
    
    
    self.commentNum = [UILabel CreatLabeltext:@"13" Font:[UIFont boldSystemFontOfSize:kSCRATIO(13)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    
    [self.container addSubview:self.commentNum];
    
    self.favorite = [FavoriteView new];
    blockWeakSelf;
    [self.favorite setIsFavoriteBlock:^(BOOL isFavorite) {
        if (weakSelf.isFavoriteBlock) {
            weakSelf.isFavoriteBlock(isFavorite, weakSelf.baseModelContents);
        }
    }];
    [ self.container addSubview:self.favorite];
    
    self.favoriteNum = [UILabel CreatLabeltext:@"13" Font:[UIFont boldSystemFontOfSize:kSCRATIO(13)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    
    
    [ self.container addSubview:self.favoriteNum];
    
    
    
    [ self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    self.upwardDynamicHeightMarqueeViewButton=[UIButton new];
    [self.upwardDynamicHeightMarqueeViewButton setImage:[UIImage imageNamed:@"closeBarrageButton"] forState:0];
    [self.upwardDynamicHeightMarqueeViewButton setImage:[UIImage imageNamed:@"openBarrageButton"] forState:UIControlStateSelected];
    
    [self.upwardDynamicHeightMarqueeViewButton addTarget:self action:@selector(upwardDynamicHeightMarqueeViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [ self.container addSubview:self.upwardDynamicHeightMarqueeViewButton];
    
    self.headsetImageView = [[UIImageView alloc]init];
    ViewContentMode(self.headsetImageView);
    self.headsetImageView.image = [UIImage imageNamed:@"形状"];
    self.headsetImageView.userInteractionEnabled = YES;
    self.headsetImageView.hidden = YES;

    self.headsetImageView.tag = kAwemeListLikeHeartTag;
    [self.headsetImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [ self.container addSubview:self.headsetImageView];
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_offset(kStatusBarHeight+kSCRATIO(5));
        make.width.mas_offset(kSCRATIO(250));
        
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.desc.mas_bottom).offset(kSCRATIO(2));
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_offset(kSCRATIO(380));
        make.height.mas_offset(kSCRATIO(1));
        make.top.mas_offset(kSCRATIO(60)+kStatusBarHeight);
    }];
    [self.cycleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(kSCRATIO(64));
        make.right.mas_offset(-kSCRATIO(28));
        make.height.width.mas_offset(kSCRATIO(18));
        
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(kSCRATIO(11));
        make.height.mas_offset(kSCRATIO(0));
        make.left.mas_offset(kSCRATIO(15));
        make.right.mas_offset(0);
    }];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.coverBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.collectionView.mas_bottom).offset(kSCRATIO(15));
        make.width.height.mas_offset(kSCRATIO(300));
    }];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverBackgroundView);
        make.width.height.mas_offset(kSCRATIO(200));
        
    }];
    ViewRadius(self.coverView, kSCRATIO(100));
    ViewContentMode(self.coverView);
    
    coverBackView.image=[UIImage imageNamed:@"coverBackView"];
    
    ViewContentMode(coverBackView);
    
    [coverBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverView);
        make.width.height.mas_offset(kSCRATIO(280));
        
    }];
    self.progressLabel=[UILabel CreatLabeltext:@"" Font:[UIFont systemFontOfSize:kSCRATIO(10)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    
    [coverBackView addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.coverBackgroundView);
        make.top.mas_offset(kSCRATIO(20));
    }];
    [self.coverBackgroundView addSubview:self.circleSlider];
    self.coverBackgroundView.userInteractionEnabled = YES;
    [self.coverBackgroundView addSubview:self.playButton];
    
    [self.circleSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverBackgroundView);
        make.width.height.mas_offset(kSCRATIO(280));
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverView);
        make.width.height.mas_offset(kSCRATIO(57));
    }];
    [self.headsetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-kSCRATIO(50)-BOTTOM_HEIGHT);
        make.right.equalTo(self).inset(12);

        make.width.height.mas_offset(kSCRATIO(30));

    }];
//    [self.headsetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.upwardDynamicHeightMarqueeViewButton.mas_bottom).mas_offset(kSCRATIO(25));
//        make.centerX.equalTo(self.upwardDynamicHeightMarqueeViewButton.mas_centerX).offset(kSCRATIO(-2));
//
//        make.width.height.mas_offset(kSCRATIO(30));
//
//    }];

    [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headsetImageView.mas_top).offset(kSCRATIO(-42));
        make.centerX.equalTo(self.headsetImageView);
        make.width.height.mas_offset(kSCRATIO(30));
    }];
    [self.collectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comment.mas_bottom).offset(kSCRATIO(42));
        make.centerX.equalTo(self.comment);
        make.width.height.mas_offset(kSCRATIO(30));
    }];
    [self.commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comment.mas_bottom).offset(kSCRATIO(5));
        make.centerX.equalTo(self.comment);
    }];
    [self.share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.comment.mas_top).offset(-kSCRATIO(44));
        make.centerX.equalTo(self.headsetImageView);
        make.width.height.mas_offset(kSCRATIO(30));
        
    }];
    
    
    [self.favorite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.share.mas_top).offset(-kSCRATIO(50));
        make.centerX.equalTo(self.headsetImageView);
        make.width.mas_equalTo(kSCRATIO(38));
        make.height.mas_equalTo(kSCRATIO(34));
    }];
    
    [self.favoriteNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favorite.mas_bottom).offset(kSCRATIO(5));
        make.centerX.equalTo(self.favorite);
    }];
    
    
    [self.newsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.container);
        make.top.equalTo(self.collectionView.mas_bottom).offset(kSCRATIO(20));
        make.bottom.mas_offset(kSCRATIO(-6)-BOTTOM_HEIGHT);
        
    }];
    [self.lyricView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.newsView);
    }];
    
    
    self.newsImageView=[UIImageView new];
    ViewContentMode(self.newsImageView);
    self.newsImageView.backgroundColor=UIColor.clearColor;
    [self.newsView addSubview:self.newsImageView];
    
    [self.newsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self.newsView);
        make.width.mas_offset(kSCRATIO(384));
        make.height.mas_offset(kSCRATIO(216));
    }];
    
//    self.upwardDynamicHeightMarqueeView = [[UUMarqueeView alloc] initWithFrame:CGRectMake(0, kSCRATIO(490), ScreenWidth , 130.0f)];
//    self.upwardDynamicHeightMarqueeView.delegate = self;
//    self.upwardDynamicHeightMarqueeView.timeIntervalPerScroll = 0.0f;
//    self.upwardDynamicHeightMarqueeView.timeDurationPerScroll = 0;    // 条目滑动时间
//
//    self.upwardDynamicHeightMarqueeView.scrollSpeed = 30;
//
//    self.upwardDynamicHeightMarqueeView.useDynamicHeight = YES;
//    self.upwardDynamicHeightMarqueeView.touchEnabled = YES;
//    [self.container addSubview:self.upwardDynamicHeightMarqueeView];
//    [self.upwardDynamicHeightMarqueeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_offset(kSCRATIO(15));
//        make.width.mas_offset(kSCRATIO(300));
//        make.bottom.mas_offset(kSCRATIO(-6)-BOTTOM_HEIGHT);
//        make.height.mas_offset(kSCRATIO(360));
//
//    }];
    
//    [self.upwardDynamicHeightMarqueeView layoutIfNeeded];
//
//    self.upwardDynamicHeightMarqueeView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
//        graColor.fromColor = kColorFromARGBHex(0x222B36, 0.8);
//        graColor.toColor = kColorFromARGBHex(0x222B36, 1);
//        graColor.type = QQGradualChangeTypeUpToDown;
//    } size:self.upwardDynamicHeightMarqueeView.size cornerRadius:QQRadiusMakeSame(0)]];
    [self.container addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(15));
        make.width.mas_offset(kSCRATIO(300));
        make.bottom.mas_offset(kSCRATIO(-6)-BOTTOM_HEIGHT-30);
        make.top.equalTo(self.coverBackgroundView.mas_bottom);

    }];
}

- (void)showLyricView {
    self.newsView.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.newsView.alpha            = 1.0;
        self.coverView.alpha            = 0.0;
    }completion:^(BOOL finished) {
        self.newsView.hidden           = NO;
        self.coverView.hidden           = YES;
    }];
}

- (void)showCoverView {
    self.coverView.hidden           = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.newsView.alpha            = 0.0;
        
        self.coverView.alpha            = 1.0;
    }completion:^(BOOL finished) {
        self.newsView.hidden           = YES;
        self.coverView.hidden           = NO;
    }];
}

//gesture
-(void)upwardDynamicHeightMarqueeViewButtonClick:(UIButton *)sender{
    
    sender.selected=!sender.selected;
    self.tableView.hidden=sender.selected;
    SaiContext.isUpwardDynamicHeightMarqueeViewIsOpen=sender.selected;
    
}
-(void)cycleButtonClick:(UIButton *)sender{
    
    sender.selected=!sender.selected;
}
-(void)playButtonClick:(UIButton *)sender{
    
    if (!sender.selected) {
        if (kPlayer.playerState==GKAudioPlayerStatePlaying) {
            [[SaiAzeroManager sharedAzeroManager] saiAzeroButtonPressed:ButtonTypePAUSE];
            sender.selected=!sender.selected;
            
        }
        
    }else{
        if (kPlayer.playerState==GKAudioPlayerStatePaused||kPlayer.playerState==GKAudioPlayerStateStopped||kPlayer.playerState==GKAudioPlayerStateStoppedBy) {
            
            [[SaiAzeroManager sharedAzeroManager] saiAzeroButtonPressed:ButtonTypePLAY];
            sender.selected=!sender.selected;
            
            
        }
    }
}
- (void)handleGesture:(UITapGestureRecognizer *)sender {
    switch (sender.view.tag) {
        case kAwemeListLikeCommentTag: {
            CommentsPopView *popView = [[CommentsPopView alloc] init];
            [popView setTextClick:^(NSString * _Nonnull text) {
                if (self.textClick) {
                    self.textClick(text, self.baseModelContents);
                }
            }];
            [popView show];
            break;
        }
        case kAwemeListLikeShareTag: {
            SharePopView *popView = [[SharePopView alloc] init];
            [popView setClickBlock:^(NSInteger integer) {
                if (self.clickBlock) {
                    self.clickBlock(integer, self.baseModelContents);
                }
                
            }];
            
            [popView show];
            break;
        }
        case kAwemeListLikeHeartTag:{
            if (SaiContext.doudouerji) {
                
            }else{
               
            }
            
        }
            break;
        case kAwemeListLikeCollectionTag:{
//            if (1) {//收藏
//                [self cancelCollectionMusicTag];
//            }else{
                [self collectionMusicTag];
//            }
            
        }
            break;
        default: 
            break;
    }
    
}
#pragma mark - UUMarqueeViewDelegate

- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView*)marqueeView {
    // 指定可视条目的行数，仅[UUMarqueeViewDirectionUpward]时被调用。
    // 当[UUMarqueeViewDirectionLeftward]时行数固定为1。
    return 5;
}

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView*)marqueeView {
    // 指定数据源的个数。例:数据源是字符串数组@[@"A", @"B", @"C"]时，return 3。
    
    
    return self.baseModelContents.ext.comment.firstPage.count;
}

- (void)createItemView:(UIView*)itemView forMarqueeView:(UUMarqueeView*)marqueeView{
    ViewRadius(itemView, kSCRATIO(10));
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(kSCRATIO(3), 0, kSCRATIO(16), kSCRATIO(30))];
    imageView.tag=1010;
    itemView.backgroundColor=Color222B36;
    itemView.backgroundColor=UIColor.clearColor;
    ViewRadius(imageView, kSCRATIO(14));
    ViewContentMode(imageView);
    [itemView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(10));
        make.width.height.mas_offset(kSCRATIO(28));
        make.top.equalTo(itemView);
    }];
    UILabel *content1 = [UILabel CreatLabeltext:@"" Font:[UIFont systemFontOfSize:kSCRATIO(14)] Textcolor:UIColor.whiteColor textAlignment:0];
    content1.tag = 1009;
    [itemView addSubview:content1];
    
    [content1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).mas_offset(kSCRATIO(6));
        make.height.mas_offset(kSCRATIO(20));
        make.top.equalTo(itemView);
    }];
    UIImageView *contentView2=[UIImageView new];
    [itemView addSubview:contentView2];
    contentView2.image=[UIImage imageNamed:@"rectangular"];
    [contentView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).mas_offset(kSCRATIO(6));
        make.top.equalTo(content1.mas_bottom).offset(kSCRATIO(4));
    }];
    UILabel *content2 = [UILabel CreatLabeltext:@"" Font:[UIFont systemFontOfSize:kSCRATIO(14)] Textcolor:UIColor.whiteColor textAlignment:0];
    content2.numberOfLines=2;
    content2.tag = 1008;
    [contentView2 addSubview:content2];
    [content2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView2).insets(UIEdgeInsetsMake(kSCRATIO(4.5), kSCRATIO(7.5), kSCRATIO(4.5), kSCRATIO(7.5)));
        make.width.mas_offset(kSCRATIO(0));
        make.height.mas_offset(kSCRATIO(0));
        
    }];
    
    
}
- (void)updateItemView:(UIView*)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView{
    WXBaseModelContentsExtCommentFirstPage *baseModelContentsExtCommentFirstPage = self.baseModelContents.ext.comment.firstPage[index];
    UIImageView *contentImageView = [itemView viewWithTag:1010];
    [contentImageView setImageWithURL:[NSURL URLWithString:baseModelContentsExtCommentFirstPage.user.pictureUrl] placeholder:[UIImage imageNamed:@"placeHolderSmall"]];
    UILabel *content = [itemView viewWithTag:1009];
    content.text =baseModelContentsExtCommentFirstPage.user.name;
    
    UILabel *content2 = [itemView viewWithTag:1008];
    content2.text =baseModelContentsExtCommentFirstPage.content;
    CGSize size=[QKUITools getTextHeight:baseModelContentsExtCommentFirstPage.content width:kSCRATIO(220) font:[UIFont systemFontOfSize:kSCRATIO(14)]];
    
    size.height=size.height<kSCRATIO(50)?size.height:kSCRATIO(50);
    [content2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(size.height+kSCRATIO(2));
        make.width.mas_offset(size.width+kSCRATIO(2));
        
    }];
}
- (CGFloat)itemViewHeightAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    WXBaseModelContentsExtCommentFirstPage *baseModelContentsExtCommentFirstPage = self.baseModelContents.ext.comment.firstPage[index];
    
    CGSize size=[QKUITools getTextHeight:baseModelContentsExtCommentFirstPage.content width:kSCRATIO(220) font:[UIFont systemFontOfSize:kSCRATIO(14)]];
    
    size.height=size.height<kSCRATIO(50)?size.height:kSCRATIO(50);
    
    return kSCRATIO(60)+size.height;
}

- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    return kSCRATIO(300);
}
#pragma mark UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    WXBaseModelContentsTags *baseModelContentsTags  =self.baseModelContents.tags[indexPath.row];
    CGSize size=[QKUITools getTextHeight:baseModelContentsTags.title hight:kSCRATIO(23) font:[UIFont systemFontOfSize:kSCRATIO(14)]];
    
    return CGSizeMake(size.width+kSCRATIO(23), kSCRATIO(23));
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.baseModelContents.tags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SaiTagsCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SaiTagsCollectionViewCell class]) forIndexPath:indexPath];
    ViewRadius(cell.contentView, kSCRATIO(10));
    WXBaseModelContentsTags *baseModelContentsTags  =self.baseModelContents.tags[indexPath.row];
    cell.cellLabel.text=baseModelContentsTags.title;
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WXBaseModelContentsTags *baseModelContentsTags  =self.baseModelContents.tags[indexPath.row];
    [[SaiAzeroManager sharedAzeroManager]saiAzeroManagerAction:@"Search" andPosition:[NSString stringWithFormat:@"%d",SaiContext.currentIndex+1] selectedPosition:@"" andResourceId:@"" andkeyword:baseModelContentsTags.feedback];
    
}


- (void)collectionMusicTag{
    NSDictionary *paramDic = @{
        @"sourceId":self.baseModelContents.resourceId,
        @"sourceType":@"MUSIC"
    };
    [QKBaseHttpClient httpType:POST andURL:collectionAudioInformationUrl andParam:paramDic andSuccessBlock:^(NSURL *URL, id data) {
        NSString * code = data[@"code"];
        if (code.intValue == 200) {
            self.collectionImageView.image = [UIImage imageNamed:@"collectionTag-fill"];
        }else{
            [MessageAlertView showHudMessage:@"收藏失败，请稍候重试"];
        }
    } andFailBlock:^(NSURL *URL, NSError *error) {
        [MessageAlertView showHudMessage:@"网络请求错误，请稍候重试"];
    }];
}
- (void)cancelCollectionMusicTag{
    NSDictionary *paramDic = @{
        @"userId":SaiContext.currentUser.userId,
        @"resourceInfos":@[],
        @"providerId":@"",
        @"resourceId":self.baseModelContents.resourceId,
        @"type":@"music"
    };
    [QKBaseHttpClient httpType:POST andURL:cancelCollectionAlbumUrl andParam:paramDic andSuccessBlock:^(NSURL *URL, id data) {
        NSString * code = data[@"code"];
        if (code.intValue == 200) {
            self.collectionImageView.image = [UIImage imageNamed:@"collectionTag"];
        }else{
            [MessageAlertView showHudMessage:@"取消收藏失败，请稍候重试"];
        }
    } andFailBlock:^(NSURL *URL, NSError *error) {
        [MessageAlertView showHudMessage:@"网络请求错误，请稍候重试"];
    }];
}

@end
