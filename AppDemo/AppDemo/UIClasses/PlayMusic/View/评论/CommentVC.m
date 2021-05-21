//
//  CommentVC.m
//  dope
//
//  Created by apple on 2018/11/29.
//  Copyright © 2018 apple. All rights reserved.
//

#import "CommentVC.h"
#import "CommentsCell.h"
#import "CustomModel.h"
#import "CommentInfoModel.h"
#import "DetailCellFrame.h"
#import "CommentToolBar.h"
#import <IQKeyboardManager.h>


#import "QQPersonViewController.h"
static NSString *identifer = @"ViewControllerTableViewCell";

@interface CommentVC ()<CommentsTableViewCellDelegate>
@property (nonatomic,strong)CommentToolBar *commentView; //评论框
@property (nonatomic,strong)CustomModel *selectModel;
@property (nonatomic, strong)UIView *blankView;

@end

@implementation CommentVC
{
    NSInteger pageIndex;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    pageIndex=1;
    self.view.backgroundColor=ColorWhite;
    [self.view addSubview:self.baseTableView];

    [self.baseTableView registerClass:[CommentsCell class] forCellReuseIdentifier:identifer];
    self.baseTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            pageIndex=1;
            [self.dataArray removeAllObjects];
            [self createViews];
            [self.baseTableView.mj_header endRefreshing];
            
        });
    }];
    self.baseTableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageIndex++;
        [self createViews];
        [self.baseTableView.mj_footer endRefreshing];

        
    }];
    [self.baseTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-kSCRATIO(50)-BOTTOM_HEIGHT);
    }];
    [self createViews];
   
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-BOTTOM_HEIGHT);
        make.height.mas_offset(kSCRATIO(52));
    }];

    self.commentView.EwenTextViewBlock = ^(NSString *text){

        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             [NSString stringWithFormat:@"%ld",(long)weakSelf.model.squareInfoId]    , @"squareInfoId",
                             text, @"txt",
                             
                             nil];
        if (weakSelf.selectModel) {
            [dic setValue:[NSString stringWithFormat:@"%ld",(long)weakSelf.selectModel.squareCommentId] forKey:@"replyCommentId"];
            [dic setValue:[NSString stringWithFormat:@"%ld",(long)weakSelf.selectModel.userId] forKey:@"replyUserId"];
        }
        [[NetWorkManager sharedManager]postJSON:@"social/social-rest/comment" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
            pageIndex=1;
            [weakSelf createViews];
             [weakSelf.view addSubview:weakSelf.commentView];

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ketBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ketBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.commentView.textView resignFirstResponder];
    if (self.isHiddenNacBar) {
         [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];

    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - 监听键盘高度
- (void)ketBoardWillShow:(NSNotification *)noti{
    //获取键盘的高度
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    double height = keyboardRect.size.height;
    [UIView animateWithDuration:0.25 animations:^{

        [self.commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.equalTo(self.view).offset(-height);
            make.height.mas_offset(kSCRATIO(52));
        }];
        [self.commentView layoutIfNeeded];
    }];
    
}

- (void)ketBoardWillHidden:(NSNotification *)noti{
    [UIView animateWithDuration:0.25 animations:^{

        [self.commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.equalTo(self.view).offset(-BOTTOM_HEIGHT);
            make.height.mas_offset(kSCRATIO(52));
        }];
        [self.commentView layoutIfNeeded];
    }];
}


-(void)backAction{
    if (self.back) {
        self.back();
    }

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createViews {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSString stringWithFormat:@"%ld",(long)_model.squareInfoId], @"squareInfoId",
                         [NSString stringWithFormat:@"%ld",(long)pageIndex], @"pageIndex",
                                                      @"10", @"pageSize",
                         
                                                      nil];
                                 [[NetWorkManager sharedManager]getData:@"social/social-rest/comment-list" parameters:dic  success:^(NSURLSessionDataTask *task, id responseObject) {
                                    
                                     if (pageIndex==1) {
                                         [self.dataArray removeAllObjects];
                                     }

                                     NSArray *array=responseObject[@"data"];
                                     if (![UtilTools isBlankArray:array]) {
                                         
                                   
                                         for (NSDictionary *dic in array) {
                                        
                                         CustomModel *model = [[CustomModel alloc] init];
                                             [model setValuesForKeysWithDictionary:  dic[@"baseComment"]];
                                         model.name =model.userName;
                                         model.content = model.txt;
                                         NSMutableArray *arr = [NSMutableArray array];
                                         
                                             for (NSDictionary *diction in dic[@"detailComment"]) {
                                             CommentInfoModel *mod = [[CommentInfoModel alloc] init];
                                                 [mod setValuesForKeysWithDictionary:  diction];


                                             mod.replyContent = mod.txt;
                                             mod.replyTime =[UtilTools intervalSinceNow:[UtilTools getDateFromDateLine:[NSString stringWithFormat:@"%@",mod.commentTime] format:@"yyyy-MM-dd HH:mm:ss"]];
                                             mod.nickName = mod.userName;
                                             mod.toNickName = mod.replyUserName;
                                             mod.toUserImageUrl = mod.userAvatar;
                                             mod.userImageUrl = mod.replyUserAvatar;
                                             
                                             [arr addObject:mod];
                                         }
                                         model.commentArray = [self statusFramesWithStatuses:arr];
                                         [self.dataArray addObject:model];
                                     }
                                        
                                         
                                           }
                                     if ([UtilTools isBlankArray:self.dataArray]) {
                                         self.baseTableView.tableFooterView =self.blankView;
                                     }else
                                     {
                                         self.baseTableView.tableFooterView =nil;
                                         [self.baseTableView reloadData];
                                         
                                     }
                                 } failure:^(NSURLSessionDataTask *task, NSError *error) {

                                 }];
    
   
    
   
    
    ;

}
-(UIView *)blankView{
    if (!_blankView) {
        _blankView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, kSCRATIO(350))];
        _blankView.backgroundColor=Color130A29;
        UIImageView *blankImageView=[UIImageView new];
        blankImageView.image=[UIImage imageNamed:@"blankImage"];
        [_blankView addSubview:blankImageView];
        UILabel *blankLabel=[UILabel CreatLabeltext:@"暂时还没有评论" Font:[UIFont systemFontOfSize:kSCRATIO(12)] Textcolor:Color999999 textAlignment:NSTextAlignmentCenter];
        blankLabel.backgroundColor=Color130A29;
        [_blankView addSubview:blankLabel];
       
        [blankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(kSCRATIO(120));
            make.centerX.equalTo(_blankView);
            
            make.width.mas_offset(kSCRATIO(220));
            make.height.mas_offset(kSCRATIO(160));
        }];
        [blankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_blankView);
            make.top.equalTo(blankImageView.mas_bottom).offset(kSCRATIO(20));
            
            make.width.mas_equalTo(kSCRATIO(300));
            make.height.mas_equalTo(kSCRATIO(17));
        }];
        
       
    }
    return  _blankView;
}
#pragma mark -TableView Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomModel *model = self.dataArray[indexPath.row];

    return model.height;
}
- (NSMutableArray *)statusFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (CommentInfoModel *commentModel in statuses) {
        DetailCellFrame *frame = [[DetailCellFrame alloc] init];
        frame.commentModel = commentModel;
        [frames addObject:frame];
    }
    return frames;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate=self;
    cell.model = self.dataArray[indexPath.row];
    [cell.tableView reloadData];
    [cell setModelblock:^(CustomModel *model) {
        QQPersonViewController *person=[[QQPersonViewController alloc]init];
        person.userId=[NSString stringWithFormat:@"%ld",(long)model.userId];
        person.isPerson=![[NSString stringWithFormat:@"%ld",(long)model.userId] isEqualToString:Context.currentUser.userId];
        person.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:person animated:YES];
        
    }];
    [cell setIdBlock:^(NSString *userID) {
        QQPersonViewController *person=[[QQPersonViewController alloc]init];
        person.userId=userID;
        person.isPerson=![userID isEqualToString:Context.currentUser.userId];
        person.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:person animated:YES];
    }];
    cell.backgroundColor=Color130A29;

    return cell;
}
-(void)reload{
    
    [self.baseTableView reloadData ];

}

- (void)clickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index  key:(NSString *)key {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomModel *model= self.dataArray[indexPath.row];
    [self.commentView setPlaceholderText:[NSString stringWithFormat:@"回复%@",model.userName]];
    self.commentView.row=indexPath.row;
    self.selectModel =model;

    if (![self.commentView.textView becomeFirstResponder]) {
        [self.commentView.textView becomeFirstResponder];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -Lazy Load

-(CommentToolBar *)commentView
{
    if (!_commentView) {
        _commentView = [[CommentToolBar alloc]init];
        _commentView.backgroundColor=ColorWhite;
        [_commentView setPlaceholderText:@"说点什么吧…"];
    }
    return _commentView;
}


@end
