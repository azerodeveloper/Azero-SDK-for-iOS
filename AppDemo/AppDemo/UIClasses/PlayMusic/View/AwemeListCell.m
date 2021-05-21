//
//  AwemeListCell.m
//  AwemeDemo
//
//  Created by sunyazhou on 2018/10/18.
//  Copyright © 2018 sunyazhou.com. All rights reserved.
//

#import "AwemeListCell.h"
#import "TGBarrageTableViewCell.h"

#import "JYEqualCellSpaceFlowLayout.h"

@interface AwemeListCell ()



@end

@implementation AwemeListCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = RGBA(0.0, 0.0, 0.0, 0.01);
    [self initSubViews];
    
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;
}
-(void)setBaseModelContents:(WXBaseModelContents *)baseModelContents{
    _baseModelContents = baseModelContents;
    if (![QKUITools isBlankArray:baseModelContents.ext.comment.firstPage]) {
        
        
        __block NSMutableArray *datas =baseModelContents.ext.comment.firstPage.mutableCopy;
        self.mtArray=[NSMutableArray array];
        [self.tableView reloadData];
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //定时器模式  事件源
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
        
        self.timer = timer;
        
        //NSEC_PER_SEC是秒，＊1是每秒
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
        //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
        dispatch_source_set_event_handler(timer, ^{
            //回调主线程，在主线程中操作UI
            dispatch_async(dispatch_get_main_queue(), ^{
                WXBaseModelContentsExtCommentFirstPage *first = datas.firstObject;
                [datas removeObjectAtIndex:0];
                [datas addObject:first];
                //    self.mtArray = mtArray;
                [self.mtArray addObject:first];
                
                //刷新完成
                //
                
                NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow: self.mtArray.count - 1 inSection:0];
                
                [self.tableView insertRowsAtIndexPaths:@[myIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
                         for (UIView *view in self.tableView.subviews) {
                             if ([view isKindOfClass:[UITableViewCell class]]) {
                                 UITableViewCell *cell = (UITableViewCell *)view;
                                 NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

                                 CGFloat alpha = (6 - (self.mtArray.count - indexPath.row))  * 0.1;
                                 if ((self.mtArray.count - indexPath.row)>4) {
                                     alpha=0;
                                 }
                                 cell.alpha = alpha;
                             }
                         }
                [self.tableView scrollToRowAtIndexPath:myIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
            });
        });
        //启动源
        dispatch_resume(self.timer);

    }
    self.tableView.hidden=[QKUITools isBlankArray:baseModelContents.ext.comment.firstPage];
    
    self.desc.text = [QKUITools isBlankString:baseModelContents.title]?@"未知":baseModelContents.title;
    self.nickName.text=baseModelContents.provider.name;
    WXBaseModelContentsArtSources *baseModelContentsArtSources  =  baseModelContents.art.sources.firstObject;
    [self.collectionView reloadData];
    self.favorite.isFavorite=[baseModelContents.ext.like.isLike boolValue];
    self.favoriteNum.text=[baseModelContents.ext.like.num stringValue];
    self.commentNum.text=[baseModelContents.ext.comment.num stringValue];
    if (![QKUITools isBlankArray:self.baseModelContents.tags]) {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(kSCRATIO(23));
        }];
    }
    
    if (![baseModelContents.provider.type isEqualToString:@"news"]) {
        if ([QKUITools isBlankString:baseModelContents.provider.lyric]) {
            [self.coverView setImageWithURL:[NSURL URLWithString:baseModelContentsArtSources.url] placeholder:[UIImage imageNamed:@"placeHolder"]];
            
            self.newsView.hidden=YES;
            self.coverBackgroundView.hidden=NO;
            self.cycleButton.hidden=YES;
            self.lyricView.hidden=YES;
            
            return;
        }
        self.lyricView.lyrics=nil;
        self.newsView.hidden=YES;
        self.coverBackgroundView.hidden=YES;
        self.cycleButton.hidden=YES;
        self.lyricView.hidden=NO;
        self.lyricView.lyrics = [GKLyricParser lyricParserWithUrl:baseModelContents.provider.lyric isDelBlank:YES];
    }else{
        self.lyricView.hidden=YES;
        
        self.newsView.hidden=NO;
        self.coverBackgroundView.hidden=YES;
        self.cycleButton.hidden=YES;
        
        [self.newsImageView setImageWithURL:[NSURL URLWithString:baseModelContentsArtSources.url] placeholder:[UIImage imageNamed:@"placeHolder"]];
        
    }
    
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mtArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXBaseModelContentsExtCommentFirstPage *   baseModelContents= self.mtArray[indexPath.row];
    CGSize size=[QKUITools getTextHeight:baseModelContents.content width:kSCRATIO(220) font:[UIFont systemFontOfSize:kSCRATIO(14)]];
    size.height=size.height<kSCRATIO(50)?size.height:kSCRATIO(50);

    return      size.height+kSCRATIO(55);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TGBarrageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[TGBarrageTableViewCell alloc] init];
    }
    cell.baseModelContents = self.mtArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGPoint animationPoint = CGPointMake(0, 0);
    CGFloat offsetX = animationPoint.x - cell.frame.size.width / 2;
    CGFloat offsetY = animationPoint.y - cell.frame.size.height / 2;
    cell.contentView.transform = CGAffineTransformMake(0.01, 0, 0, 0.01, offsetX, offsetY);
    [UIView animateWithDuration:.5f animations:^{
        cell.contentView.transform = CGAffineTransformMake(1.05f, 0, 0, 1.0f, 0, 0);
    } completion:^(BOOL finished) {
    }];
}


- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return YES;
    
}
#pragma  mark 通知


- (IBAction)circleSliderValueDidChanged:(ZCircleSlider *)slider {
    if (!slider.interaction) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [kPlayer setPlayerProgress: slider.value];
        
    });
    
}
#pragma  mark lazy
- (UIImageView    *)coverView {
    if (!_coverView) {
        _coverView = [UIImageView new];
    }
    return _coverView;
}

- (GKWYMusicLyricView *)lyricView {
    if (!_lyricView) {
        _lyricView = [GKWYMusicLyricView new];
        _lyricView.backgroundColor = [UIColor clearColor];
        _lyricView.hidden = YES;
    }
    return _lyricView;
}
-(UIView *)newsView{
    if (!_newsView) {
        _newsView=[UIView new];
        _newsView.hidden=YES;
    }
    return  _newsView;
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {

        JYEqualCellSpaceFlowLayout * flowLayout = [[JYEqualCellSpaceFlowLayout alloc]initWithType:AlignWithCenter betweenOfCell:5.0];
//        UICollectionViewFlowLayout *layout=[UICollectionViewFlowLayout new];
//        layout.minimumInteritemSpacing=kSCRATIO(10);


        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kSCRATIO(15), 0, ScreenWidth-kSCRATIO(20)*2, kSCRATIO(60)) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor=UIColor.clearColor;
        // 注册cell、sectionHeader、sectionFooter
        [_collectionView registerClass:[SaiTagsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SaiTagsCollectionViewCell class])];
        
        
        
        //        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        
    }
    return _collectionView;
}
- (ZCircleSlider *)circleSlider {
    if (!_circleSlider) {
        _circleSlider = [[ZCircleSlider alloc] initWithFrame:CGRectMake(0, 0, kSCRATIO(280), kSCRATIO(280))];
        _circleSlider.minimumTrackTintColor = UIColor.whiteColor;
        _circleSlider.maximumTrackTintColor = UIColor.clearColor;
        _circleSlider.backgroundTintColor = UIColor.clearColor;
        _circleSlider.circleBorderWidth = kSCRATIO(5);
        _circleSlider.thumbRadius = kSCRATIO(5);
        _circleSlider.thumbExpandRadius = kSCRATIO(10);
        _circleSlider.thumbTintColor = UIColor.whiteColor;
        _circleSlider.circleRadius = _circleSlider.width/2-kSCRATIO(5);
        _circleSlider.value = 0;
        _circleSlider.loadProgress = 0;
        _circleSlider.enabled=NO;
        //        [_circleSlider addTarget:self
        //                          action:@selector(circleSliderValueDidChanged:)
        //                forControlEvents:UIControlEventTouchUpInside];
    }
    return _circleSlider;
}

-(UITextView *)newsTextView{
    if (!_newsTextView) {
        _newsTextView=[UITextView new];
        _newsTextView.font=[UIFont systemFontOfSize:kSCRATIO(18)];
        _newsTextView.textColor=[UIColor colorWithWhite:1 alpha:0.6];
        _newsTextView.backgroundColor=Color222B36;
        _newsTextView.editable=NO;
    }
    return _newsTextView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.contentInset = UIEdgeInsetsMake(_definecellHeight * 4, 0, 0, 0);
      
    }
    return _tableView;
}
@end

