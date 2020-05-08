//
//  GWHomePageVC.m
//  GUOWER
//
//  Created by ourslook on 2018/6/25.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWHomePageVC.h"
#import "UIImage+ImageWithColor.h"
#import "UIButton+ImageTitleSpacing.h"
//顶部菜单
#import "TYTabPagerBar.h"
//分页控制器
#import "TYPagerController.h"
//Banner类型首页
#import "GWHPBannerVC.h"
//model
#import "GWDictInfoModel.h"
//push
#import <JPUSHService.h>

@interface GWHomePageVC ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>

/** 分类名称数组 */
@property (nonatomic, strong) NSMutableArray *gw_titleArray;
/** 分类数组 */
@property (nonatomic, strong) NSMutableArray *gw_array;
@property (nonatomic, weak) TYTabPagerBar *gw_topBar;
@property (nonatomic, weak) TYPagerController *gw_pagerController;

@end

@implementation GWHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //加载item信息
    [self loadItemData];
    
    //初始化菜单栏
    [self setupPagerTabBar];
    //初始化分页栏
    [self setupPagerController];
    
}

- (void)loadItemData{
    
    @weakify(self);
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_cfg_dictInfoWithCode:@"TYPE_NEWS" parentView:self.navigationController.view hasHud:NO hasMask:YES end:^(URLResponse *response) {

    } success:^(URLResponse *response, id object) {
        
        self_weak_.gw_array = [GWDictInfoModel mj_objectArrayWithKeyValuesArray:object];
        
        //添加固定的两个栏目
        GWDictInfoModel *hotItem = [[GWDictInfoModel alloc]init];
        hotItem.name = @"热点";
        GWDictInfoModel *columnItem = [[GWDictInfoModel alloc]init];
        columnItem.name = @"专栏";
        [self_weak_.gw_array insertObject:columnItem atIndex:0];
        [self_weak_.gw_array insertObject:hotItem atIndex:0];
        
        [self_weak_.gw_topBar reloadData];
        [self_weak_.gw_pagerController reloadData];

        
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {

    } netWorkError:^(NSError *error) {

    }]];
    
}

- (void)setupPagerTabBar {
    
    TYTabPagerBar *topBar = [[TYTabPagerBar alloc]init];
    topBar.dataSource = self;
    topBar.delegate = self;
    [topBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.navigationController.view addSubview:topBar];
    @weakify(self);
    [topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self_weak_.navigationController.navigationBar.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(34);
    }];
    
    TYTabPagerBarLayout *layout = [[TYTabPagerBarLayout alloc]initWithPagerTabBar:topBar];
    layout.adjustContentCellsCenter = YES;
    layout.barStyle = TYPagerBarStyleNoneView;
    layout.sectionInset = UIEdgeInsetsMake(0, 25, 0, 25);
    layout.normalTextFont = m_FontPF_Regular_WithSize(18);//8月3日 由15号字体修改为18号字体
    layout.normalTextColor = m_Color_gray(188.0);
    layout.selectedTextFont = m_FontPF_Semibold_WithSize(18);
    layout.selectedTextColor = m_Color_gray(47.0);
    [topBar setLayout:layout];
    
    self.gw_topBar = topBar;
    
    //line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = m_Color_gray(229);
    [topBar addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
}

- (void)setupPagerController {
    
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.layout.prefetchItemCount = 1;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.navigationController.view addSubview:pagerController.view];
    
    @weakify(self);
    [pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self_weak_.gw_topBar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.gw_pagerController = pagerController;
    
}

#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    
    return self.gw_titleArray.count;

}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = [self.gw_titleArray objectAtIndex:index];
    return cell;
    
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    
    NSString *title = [self.gw_titleArray objectAtIndex:index];
    return [pagerTabBar cellWidthForTitle:title];
    
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {

    [self.gw_pagerController scrollToControllerAtIndex:index animate:YES];
    
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    
    return self.gw_titleArray.count;
    
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    
    GWDictInfoModel *model = [self.gw_array objectAtIndex:index];
    
    GWHPBaseTableVC *vc = nil;
    
    if ([model.name isEqualToString:@"热点"]) {
        vc = [[GWHPBannerVC alloc]init];
    }else{
        vc = [[GWHPBaseTableVC alloc]init];
    }
    vc.model = model;
    
    return vc;
    
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    
    [self.gw_topBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
    
}

- (NSMutableArray *)gw_titleArray{
    
    if (!_gw_titleArray) {
        _gw_titleArray = [self.gw_array mutableArrayValueForKeyPath:@"name"];
    }
    return _gw_titleArray;
    
}

#pragma mark -- VC配置项

- (void)base_userRepeatClickTabBarItem:(NSString *)title{
    
    if (self.gw_pagerController.scrollView.isDragging||self.gw_pagerController.scrollView.isDecelerating) return;
    //获取视图
    
    GWBaseTableVC *tableVC = (GWBaseTableVC*)[self.gw_pagerController controllerForIndex:self.gw_pagerController.curIndex];
    if (tableVC&&[tableVC isKindOfClass:GWBaseTableVC.class]) {
        
        if (tableVC.tableView.isTracking) return;
        
        if (tableVC.tableView.contentOffset.y > 0)
        {
            CGFloat y = -tableVC.tableView.contentInset.top;
            if (tableVC.tableView.mj_header.isRefreshing) {
                y -= tableVC.tableView.mj_header.ol_height;
            }
            [tableVC.tableView setContentOffset:CGPointMake(0,y) animated:YES];
        }
        else if ([tableVC base_haveRefreshHeader]){
            if (!tableVC.tableView.mj_header.isRefreshing) {
                [tableVC.tableView.mj_header beginRefreshing];
            }
        }
        
    }
    
}

- (Class)rt_navigationBarClass{
    
    return NSClassFromString(@"GWHPNavigationBar");
    
}

- (BOOL)base_hiddenNavigationBarLine{
    
    return YES;
    
}

- (void)base_networkingReachabilityDidChange:(GWNetworkReachabilityStatus)status{
    
    [super base_networkingReachabilityDidChange:status];
    
    if (status!=GWNetworkReachabilityStatusNotReachable) {
        
        if (AccountMannger_isLogin) {
            [URLRequestHelper api_p_updateTokenWithToken:AccountMannger_userInfo.token parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
                
            } success:^(URLResponse *response, id object) {
                
                GWUserModel *model = [GWUserModel mj_objectWithKeyValues:object];
                AccountMannger_setUserInfo(model);
                [JPUSHService setAlias:model.ID.stringValue completion:nil seq:0];
                
            } failure:^(URLResponse *response, NSInteger code, NSString *message) {
                
                AccountMannger_removeUserInfo;
                m_ToastCenter(@"登录失效");
                
            } netWorkError:^(NSError *error) {
                
            }];
        }
        
    }
    
}


@end
