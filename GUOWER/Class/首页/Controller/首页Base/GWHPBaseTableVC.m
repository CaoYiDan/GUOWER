//
//  GWHPBaseTableVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/19.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWHPBaseTableVC.h"
#import <SDAutoLayout.h>
//newsDetail
#import "GWNewsDetailVC.h"
//HotCell
#import "GWHPHotNewsCell.h"
//AdvertCell
#import "GWHPAdvertCell.h"
//HighCell
#import "GWHPHighNewsCell.h"

@interface GWHPBaseTableVC ()

/** 文章类型【字典类remarks字段】 */
@property (nonatomic, copy) NSString *newsType;
/** 是否热点【1.是】 */
@property (nonatomic, copy) NSString *isHotspot;
/** 是否专栏【2.是】 */
@property (nonatomic, copy) NSString *releaseType;

@end

@implementation GWHPBaseTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = [NSMutableArray array];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupTableView];
    
    [self loadDataWithHeader:YES hud:YES page:self.page size:self.size];
    
}

- (void)setupTableView{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(GWHPHotNewsCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(GWHPHotNewsCell.class)];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(GWHPAdvertCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(GWHPAdvertCell.class)];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(GWHPHighNewsCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(GWHPHighNewsCell.class)];
    
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
    
    GWNewsModel *model = [self.array objectAtIndex:indexPath.row];
    
    //是否是广告
    if (model.isAdvertisement.boolValue) {
        
        GWHPAdvertCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWHPAdvertCell.class)];
        cell.model = model;
        return cell;
        
    }else{
        
        //大图
        if (model.isGw_bigImage) {
            GWHPHighNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWHPHighNewsCell.class)];
            cell.model = model;
            return cell;
        }else{
            GWHPHotNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWHPHotNewsCell.class)];
            cell.model = model;
            return cell;
        }
        
    }
    
}

/**
 *  行高
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    GWNewsModel *model = [self.array objectAtIndex:indexPath.row];
    
    //是否是广告
    if (model.isAdvertisement.boolValue) {
        
        CGFloat proportion = 375/160.00;
        
        return m_ScreenW/proportion;
        
    }else{
        
        //大图
        if (model.isGw_bigImage) {
            return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:GWHPHighNewsCell.class contentViewWidth:m_ScreenW];
        }else{
            CGFloat proportion = 375/114.00;
            
            return m_ScreenW/proportion;
        }
        
    }
    
}

#pragma mark - UITableViewDelegate

/**
 *  单元格点击
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GWNewsModel *model = [self.array objectAtIndex:indexPath.row];
    
    GWNewsDetailVC *vc = [[GWNewsDetailVC alloc]init];
    vc.newsID = model.ID.stringValue;
    [self.navigationController pushViewController:vc animated:YES];
    
//    //是否是广告
//    if (model.isAdvertisement.boolValue) {
//
//
//
//    }else{
//
//
//        
//    }
    
}

- (void)setModel:(GWDictInfoModel *)model{
    
    _model = model;
    
    if ([model.name isEqualToString:@"热点"]) {
        self.newsType = nil;
        self.isHotspot = @"1";
        self.releaseType = @"0";
    }else if ([model.name isEqualToString:@"专栏"]){
        self.newsType = nil;
        self.isHotspot = @"0";
        self.releaseType = @"2";
    }else{
        self.newsType = model.remarks;
        self.isHotspot = @"0";
        self.releaseType = @"0";
    }

}

#pragma mark -- VC配置项

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
    
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_news_listByTypeWithPageCurrent:page.stringValue pageSize:size.stringValue newsType:self.newsType isHotspot:self.isHotspot releaseType:self.releaseType parentView:self.view hasHud:NO hasMask:hud end:^(URLResponse *response) {
        
    } success:^(URLResponse *response, id object) {
        
        NSArray *array = [GWNewsModel mj_objectArrayWithKeyValuesArray:object];
        
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

/**
 *    @brief    是否展示空视图
 */
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return NO;
}

@end
