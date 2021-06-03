//
//  MSH5ViewController.m
//  WuNuo
//
//  Created by silk on 2019/7/16.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "MSH5ViewController.h"
#import  <WebKit/WebKit.h>

@interface MSH5ViewController ()<WKNavigationDelegate,WKUIDelegate>
//设置加载进度条
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation MSH5ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        }else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        }
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
} 
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    self.title = self.h5Title;
    if (self.isRegister) {
        UIButton *leftBtn = [self sai_initNavLeftBtn];
        [leftBtn setImage:[UIImage imageNamed:@"skill_back_graw_n"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtnClickCallBack) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self sai_initGoBackBlackButton];
    }
//    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 88, kScreenWidth, kScreenHeight)];
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.H5Url]]];
//    [self.view addSubview:webView];
    WKWebView *webView ;
    if (Sai_iPhoneX||Sai_iPhoneXsXrMax) {
        webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 88, kScreenWidth, kScreenHeight - 88)];
        self.progressView.frame = CGRectMake(0, 88, self.view.bounds.size.width, 3);
    }else{
        webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, ViewWidth, ViewHeight - 64)];
        self.progressView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 3);
    }
    [self.view addSubview:self.progressView];
    for (UIView *_aView in [webView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
        }
    }
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    self.webView = webView;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.H5Url]]];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}
- (void)leftBtnClickCallBack{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    //    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    //self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败   %@",error);
    //加载失败同样需要隐藏progressView
    //self.progressView.hidden = YES;
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        // 设置进度条的色彩
        [_progressView setTrackTintColor:[UIColor colorWithRed:112.0/255 green:148.0/255 blue:234.0/255 alpha:0.8]];
        _progressView.progressTintColor = SaiColor(112, 148, 234) ;
    }
    return _progressView;
}
- (void)gobackBtnClickCallBack{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
