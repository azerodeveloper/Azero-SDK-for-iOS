//
//  SaiLocationViewController.m
//  HeIsComing
//
//  Created by mike on 2020/7/29.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiLocationViewController.h"
#import <MapKit/MapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "DGTextPlayer.h"
#import "SelectableOverlay.h"

@interface PathPlanView : UIView
-(instancetype)initAlertView:(NSDictionary<NSNumber *, AMapNaviRoute *>  *)mapNaviRoutes;
@property (copy, nonatomic) void(^startblock)(void);
@property (copy, nonatomic) void(^selectIntegerblock)(NSUInteger routeUID );

@end
@implementation PathPlanView
-(instancetype)initAlertView:(NSDictionary<NSNumber *, AMapNaviRoute *>  *)mapNaviRoutes{
    if (self=[super init]) {
        [mapNaviRoutes.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AMapNaviRoute * aMapNaviRoute =obj;
            UIView *cardView=[UIView new];
            cardView.layer.borderColor=kColorFromRGBHex(0xE5E5E5).CGColor;
            cardView.layer.borderWidth=0.5;
            [self addSubview:cardView];
            [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(KScreenW/3*idx);
                make.width.mas_offset(KScreenW/3);
                make.top.mas_offset(0);
                make.height.mas_offset(kSCRATIO(85));
            }];
            UIButton *leftButton=[UIButton CreatButtontext:[NSString stringWithFormat:@"%lu",(unsigned long)idx+1] image:nil Font:[UIFont boldSystemFontOfSize:kSCRATIO(12)] Textcolor:UIColor.whiteColor];
            [leftButton setBackgroundImage:[UIImage imageNamed:@"bg1"] forState:0];
            [cardView addSubview:leftButton];
            [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(0);
                make.width.mas_offset(kSCRATIO(18));
                make.top.mas_offset(kSCRATIO(15));
                make.height.mas_offset(kSCRATIO(18));
                
            }];
            NSArray *    routeLabels=aMapNaviRoute.routeLabels;
            AMapNaviRouteLabel *mapNaviRouteLabel=routeLabels.firstObject;
            UILabel *titleLabel=[UILabel CreatLabeltext:mapNaviRouteLabel.content Font:[UIFont boldSystemFontOfSize:kSCRATIO(12)] Textcolor:kColorFromRGBHex(0x007AFF) textAlignment:0];
            [cardView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(kSCRATIO(30));
                make.top.mas_offset(kSCRATIO(15));
                
            }];
            
            UILabel *timeLabel=[UILabel CreatLabeltext:[QKUITools timeFormattedHHMM:aMapNaviRoute.routeTime ] Font:[UIFont boldSystemFontOfSize:kSCRATIO(18)] Textcolor:kColorFromRGBHex(0x007AFF) textAlignment:0];
            [cardView addSubview:timeLabel];
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(kSCRATIO(30));
                make.top.mas_offset(kSCRATIO(36));
                
            }];
            NSString *distance=   aMapNaviRoute.routeLength/1000>1?[NSString stringWithFormat:@"%01ld公里",aMapNaviRoute.routeLength/1000]:[NSString stringWithFormat:@"%01ld米",(long)aMapNaviRoute.routeLength] ;
            UILabel *distanceLabel=[UILabel CreatLabeltext:distance Font:[UIFont boldSystemFontOfSize:kSCRATIO(12)] Textcolor:kColorFromRGBHex(0x007AFF) textAlignment:0];
            [cardView addSubview:distanceLabel];
            [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(kSCRATIO(30));
                make.top.mas_offset(kSCRATIO(60));
                
            }];
            UIButton *trafficLightsButton=[UIButton CreatButtontext:[NSString stringWithFormat:@"%lu",aMapNaviRoute.routeTrafficLightCount] image:[UIImage imageNamed:@"traffic-status"] Font:[UIFont boldSystemFontOfSize:kSCRATIO(12)] Textcolor:kColorFromRGBHex(0x007AFF)];
            [cardView addSubview:trafficLightsButton];
            [trafficLightsButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(distanceLabel.mas_right).mas_offset(kSCRATIO(2));
                make.width.mas_offset(kSCRATIO(30));
                make.centerY.equalTo(distanceLabel);
                make.height.mas_offset(kSCRATIO(12));
                
            }];
            [trafficLightsButton layoutIfNeeded];
            
            [trafficLightsButton layoutWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle_Left) imageTitleSpace:kSCRATIO(3)];
            [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
                if (self.selectIntegerblock) {
                    self.selectIntegerblock(idx);
                }
                
            }]];
        }];
        
        
        
        
        UIButton *shareButton=[UIButton CreatButtontext:@"开始导航" image:[UIImage imageNamed:@""] Font:[UIFont boldSystemFontOfSize:kSCRATIO(17)] Textcolor:UIColor.whiteColor];
        [self addSubview:shareButton];
        [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        shareButton.backgroundColor=kColorFromRGBHex(0x007AFF);
        ViewRadius(shareButton, kSCRATIO(25));
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(kSCRATIO(95));
            make.centerX.equalTo(self);
            make.width.mas_offset(kSCRATIO(345));
            make.height.mas_offset(kSCRATIO(50));
            
        }];
        
        
    }
    return self;
}
-(void)share{
    if(self.startblock ){
        self.startblock();
    }
}
@end
@interface SaiLocationViewController ()<AMapNaviDriveManagerDelegate,MAMapViewDelegate,AMapSearchDelegate,AMapNaviDriveViewDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) AMapNaviDriveView *driveView;
@property(nonatomic,strong)NSMutableArray *routeIdArray;
@property(nonatomic,strong)PathPlanView *pathPlanView ;

@end

@implementation SaiLocationViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [SaiAzeroManager sharedAzeroManager].isNavigation=YES;
    
    [self.view addSubview:self.mapView];
    
    
    //将AMapNaviManager与AMapNaviDriveView关联起来
    [[AMapNaviDriveManager sharedInstance] setAllowsBackgroundLocationUpdates:YES];
    [[AMapNaviDriveManager sharedInstance] setDelegate:self];
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveView];
    
    
    [[DGTextPlayer sharedInstance]setDefaultWithVolume:1 rate:0.5 pitchMultiplier:1];
    
    //    UIButton *changeButton=[UIButton CreatButtontext:@"切换" image:nil Font:[UIFont systemFontOfSize:15] Textcolor:UIColor.redColor];
    //    [self.driveView addSubview:changeButton];
    //    [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.center.equalTo(self.driveView);
    //        make.size.mas_offset(CGSizeMake(40, 40));
    //    }];
    //    [changeButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
    //        [self selectNaviRouteWithID:2];
    //    }]];
    //    UIButton *startButton=[UIButton CreatButtontext:@"开始" image:nil Font:[UIFont systemFontOfSize:15] Textcolor:UIColor.greenColor];
    //    [self.driveView addSubview:startButton];
    //    [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(changeButton.mas_bottom);
    //        make.centerX.equalTo(self.driveView);
    //        make.size.mas_offset(CGSizeMake(40, 40));
    //    }];
    //    [startButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
    //        [[AMapNaviDriveManager sharedInstance]startEmulatorNavi ];
    //        _driveView.showUIElements=YES;
    //
    //    }]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
    
}
//String START_NAVIGATION = "StartNavigation";
//String STRATEGY_SWITCH = "StrategySwitch";
//String TRAFFIC_SWITCH = "TrafficSwitch";
//String ROAD_SWITCH = "RoadSwitch";
//String PATH_PLANING = "PathPlaning";
//String CANCEL_NAVIGATION = "CancelNavigation";
-(void)loadData{
//    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString * locationPayload=  [[NSUserDefaults standardUserDefaults] objectForKey:@"locationPayload"];
        NSDictionary *dic = [SaiJsonConversionModel dictionaryWithJsonString:locationPayload];
        NSString *operation=[NSString stringWithFormat:@"%@",dic[@"operation"]];
        if ([dic containsObjectForKey:@"operation"]) {
            if ([operation isEqualToString:@"StartNavigation"]&&![[dic allKeys] containsObject:@"count"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.pathPlanView.startblock ){
                        self.pathPlanView.startblock();
                    }
                });
                return;
            }
        }

        if ([dic containsObjectForKey:@"operation"]) {
            if ([operation isEqualToString:@"CancelNavigation"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                [self backAction];
                });
                return;
            }
        }
        if ([dic containsObjectForKey:@"operation"]) {
            if ([operation isEqualToString:@"RoadSwitch"]) {
                AMapNaviParallelRoadInfo *mapNaviParallelRoadInfo=[AMapNaviParallelRoadInfo new];
                mapNaviParallelRoadInfo.type=1;
                [[AMapNaviDriveManager sharedInstance]switchParallelRoad:mapNaviParallelRoadInfo];
                return;
            }
        }
        if ([dic containsObjectForKey:@"operation"]) {
            if ([operation isEqualToString:@"ZoomIn"]) {
                
                self.driveView.mapZoomLevel+=1;
                return;
            }
        }
        if ([dic containsObjectForKey:@"operation"]) {
            if ([operation isEqualToString:@"ZoomOut"]) {
                if (self.driveView.mapZoomLevel<=5) {
                    return;
                }
                self.driveView.mapZoomLevel-=1;
                return;
            }
        }
        NSArray *locArray=dic[@"points"];
        if (locArray.count != 0) {
            self.locArray=locArray.modelCopy;
            if ([QKUITools isBlankArray:locArray]) {
                return;
            }
        }
        if ([operation isEqualToString:@"Select"]&&![[NSUserDefaults standardUserDefaults] boolForKey:@"PathPlanning"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger select = [dic[@"select"] integerValue];
                NSDictionary *locDiction = self.locArray[select-1];
                [self.tableView removeFromSuperview];
                [self.mapView removeAnnotations:self.mapView.annotations];
                [self.view addSubview:self.driveView];
                AMapNaviPoint *destinationCoordinate=[AMapNaviPoint locationWithLatitude:[[NSString stringWithFormat:@"%@",locDiction[@"coordinate"][@"latitudeInDegrees"]] floatValue] longitude:[[NSString stringWithFormat:@"%@",locDiction[@"coordinate"][@"longitudeInDegrees"]] floatValue]];
                [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithEndPoints:@[destinationCoordinate] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategyMultipleDefault];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PathPlanning"];
            });
            return;
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"PathPlanning"]&&[operation isEqualToString:@"Select"]) {
            NSInteger  select=[[NSString stringWithFormat:@"%@",dic[@"select"]] integerValue];
            if (select>self.routeIdArray.count) {
                return;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSInteger select = [[NSString stringWithFormat:@"%@",dic[@"select"]] integerValue] - 1;
                NSUInteger selectUinteger = [[self.routeIdArray objectAtIndex:select] integerValue];
                [self selectNaviRouteWithID:selectUinteger];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[AMapNaviDriveManager sharedInstance] startGPSNavi];
                    
                    _driveView.showUIElements=YES;
                    
                    [self.pathPlanView removeFromSuperview];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"PathPlanning"];
                    
                });
            });
            
            
            return;
        }
        NSDictionary *locDiction=locArray.firstObject;
        if ([[NSString stringWithFormat:@"%@",dic[@"count"] ] isEqualToString:@"1"]) {
            [self.view addSubview:self.driveView];
            AMapNaviPoint *destinationCoordinate=[AMapNaviPoint locationWithLatitude:[[NSString stringWithFormat:@"%@",locDiction[@"coordinate"][@"latitudeInDegrees"]] floatValue] longitude:[[NSString stringWithFormat:@"%@",locDiction[@"coordinate"][@"longitudeInDegrees"]] floatValue]];
//
            [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithEndPoints:@[destinationCoordinate] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategyMultipleDefault];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PathPlanning"];
        }else{
            if (!self.tableView.superview) {
                [self.view addSubview:self.tableView];
                [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_offset(0);
                    make.bottom.mas_offset(0);
                    
                    make.height.mas_offset(locArray.count*kSCRATIO(68));
                }];
            }else{
                [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_offset(0);
                    make.bottom.mas_offset(-BOTTOM_HEIGHT);
                    
                    make.height.mas_offset(locArray.count*kSCRATIO(68));
                }];
            }
            
            [self.tableView reloadData];
            [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_offset(0);
                make.bottom.equalTo(self.tableView.mas_top);
            }];
            [self.mapView removeAnnotations:self.mapView.annotations];
            NSMutableArray *annotations=[NSMutableArray array];
            for (int i=0; i<locArray.count; i++) {
                NSDictionary *locDiction=locArray[i];
                
                MAPointAnnotation *beginAnnotation = [[MAPointAnnotation alloc] init];
                [beginAnnotation setCoordinate:CLLocationCoordinate2DMake([[NSString stringWithFormat:@"%@",locDiction[@"coordinate"][@"latitudeInDegrees"]] floatValue], [[NSString stringWithFormat:@"%@",locDiction[@"coordinate"][@"longitudeInDegrees"]] floatValue])];
                beginAnnotation.title = [NSString stringWithFormat:@"第%d个",i+1];
                beginAnnotation.subtitle = [NSString stringWithFormat:@"%@",locDiction[@"name"]];
                [annotations addObject:beginAnnotation];
                
            }
            [self.mapView addAnnotations:annotations];
            
            [self.mapView showAnnotations:self.mapView.annotations animated:YES];
            
            [self zoomMapViewToFitAnnotations:self.mapView animated:YES];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"PathPlanning"];
            
        }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [[SaiAzeroManager sharedAzeroManager] setLocationblock:^(NSString *text) {
        [[NSUserDefaults standardUserDefaults] setObject:text  forKey:@"locationPayload"];
        [self loadData];
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [SaiAzeroManager sharedAzeroManager].isNavigation=NO;
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
    [[DGTextPlayer sharedInstance]stopSpeak];
}




#pragma mark - AMapSearchDelegate

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    
    
    if (response.count > 0)
    {
        [self presentCurrentCourse];
    }
}
/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    //        MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    //        MAPointAnnotation * naviRoute = [MAPointAnnotation naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
    //        [naviRoute addToMapView:self.mapView];
    
    //     缩放地图使其适应polylines的展示.
    //        [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
    //                            edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
    //                               animated:YES];
}
- (void)showNaviRoutes{
    if ([[AMapNaviDriveManager sharedInstance].naviRoutes count] <= 0)
    {
        return;
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    //将路径显示到地图上
    for (NSNumber *aRouteID in [[AMapNaviDriveManager sharedInstance].naviRoutes allKeys])
    {
        AMapNaviRoute *aRoute = [[[AMapNaviDriveManager sharedInstance] naviRoutes] objectForKey:aRouteID];
        int count = (int)[[aRoute routeCoordinates] count];
        
        //添加路径Polyline
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < count; i++)
        {
            AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
            coords[i].latitude = [coordinate latitude];
            coords[i].longitude = [coordinate longitude];
        }
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
        
        SelectableOverlay *selectablePolyline = [[SelectableOverlay alloc] initWithOverlay:polyline];
        [selectablePolyline setRouteID:[aRouteID integerValue]];
        [self.mapView addOverlay:polyline];
        [self.routeIdArray addObject:aRouteID];
        
        
    }
    [self.driveView addSubview:self.pathPlanView];
    blockWeakSelf;
    [self.pathPlanView setStartblock:^{
        [[AMapNaviDriveManager sharedInstance] startGPSNavi];
        weakSelf.driveView.showUIElements=YES;
        
        [weakSelf.pathPlanView removeFromSuperview];
    }];
    [self.pathPlanView setSelectIntegerblock:^(NSUInteger routeUID) {
        [weakSelf selectNaviRouteWithID:[[NSNumber numberWithUnsignedInteger:routeUID] integerValue]];
    }];
    self.pathPlanView.backgroundColor=UIColor.whiteColor;
    [self.pathPlanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(0);
        
        make.height.mas_offset(kSCRATIO(153)+BOTTOM_HEIGHT);
        
    }];
    [self.pathPlanView layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.pathPlanView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.pathPlanView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.pathPlanView.layer.mask = maskLayer;
    
    self.pathPlanView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    self.pathPlanView.layer.shadowOffset = CGSizeMake(0,2);
    self.pathPlanView.layer.shadowOpacity = 1;
    self.pathPlanView.layer.shadowRadius = 4;
    self.pathPlanView.layer.cornerRadius = 15;
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    //
    [self selectNaviRouteWithID:[[self.routeIdArray firstObject]integerValue]];
    
}
- (void)selectNaviRouteWithID:(NSInteger)routeID
{
    //在开始导航前进行路径选择
    if ([[AMapNaviDriveManager sharedInstance] selectNaviRouteWithRouteID:routeID])
    {
        [self selecteOverlayWithRouteID:routeID];
    }
    else
    {
        NSLog(@"路径选择失败!");
    }
}
- (void)selecteOverlayWithRouteID:(NSInteger)routeID
{
    [self.mapView.overlays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<MAOverlay> overlay, NSUInteger idx, BOOL *stop)
     {
        if ([overlay isKindOfClass:[SelectableOverlay class]])
        {
            SelectableOverlay *selectableOverlay = overlay;
            
            /* 获取overlay对应的renderer. */
            MAPolylineRenderer * overlayRenderer = (MAPolylineRenderer *)[self.mapView rendererForOverlay:selectableOverlay];
            
            if (selectableOverlay.routeID == routeID)
            {
                /* 设置选中状态. */
                selectableOverlay.selected = YES;
                
                /* 修改renderer选中颜色. */
                overlayRenderer.fillColor   = selectableOverlay.selectedColor;
                overlayRenderer.strokeColor = selectableOverlay.selectedColor;
                
                /* 修改overlay覆盖的顺序. */
                [self.mapView exchangeOverlayAtIndex:idx withOverlayAtIndex:self.mapView.overlays.count - 1];
            }
            else
            {
                /* 设置选中状态. */
                selectableOverlay.selected = NO;
                
                /* 修改renderer选中颜色. */
                overlayRenderer.fillColor   = selectableOverlay.regularColor;
                overlayRenderer.strokeColor = selectableOverlay.regularColor;
            }
        }
    }];
}

#pragma mark - 根据所有的大头针坐标,计算显示范围,屏幕能够刚好显示大头针
#define CW_MINIMUM_ZOOM_ARC 0.014
#define CW_ANNOTATION_REGION_PAD_FACTOR 1.15
#define CW_MAX_DEGREES_ARC 360
- (void)zoomMapViewToFitAnnotations:(MAMapView *)mapView animated:(BOOL)animated{
    NSArray *annotations = mapView.annotations;
    NSInteger count = [mapView.annotations count];
    if ( count == 0) { return; }
    MAMapPoint points[count];
    for( int i=0; i<count; i++ )
    {
        CLLocationCoordinate2D coordinate = [(id <MAAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MAMapPointForCoordinate(coordinate);
    }
    MAMapRect mapRect = [[MAPolygon polygonWithPoints:points count:count] boundingMapRect];
    // 因为,中间的一个大头针居中显示,所以这里的size要减一半.所以乘以二
    //        mapRect.size.width = mapRect.size.width * 2;
    //        mapRect.size.height = mapRect.size.height * 2;
    
    mapRect.size.width = mapRect.size.width;
    mapRect.size.height = mapRect.size.height;
    
    MACoordinateRegion region = MACoordinateRegionForMapRect(mapRect);
    
    region.span.latitudeDelta  *= CW_ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= CW_ANNOTATION_REGION_PAD_FACTOR;
    
    if( region.span.latitudeDelta > CW_MAX_DEGREES_ARC ) { region.span.latitudeDelta  = CW_MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > CW_MAX_DEGREES_ARC ){ region.span.longitudeDelta = CW_MAX_DEGREES_ARC; }
    if( region.span.latitudeDelta  < CW_MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = CW_MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < CW_MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = CW_MINIMUM_ZOOM_ARC; }
    if( count == 1 )
    {
        region.span.latitudeDelta = CW_MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = CW_MINIMUM_ZOOM_ARC;
    }
    //    region.center = self.location1;
    [mapView setRegion:region animated:animated];
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager{
    [self showNaviRoutes];
    
    
}
- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType{
    
    [[DGTextPlayer sharedInstance]play:soundString];
    [kPlayer setMp3VolumeNum:30];
    [[AudioQueuePlay sharedAudioQueuePlay]setVoume:0.3];
    [[DGTextPlayer sharedInstance] setStop:^{
        [kPlayer setMp3VolumeNum:100];
        [[AudioQueuePlay sharedAudioQueuePlay]setVoume:1];
        
    }];
    
}
- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager
{
    return [[DGTextPlayer sharedInstance] isSpeaking];
}
#pragma mark - AMapNaviWalkViewDelegate

- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView
{
    //停止导航
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
    [[DGTextPlayer sharedInstance]stopSpeak];
    //停止语音
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)driveViewMoreButtonClicked:(AMapNaviDriveView *)driveView
{
    
    //配置MoreMenu状态
    //        [self.moreMenu setTrackingMode:self.driveView.trackingMode];
    //        [self.moreMenu setShowNightType:self.driveView.showStandardNightType];
    //
    //        [self.moreMenu setFrame:self.view.bounds];
    //        [self.view addSubview:self.moreMenu];
}
- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView
{
    NSLog(@"TrunIndicatorViewTapped");
}

- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode
{
    NSLog(@"didChangeShowMode:%ld", (long)showMode);
}
#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    //    if ([overlay isKindOfClass:[LineDashPolyline class]])
    //    {
    //        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
    //        polylineRenderer.lineWidth   = 8;
    //        polylineRenderer.lineDashType = kMALineDashTypeSquare;
    //        polylineRenderer.strokeColor = [UIColor redColor];
    //
    //        return polylineRenderer;
    //    }
    //    if ([overlay isKindOfClass:[MANaviPolyline class]])
    //    {
    //        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
    //        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
    //
    //        polylineRenderer.lineWidth = 8;
    //
    //        if (naviPolyline.type == MANaviAnnotationTypeWalking)
    //        {
    //            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
    //        }
    //        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
    //        {
    //            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
    //        }
    //        else
    //        {
    //            polylineRenderer.strokeColor = self.naviRoute.routeColor;
    //        }
    //
    //        return polylineRenderer;
    //    }
    //    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    //    {
    //        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
    //
    //        polylineRenderer.lineWidth = 10;
    //        //        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
    //
    //        return polylineRenderer;
    //    }
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = UIColor.redColor;
        //        polylineRenderer.lineJoinType = kMALineJoinRound;
        //        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
    }
    return nil;
}
////添加完大头针的代理方法
//-(void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
//    if ([views[0] isKindOfClass:MAPinAnnotationView.class]){
//        MAPinAnnotationView *mapView = (MAPinAnnotationView*)views[0];
//        [self.mapView selectAnnotation:mapView.annotation animated:true];
//    }
//}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.draggable = NO;
        poiAnnotationView.selected = YES;
        [poiAnnotationView setSelected:YES animated:YES];
        poiAnnotationView.animatesDrop=NO;
        poiAnnotationView.image = nil;
        [poiAnnotationView setPinColor:MAPinAnnotationColorGreen];
        //        if ([annotation isKindOfClass:[MANaviAnnotation class]]){
        //            switch (((MANaviAnnotation*)annotation).type)
        //            {
        //                case MANaviAnnotationTypeRailway:
        //                    poiAnnotationView.image = [UIImage imageNamed:@"railway_station"];
        //                    break;
        //
        //                case MANaviAnnotationTypeBus:
        //                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
        //                    break;
        //
        //                case MANaviAnnotationTypeDrive:
        //                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
        //                    break;
        //
        //                case MANaviAnnotationTypeWalking:
        //                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
        //                    break;
        //
        //                default:
        //                    break;
        //            }
        //        }
        //        else
        //        {
        /* 起点. */
        //            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
        //            {
        //                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
        //            }
        //            /* 终点. */
        //            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
        //            {
        //                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
        //            }
        
        //        }
        
        return poiAnnotationView;
    }
    
    return nil;
}
- (void)dealloc{
    [AMapNaviDriveManager destroyInstance];
}
#pragma mark 懒加载
-(MAMapView *)mapView{
    if (!_mapView) {
        _mapView=[[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_mapView];
        _mapView.delegate=self;
    }
    return _mapView;
}
-(AMapNaviDriveView *)driveView{
    if (_driveView == nil)
    {
        _driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
        _driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_driveView setDelegate:self];
        //        [_driveView setShowGreyAfterPass:YES];
//        [_driveView setAutoZoomMapLevel:YES];
        _driveView.showVectorline=NO;
        _driveView.showUIElements=NO;
        [_driveView setTrackingMode:AMapNaviViewTrackingModeCarNorth];
        
    }
    return _driveView;
}
-(NSMutableArray *)routeIdArray{
    if (!_routeIdArray) {
        _routeIdArray=[NSMutableArray array];
    }
    return _routeIdArray;
}
-(PathPlanView *)pathPlanView{
    if (!_pathPlanView) {
        _pathPlanView=[[PathPlanView alloc]initAlertView:[[AMapNaviDriveManager sharedInstance] naviRoutes]];
    }
    return _pathPlanView;
}
@end
