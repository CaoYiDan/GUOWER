//
//  VAWebViewController.m
//  GUOWER
//
//  Created by ourslook on 2018/7/20.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "VAWebViewController.h"
//WebView
#import <WebKit/WebKit.h>

@interface VAWebViewController () <WKNavigationDelegate>

/** webView */
@property (nonatomic, strong) WKWebView *va_webView;

/** 进度条 */
@property (nonatomic, strong) UIProgressView *va_progressView;

/** type */
@property (nonatomic, assign) VAWebViewContentType va_type;

/** content */
@property (nonatomic, copy) NSString *va_content;

@end

@implementation VAWebViewController

- (instancetype)initWithType:(VAWebViewContentType)type content:(NSString*)content
{
    self = [super init];
    if (self) {
        self.va_type = type;
        self.va_content = content;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview:self.va_webView];
    [self.va_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.navigationController.navigationBar addSubview:self.va_progressView];
    
    @weakify(self);
    //监听进度
    [RACObserve(self.va_webView, estimatedProgress) subscribeNext:^(id  _Nullable x) {
        
        [self_weak_.va_progressView setProgress:self_weak_.va_webView.estimatedProgress animated:YES];
        
        if (self_weak_.va_progressView.progress == 1) {
            
            [UIView animateWithDuration:0.5 animations:^{
                self_weak_.va_progressView.alpha = 0;
            }completion:^(BOOL finished) {
                self_weak_.va_progressView.progress = 0;
            }];
            
        }
    }];

    [self loadData];
    
}

- (void)loadData{
    
    switch (self.va_type) {
        case VAWebViewContentHTMLString:
        {
            //加载Html
            NSString *html = m_NSStringFormat(@"<html><head><link rel=\"stylesheet\" href=http://news-at.zhihu.com/css/news_qa.auto.css?v=4b3e3></head><body><div class=\"main-wrap content-wrap\"><div class=\"content-inner\"><div class=\"question\"><div class=\"answer\"><div class=\"content\"><p>%@</p></div></div></div></div></div></body></html>",self.va_content);
            [self.va_webView loadHTMLString:html baseURL:API_BASE_URL.mj_url];
        }
            break;
        case VAWebViewContentURL:
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:self.va_content.mj_url];
            [self.va_webView loadRequest:request];
        }
        default:
            break;
    }
    
}

#pragma mark -- -- --  WKNavigationDelegate

/** 页面开始加载时调用 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.va_progressView.alpha = 1;
    NSLog(@"开始加载");
    
}

/** 页面加载完成之后调用 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"加载完成");
}

/** 页面加载失败时调用*/
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
    self.va_progressView.progress = 0;
    self.va_progressView.alpha = 0;
    NSLog(@"加载失败");
}

- (WKWebView *)va_webView{
    
    if (!_va_webView) {
        NSString *jScript = @"var script = document.createElement('meta');"
        "script.name = 'viewport';"
        "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
        "document.getElementsByTagName('head')[0].appendChild(script); var objs = document.getElementsByTagName('img'); for(var i=0;i<objs.length;i++) { var img = objs[i];  img.style.maxWidth = '100%'; img.style.height = 'auto'; }";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = wkUController;
        _va_webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _va_webView.navigationDelegate = self;
    }
    return _va_webView;
    
}

-(UIProgressView *)va_progressView{
    if (!_va_progressView) {
        _va_progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.ol_height-2, [[UIScreen mainScreen] bounds].size.width, 2)];
        _va_progressView.progressTintColor = GW_OrangeColor;
        _va_progressView.progressViewStyle = UIProgressViewStyleBar;
        _va_progressView.trackTintColor = [UIColor clearColor];
        
    }
    return _va_progressView;
    
}

@end
