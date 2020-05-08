//
//  GWExchangeHistoryVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/16.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWExchangeHistoryVC.h"
//cell
#import "GWExchangeHistoryCell.h"
//model
#import "GWExchangeModel.h"


@interface GWExchangeHistoryVC ()

/** 数据 */
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation GWExchangeHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"兑换记录";

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(GWExchangeHistoryCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(GWExchangeHistoryCell.class)];
    
    self.array = [NSMutableArray array];
    
    [self loadDataWithHeader:YES hud:YES page:self.page size:self.size];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}

/**
 *  单元格方法
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GWExchangeHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWExchangeHistoryCell.class)];
    cell.model = [self.array objectAtIndex:indexPath.row];
    return cell;
}

/**
 *  行高
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 74;
}

#pragma mark - UITableViewDelegate

/**
 *  单元格点击
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIImage *)base_emptyImage{
    
    return [UIImage imageNamed:@"history_empty"];
    
}

- (NSString *)base_emptyTitle{
    
    return @"还没有兑换记录呦~";
    
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
    
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_currency_exchangeRecordWithPageCurrent:page.stringValue pageSize:size.stringValue parentView:self.view hasHud:NO hasMask:hud end:^(URLResponse *response) {
        
    } success:^(URLResponse *response, id object) {
        
        NSArray *array = [GWExchangeModel mj_objectArrayWithKeyValuesArray:object];
        
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
        
        [self_weak_.array addObjectsFromArray:array];
        [self_weak_.tableView reloadData];
        
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        
        [self_weak_.tableView.mj_header endRefreshing];
        [self_weak_.tableView.mj_footer endRefreshing];
        
    } netWorkError:^(NSError *error) {
        
        [self_weak_.tableView.mj_header endRefreshing];
        [self_weak_.tableView.mj_footer endRefreshing];
        
    }]];
    
}


@end
