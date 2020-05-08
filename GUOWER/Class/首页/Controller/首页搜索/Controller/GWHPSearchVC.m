//
//  GWHPSearchVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/2.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWHPSearchVC.h"
#import "UIImage+ImageWithColor.h"
#import <MARTNSObject.h>
#import "GWNewsModel.h"
//cell
#import "GWHPHotNewsCell.h"
//newsDetail
#import "GWNewsDetailVC.h"

@interface GWHPSearchVC ()<UISearchBarDelegate>

/** searchBar */
@property (nonatomic, weak) UISearchBar *searchBar;

/** 是否展示空界面 */
@property (nonatomic, assign) BOOL showEmpty;

/** array */
@property (nonatomic, strong) NSMutableArray *array;

/** 关键字 */
@property (nonatomic, strong) NSString *gw_title;

@end

@implementation GWHPSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.tableView.backgroundColor = UIColor.whiteColor;
    
    self.array = [NSMutableArray array];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(GWHPHotNewsCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(GWHPHotNewsCell.class)];
    
    [self setupSearchBar];
    
}

- (void)setupSearchBar{
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.backgroundColor = UIColor.clearColor;
    searchBar.barTintColor = UIColor.clearColor;
    searchBar.backgroundImage = [UIImage imageWithColor:UIColor.clearColor];
    searchBar.tintColor = m_Color_gray(153.00);
    searchBar.placeholder = @"搜索关键词";
    searchBar.delegate = self;
    self.searchBar = searchBar;
    UITextField *view = [searchBar valueForKeyPath:@"searchBarTextField"];
    view.superview.backgroundColor = m_Color_gray(245.00);
    view.backgroundColor = m_Color_gray(245.00);
    view.font = m_FontPF_Regular_WithSize(13);
    view.textColor = m_Color_gray(153.00);
    UIButton *button = [view valueForKey:@"_clearButton"];
    [button setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [searchBar setImage:[UIImage imageNamed:@"search1"]
            forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.navigationController.view addSubview:searchBar];
    searchBar.masksToBounol_ol = YES;
    searchBar.cornerRadius_ol = 15;
    @weakify(self);
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(44);
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self_weak_.navigationController.navigationBar.mas_bottom).mas_equalTo(-7);
        make.height.mas_equalTo(30);
    }];
    
    [self.base_disposableArray addObject:[view.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        
        [self_weak_ setupTableViewWithString:x];
        
    }]];
    
}

- (void)setupTableViewWithString:(NSString*)text{
    
    if ([NSString ol_isNullOrNilWithObject:text]) {//展示搜索历史
        
        self.showEmpty = NO;
        [self.array removeAllObjects];
        [self.tableView reloadData];
        
        self.tableView.hidden = YES;
        
        
    }else{
        
        self.showEmpty = YES;
        
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar endEditing:YES];
    self.gw_title = searchBar.text;
    self.page = @1;
    [self loadDataWithHeader:YES hud:YES page:self.page size:self.size];
    
}

/**
 *    @brief    加载列表信息
 */
-(void)loadDataWithHeader:(BOOL)header hud:(BOOL)hud page:(NSNumber *)page size:(NSNumber *)size{
    
    @weakify(self);
    
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_news_listByTitleWithPageCurrent:page.stringValue pageSize:size.stringValue title:self.gw_title parentView:self.view hasHud:hud hasMask:NO end:^(URLResponse *response) {
        
        self_weak_.tableView.hidden = NO;
        
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

#pragma mark -- VC配置项

- (BOOL)base_haveRefreshFooter{
    
    return YES;
    
}

- (void)base_footerRefreshingMethod:(MJRefreshFooter *)refreshFooter page:(NSNumber *)page size:(NSNumber *)size{
    [self loadDataWithHeader:NO hud:NO page:page size:size];
}

#pragma mark - UITableViewDataSource

/**
 *  行数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat proportion = 375/114.00;
    return m_ScreenW/proportion;
    
}

/**
 *  单元格方法
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GWHPHotNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWHPHotNewsCell.class)];
    cell.model = [self.array objectAtIndex:indexPath.row];
    return cell;
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

/**
 *    @brief    是否展示空视图
 */
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.showEmpty;
}

- (UIImage *)base_emptyImage{
    
    return [UIImage imageNamed:@"article_empty"];
    
}

- (NSString *)base_emptyTitle{
    
    return @"没有找到相关信息~";
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.gw_title) {
        return;
    }
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar endEditing:YES];
}

@end
