//
//  SaiDigitalCharacterCell.m
//  HeIsComing
//
//  Created by mike on 2020/10/28.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiDigitalCharacterCell.h"
#import "TGBarrageTableViewCell.h"
#import "SaiNewFeaturesCellFrameModel.h"
#import "SaiNewFeaturesPureTextCell.h"


@implementation SaiDigitalCharacterCell
{
    NSTimeInterval  localDataNSTimeInterval;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backImageView=[LLGifImageView new];
        [self.contentView addSubview:self.backImageView];
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.mas_offset(kScreenWidth*0.9);
            make.height.mas_offset(kScreenHeight*0.9);
        }];
        ViewContentMode(self.backImageView);
        [self initSubViews];
    }
    return  self;
    
}


-(void)setIndexPath:(NSInteger)indexPath{
    _indexPath=indexPath;
//    int x = _indexPath%2;
    NSData *localData;
    if (self.isBoy) {
//        localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"互动%@",@"1"] ofType:@"gif"]];
        localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"互动男" ofType:@"gif"]];
    }else{
        localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"互动%@",@"1"] ofType:@"gif"]];
    }
    self.backImageView.gifData = localData;
    localDataNSTimeInterval=  [LLGifImageView durationForGifData:localData];
}


-(void)startAnimation{
//    int x = self.indexPath%2;
    [self.backImageView startGif];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(localDataNSTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData *localData2;
        if (self.isBoy) {
//            localData2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"待机%@",@"1"] ofType:@"gif"]];
            localData2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"待机男" ofType:@"gif"]];
//            localData2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"待机男" ofType:@"gif"]];
        }else{
            localData2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"待机%@",@"1"] ofType:@"gif"]];
        }
        self.backImageView.gifData = localData2;
        
        
        
    });
    
}



-(void)setBaseModelContents:(WXBaseModelContents *)baseModelContents{
    _baseModelContents=baseModelContents;
    self.favorite.isFavorite=[baseModelContents.ext.like.isLike boolValue];
    self.favoriteNum.text=[baseModelContents.ext.like.num stringValue];
    self.commentNum.text=[baseModelContents.ext.comment.num stringValue];
    if (![QKUITools isBlankArray:self.baseModelContents.guideWords]) {
        
        [self.newFeaturesTableView reloadData];
    }
  
    self.newFeaturesTableView.hidden=[QKUITools isBlankArray:self.baseModelContents.guideWords];

    self.descBackView.hidden=![QKUITools isBlankArray:self.baseModelContents.guideWords]||([self.baseModelContents.position intValue]==0);
    if (![QKUITools isBlankArray:self.baseModelContents.ext.comment.firstPage]) {
        
        
        __block NSMutableArray *datas =baseModelContents.ext.comment.firstPage.mutableCopy;
        self.mtArray=[NSMutableArray array];
//        self.cyclesQueueItem=nil;
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
    
    
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.newFeaturesTableView == tableView) {
        return self.baseModelContents.guideWords.count;
    }else{
        return self.mtArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.newFeaturesTableView == tableView) {
        SaiNewFeaturesPureTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaiNewFeaturesPureTextCell"];
        SaiNewFeaturesCellFrameModel *newFeaturesCellFrameModel=[SaiNewFeaturesCellFrameModel new];
        newFeaturesCellFrameModel.featuresText=self.baseModelContents.guideWords[indexPath.row];
        cell.frameModel = newFeaturesCellFrameModel;
        return cell;
    }else{
        TGBarrageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[TGBarrageTableViewCell alloc] init];
        }
        cell.baseModelContents = self.mtArray[indexPath.row];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.newFeaturesTableView == tableView) {
        SaiNewFeaturesCellFrameModel *newFeaturesCellFrameModel=[SaiNewFeaturesCellFrameModel new];
        newFeaturesCellFrameModel.featuresText=self.baseModelContents.guideWords[indexPath.row];
        
        return [QKUITools isBlankArray:self.baseModelContents.guideWords]?0:newFeaturesCellFrameModel.cellHeight+kSCRATIO(10);
    }else{
        WXBaseModelContentsExtCommentFirstPage *   baseModelContents= self.mtArray[indexPath.row];
        CGSize size=[QKUITools getTextHeight:baseModelContents.content width:kSCRATIO(220) font:[UIFont systemFontOfSize:kSCRATIO(14)]];
        size.height=size.height<kSCRATIO(50)?size.height:kSCRATIO(50);

        return      size.height+kSCRATIO(55);
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.newFeaturesTableView == tableView) {
        return;
    }else{
        CGPoint animationPoint = CGPointMake(0, 0);
        CGFloat offsetX = animationPoint.x - cell.frame.size.width / 2;
        CGFloat offsetY = animationPoint.y - cell.frame.size.height / 2;
        cell.contentView.transform = CGAffineTransformMake(0.01, 0, 0, 0.01, offsetX, offsetY);
        [UIView animateWithDuration:.5f animations:^{
            cell.contentView.transform = CGAffineTransformMake(1.05f, 0, 0, 1.0f, 0, 0);
        } completion:^(BOOL finished) {
        }];
    }
    
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
- (UITableView *)newFeaturesTableView{
    if (_newFeaturesTableView == nil) {
        _newFeaturesTableView = [[UITableView alloc] init];
        _newFeaturesTableView.backgroundColor = [UIColor clearColor];
        _newFeaturesTableView.scrollEnabled = NO;
        _newFeaturesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _newFeaturesTableView.delegate = self;
        _newFeaturesTableView.dataSource = self;
        [_newFeaturesTableView registerClass:[SaiNewFeaturesPureTextCell class] forCellReuseIdentifier:@"SaiNewFeaturesPureTextCell"];
        _newFeaturesTableView.hidden = YES;
    }
    return _newFeaturesTableView;
}

- (NSMutableArray *)messagesArray{
    if (_messagesArray==nil) {
        _messagesArray = [NSMutableArray array];
        for (int i=0; i<3; i++) {
            SaiNewFeaturesCellFrameModel *model = [[SaiNewFeaturesCellFrameModel alloc] init];
            model.featuresText = @"你好呀 你好呀你好呀你好呀你好呀你好呀你好呀你好呀";
            [_messagesArray addObject:model];
        }
    }
    return _messagesArray;
}

@end
