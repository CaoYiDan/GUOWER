//
//  GWWeiBoLiastVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/23.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWWeiBoLiastVC.h"
#import <SDAutoLayout.h>
//model
#import "GWWBRootClass.h"
//
#import "NSDate+InternetDateTime.h"
//
#import "GWFastNewsUIModel.h"
#import "GWNNewsHeaderView.h"
#import "GWWeiBoCell.h"
//Safari
#import "GWSafariViewController.h"

@interface GWWeiBoLiastVC ()

/**  */
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation GWWeiBoLiastVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = [NSMutableArray array];
    
    [self setupTableView];

    [self loadDataWithHeader:YES hud:YES page:self.page size:self.size];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}

- (UITableViewStyle)base_tableViewStyle{
    
    return UITableViewStylePlain;
    
}

- (void)setupTableView{
    
    [self.tableView registerClass:GWNNewsHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(GWNNewsHeaderView.class)];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(GWWeiBoCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(GWWeiBoCell.class)];
    
}

#pragma mark - UITableViewDataSource

/**
 *  行数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GWFastNewsUIModel *model = [self.array objectAtIndex:section];
    return model.gw_array.count;
}

/**
 *  区数
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

/**
 *  单元格方法
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GWWeiBoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWWeiBoCell.class)];
    GWFastNewsUIModel *model = [self.array objectAtIndex:indexPath.section];
    cell.model = [model.gw_array objectAtIndex:indexPath.row];
    return cell;
}

/**
 *  行高
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    GWFastNewsUIModel *model = [self.array objectAtIndex:indexPath.section];
    GWWBStatuse *cellModel = [model.gw_array objectAtIndex:indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:cellModel keyPath:@"model" cellClass:GWWeiBoCell.class contentViewWidth:m_ScreenW];
}

/**
 *  区头高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 53;
}

/**
 *  区头高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    GWNNewsHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(GWNNewsHeaderView.class)];
    GWFastNewsUIModel *model = [self.array objectAtIndex:section];
    view.gw_timeTitle = model.gw_data.ol_yMd_to_yMd_M;
    view.ol_width = m_ScreenW;
    return view;
    
}

#pragma mark - UITableViewDelegate

/**
 *  单元格点击
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    GWSafariViewController *vc = [[GWSafariViewController alloc]initWithURL:url];
//    [UIViewController.currentViewController presentViewController:vc animated:YES completion:nil];
    
}

- (BOOL)base_haveRefreshHeader{
    
    return YES;
    
}

- (BOOL)base_haveRefreshFooter{
    
    return YES;
    
}

- (void)base_headerRefreshingMethod:(MJRefreshHeader *)refreshHeader page:(NSNumber *)page size:(NSNumber *)size{
    
    [self loadDataWithHeader:YES hud:NO page:page size:size];
}

- (void)base_footerRefreshingMethod:(MJRefreshFooter *)refreshFooter page:(NSNumber *)page size:(NSNumber *)size{
    
    [self loadDataWithHeader:NO hud:NO page:page size:size];
    
}

/**
 *    @brief    加载列表信息
 */
-(void)loadDataWithHeader:(BOOL)header hud:(BOOL)hud page:(NSNumber *)page size:(NSNumber *)size{
    
    @weakify(self);
    
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_weibo_homeTimelineWithPageCurrent:self.page.stringValue pageSize:self.size.stringValue parentView:self.view hasHud:NO hasMask:hud end:^(URLResponse *response)  {
        
    } success:^(URLResponse *response, id object) {
    
        
        
        GWWBRootClass *model = [GWWBRootClass mj_objectWithKeyValues:object];
        
        NSArray *array = model.statuses;
        
        if (header) {
            [self_weak_.array removeAllObjects];
            [self_weak_.tableView.mj_header endRefreshing];
            if (array.count<size.integerValue) {
                [self_weak_.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self_weak_.tableView.mj_footer endRefreshing];
            }
        }else{
            if(array.count<size.integerValue){
                [self_weak_.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self_weak_.tableView.mj_footer endRefreshing];
            }
        }
        
        [self_weak_ addingObjectsFromArray:array];
        
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        
        [self_weak_.tableView.mj_header endRefreshing];
        [self_weak_.tableView.mj_footer endRefreshing];
        
    } netWorkError:^(NSError *error) {
        
        [self_weak_.tableView.mj_header endRefreshing];
        [self_weak_.tableView.mj_footer endRefreshing];
        
    }]];
    
}

- (void)addingObjectsFromArray:(NSArray*)fromArray{
    
    //获取所有日期
    NSMutableSet *newAllDateSet = [NSMutableSet set];
    [newAllDateSet addObjectsFromArray:[fromArray mutableArrayValueForKeyPath:@"created_at.ol_yMdHms_to_yMd"]];
    //NSSet是无序的 重新进行排序
    NSComparator compcarator = ^(NSString *obj1, NSString *obj2){
        
        long int timeStamp1 = [NSDate dateFromString:obj1 withFormat:[NSDate dateFormatString]].utcTimeStamp;
        long int timeStamp2 = [NSDate dateFromString:obj2 withFormat:[NSDate dateFormatString]].utcTimeStamp;
        if (timeStamp1 > timeStamp2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        if (timeStamp1 < timeStamp2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
        
    };
    
    NSArray *newDateArray = [newAllDateSet.allObjects sortedArrayUsingComparator:compcarator];
    
    @weakify(self);
    
    [newDateArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //获取对应日期的数据
        NSPredicate *newP = [NSPredicate predicateWithFormat:@"created_at.ol_yMdHms_to_yMd == %@",obj];
        NSArray *newArray = [fromArray filteredArrayUsingPredicate:newP];
        //获取老数据对应日期的数据
        NSPredicate *oldP = [NSPredicate predicateWithFormat:@"gw_data == %@",obj];
        NSArray *oldArray = [self_weak_.array filteredArrayUsingPredicate:oldP];
        if (oldArray.count) {
            NSLog(@"在旧数据中找到 %@ 的数据 插入 %ld 条",obj,newArray.count);
            GWFastNewsUIModel *model = oldArray.firstObject;
            [model.gw_array addObjectsFromArray:newArray];
        }else{
            NSLog(@"没有找到 %@ 的旧数据 重新创建 %ld 条",obj,newArray.count);
            GWFastNewsUIModel *model = [[GWFastNewsUIModel alloc]init];
            model.gw_data = obj;
            model.gw_array = [NSMutableArray arrayWithArray:newArray];
            [self_weak_.array addObject:model];
        }
        
    }];
    
    [self.tableView reloadData];
    
}

- (UIImage *)base_emptyImage{
    
    return [UIImage imageNamed:@"article_empty"];
    
}

- (NSString *)base_emptyTitle{
    
    return @"没有微博信息~";
    
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

@end
