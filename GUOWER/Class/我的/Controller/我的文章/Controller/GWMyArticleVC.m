//
//  GWMyArticleVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/13.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWMyArticleVC.h"
//cells
#import "GWMyArticleCell.h"
//model
#import "GWNewsModel.h"
//newsDetail
#import "GWNewsDetailVC.h"

@interface GWMyArticleVC ()

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation GWMyArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的文章";
    
    self.array = [NSMutableArray array];
    
    [self setupTableView];
    
    [self loadDataWithHeader:YES hud:YES page:self.page size:self.size];
    
}

- (void)setupTableView{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(GWMyArticleCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(GWMyArticleCell.class)];
    
}

/**
 *  单元格方法
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GWMyArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWMyArticleCell.class)];
    cell.model = [self.array objectAtIndex:indexPath.row];
    return cell;
    
}

/**
 *  行高
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    CGFloat proportion = 375/114.00;
    
    return m_ScreenW/proportion;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GWNewsDetailVC *vc = [[GWNewsDetailVC alloc]init];
    GWNewsModel *model = [self.array objectAtIndex:indexPath.row];
    vc.newsID = model.ID.stringValue;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (BOOL)base_haveRefreshHeader{
    
    return YES;
    
}

- (BOOL)base_haveRefreshFooter{
    
    return YES;
    
}

- (void)base_headerRefreshingMethod:(MJRefreshHeader *)refreshHeader page:(NSNumber *)page size:(NSNumber*)size{
    [self loadDataWithHeader:YES hud:NO page:page size:size];
}

- (void)base_footerRefreshingMethod:(MJRefreshFooter *)refreshFooter page:(NSNumber *)page size:(NSNumber*)size{
    [self loadDataWithHeader:NO hud:NO page:page size:size];
}

/**
 *    @brief    加载列表信息
 */
-(void)loadDataWithHeader:(BOOL)header hud:(BOOL)hud page:(NSNumber*)page size:(NSNumber*)size{
    
    @weakify(self);
    
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_p_user_getMyNewsWithPageCurrent:page.stringValue pageSize:@"10" parentView:self.view hasHud:NO hasMask:hud end:^(URLResponse *response) {
        
    } success:^(URLResponse *response, id object) {
        
        NSArray *array = [GWNewsModel mj_objectArrayWithKeyValuesArray:object[@"list"]];
        
        if (header) {
            [self_weak_.array removeAllObjects];
            [self_weak_.tableView.mj_header endRefreshing];
            if (array.count<10) {
                [self_weak_.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self_weak_.tableView.mj_footer endRefreshing];
            }
        }else{
            if(array.count<10){
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

- (UIImage *)base_emptyImage{
    
    return [UIImage imageNamed:@"article_empty"];
    
}

- (NSString *)base_emptyTitle{
    
    return @"还没有发布文章呦~";
    
}

@end
