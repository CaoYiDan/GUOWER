//
//  GWBaseTableVC.h
//  XueYouHui_User
//
//  Created by ourslook on 2018/4/24.
//  Copyright © 2018年 Ourslook. All rights reserved.
//

#import "GWBaseVC.h"
#import <MJRefresh.h>

@class BMYScrollableNavigationBar;

/**
 *    @brief    表单控制器
 */
@interface GWBaseTableVC : GWBaseVC
 <UITableViewDelegate,UITableViewDataSource>

/** 表单 */
@property (nonatomic, strong) UITableView *tableView;

/** 分页页码 */
@property (nonatomic, strong) NSNumber *page;

/** 分页大小 */
@property (nonatomic, strong) NSNumber *size;

/**
 *    @brief    表单类型 默认Group
 */
-(UITableViewStyle)base_tableViewStyle;

/**
 *    @brief    空页面标题
 */
-(NSString*)base_emptyTitle;

/**
 *    @brief    空页面描述
 */
-(NSString*)base_emptyDescription;

/**
 *    @brief    空页面描述
 */
-(UIImage*)base_emptyImage;

/**
 *    @brief    空页面偏移量
 */
-(CGFloat)base_emptyOffsetY;

/**
 *    @brief    是否初始化下拉刷新
 */
- (BOOL)base_haveRefreshHeader;

/**
 *    @brief    是否初始化上拉加载
 */
- (BOOL)base_haveRefreshFooter;

/**
 *    @brief    下拉刷新回调
 */
- (void)base_headerRefreshingMethod:(MJRefreshHeader*)refreshHeader page:(NSNumber*)page size:(NSNumber*)size;

/**
 *    @brief    上拉加载回调
 */
- (void)base_footerRefreshingMethod:(MJRefreshFooter*)refreshFooter page:(NSNumber*)page size:(NSNumber*)size;

/**
 *    @brief    是否加载伸缩式导航条
 */
- (BOOL)base_enableScrollableNavigationBar;

/**
 *    @brief    获取导航实体 base_enableScrollableNavigationBar 为 YES 时有值
 */
- (BMYScrollableNavigationBar*)base_scrollableNavigationBar;

@end
