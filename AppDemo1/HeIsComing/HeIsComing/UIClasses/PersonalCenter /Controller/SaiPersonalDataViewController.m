//
//  SaiPersonalDataViewController.m
//  HeIsComing
//
//  Created by mike on 2020/3/25.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiPersonalDataViewController.h"
#import "SaiChooseView.h"
#import <AVFoundation/AVFoundation.h>
#import "YLSOPickerView.h"
#import "TZImagePickerController.h"
#import "EOTimerPicker.h"
#import "MessageAlertView.h"
#import "SaiJXHomePageViewController.h"
#import "BaseNC.h"
#import "LoginViewController.h"
#import "SaiNewFeatureViewController.h"

#define LogoutButtonX   20
#define LogoutButtonH   50
#define LogoutButtonY   50

@interface SaiPersonalDataViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,TZImagePickerControllerDelegate>
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSArray *placeDataArray;

@end

@implementation SaiPersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人资料";

    [self setNavigation];
    self.dataArray=@[@"头像",@"昵称",@"性别",@"生日",@"邮箱"];
    self.placeDataArray=@[@"添加",@"添加",@"选择",@"选择",@"添加"];
//    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc] initWithTitle:@"完成    " style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
//    UIBarButtonItem *barItem;
//    if (@available(iOS 9, *)) {
//        barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
//    }
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSFontAttributeName] = UIColor.blackColor;
//    [barItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    NSDictionary *dic =[NSDictionary dictionaryWithObject:UIColor.blackColor forKey:NSForegroundColorAttributeName];
//    [rightitem setTitleTextAttributes:dic forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = rightitem;
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled=NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.left.top.mas_offset(0);
    }];
    [self getDataClick];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newNotice:)
                                                 name:@"性别选择"
                                               object:nil];
    
    UIButton *logoutButton = [[UIButton alloc] init];
    logoutButton.frame = CGRectMake(LogoutButtonX, ScreenHeight-LogoutButtonH-LogoutButtonY, ScreenWidth-LogoutButtonX*2, LogoutButtonH);
    [logoutButton addTarget:self action:@selector(loginOutClick) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.layer.masksToBounds = YES;
    logoutButton.layer.cornerRadius = LogoutButtonH/2;
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];  
    logoutButton.titleLabel.textColor = [UIColor whiteColor];
    logoutButton.backgroundColor = SaiColor(0, 149, 231);
    [self.view addSubview:logoutButton];
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(LogoutButtonX);
        make.right.equalTo(self.view).with.offset(-LogoutButtonX);
        make.height.mas_equalTo(LogoutButtonH);
        make.bottom.equalTo(self.view).with.offset(-LogoutButtonY);
    }];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)getDataClick{
    [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/queryUserInfo" andParam:@{@"userId":SaiContext.currentUser.userId} andSuccessBlock:^(NSURL *URL, id data) {
        NSDictionary *dic=(NSDictionary *)data;
        UIImageView *imageView =   [self.view viewWithTag:10000];
        imageView.hidden=NO;
        [imageView setImageURL:[NSURL URLWithString:dic[@"data"][@"pictureUrl"]]];
        ((UITextField *)[self.view viewWithTag:1001]).text=dic[@"data"][@"name"];
        ((UITextField *)[self.view viewWithTag:1002]).text=dic[@"data"][@"sex"];
        
        ((UITextField *)[self.view viewWithTag:1003]).text=dic[@"data"][@"birthday"];
        ((UITextField *)[self.view viewWithTag:1004]).text=dic[@"data"][@"email"];
    } andFailBlock:^(NSURL *URL, NSError *error) {
        
    }];
}
-(void)updatePersonalDataWithPictureUrl:(NSString *)pictureUrl{
    NSDictionary *paraDic=@{@"userId":SaiContext.currentUser.userId,@"pictureUrl":pictureUrl,};
    [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/modify" andParam:paraDic andSuccessBlock:^(NSURL *URL, id data) {
        NSDictionary *   dict = (NSDictionary *)data;
        NSString *code = dict[@"code"];
        if (code.intValue == 200) {
            SaiContext.currentUser.pictureUrl=paraDic[@"pictureUrl"];
            [YYTextArchiver archiveRootObject:SaiContext.currentUser toFile:DOCUMENT_FOLDER(@"loginedUser")];
        }
        
        
    } andFailBlock:^(NSURL *URL, NSError *error) {
        
    }];
}
-(void)rightBtnClick{
//    if (((UITextField *)[self.view viewWithTag:1001]).text.length<4||((UITextField *)[self.view viewWithTag:1001]).text.length>20) {
//        [MessageAlertView showHudMessage:@"昵称请输入4-20个字符"];
//        return;
//    }
    
    UIImageView *image=[self.view viewWithTag:10000];
    NSData *uploadImageData = UIImageJPEGRepresentation(image.image, 0.5);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/html",nil];
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",SaiContext.currentUser.token] forHTTPHeaderField:@"Authorization"];
    [manager POST:@"https://api-azero.soundai.cn/v1/cmsservice/resource/upload"  parameters:nil headers:nil constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyyMMddHHmmss";
        NSString *str=[formatter stringFromDate:[NSDate date]];
        NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
        [formData appendPartWithFileData:uploadImageData name:@"file" fileName:fileName mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 转换responseObject对象
        NSDictionary *dict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            dict = (NSDictionary *)responseObject;
            NSString *code = dict[@"code"];
            if (code.intValue == 200) {
                NSDictionary *dataDic = dict[@"data"];
                NSString *pictureUrl = dataDic[@"url"];
                [self updatePersonalDataWithPictureUrl:pictureUrl];
            }else{
                [MessageAlertView showHudMessage:@"修改失败，请稍后重试。"];
            }
        } else {
            dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSString *code = dict[@"code"];
            if (code.intValue == 200) {
                NSDictionary *dataDic = dict[@"data"];
                NSString *pictureUrl = dataDic[@"url"];
                [self updatePersonalDataWithPictureUrl:pictureUrl];
            }else{
                [MessageAlertView showHudMessage:@"修改失败，请稍后重试。"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TYLog(@"error : %@",error);
        [MessageAlertView showHudMessage:@"修改失败，请稍后重试。"];
    }];
}
-(void)loginOutClick{
    [QKBaseHttpClient httpType:GET andURL:@"/v1/surrogate/users/logout" andParam:@{@"userId":SaiContext.currentUser.userId} andSuccessBlock:^(NSURL *URL, id data) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SaikIsLogin];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[SaiJXHomePageViewController sharedInstance] switchIndex:1];
        [SaiNotificationCenter postNotificationName:SaiLogoutSuccessNoti object:nil];
//        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:nil messmage:@"827record SaiPersonalDataViewController **************** [[XBEchoCancellation shared] stop] 前"];
        [[XBEchoCancellation shared] stop];
//        [[SaiAzeroManager sharedAzeroManager] saiUpdateMessageWithLevel:SaiINFO tag:nil messmage:@"827record SaiPersonalDataViewController **************** [[XBEchoCancellation shared] stop] 后"];
        [kPlayer stop];
        [[AudioQueuePlay sharedAudioQueuePlay] immediatelyStopPlay];
        [[SaiAzeroManager sharedAzeroManager] saiAzeroButtonPressed:ButtonTypePAUSE];
        [[SaiAzeroManager sharedAzeroManager] saiLogoutAzeroSDK];

        SaiNewFeatureViewController *newFeatureViewController = [[SaiNewFeatureViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController =newFeatureViewController ;
    } andFailBlock:^(NSURL *URL, NSError *error) {
        
    }];
}
- (void)keyboardHide:(UITapGestureRecognizer *)tap
{
    YLSOPickerView *pickView=(YLSOPickerView *)tap.view;
    [pickView quit];
    
}
#pragma mark -  Notification Methods

- (void)newNotice:(NSNotification *)notification
{
    UITextField *textField=(UITextField *)[self.view viewWithTag:1002];
    textField.text=notification.object;
    NSDictionary *paraDic=@{@"userId":SaiContext.currentUser.userId,@"sex":((UITextField *)[self.view viewWithTag:1002]).text};
    [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/modify" andParam:paraDic andSuccessBlock:^(NSURL *URL, id data) {
        NSDictionary *   dict = (NSDictionary *)data;
        NSString *code = dict[@"code"];
        if (code.intValue == 200) {
            SaiContext.currentUser.sex=paraDic[@"sex"];
            [YYTextArchiver archiveRootObject:SaiContext.currentUser toFile:DOCUMENT_FOLDER(@"loginedUser")];
        }
        
        
    } andFailBlock:^(NSURL *URL, NSError *error) {
        
    }];
    
    
}
#pragma mark - UITableViewDataSource Methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [[UIFont systemFontOfSize:17] fontWithBold];
        cell.textLabel.textColor=Color333333;
        cell.detailTextLabel.textColor=Color666666;
        cell.detailTextLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dx_icon_next"]];
        cell.backgroundColor=UIColor.whiteColor;
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(KScreenW-280, 0, 250, cell.frame.size.height)];
    textField.textColor=Color666666;
    textField.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    textField.textAlignment=NSTextAlignmentRight;
    NSMutableParagraphStyle *style = [textField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.alignment=NSTextAlignmentRight;
    style.minimumLineHeight = textField.font.lineHeight - (textField.font.lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) / 2.0;
    textField.attributedPlaceholder=[[NSAttributedString alloc] initWithString:self.placeDataArray[indexPath.row] attributes:@{NSForegroundColorAttributeName: Color999999,NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName : style}];
    textField.delegate=self;
    textField.tag=1000+indexPath.row;
    [cell.contentView addSubview:textField];
    if (indexPath.row==0) {
        UIImageView *image=[UIImageView new];
        image.tag=10000;
        image.hidden=YES;
        image.contentMode=UIViewContentModeScaleAspectFill;
        image.clipsToBounds=YES;
        [cell.contentView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_offset(kSCRATIO(33));
            make.centerY.right.equalTo(textField);
        }];
    }
    return cell;
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==1001) {
          if (textField.text.length<4 ||textField.text.length>20) {
              [MessageAlertView showHudMessage:@"昵称请输入4-20个字符"];
              return;
          }
          NSDictionary *paraDic=@{@"userId":SaiContext.currentUser.userId,@"name":textField.text};
                       [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/modify" andParam:paraDic andSuccessBlock:^(NSURL *URL, id data) {
                           NSDictionary *   dict = (NSDictionary *)data;
                           NSString *code = dict[@"code"];
                           if (code.intValue == 200) {
                               SaiContext.currentUser.name=paraDic[@"name"];
                               [YYTextArchiver archiveRootObject:SaiContext.currentUser toFile:DOCUMENT_FOLDER(@"loginedUser")];
                           }
                           
                           
                       } andFailBlock:^(NSURL *URL, NSError *error) {
                           
                       }];
        return;
    }
  
    NSDictionary *paraDic=@{@"userId":SaiContext.currentUser.userId,@"email":textField.text};
                 [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/modify" andParam:paraDic andSuccessBlock:^(NSURL *URL, id data) {
                     NSDictionary *   dict = (NSDictionary *)data;
                     NSString *code = dict[@"code"];
                     if (code.intValue == 200) {
                         SaiContext.currentUser.email=paraDic[@"email"];
                         [YYTextArchiver archiveRootObject:SaiContext.currentUser toFile:DOCUMENT_FOLDER(@"loginedUser")];
                     }
                     
                     
                 } andFailBlock:^(NSURL *URL, NSError *error) {
                     
                 }];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if (textField.tag==1000) {
        
        SaiChooseView *   anythingView =[[SaiChooseView alloc]initWithFrame:self.view.frame withTitleArray:nil];
        [[[UIApplication sharedApplication].delegate window] addSubview:anythingView];
        [anythingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.left.right.mas_offset(0);
            make.height.mas_offset(KScreenH);
        }];
        __weak typeof(self)weakSelf=self;
        
        [anythingView setTableViewSelectBlock:^(NSInteger integer) {
            if (integer==0) {
                
                NSString *mediaType = AVMediaTypeVideo;
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                    //程序的名字
                    NSDictionary*info =[[NSBundle mainBundle] infoDictionary];
                    NSString*projectName =[info objectForKey:@"CFBundleName"];
                    NSString *title = [NSString stringWithFormat:@"请在%@的“设置－隐私－相机”选项中，允许%@访问您的相机。",[UIDevice currentDevice].model,projectName];
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                        
                    }]];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:nil]];
                    
                    [weakSelf presentViewController:alertController animated:YES completion:nil];
                }else{
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePickerController.delegate = weakSelf;
                    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                    [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
                    
                }
                
            }else{
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
                imagePickerVc.statusBarStyle=UIStatusBarStyleDefault;
                imagePickerVc.naviTitleColor=UIColor.blackColor;
                imagePickerVc.barItemTextColor=UIColor.blackColor;
                imagePickerVc.cancelBtnTitleStr=@"取消  ";
                imagePickerVc.allowPickingVideo=NO;
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    if (photos) {
                        UIImageView *image=[self.view viewWithTag:10000];
                        image.hidden=NO;
                        image.image=photos.firstObject;
                        [self rightBtnClick];
                    }
                    
                    
                }];
                
                
                [self presentViewController:imagePickerVc animated:NO completion:nil];
                
            }
        }];
        
        return NO;
        
    }
    else if (textField.tag==1002) {
        
        YLSOPickerView *pickView=[YLSOPickerView pickerView];
        pickView.title=@"性别选择";
        pickView.array=@[@"男",@"女"];
        [pickView show];
        return NO;
    }
    else if (textField.tag==1003) {
        
        UIView *bgV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        
        EOTimerPicker *timerPicker = [[EOTimerPicker alloc] initWithFrame:CGRectMake(0, KScreenH, KScreenW, kSCRATIO(250) + BOTTOM_HEIGHT)];
        timerPicker.maxDate=[NSDate date];
        NSString *str = @"19950101";
        //规定时间格式
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        //设置时区  全球标准时间CUT 必须设置 我们要设置中国的时区
        NSTimeZone *zone = [[NSTimeZone alloc] initWithName:@"CUT"];
        [formatter setTimeZone:zone];
        //变回日期格式
        NSDate *stringDate = [formatter dateFromString:str];
        timerPicker.currentDate=stringDate;
        __weak EOTimerPicker *weakPicker = timerPicker;
        timerPicker.sureblock = ^(NSDate *date) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
            
            textField.text=[dateFormatter stringFromDate:date];
            [bgV removeFromSuperview];
            [weakPicker removeFromSuperview];
            NSDictionary *paraDic=@{@"userId":SaiContext.currentUser.userId,@"birthday":textField.text};
               [QKBaseHttpClient httpType:POST andURL:@"/v1/surrogate/users/modify" andParam:paraDic andSuccessBlock:^(NSURL *URL, id data) {
                   NSDictionary *   dict = (NSDictionary *)data;
                   NSString *code = dict[@"code"];
                   if (code.intValue == 200) {
                       SaiContext.currentUser.birthday=paraDic[@"birthday"];
                       [YYTextArchiver archiveRootObject:SaiContext.currentUser toFile:DOCUMENT_FOLDER(@"loginedUser")];
                   }
                   
                   
               } andFailBlock:^(NSURL *URL, NSError *error) {
                   
               }];
        };
        
        [[UIApplication sharedApplication].keyWindow addSubview:bgV];
        [[UIApplication sharedApplication].keyWindow addSubview:timerPicker];
        [UIView animateWithDuration:0.15 animations:^{
            timerPicker.bottom = KScreenH;
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [bgV removeFromSuperview];
            [timerPicker removeFromSuperview];
        }];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [bgV addGestureRecognizer:tap];
        return NO;
    }
    return YES;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
    
        UIImage *image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageView *image=[self.view viewWithTag:10000];
                               image.hidden=NO;
                               image.image=image1;
        [self rightBtnClick];

     
        
    }
    
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
