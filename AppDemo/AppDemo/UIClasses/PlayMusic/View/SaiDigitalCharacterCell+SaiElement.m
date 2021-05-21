//
//  SaiDigitalCharacterCell+SaiElement.m
//  HeIsComing
//
//  Created by mike on 2020/10/29.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiDigitalCharacterCell+SaiElement.h"
static const NSInteger kAwemeListLikeCommentTag = 0x01;
static const NSInteger kAwemeListLikeShareTag   = 0x02;
static const NSInteger kAwemeListLikeHeartTag   = 0x03;

@implementation SaiDigitalCharacterCell (SaiElement)
+ (void)load{

    [SaiDigitalCharacterCell swizzleInstanceMethodWithClass:[SaiDigitalCharacterCell class] originalSel:@selector(initSubViews) replacementSel:@selector(initSubViewsReplace)];
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
    self.contentView.backgroundColor=Color222B36;
    //init hover on player view container
    self.container = [UIView new];
    [self.contentView addSubview: self.container];
    
    self.singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [ self.container addGestureRecognizer: self.singleTapGesture];
    
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
    
    self.commentNum = [UILabel CreatLabeltext:@"13" Font:[UIFont boldSystemFontOfSize:kSCRATIO(13)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    
    [self.container addSubview:self.commentNum];
    
    self.favorite = [[FavoriteView alloc]initWithFrame:CGRectMake(0, 0, kSCRATIO(38), kSCRATIO(34))];
    blockWeakSelf;
    [self.favorite setIsFavoriteBlock:^(BOOL isFavorite) {
        if (weakSelf.isFavoriteBlock) {
            weakSelf.isFavoriteBlock(isFavorite, weakSelf.baseModelContents);
        }
    }];
    [ self.container addSubview:self.favorite];
    
    self.favoriteNum = [UILabel CreatLabeltext:@"" Font:[UIFont boldSystemFontOfSize:kSCRATIO(13)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
    
    
    [ self.container addSubview:self.favoriteNum];
    
    
    
    [ self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.upwardDynamicHeightMarqueeViewButton=[UIButton new];
    [self.upwardDynamicHeightMarqueeViewButton setImage:[UIImage imageNamed:@"closeBarrageButton"] forState:0];
    [self.upwardDynamicHeightMarqueeViewButton setImage:[UIImage imageNamed:@"openBarrageButton"] forState:UIControlStateSelected];
    [ self.container addSubview:self.upwardDynamicHeightMarqueeViewButton];
    [self.upwardDynamicHeightMarqueeViewButton addTarget:self action:@selector(upwardDynamicHeightMarqueeViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];

  
  
    self.headsetImageView = [[UIImageView alloc]init];
    ViewContentMode(self.headsetImageView);
    self.headsetImageView.image = [UIImage imageNamed:@"形状"];
    self.headsetImageView.userInteractionEnabled = YES;
    self.headsetImageView.hidden = YES;

    self.headsetImageView.tag = kAwemeListLikeHeartTag;
    [self.headsetImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [self.container addSubview:self.headsetImageView];
    [self.headsetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headsetImageView.mas_bottom).mas_offset(kSCRATIO(30));
        make.centerX.equalTo(self.headsetImageView);

        make.width.height.mas_offset(kSCRATIO(30));

    }];
    [self.headsetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-kSCRATIO(50)-BOTTOM_HEIGHT);
        make.right.equalTo(self).inset(12);
        
        make.width.height.mas_offset(kSCRATIO(30));
        
    }];
    UIView *descBackView=[UIView new];
    self.descBackView=descBackView;
    descBackView.hidden=YES;
    descBackView.backgroundColor=kColorFromRGBHex(0x182015);
    ViewRadius(descBackView, kSCRATIO(7));
    [ self.container addSubview:descBackView];
    self.desc=[UILabel CreatLabeltext:@"" Font:[UIFont systemFontOfSize:kSCRATIO(12)] Textcolor:UIColor.whiteColor textAlignment:0];
    self.desc.numberOfLines=0;
    [descBackView addSubview:self.desc];
    
    [descBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(kSCRATIO(-15));
        make.width.mas_offset(kSCRATIO(120));

        make.top.mas_offset(kStatusBarHeight+kSCRATIO(120));
    }];
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(descBackView).inset(kSCRATIO(15));
//        make.height.mas_offset(kSCRATIO(15));
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.desc.mas_bottom).offset(kSCRATIO(2));
    }];
  
    
   
    [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headsetImageView.mas_top).offset(kSCRATIO(-42));
        make.centerX.equalTo(self.headsetImageView);
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
//    [self.shareNum mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.share.mas_bottom).offset(kSCRATIO(5));
//        make.centerX.equalTo(self.share);
//    }];
    
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
 
//    self.upwardDynamicHeightMarqueeView = [[UUMarqueeView alloc] initWithFrame:CGRectMake(0, kSCRATIO(490), ScreenWidth , 130.0f)];
//    self.upwardDynamicHeightMarqueeView.backgroundColor = [UIColor clearColor];
//    self.upwardDynamicHeightMarqueeView.delegate = self;
//    self.upwardDynamicHeightMarqueeView.timeIntervalPerScroll = 0.0f;
//    self.upwardDynamicHeightMarqueeView.timeDurationPerScroll = 0;    // 条目滑动时间
//    
//    self.upwardDynamicHeightMarqueeView.scrollSpeed = 10;
//    
//    self.upwardDynamicHeightMarqueeView.useDynamicHeight = YES;
//    self.upwardDynamicHeightMarqueeView.touchEnabled = YES;
//    [self.container addSubview:self.upwardDynamicHeightMarqueeView];
    [self.container addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(15));
        make.width.mas_offset(kSCRATIO(300));
        make.bottom.mas_offset(kSCRATIO(-6)-BOTTOM_HEIGHT-30);
        make.height.mas_equalTo(_definecellHeight * 4);

    }];
    
    
    [self.contentView addSubview:self.newFeaturesTableView];
    [self.newFeaturesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.right.mas_equalTo(self.contentView).offset(-20);
            make.top.mas_equalTo(self.contentView.mas_safeAreaLayoutGuideTop).offset(60);
            make.width.offset(100);
            make.height.offset(300);
        }else{
            make.right.mas_equalTo(self.contentView).offset(-20);
            make.top.mas_equalTo(self.contentView).offset(60);
            make.width.offset(100);
            make.height.offset(300);
        }
    }];
  
}
//gesture
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
        default: {
            //获取点击坐标，用于设置爱心显示位置
            CGPoint point = [sender locationInView:self.container];
            //获取当前时间
            NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
            //判断当前点击时间与上次点击时间的时间间隔
            if(time -self.lastTapTime > 0.25f) {
                //推迟0.25秒执行单击方法
                //                [self performSelector:@selector(singleTapAction) withObject:nil afterDelay:0.25f];
            }else {
                //取消执行单击方法
                //                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction) object: nil];
                //执行连击显示爱心的方法
//                [self showLikeViewAnim:point oldPoint:self.lastTapPoint];
            }
            //更新上一次点击位置
            self.lastTapPoint = point;
            //更新上一次点击时间
            self.lastTapTime =  time;
            break;
        }
    }
    
}

-(void)upwardDynamicHeightMarqueeViewButtonClick:(UIButton *)sender{
    
    sender.selected=!sender.selected;
    self.tableView.hidden=sender.selected;
    SaiContext.isUpwardDynamicHeightMarqueeViewIsOpen=sender.selected;

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
    CGSize size=[QKUITools getTextHeight:baseModelContentsExtCommentFirstPage.content width:kSCRATIO(235) font:[UIFont systemFontOfSize:kSCRATIO(14)]];

    size.height=size.height<kSCRATIO(50)?size.height:kSCRATIO(50);
    [content2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(size.height+kSCRATIO(2));
        make.width.mas_offset(size.width+kSCRATIO(2));
        
    }];
}
- (CGFloat)itemViewHeightAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    WXBaseModelContentsExtCommentFirstPage *baseModelContentsExtCommentFirstPage = self.baseModelContents.ext.comment.firstPage[index];

    CGSize size=[QKUITools getTextHeight:baseModelContentsExtCommentFirstPage.content width:kSCRATIO(235) font:[UIFont systemFontOfSize:kSCRATIO(14)]];

    size.height=size.height<kSCRATIO(50)?size.height:kSCRATIO(50);

    return kSCRATIO(60)+size.height;
}

- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    return kSCRATIO(300);
}


@end
