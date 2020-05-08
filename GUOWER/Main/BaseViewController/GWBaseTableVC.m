//
//  GWBaseTableVC.m
//  XueYouHui_User
//
//  Created by ourslook on 2018/4/24.
//  Copyright © 2018年 Ourslook. All rights reserved.

#import "GWBaseTableVC.h"
#import "UIImage+ImageWithColor.h"

//空界面
#import <UIScrollView+EmptyDataSet.h>

#import "BMYScrollableNavigationBar.h"

@interface GWBaseTableVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@end

@implementation GWBaseTableVC

#pragma mark - UITableViewDataSource

/**
 *  表单懒加载
 */
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:[self base_tableViewStyle]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    @weakify(self);
    //添加下拉刷新
    if ([self base_haveRefreshHeader]) {
        
        //初始值
        self.page = @1;
        self.size = @5;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            //重置值
            self_weak_.page = @1;
            self_weak_.size = @5;
            [self_weak_ base_headerRefreshingMethod:self_weak_.tableView.mj_header page:self_weak_.page size:self_weak_.size];
            
        }];
        header.stateLabel.font = m_FontPF_Regular_WithSize(14);
        header.lastUpdatedTimeLabel.font = m_FontPF_Regular_WithSize(14);
        self.tableView.mj_header = header;
        
    }
    
    if ([self base_haveRefreshFooter]) {
        
        //初始值
        self.page = @1;
        self.size = @5;
        
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            NSInteger page = self_weak_.page.integerValue;
            page++;
            self_weak_.page = [NSNumber numberWithInteger:page];
            //上拉值
            self_weak_.size = @5;
            [self_weak_ base_footerRefreshingMethod:self_weak_.tableView.mj_footer page:self_weak_.page size:self_weak_.size];
            
        }];
        
        //提前加载量
        footer.triggerAutomaticallyRefreshPercent = -2;
        footer.onlyRefreshPerDrag = YES;
        footer.stateLabel.font = m_FontPF_Regular_WithSize(14);
        [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
        self.tableView.mj_footer = footer;

    }
    
    
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self.base_disposableArray addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        if (self_weak_.base_enableScrollableNavigationBar) {
            [self_weak_ base_scrollableNavigationBar].scrollView = self_weak_.tableView;
            [[self_weak_ base_scrollableNavigationBar] resetToDefaultPosition:YES];
        }
    }]];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

/** iOS11之后需要返回 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark -- -- -- 公开方法默认值

/**
 *    @brief    表单类型 默认Group
 */
-(UITableViewStyle)base_tableViewStyle{
    
    return UITableViewStyleGrouped;
    
}

/**
 * 是否初始化下拉刷新  默认NO
 */
- (BOOL)base_haveRefreshHeader{
    
    return NO;
    
}

/**
 * 是否初始化上拉加载  默认NO
 */
- (BOOL)base_haveRefreshFooter{
    
    return NO;
    
}

/**
 * 下拉刷新回调
 */
- (void)base_headerRefreshingMethod:(MJRefreshHeader*)refreshHeader page:(NSNumber*)page size:(NSNumber*)size{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshHeader endRefreshing];
    });
    
}

/**
 * 上拉加载回调
 */
- (void)base_footerRefreshingMethod:(MJRefreshFooter*)refreshFooter page:(NSNumber*)page size:(NSNumber*)size{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshFooter endRefreshing];
    });
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *cellID = @"baseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = m_Color_randomColor;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;

}

#pragma mark - DZNEmptyDataSetSource Methods

/**
 *    @brief    标题文字
 */
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [self base_emptyTitle];
    UIFont *font = font = m_FontPF_Regular_WithSize(14);
    UIColor *textColor = m_Color_gray(188);
    
    if (!text) {
        return nil;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/**
 *    @brief    描述文字
 */
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [self base_emptyDescription];
    UIFont *font = [UIFont boldSystemFontOfSize:15.0];
    UIColor *textColor = m_Color_gray(188);
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    return attributedString;
}

/**
 *    @brief    返回空图片
 */
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [self base_emptyImage];
}

/**
 *    @brief    图片动画
 */
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
}

/**
 *    @brief    按钮文字
 */
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return nil;
}

/**
 *    @brief    根据不同状态返回按钮图片
 */
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return nil;
}

/**
 *    @brief    背景色
 */
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return UIColor.whiteColor;
}

/**
 *    @brief    偏移量
 */
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return [self base_emptyOffsetY];
}

/**
 *    @brief    空白区域的高度
 */
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 40;
}


#pragma mark - DZNEmptyDataSetDelegate Methods

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView{
    
    self.tableView.mj_footer.hidden = YES;
    
}

- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView{
    
    self.tableView.mj_footer.hidden = NO;
    
}


/**
 *    @brief    是否展示空视图
 */
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

/**
 *    @brief    是否可以点击
 */
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return NO;
}

/**
 *    @brief    是否可以滚动
 */
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

/**
 *    @brief    是否展示图片动画
 */
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    return NO;
}

/**
 *    @brief    点击回调
 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    
}

/**
 *    @brief    按钮点击回调
 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{

}

/**
 *    @brief    空页面标题
 */
-(NSString*)base_emptyTitle{
    
    return nil;
    
}

/**
 *    @brief    空页面描述
 */
-(NSString*)base_emptyDescription{
    
    return nil;
    
}

/**
 *    @brief    空页面描述
 */
-(UIImage*)base_emptyImage{
    
    return nil;
    
}

/**
 *    @brief    空页面偏移量
 */
-(CGFloat)base_emptyOffsetY{
    
    return -(m_TopHeight + 40);
    
}

#pragma mark -- 滚动隐藏导航相关

/**
 *    @brief    是否初始化上拉隐藏导航
 */
- (BOOL)base_enableScrollableNavigationBar{
    
    return NO;
    
}

/**
 *    @brief    给RTNav返回自定义NavBar
 */
-(Class)rt_navigationBarClass{

    return self.base_enableScrollableNavigationBar?BMYScrollableNavigationBar.class:[super rt_navigationBarClass];
    
}

- (BMYScrollableNavigationBar*)base_scrollableNavigationBar{
    
    if (!self.base_enableScrollableNavigationBar) return nil;
    return (BMYScrollableNavigationBar*)self.navigationController.navigationBar;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if (self.base_enableScrollableNavigationBar) {
        [self base_scrollableNavigationBar].scrollView = self.tableView;
        [self base_scrollableNavigationBar].viewControllerIsAboutToBePresented = YES;
        [[self base_scrollableNavigationBar] resetToDefaultPosition:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.base_enableScrollableNavigationBar) {
        [self base_scrollableNavigationBar].scrollView = nil;
        [self base_scrollableNavigationBar].viewControllerIsAboutToBePresented = NO;
        [[self base_scrollableNavigationBar] resetToDefaultPosition:YES];
    }
}

@end
