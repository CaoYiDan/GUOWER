//
//  GWNewsVC.m
//  GUOWER
//
//  Created by ourslook on 2018/6/25.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWNewsVC.h"
//顶部菜单
#import "TYTabPagerBar.h"
//分页控制器
#import "TYPagerController.h"
//快报
#import "GWNNewsVC.h"
//微博
#import "GWWeiBoLiastVC.h"

@interface GWNewsVC ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, weak) TYTabPagerBar *gw_topBar;
@property (nonatomic, weak) TYPagerController *gw_pagerController;

@end

@implementation GWNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化菜单栏
    [self setupPagerTabBar];
    //初始化分页栏
    [self setupPagerController];
    
    [self.gw_topBar reloadData];
    
    [self.gw_pagerController reloadData];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:NewsReloadNotification object:nil];
}
- (void)setupPagerTabBar {
    
    TYTabPagerBar *topBar = [[TYTabPagerBar alloc]init];
    topBar.dataSource = self;
    topBar.delegate = self;
    [topBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.navigationController.view addSubview:topBar];
    @weakify(self);
    [topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self_weak_.navigationController.navigationBar.mas_bottom);
        make.height.mas_equalTo(44);
    }];
    
    TYTabPagerBarLayout *layout = [[TYTabPagerBarLayout alloc]initWithPagerTabBar:topBar];
    layout.adjustContentCellsCenter = YES;
    layout.barStyle = TYPagerBarStyleProgressView;
    layout.progressWidth = 30;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.normalTextFont = m_FontPF_Regular_WithSize(18);
    layout.normalTextColor = m_Color_gray(188.0);
    layout.selectedTextFont = m_FontPF_Semibold_WithSize(18);
    layout.selectedTextColor = m_Color_gray(47.0);
    layout.cellWidth = m_ScreenW/2.5;
    [topBar setLayout:layout];
    
    self.gw_topBar = topBar;
    
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
        make.top.equalTo(self_weak_.navigationController.navigationBar.mas_bottom).mas_offset(1);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.gw_pagerController = pagerController;
    
}

#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    
    return 2;
    
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = index?@"微博":@"快报";
    return cell;
    
}

#pragma mark - TYTabPagerBarDelegate

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    
    [self.gw_pagerController scrollToControllerAtIndex:index animate:YES];
    
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    
    return 2;
    
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    
    switch (index) {
        case 0:
        {
            GWNNewsVC *vc = [[GWNNewsVC alloc]init];
            return vc;
        }
            break;
        case 1:
        {
            GWWeiBoLiastVC *vc = [[GWWeiBoLiastVC alloc]init];
            return vc;
        }
            break;
            
        default:
            break;
    }
    
    GWNNewsVC *vc = [[GWNNewsVC alloc]init];
    return vc;
    
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    
    [self.gw_topBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
    
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

@end
