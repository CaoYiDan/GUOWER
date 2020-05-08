//
//  GWExchangeVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/16.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWExchangeVC.h"
#import "GWExchangeCell.h"
//立即兑换
#import "GWImmediatelyVC.h"
//history
#import "GWExchangeHistoryVC.h"
//model
#import "GWExchangeGoodsModel.h"

@interface GWExchangeVC ()

/** 数据 */
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation GWExchangeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"积分兑换";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"兑换记录" style:UIBarButtonItemStylePlain target:self action:@selector(exchangeHistory)];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:m_FontPF_Regular_WithSize(14),NSFontAttributeName,m_Color_gray(47),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(GWExchangeCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(GWExchangeCell.class)];
    
    self.array = [NSMutableArray array];
    
    [self loadDataWithHeader:YES hud:YES page:self.page size:self.size];
    
}

- (void)exchangeHistory{
    
    GWExchangeHistoryVC *vc = [[GWExchangeHistoryVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UITableViewDataSource

/**
 *  行数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}

/**
 *  区数
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/**
 *  单元格方法
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GWExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWExchangeCell.class)];
    GWExchangeGoodsModel *model = [self.array objectAtIndex:indexPath.row];
    cell.model = model;
    @weakify(self);
    cell.immediatelyChangeBlock = ^{
        GWImmediatelyVC *vc = [[GWImmediatelyVC alloc]init];
        vc.modelChangeBlock = ^{
            [tableView reloadData];
        };
        vc.model = model;
        [self_weak_.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}

#pragma mark - UITableViewDelegate

/**
 *  单元格点击
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
-(void)loadDataWithHeader:(BOOL)header hud:(BOOL)hud page:(NSNumber*)page size:(NSNumber*)size{
    
    @weakify(self);
    
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_currency_listWithPageCurrent:page.stringValue pageSize:size.stringValue parentView:self.view hasHud:NO hasMask:hud end:^(URLResponse *response) {
        
    } success:^(URLResponse *response, id object) {
        
        NSArray *array = [GWExchangeGoodsModel mj_objectArrayWithKeyValuesArray:object];
        
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
