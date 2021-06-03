//
//  SaiWeatherViewController.m
//  HeIsComing
//
//  Created by mike on 2020/3/30.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiWeatherViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SaiWeatherViewController ()
@property (nonatomic , assign) BOOL receiveBool;
@property(nonatomic,strong) UIImageView *backImageView1;

@end

@implementation SaiWeatherViewController{
    UIImageView *backImageView;
    UILabel *addressLabel;
    UILabel *cityLabel;
    UIButton *playWhiteButton;
    UILabel *temperatureLabel;
    UILabel *weatherLabel;
    UILabel *calendarLabel;
    UILabel *weekLabel;
}
#pragma mark -  Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weatherModel=[SaiWeatherModel modelWithJson:[SaiAzeroManager sharedAzeroManager].renderTemplateStr];

    [self initWithView];
    [self registerNoti];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    blockWeakSelf;
    self.responseRenderTemplateStr = ^(NSString * _Nonnull renderTemplateStr) {
        NSDictionary *diction=[SaiJsonConversionModel dictionaryWithJsonString:renderTemplateStr];
                  TemplateTypeENUM templateTypet=[QKUITools returnTemplateFromRenderTemplateStr:diction[@"type"]];
                  switch (templateTypet) {
                      case WeatherTemplate:
                      {
                          weakSelf.weatherModel=[SaiWeatherModel modelWithJson:[SaiAzeroManager sharedAzeroManager].renderTemplateStr];
                          [weakSelf.backImageView1 removeFromSuperview];
                          [weakSelf initWithView];
                      }
                          break;
                          
                      default:{
                          [weakSelf jumpVC:YES renderTemplateStr:renderTemplateStr];

                      }
                          break;
                  }
    };
   
    
}

-(void)initWithView{
    NSString *backImageViewString;
    if ([self.weatherModel.condition.text containsString:@"晴"]) {
        backImageViewString=@"tq_bg_sunny";
    }else if ([self.weatherModel.condition.text containsString:@"云"]){
        backImageViewString=@"tq_bg_cloudy";

    }else if ([self.weatherModel.condition.text containsString:@"阴"]){
        backImageViewString=@"tq_bg_overcast";

    }else if ([self.weatherModel.condition.text containsString:@"雨"]){
        backImageViewString=@"tq_bg_rain";

    }else if ([self.weatherModel.condition.text containsString:@"雪"]){
        backImageViewString=@"tq_bg_snow";

    }else if ([self.weatherModel.condition.text containsString:@"冰"]){
        backImageViewString=@"tq_bg_hail";

    }else if ([self.weatherModel.condition.text containsString:@"沙"]||[self.weatherModel.condition.text containsString:@"尘"]){
        backImageViewString=@"tq_bg_sand";

    }else if ([self.weatherModel.condition.text containsString:@"雾"]){
        backImageViewString=@"tq_bg_foggy";

    }else if ([self.weatherModel.condition.text containsString:@"霾"]){
        backImageViewString=@"tq_bg_smog";

    }else if ([self.weatherModel.condition.text containsString:@"雪"]){
        backImageViewString=@"tq_bg_cloudy";

    }else{
        backImageViewString=@"tq_bg_sunny";

    }
    if (!self.weatherModel.condition) {
        [self backAction];
    }
   backImageView=[UIImageView new];
    backImageView.userInteractionEnabled=YES;
    [self.view addSubview:backImageView];
    self.backImageView1=backImageView;
    backImageView.image=[UIImage imageNamed:backImageViewString];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIButton *addButton=[UIButton new];
    [backImageView addSubview:addButton];
    [addButton setImage:[UIImage imageNamed:@"tq_icon_add"] forState:0];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(15));
        make.width.height.mas_offset(kSCRATIO(14));
        make.top.mas_offset(kSCRATIO(7)+kStatusBarHeight);
    }];
    addressLabel=[UILabel CreatLabeltext:self.weatherModel.city Font:[UIFont fontWithName:@"PingFang-SC-Bold" size:kSCRATIO(18)] Textcolor:UIColor.whiteColor textAlignment:0];
    [backImageView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addButton.mas_right).offset(kSCRATIO(2));
        make.height.mas_offset(kSCRATIO(17));
        make.centerY.equalTo(addButton);
    }];
    UIButton *positionButton=[UIButton new];
    [backImageView addSubview:positionButton];
    [positionButton setImage:[UIImage imageNamed:@"tq_icon_location"] forState:0];
    [positionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLabel.mas_right).offset(kSCRATIO(7));
        make.width.height.mas_offset(kSCRATIO(16));
        make.centerY.equalTo(addButton);
    }];

    cityLabel=[UILabel CreatLabeltext:self.weatherModel.city Font:[UIFont fontWithName:@"PingFang-SC-Medium" size:kSCRATIO(12)] Textcolor:UIColor.whiteColor textAlignment:0];
    [backImageView addSubview:cityLabel];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLabel);
        make.height.mas_offset(kSCRATIO(12));
        make.top.equalTo(addressLabel.mas_bottom).offset(kSCRATIO(2));
    }];
    UIImageView *playBlackImageView=[UIImageView new];
    playBlackImageView.image=[UIImage imageNamed:@"tq_bg_play_black"];
    [backImageView addSubview:playBlackImageView];
    playBlackImageView.hidden=YES;
    [playBlackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addButton);
        make.height.mas_offset(kSCRATIO(10));
        make.top.equalTo(cityLabel.mas_bottom).offset(kSCRATIO(2));
        make.width.mas_offset(kSCRATIO(345));
        
    }];
    playWhiteButton=[UIButton CreatButtontext:self.weatherModel.answer image:[UIImage imageNamed:@"tq_icon_play_white"] Font:[UIFont boldSystemFontOfSize:kSCRATIO(12)] Textcolor:UIColor.whiteColor];
    [playBlackImageView addSubview:playWhiteButton];
    [playWhiteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(playBlackImageView);
        
    }];
    [playWhiteButton layoutIfNeeded];
    [playWhiteButton layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyle_Left imageTitleSpace:kSCRATIO(4)];
    
    UIView *temperatureView=[UIView new];
    [backImageView addSubview:temperatureView];
    temperatureView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
    [temperatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(playBlackImageView) ;
        make.top.equalTo(playBlackImageView.mas_bottom);
        make.height.mas_offset(kSCRATIO(130));
    }];
    [temperatureView layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:temperatureView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = temperatureView.bounds;
    maskLayer.path = maskPath.CGPath;
    temperatureView.layer.mask = maskLayer;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *nowStr = [fmt stringFromDate:now];
    CGSize size;
    NSString *str;
    if (self.weatherModel.now!=nil&&[self.weatherModel.date isEqualToString:nowStr]) {
        temperatureLabel=[UILabel CreatLabeltext:[NSString stringWithFormat:@"%@°",self.weatherModel.now.temperature] Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(70)] Textcolor:UIColor.whiteColor textAlignment:0];
        size = [SaiUIUtils getSizeWithLabel:temperatureLabel.text withFont:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(70)] withSize:CGSizeMake(MAXFLOAT, 70)];
        str = self.weatherModel.condition.text;
    }else{
        temperatureLabel=[UILabel CreatLabeltext:[NSString stringWithFormat:@"%@°~%@°",self.weatherModel.weather.low,self.weatherModel.weather.high] Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(30)] Textcolor:UIColor.whiteColor textAlignment:0];
        size = [SaiUIUtils getSizeWithLabel:temperatureLabel.text withFont:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(30)] withSize:CGSizeMake(MAXFLOAT, 30)];
        str = [NSString stringWithFormat:@"%@转%@",self.weatherModel.weather.textDay,self.weatherModel.weather.textNight];
    }
//    temperatureLabel.backgroundColor = [UIColor blackColor];
    [temperatureView addSubview:temperatureLabel];
    if (self.weatherModel.now!=nil&&[self.weatherModel.date isEqualToString:nowStr]) {
        [temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_offset(kSCRATIO(22)) ;
            make.height.mas_offset(kSCRATIO(70));
            make.width.mas_offset(kSCRATIO(size.width));
        }];
    }else{
        [temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_offset(kSCRATIO(22)) ;
            make.height.mas_offset(kSCRATIO(30));
            make.width.mas_offset(kSCRATIO(size.width+10));
        }];
    }
   weatherLabel=[UILabel CreatLabeltext:str Font:[UIFont fontWithName:@"PingFang SC" size: kSCRATIO(20)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentRight];
//    weatherLabel.backgroundColor = [UIColor redColor];
    [temperatureLabel addSubview:weatherLabel];
    if (self.weatherModel.now!=nil&&[self.weatherModel.date isEqualToString:nowStr]) {
        weatherLabel.font = [UIFont fontWithName:@"PingFang SC" size: kSCRATIO(20)];
        [weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(temperatureLabel) ;
                       make.centerX.equalTo(temperatureLabel.mas_right);
            //           make.width.mas_offset(kSCRATIO(110));
        }];
    }else{
        weatherLabel.font = [UIFont fontWithName:@"PingFang SC" size: kSCRATIO(16)];
        [weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(temperatureLabel.mas_bottom).mas_offset(kSCRATIO(5));
            make.left.mas_offset(kSCRATIO(0)) ;
//                       make.centerX.equalTo(temperatureLabel);
            //           make.width.mas_offset(kSCRATIO(110));
        }];
    }
   calendarLabel=[UILabel CreatLabeltext:[self toYearString:self.weatherModel.date] Font:[UIFont  boldSystemFontOfSize:kSCRATIO(18)] Textcolor:UIColor.whiteColor textAlignment:0];
//    calendarLabel.backgroundColor = [UIColor redColor];
    [temperatureView addSubview:calendarLabel];
    [calendarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(kSCRATIO(-20)) ;
        make.top.mas_offset(kSCRATIO(50));
        make.height.mas_offset(kSCRATIO(18));
    }];
    weekLabel=[UILabel CreatLabeltext:[NSString stringWithFormat:@" %@",self.weatherModel.week] Font:[UIFont  boldSystemFontOfSize:kSCRATIO(12)] Textcolor:UIColor.whiteColor textAlignment:0];
    [temperatureView addSubview:weekLabel];
    [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(kSCRATIO(-20)) ;
        make.top.equalTo(calendarLabel.mas_bottom).mas_offset(kSCRATIO(5));
        make.height.mas_offset(kSCRATIO(12));
    }];
    UIButton *feedbackWeatherView=[UIButton CreatButtontext:@"反馈天气" image:[UIImage imageNamed:@"tq_icon_feedback"] Font:[UIFont boldSystemFontOfSize:kSCRATIO(11)] Textcolor:UIColor.whiteColor];
    [temperatureView addSubview:feedbackWeatherView];
    feedbackWeatherView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.2];
    ViewRadius(feedbackWeatherView, kSCRATIO(3));
    if (self.weatherModel.now!=nil&&[self.weatherModel.date isEqualToString:nowStr]) {
        [feedbackWeatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(kSCRATIO(24)) ;
            make.top.equalTo(temperatureLabel.mas_bottom).offset(kSCRATIO(10));
            make.height.mas_offset(kSCRATIO(18));
            make.width.mas_offset(kSCRATIO(74));
        }];
    }else{
        [feedbackWeatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(kSCRATIO(24)) ;
            make.top.equalTo(weatherLabel.mas_bottom).offset(kSCRATIO(10));
            make.height.mas_offset(kSCRATIO(18));
            make.width.mas_offset(kSCRATIO(74));
        }];
    }
    
    [feedbackWeatherView layoutIfNeeded];
    [feedbackWeatherView layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyle_Left imageTitleSpace:kSCRATIO(2)];
    
    UIView *temperatureDetailsView=[UIView new];
    [backImageView addSubview:temperatureDetailsView];
    temperatureDetailsView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
    [temperatureDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(playBlackImageView) ;
        make.top.equalTo(temperatureView.mas_bottom).offset(kSCRATIO(10));
        make.height.mas_offset(kSCRATIO(107));
    }];
    [temperatureDetailsView layoutIfNeeded];
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:temperatureDetailsView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = temperatureDetailsView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    temperatureDetailsView.layer.mask = maskLayer1;
    NSArray *titleArray=@[@"温度区间",@"湿度",@"风力"];
    for (int i=0; i<titleArray.count; i++) {
        UILabel *leftLabel=[UILabel CreatLabeltext:titleArray[i] Font:[UIFont boldSystemFontOfSize:kSCRATIO(14)] Textcolor:UIColor.whiteColor textAlignment:0];
        [temperatureDetailsView addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(kSCRATIO(13));
            make.left.mas_offset(kSCRATIO(20));
            
            make.top.mas_offset(kSCRATIO(11)+kSCRATIO(35)*i);
            
        }];
        UILabel *rightLabel=[UILabel CreatLabeltext:titleArray[i] Font:[UIFont boldSystemFontOfSize:kSCRATIO(14)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentRight];
        switch (i) {
            case 0:
            {
                rightLabel.text=[NSString stringWithFormat:@"%@°~%@°",self.weatherModel.weather.low,self.weatherModel.weather.high];
            }
                break;
            case 1:
            {
                rightLabel.text=[NSString stringWithFormat:@"%@%%",self.weatherModel.now.humidity];
            }
                break;
            case 2:
            {
                rightLabel.text=[NSString stringWithFormat:@"%@风；%@级",self.weatherModel.weather.windDirection,self.weatherModel.weather.windScale];
            }
                break;
                
            default:
                break;
        }

        [temperatureDetailsView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(kSCRATIO(13));
            make.right.mas_offset(kSCRATIO(-20));
            make.centerY.equalTo(leftLabel);
            
        }];
        if (i!=0) {
            UIImageView *lineImageView=[UIImageView new];
            [temperatureDetailsView addSubview:lineImageView];
            [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(kSCRATIO(2));
                make.width.mas_offset(kSCRATIO(305));
                make.centerX.equalTo(temperatureDetailsView);
                make.top.mas_offset(kSCRATIO(35)*i);
            }];
            [lineImageView layoutIfNeeded];
            [self drawLineByImageView:lineImageView];
        }
        
    }
    UIView *temperatureDayView=[UIView new];
    [backImageView addSubview:temperatureDayView];
    temperatureDayView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
    [temperatureDayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(playBlackImageView) ;
        make.top.equalTo(temperatureDetailsView.mas_bottom).offset(kSCRATIO(10));
        make.height.mas_offset(kSCRATIO(78));
    }];
    [temperatureDayView layoutIfNeeded];
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:temperatureDayView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = temperatureDayView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    temperatureDayView.layer.mask = maskLayer2;
    NSDictionary *qualitydic=@{@"优":@[kColorFromRGBHex(0x46E5B0),kColorFromRGBHex(0x1DBD88)],@"中度":@[kColorFromRGBHex(0xFF6150),kColorFromRGBHex(0xEC2C17)],@"高度":@[kColorFromRGBHex(0xFF895E),kColorFromRGBHex(0xFA642D)]};
    for ( int i=0; i<2; i++) {
        SaiWeatherModelDailyDaily * saiWeatherModelDailyDaily     =self.weatherModel.daily.daily[i];
        SaiWeatherModelAirs * saiWeatherModelAirs     =self.weatherModel.airs[i];
        
        UIView *dayView=[UIView new];
        [temperatureDayView addSubview:dayView];
        [dayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(temperatureDayView);
            make.width.mas_offset(temperatureDayView.width/2);
            make.left.mas_offset(temperatureDayView.width/2*i);
        }];
        UILabel *dayLabel=[UILabel CreatLabeltext:saiWeatherModelDailyDaily.week Font:[UIFont boldSystemFontOfSize:kSCRATIO(15)] Textcolor:UIColor.whiteColor textAlignment:0];
        [dayView addSubview:dayLabel];
        [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(kSCRATIO(20));
            make.top.mas_offset(kSCRATIO(17));
            make.height.mas_offset(kSCRATIO(15));
        }];
        NSString *textWeather;
        if ([saiWeatherModelDailyDaily.textDay isEqualToString:saiWeatherModelDailyDaily.textNight]) {
            textWeather=saiWeatherModelDailyDaily.textDay;
        }else{
            textWeather=[NSString stringWithFormat:@"%@转%@",saiWeatherModelDailyDaily.textDay,saiWeatherModelDailyDaily.textNight];
            
        }
        UILabel *weatherLabel=[UILabel CreatLabeltext:textWeather Font:[UIFont boldSystemFontOfSize:kSCRATIO(16)] Textcolor:UIColor.whiteColor textAlignment:0];
        [dayView addSubview:weatherLabel];
        weatherLabel.adjustsFontSizeToFitWidth=YES;
        [weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-kSCRATIO(25));
            make.top.mas_offset(kSCRATIO(17));
            make.height.mas_offset(kSCRATIO(15));
            make.width.mas_lessThanOrEqualTo(kSCRATIO(80));

        }];
        UILabel *temperatureLabel=[UILabel CreatLabeltext:[NSString stringWithFormat:@"%@/%@°",saiWeatherModelDailyDaily.high,saiWeatherModelDailyDaily.low] Font:[UIFont boldSystemFontOfSize:kSCRATIO(16)] Textcolor:UIColor.whiteColor textAlignment:0];
        [dayView addSubview:temperatureLabel];
        [temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(kSCRATIO(20));
            make.top.mas_offset(kSCRATIO(45));
            make.height.mas_offset(kSCRATIO(15));
        }];
        
        UIView *labelBackground=[[UILabel alloc]initWithFrame:CGRectZero];
        [dayView addSubview:labelBackground];
        [labelBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-kSCRATIO(25));
            make.top.mas_offset(kSCRATIO(45));
            make.width.mas_offset(kSCRATIO(40));
            make.height.mas_offset(kSCRATIO(18));
        }];
        [labelBackground layoutIfNeeded];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = labelBackground.bounds;
        gradient.cornerRadius=kSCRATIO(9);
        NSArray *colorArray=qualitydic[@"优"];
        UIColor * startColor=colorArray.firstObject;
        UIColor * endColor=colorArray.lastObject;
        
        gradient.colors = @[(id)startColor.CGColor,(id)endColor.CGColor,];
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(1, 1);
        gradient.locations = @[@(0), @(1)];
        
        [labelBackground.layer addSublayer:gradient];
        UILabel *airQualityLabel=[UILabel CreatLabeltext:saiWeatherModelAirs.quality Font:[UIFont boldSystemFontOfSize:kSCRATIO(15)] Textcolor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter];
        [dayView addSubview:airQualityLabel];
        airQualityLabel.adjustsFontSizeToFitWidth=YES;
        airQualityLabel.baselineAdjustment        = UIBaselineAdjustmentAlignCenters;

        [airQualityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.height.equalTo(labelBackground);
            make.width.mas_offset(kSCRATIO(36));
        }];
    }
    
//    UIImageView *logoImageView=[UIImageView new];
//    [backImageView addSubview:logoImageView];
//    logoImageView.contentMode=UIViewContentModeScaleAspectFit;
//    
//    logoImageView.image=[UIImage imageNamed:@"yd_img_logo"];
//    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_offset(kSCRATIO(20));
//        make.top.equalTo(temperatureDayView.mas_bottom).offset(kSCRATIO(12));
//        make.width.mas_offset(kSCRATIO(138));
//        make.height.mas_offset(kSCRATIO(196));
//        
//    }];
    //    UIImageView *hornImageView=[UIImageView new];
    //    [self.view addSubview:hornImageView];
    //    hornImageView.image=[UIImage imageNamed:@"bk_icon_horn"];
    //    [hornImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_offset(-kSCRATIO(15));
    //        make.top.equalTo(temperatureDayView.mas_bottom).offset(kSCRATIO(45));
    //        make.width.height.mas_offset(kSCRATIO(60));
    //    }];
    //    UIButton *homePagegeImageView=[UIButton new];
    //    [self.view addSubview:homePagegeImageView];
    //    [homePagegeImageView addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    //    [homePagegeImageView setImage:[UIImage imageNamed:@"bk_icon_home"] forState:0];
    //    [homePagegeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_offset(-kSCRATIO(15));
    //        make.top.equalTo(hornImageView.mas_bottom).offset(kSCRATIO(6));
    //        make.width.height.mas_offset(kSCRATIO(60));
    //    }];
}


#pragma mark -  Button Callbacks
-(NSString *)toYearString:(NSString *)yearString{
    NSDateFormatter *dstFmt = [[NSDateFormatter alloc]init];

    dstFmt.dateFormat=@"yyyy-MM-dd";
    NSDate*srcDate=[dstFmt dateFromString:yearString];
    NSDateFormatter*fmt= [[NSDateFormatter alloc]init];
    fmt.dateFormat=@"MM月dd日";
 

    return [fmt stringFromDate:srcDate];
}
- (void)drawLineByImageView:(UIImageView *)imageView {
    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor whiteColor].CGColor);
    
    
    CGFloat lengths[] = {5,2};//先画4个点再画2个点
    CGContextSetLineDash(line,0, lengths,2);//注意2(count)的值等于lengths数组的长度
    
    CGContextMoveToPoint(line, 0.0, 2.0);    //开始画线
    CGContextAddLineToPoint(line,imageView.frame.size.width,2.0);
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    UIImage *image =   UIGraphicsGetImageFromCurrentImageContext();
    imageView.image = image;
}
- (void)registerNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ttsPlayComplete) name:SaiTtsPlayComplete object:nil];
}

- (void)ttsPlayComplete{
            dispatch_async(dispatch_get_main_queue(), ^{

    [self backAction];
                        });

//    blockWeakSelf;
////
//    if (weakSelf.receiveBool) {
//            weakSelf.receiveBool = NO;
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self backAction];
//            });
//    }else{
//
//        weakSelf.receiveBool = YES;
//    }
    
}

@end
