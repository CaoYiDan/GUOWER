//
//  GWNewsDetailVC.m
//  GUOWER
//
//  Created by ourslook on 2018/6/28.
//  Copyright © 2018年 Vanne. All rights reserved.
//
//com.guower.ourslook
#import "GWNewsDetailVC.h"
#import <WebKit/WebKit.h>
#import <SDAutoLayout.h>
//navScroll
#import "BMYScrollableNavigationBar.h"
//topView
#import "GWNewsDetailTopView.h"

//cells
#import "GWNewsDetailProjectCell.h"
#import "GWNewsDetailAdvertCell.h"
#import "GWNewsDetailHotCell.h"

//model
#import "GWNewsModel.h"
#import "GWAdvertModel.h"

//作者主页
#import "GWHPAuthorHomePageVC.h"

//shareView
#import "VAShareView.h"

//web
#import "VAWebViewController.h"
//player
#import "VAPlayerViewController.h"

/*
 新闻详情页     这里采用 UIScrollView上放 UIView WKWebView UITableView ，关掉WKWebView和UITableView的滚动交互，通过计算外层UIScrollView的偏移量来改变WKWebView和UITableView的偏移量， 这个做的好处是 充分利用了WKWebView和UITableView的内存优化机制，保证内存的使用状况良好
 */
@interface GWNewsDetailVC ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,
WKNavigationDelegate>

/** 整体的滚动视图 */
@property (nonatomic, strong) UIScrollView *gw_containerScrollView;
/** contentView */
@property (nonatomic, strong) UIView *gw_contentView;
/** topView */
@property (nonatomic, strong) GWNewsDetailTopView *gw_topView;
/** webView */
@property (nonatomic, strong) WKWebView *gw_webView;
/** tableView */
@property (nonatomic, strong) UITableView *gw_tableView;

/** webView最后的高度 */
@property (nonatomic, assign) CGFloat lastWebViewContentHeight;
/** tableView最后的高度 */
@property (nonatomic, assign) CGFloat lastTableViewContentHeight;

/** news */
@property (nonatomic, strong) GWNewsModel *news;
/** topHeight */
@property (nonatomic, strong) NSNumber *topHeight;

/** 广告 */
@property (nonatomic, strong) NSMutableArray <GWAdvertModel*>*advertArray;
/** 热门 */
@property (nonatomic, strong) NSMutableArray <GWNewsModel*>*hotArray;

@end

const CGFloat topHeight;

@implementation GWNewsDetailVC

- (void)viewDidLoad{
    
    [super viewDidLoad];

    //请求数据 之后更新UI
    [self setupNavigation];
    [self setupTableViewCell];
    [self setupView];
    
    [self loadNewsDetail];

}

- (UIView*)gw_hud{
    
    return m_VERSION(11)?self.view:self.navigationController.view;
    
}

- (void)loadNewsDetail{
    
    [self.gw_hud showMaskWithHint:nil];
    
    __block BOOL hasFailure = NO;
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    //加载新闻详情
    dispatch_group_enter(serviceGroup);
    
    @weakify(self);
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_news_findBusNewsByidWithID:self.newsID parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
        
        dispatch_group_leave(serviceGroup);
        
    } success:^(URLResponse *response, id object) {
        
        self_weak_.news = [GWNewsModel mj_objectWithKeyValues:object];
        
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        hasFailure = YES;
    } netWorkError:^(NSError *error) {
        hasFailure = YES;
    }]];
    
    //加载广告
    dispatch_group_enter(serviceGroup);
    
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_advertisement_listByNewsDetailsWithPageCurrent:@"1" pageSize:@"3" parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
        
        dispatch_group_leave(serviceGroup);
        
    } success:^(URLResponse *response, id object) {
        self_weak_.advertArray = [GWAdvertModel mj_objectArrayWithKeyValuesArray:object];
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        hasFailure = YES;
    } netWorkError:^(NSError *error) {
        hasFailure = YES;
    }]];
    
    //加载热门文章
    dispatch_group_enter(serviceGroup);
    
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_news_listByHotWithPageCurrent:@"1" pageSize:@"4" parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
        
        dispatch_group_leave(serviceGroup);
        
    } success:^(URLResponse *response, id object) {
        
        self_weak_.hotArray = [GWNewsModel mj_objectArrayWithKeyValuesArray:object];
        
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        hasFailure = YES;
    } netWorkError:^(NSError *error) {
        hasFailure = YES;
    }]];
    
    /** 全部完成 */
    dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
        if (hasFailure) {
            
            [self_weak_.gw_hud showErrorMaskWithHint:nil clickBlock:^{
                [self_weak_ loadNewsDetail];
            }];
            
        }else{
            
            
            [self_weak_ updateBaseView];
            [self_weak_.gw_tableView reloadData];
            
        }
        NSLog(@"全部完成");
        NSLog(@"%@",@(hasFailure));
        
    });
    
    
    
}

/**
 *    @brief    更新视图内容
 */
- (void)updateBaseView{
    
    @weakify(self);
    
    //加载Html
    NSString *html = m_NSStringFormat(@"<html><head><link rel=\"stylesheet\" href=http://news-at.zhihu.com/css/news_qa.auto.css?v=4b3e3></head><body><div class=\"main-wrap content-wrap\"><div class=\"content-inner\"><div class=\"question\"><div class=\"answer\"><div class=\"content\"><p>%@</p></div></div></div></div></div></body></html>",self.news.mainText);
    [self.gw_webView loadHTMLString:html baseURL:API_BASE_URL.mj_url];
    
    //设置导航文字
    self.navigationBar.gw_iconType = self.news.tag.integerValue;
    self.navigationBar.gw_title = self.news.title;
    //设置TopView内容
    self.gw_topView.model = self.news;
    self.gw_topView.nameClickBlock = ^{
        
//        if (![self_weak_.news.author isEqualToNumber:AccountMannger_userInfo.ID]) {
            GWHPAuthorHomePageVC *vc = [[GWHPAuthorHomePageVC alloc]init];
            vc.userId = self_weak_.news.author.stringValue;
            [self_weak_.navigationController pushViewController:vc animated:YES];
//        }
        
    };
    
    //更新TopView高度
    [self.gw_topView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self_weak_.topHeight.floatValue);
        
    }];
    
    [self.gw_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(m_ScreenW);
        make.height.mas_equalTo(self_weak_.view.ol_height * 2 + self_weak_.topHeight.floatValue);
    }];
    
    [self navigationBar].scrollView = self.gw_containerScrollView;
    [self navigationBar].scrollTolerance = self.topHeight.floatValue;
    
}

/**
 *    @brief    初始化导航配置
 */
- (void)setupNavigation{

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(gw_share)];
    
}

/**
 *    @brief    分享点击
 */
- (void)gw_share{
    
    VAShareView *shareView = [[VAShareView alloc] init];
    VAShareModel *shareModel = [[VAShareModel alloc] init];
    shareModel.title = self.news.title;
    shareModel.descr = self.news.smallTitle;
    shareModel.url =  m_NSStringFormat(@"%@/#/newsDetails?id=%@",[API_BASE_URL stringByReplacingOccurrencesOfString:@"/guower" withString:@""],self.news.ID.stringValue);
    shareModel.thumbImage = self.news.isGw_bigImage?self.news.image:self.news.smallImage;
    [shareView showShareViewWithShareModel:shareModel shareContentType:VAShareContentTypeText];
    
}

/**
 *    @brief    注册Cell
 */
- (void)setupTableViewCell{

    self.gw_tableView.separatorInset = UIEdgeInsetsZero;
    [self.gw_tableView registerClass:GWNewsDetailProjectCell.class forCellReuseIdentifier:NSStringFromClass(GWNewsDetailProjectCell.class)];
    [self.gw_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(GWNewsDetailHotCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(GWNewsDetailHotCell.class)];
    [self.gw_tableView registerClass:GWNewsDetailAdvertCell.class forCellReuseIdentifier:NSStringFromClass(GWNewsDetailAdvertCell.class)];
    [self.gw_tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(self.class)];
    
}

/**
 *    @brief    初始化视图
 */
- (void)setupView{

    //顶部视图
    [self.gw_contentView addSubview:self.gw_topView];
    //网页视图
    [self.gw_contentView addSubview:self.gw_webView];
    //底部视图
    [self.gw_contentView addSubview:self.gw_tableView];
    //父Scroll
    [self.view addSubview:self.gw_containerScrollView];
    //将视图添加到Scroll
    [self.gw_containerScrollView addSubview:self.gw_contentView];
    
    @weakify(self);
    [self.gw_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
        
    }];
    [self.gw_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self_weak_.gw_topView.mas_bottom);
        make.left.right.mas_equalTo(0);
        
    }];
    [self.gw_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self_weak_.gw_webView.mas_bottom);
        make.left.right.mas_equalTo(0);
        
    }];
    
    [self.gw_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(m_ScreenW);
        make.height.mas_equalTo(self_weak_.view.ol_height * 2 + 200);
    }];
    
    [self.gw_containerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.base_disposableArray makeObjectsPerformSelector:@selector(dispose)];
    [self.base_disposableArray addObject:[RACObserve(self.gw_webView, scrollView.contentOffset) subscribeNext:^(id  _Nullable x) {
        [self_weak_ updateContainerScrollViewContentSize:0 webViewContentHeight:0];
    }]];
    
    [self.base_disposableArray addObject:[RACObserve(self.gw_tableView, contentOffset) subscribeNext:^(id  _Nullable x) {
        [self_weak_ updateContainerScrollViewContentSize:0 webViewContentHeight:0];
    }]];
    
}

- (void)updateContainerScrollViewContentSize:(NSInteger)flag webViewContentHeight:(CGFloat)inWebViewContentHeight{
    
    
    CGFloat topViewHeight = self.gw_topView.ol_height;
    
    CGFloat webViewContentHeight = flag==1 ?inWebViewContentHeight :self.gw_webView.scrollView.contentSize.height;
    CGFloat tableViewContentHeight = self.gw_tableView.contentSize.height;
    
    if (webViewContentHeight == _lastWebViewContentHeight && tableViewContentHeight == _lastTableViewContentHeight) {
        return;
    }
    
    _lastWebViewContentHeight = webViewContentHeight;
    _lastTableViewContentHeight = tableViewContentHeight;
    
    self.gw_containerScrollView.contentSize = CGSizeMake(self.view.ol_width, webViewContentHeight + tableViewContentHeight +  topViewHeight);
    
    
    CGFloat webViewHeight = (webViewContentHeight < self.view.ol_height) ?webViewContentHeight :self.view.ol_height ;
    CGFloat tableViewHeight = tableViewContentHeight < self.view.ol_height ?tableViewContentHeight :self.view.ol_height;
    
    [self.gw_webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(webViewHeight <= 0.1 ?0.1 :webViewHeight);
    }];
    [self.gw_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(webViewHeight + tableViewHeight + topViewHeight);
    }];
    [self.gw_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tableViewHeight);
    }];
    
}

/**
 *    @brief    导航条标题操作
 */
- (void)gw_navScrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat y = scrollView.contentOffset.y;
    
    //偏移量校准
    y+=scrollView.contentInset.top;
    
    if (m_VERSION(11.00)) {
        
        y += m_TopHeight;
    }
    
    if (y<15) {
        self.navigationBar.gw_titleOffset = 0;
        return;
    }
    
    //顶部视图的高度
    CGFloat topHeight = self.gw_topView.ol_height - 95;
    
    if (y >= topHeight) {
        
        self.navigationBar.gw_titleOffset = 1;
        
    }else{
        
        //计算偏移量
        CGFloat proportion = MAX(0, y/topHeight);
        proportion = MIN(1, proportion);
        self.navigationBar.gw_titleOffset = proportion;
        
    }
    
    self.navigationBar.ol_y = -y;
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //只响应父Scroll
    if (self.gw_containerScrollView != scrollView) {
        return;
    }
    
    //导航偏移事件
    [self gw_navScrollViewDidScroll:scrollView];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat topViewHeight = self.gw_topView.ol_height;
    CGFloat webViewHeight = self.gw_webView.ol_height;
    CGFloat tableViewHeight = self.gw_tableView.ol_height;
    
    CGFloat webViewContentHeight = self.gw_webView.scrollView.contentSize.height;
    CGFloat tableViewContentHeight = self.gw_tableView.contentSize.height;
    
    CGFloat contentTop = 0;
    CGPoint webOffset = CGPointZero;
    CGPoint tableOffset = CGPointZero;
    
    if (offsetY <= 0) {//下拉超出操作
        
        contentTop = 0;
        webOffset = CGPointZero;
        tableOffset = CGPointZero;
        
    }else if(offsetY < topViewHeight) {
        
    }else if(offsetY - topViewHeight < webViewContentHeight - webViewHeight){
        
        contentTop = offsetY - topViewHeight;
        webOffset = CGPointMake(0, offsetY - topViewHeight);
        tableOffset = CGPointZero;
        
    }else if(offsetY - topViewHeight < webViewContentHeight){
        
        contentTop = webViewContentHeight - webViewHeight;
        webOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
        tableOffset = CGPointZero;
        
    }else if(offsetY - topViewHeight < webViewContentHeight + tableViewContentHeight - tableViewHeight){
        
        contentTop = offsetY - webViewHeight - topViewHeight;
        webOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
        tableOffset = CGPointMake(0, offsetY - webViewContentHeight - topViewHeight);
        
    }else if(offsetY <= webViewContentHeight + tableViewContentHeight ){
        
        contentTop = self.gw_containerScrollView.contentSize.height - self.gw_contentView.ol_height;
        webOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
        tableOffset = CGPointMake(0, tableViewContentHeight - tableViewHeight);
        
    }
    
    [self.gw_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentTop);
    }];
    self.gw_webView.scrollView.contentOffset = webOffset;
    self.gw_tableView.contentOffset = tableOffset;
    
}

#pragma makr - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self_weak_.gw_hud hideMask];
    });
    
    
    
}

#pragma mark - UITableViewDataSouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return self.hotArray.count;
    }
    
    return 0;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return [tableView cellHeightForIndexPath:indexPath model:self.news keyPath:@"model" cellClass:GWNewsDetailProjectCell.class contentViewWidth:m_ScreenW];
        case 1:
            return [tableView cellHeightForIndexPath:indexPath model:self.advertArray keyPath:@"gw_array" cellClass:GWNewsDetailAdvertCell.class contentViewWidth:m_ScreenW];
        case 2:
            return 100;
    }
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            GWNewsDetailProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWNewsDetailProjectCell.class)];
            cell.model = self.news;
            return cell;
        }
        case 1:
        {
            GWNewsDetailAdvertCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWNewsDetailAdvertCell.class)];
            cell.gw_array = self.advertArray;
            @weakify(self);
            cell.advertClickBlock = ^(NSInteger index) {
                
                GWAdvertModel *model = [self_weak_.advertArray objectAtIndex:index];
                
                //【1.链接 2.视频 3.富文本 4.新闻文章】
                switch (model.jumpType.integerValue) {
                    case 1:
                    {
                        VAWebViewController *webVC = [[VAWebViewController alloc]initWithType:VAWebViewContentURL content:model.jumpUrl];
                        webVC.title = model.title;
                        [self_weak_.navigationController pushViewController:webVC animated:YES];
                    }
                        break;
                    case 2:
                    {
                        VAPlayerViewController *player = [[VAPlayerViewController alloc]init];
                        player.url = model.jumpUrl;
                        [self_weak_ presentViewController:player animated:YES completion:nil];
                    }
                        break;
                    case 3:
                    {
                        VAWebViewController *webVC = [[VAWebViewController alloc]initWithType:VAWebViewContentHTMLString content:model.mainText];
                        webVC.title = model.title;
                        [self_weak_.navigationController pushViewController:webVC animated:YES];
                    }
                        break;
                    case 4:
                    {
                        GWNewsDetailVC *vc = [[GWNewsDetailVC alloc]init];
                        vc.newsID = model.jumpNewsId.stringValue;
                        [self_weak_.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            };
            return cell;
        }
        case 2:
        {
            GWNewsDetailHotCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWNewsDetailHotCell.class)];
            cell.model = [self.hotArray objectAtIndex:indexPath.row];
            return cell;
        }

    }
    
    return [[UITableViewCell alloc]init];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==2&&self.hotArray.count) {
        return 60;
    }
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section<[self numberOfSectionsInTableView:tableView]-1) {
        return 10;
    }
    return CGFLOAT_MIN;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==2&&self.hotArray.count) {
        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(self.class)];
        
        header.contentView.backgroundColor = [UIColor whiteColor];
        
        if (![header.contentView viewWithTag:3]) {
            UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"news_detail_hot_icon"]];
            image.tag = 3;
            [header.contentView addSubview:image];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.centerY.mas_equalTo(0);
            }];
            
            UILabel *label = [[UILabel alloc]init];
            label.textColor = m_Color_gray(47.00);
            label.font = m_FontPF_Medium_WithSize(18);
            label.text = @"热门文章";
            [header.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(image.mas_right).mas_offset(10);
                make.centerY.mas_equalTo(0);
            }];
        }
        
        return header;
    }
    
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==2) {
        
        GWNewsModel *newsModel = [self.hotArray objectAtIndex:indexPath.row];
        GWNewsDetailVC *vc = [[GWNewsDetailVC alloc]init];
        vc.newsID = newsModel.ID.stringValue;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

#pragma mark -- 懒加载

- (GWNewsDetailTopView *)gw_topView{
    
    if (!_gw_topView) {
        _gw_topView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(GWNewsDetailTopView.class) owner:nil options:nil].firstObject;
    }
    return _gw_topView;
}

- (WKWebView *)gw_webView{
    if (!_gw_webView) {
        NSString *jScript = @"var script = document.createElement('meta');"
        "script.name = 'viewport';"
        "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
        "document.getElementsByTagName('head')[0].appendChild(script); var objs = document.getElementsByTagName('img'); for(var i=0;i<objs.length;i++) { var img = objs[i];  img.style.maxWidth = '100%'; img.style.height = 'auto'; }";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = wkUController;
        _gw_webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _gw_webView.scrollView.scrollEnabled = NO;
        _gw_webView.navigationDelegate = self;
    }
    
    return _gw_webView;
}

- (UITableView *)gw_tableView{
    if (!_gw_tableView) {
        _gw_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _gw_tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _gw_tableView.delegate = self;
        _gw_tableView.dataSource = self;
        _gw_tableView.tableFooterView = [UIView new];
        _gw_tableView.scrollEnabled = NO;
    }
    return _gw_tableView;
}

- (UIScrollView *)gw_containerScrollView{
    if (!_gw_containerScrollView) {
        _gw_containerScrollView = [[UIScrollView alloc] init];
        _gw_containerScrollView.delegate = self;
        _gw_containerScrollView.alwaysBounceVertical = YES;
    }
    
    return _gw_containerScrollView;
}

- (UIView *)gw_contentView{
    if (!_gw_contentView) {
        _gw_contentView = [[UIView alloc] init];
    }
    
    return _gw_contentView;
}

- (NSNumber *)topHeight{
    
    if (!_topHeight) {
        CGFloat height = [GWNewsDetailTopView titleHeightWithModel:self.news] + 110;//110是自上而下的间距总和
        _topHeight = [NSNumber numberWithFloat:height];
    }
    return _topHeight;
    
}

#pragma mark -- VC配置

- (BMYScrollableNavigationBar *)navigationBar{
    
    return (BMYScrollableNavigationBar *)self.navigationController.navigationBar;
    
}

- (Class)rt_navigationBarClass{
    
    return BMYScrollableNavigationBar.class;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[self navigationBar] resetToDefaultPosition:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationBar] resetToDefaultPosition:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self navigationBar] resetToDefaultPosition:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[self navigationBar] resetToDefaultPosition:NO];
}

@end
