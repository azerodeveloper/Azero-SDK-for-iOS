//
//  SaiJXHomePageViewController.m
//  HeIsComing
//
//  Created by mike on 2020/7/7.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiJXHomePageViewController.h"
#import "SaiHomePageViewController.h"
#import "SaiPersonController.h"
#import "SaiMusicListController.h"
#import "SaiSoundWaveView.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface SaiJXHomePageViewController ()<UIScrollViewDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong) NSMutableArray  *childVCs;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,assign)NSInteger currentInteger;
@property (nonatomic ,strong) SaiPersonController *personController;
@property(nonatomic,strong)AMapLocationManager *locationManager;

@end

@implementation SaiJXHomePageViewController


+ (instancetype)sharedInstance {
    static SaiJXHomePageViewController *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [SaiJXHomePageViewController new];
    });
    return player;
}


- (void)viewDidLoad { 
    [super viewDidLoad];
    
    [[SaiMusicListController sharedInstance] azeroSdkHandle];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"PathPlanning"];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerSwitchMode:ModeHeadset andValue:YES];

    _personController = [[SaiPersonController alloc] init];
    [self.childVCs addObject:_personController];
    [self.childVCs addObject:[SaiHomePageViewController sharedInstance]];
    
    [self.childVCs addObject:[SaiMusicListController sharedInstance]];
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.frame;
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    
    [self.childVCs enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:vc];
        
        [self.scrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(idx * w, 0, w, h);
        
    }];
    
    self.scrollView.contentSize = CGSizeMake(self.childVCs.count * w, 0);
    
    // 默认显示播放器页
    self.scrollView.contentOffset = CGPointMake(w, 0);
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior  = UIScrollViewContentInsetAdjustmentNever;
        
    } 
    [self.locationManager startUpdatingLocation];
    
}
-(void)switchIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            [[SaiHomePageViewController sharedInstance]assignmentAzeroManagerBlockHandle];
            [SaiSoundWaveView showBlue];
        }
            break;
        case 1:
        {
            [[SaiHomePageViewController sharedInstance]assignmentAzeroManagerBlockHandle];
            [SaiSoundWaveView showWhite];
        }
            break;
        case 2:{
            [[SaiMusicListController sharedInstance] azeroSdkHandle];
            [SaiSoundWaveView showBlue];
        }
        default:
            break;
    }
    [SaiMusicListController sharedInstance].currentIndex=index;
    [self.scrollView setContentOffset:CGPointMake(index * KScreenW, 0) animated:YES];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        CGPoint point =scrollView.contentOffset;
        _currentInteger=(NSInteger )(point.x/KScreenW);
        [SaiMusicListController sharedInstance].currentIndex=_currentInteger;
        if (_currentInteger==1) {
            [SaiSoundWaveView showWhite];
        }else{
            [SaiSoundWaveView showBlue];
        }
        if (_currentInteger == 0) {
            [_personController getDataClick];
        }
        
    }
}
#pragma mark AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode){
        SaiContext.address=reGeocode.formattedAddress;
        
        NSLog(@"reGeocode:%@", reGeocode);
    }
    SaiContext.longitude=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    SaiContext.latitude=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
}
#pragma mark lazy
- (NSMutableArray *)childVCs
{
    if (!_childVCs) {
        _childVCs = [NSMutableArray array];
    }
    return _childVCs;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView=[UIScrollView new];
        _scrollView.pagingEnabled = YES; //是否翻页
        _scrollView.bounces=NO;
        _scrollView.delegate=self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
-(AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter=200;
       _locationManager.allowsBackgroundLocationUpdates = YES;

        _locationManager.locatingWithReGeocode=YES;
        
    }
    return _locationManager;
}
@end
