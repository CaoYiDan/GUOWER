//
//  GWHPAuthorHomePageVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/3.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWHPAuthorHomePageVC.h"
#import "UIImage+ImageWithColor.h"
//导航
#import "GWHPAuthorNavigationBar.h"
//header
#import "GWHPAuthorHeaderView.h"
//HotCell
#import "GWMyArticleCell.h"
//model
#import "GWNewsModel.h"
//newsDetail
#import "GWNewsDetailVC.h"

@interface GWHPAuthorHomePageVC ()

/**  */
@property (nonatomic, weak) UIImageView *gw_topBgImage;

/**  */
@property (nonatomic, weak) UIImageView *gw_bgImage;

/** 是否设置成白色背景 */
@property (nonatomic, assign) BOOL gw_white;

/** 作者信息 */
@property (nonatomic, strong) GWUserModel *userInfo;

/** 数据 */
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation GWHPAuthorHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = [NSMutableArray array];
    
    self.tableView.backgroundColor = m_Color_RGB(244.00, 245.00, 249.00);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(GWMyArticleCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(GWMyArticleCell.class)];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //创建顶部背景
    UIImageView *topBgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"author_top_bg"]];
    topBgImage.contentMode = UIViewContentModeScaleAspectFill;
    self.gw_topBgImage = topBgImage;
    [self.tableView addSubview:topBgImage];
    
    //创建圆角背景
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"author_cell_bg"]];
    self.gw_bgImage = bgImage;
    [self.tableView addSubview:bgImage];
    
    [self loadUserData];
    
}

- (void)loadUserData{
    
    [self.navigationController.view showMaskWithHint:nil];
    
    __block BOOL hasFailure = NO;
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    //加载作者信息
    dispatch_group_enter(serviceGroup);
    
    @weakify(self);
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_user_infoByUserIdWithID:self.userId parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
        
        dispatch_group_leave(serviceGroup);
        
    } success:^(URLResponse *response, id object) {
        
        self_weak_.userInfo = [GWUserModel mj_objectWithKeyValues:object];
        
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        hasFailure = YES;
    } netWorkError:^(NSError *error) {
        hasFailure = YES;
    }]];
    
    //加载作者第一页文章信息
    dispatch_group_enter(serviceGroup);
    
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_news_listByUserIdWithPageCurrent:self.page.stringValue pageSize:self.size.stringValue userId:self.userId parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
        
        dispatch_group_leave(serviceGroup);
        
    } success:^(URLResponse *response, id object) {
        
         NSArray *array = [GWNewsModel mj_objectArrayWithKeyValuesArray:object];
        
        [self_weak_.array removeAllObjects];
        [self_weak_.tableView.mj_header endRefreshing];
        if (array.count<self_weak_.size.integerValue) {
            [self_weak_.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self_weak_.array addObjectsFromArray:array];
        
        
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        hasFailure = YES;
    } netWorkError:^(NSError *error) {
        hasFailure = YES;
    }]];
    
    /** 全部完成 */
    dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
        if (hasFailure) {
            
            [self_weak_.navigationController.view showErrorMaskWithHint:nil clickBlock:^{
                [self_weak_ loadUserData];
            }];
            
        }else{
            
            [self_weak_.navigationController.view hideMask];
            
            CGFloat height = [self_weak_.userInfo.signature va_calculatedTextMaxHeightWithMaxWidth:m_ScreenW-30 font:m_FontPF_Regular_WithSize(12)].height + 130;

            GWHPAuthorHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"GWHPAuthorHeaderView" owner:nil options:nil] firstObject];
            header.ol_width = m_ScreenW;
            header.ol_height = height;
            header.model = self_weak_.userInfo;
            self_weak_.tableView.tableHeaderView = header;
            self_weak_.navigationBar.gw_name = self_weak_.userInfo.nickName;
            self_weak_.navigationBar.ol_data = self_weak_.userInfo.headPortrait;
            [self_weak_ reloadData];
            [self_weak_ scrollViewDidScroll:self_weak_.tableView];
            
        }
        NSLog(@"全部完成");
        NSLog(@"%@",@(hasFailure));
        
    });
    
}

- (BOOL)base_haveRefreshHeader{
    
    return YES;
    
}

- (BOOL)base_haveRefreshFooter{
    
    return YES;
    
}

- (void)reloadData{
    
    [self.tableView reloadData];
    
    //获取区域
    CGRect rect = [self.tableView rectForSection:0];
    
    rect.origin.y-=15;
    rect.size.height += 15;
    if (rect.size.height < m_ScreenW) {
        rect.size.height = 1000;
    }
    
    [self.tableView sendSubviewToBack:self.gw_bgImage];
    
    [self.tableView sendSubviewToBack:self.gw_topBgImage];
    
    if (!CGRectEqualToRect(self.gw_bgImage.frame, rect)) {
        [self.gw_bgImage setFrame:rect];
    }
    
    CGRect topRect = CGRectMake(0, -m_TopHeight, m_ScreenW, rect.origin.y + m_TopHeight + 30);
    
    if (!CGRectEqualToRect(self.gw_topBgImage.frame, topRect)) {
        [self.gw_topBgImage setFrame:topRect];
    }
    
}

/**
 *    @brief    是否展示空视图
 */
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return NO;
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
    
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_news_listByUserIdWithPageCurrent:page.stringValue pageSize:size.stringValue userId:self.userId parentView:self.view hasHud:NO hasMask:hud end:^(URLResponse *response) {
        
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
        [self_weak_ reloadData];
        
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        
        [self_weak_.tableView.mj_header endRefreshing];
        [self_weak_.tableView.mj_footer endRefreshing];
        
    } netWorkError:^(NSError *error) {
        
        [self_weak_.tableView.mj_header endRefreshing];
        [self_weak_.tableView.mj_footer endRefreshing];
        
    }]];
    
}



- (GWHPAuthorNavigationBar*)navigationBar{
    
    return (GWHPAuthorNavigationBar*)self.navigationController.navigationBar;
    
}

- (Class)rt_navigationBarClass{
    
    return GWHPAuthorNavigationBar.class;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat y = scrollView.contentOffset.y;
    
    //偏移量校准
    y+=scrollView.contentInset.top;
    
    if (m_VERSION(11.00)) {
        
        y += m_TopHeight;
    }
    
    //顶部视图的高度  11像素是背景圆角图片阴影部分所占的高度
    CGFloat topHeight = self.gw_bgImage.ol_y + 11;
    
    if (y >= topHeight) {
        
        self.gw_white = YES;
        self.navigationBar.gw_alpha = 1;
        
    }else{
        
        self.gw_white = NO;
        //计算透明度
        CGFloat proportion = MAX(0, y/topHeight);
        proportion = MIN(1, proportion);
        self.navigationBar.gw_alpha = proportion;
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
    
}

/**
 *  单元格方法
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GWMyArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWMyArticleCell.class)];
    cell.backgroundColor = UIColor.clearColor;
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{

    [tableView sendSubviewToBack:self.gw_bgImage];

    [tableView sendSubviewToBack:self.gw_topBgImage];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView sendSubviewToBack:self.gw_bgImage];
    
    [tableView sendSubviewToBack:self.gw_topBgImage];
    
}

#

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GWNewsModel *model = [self.array objectAtIndex:indexPath.row];
    GWNewsDetailVC *vc = [[GWNewsDetailVC alloc]init];
    vc.newsID = model.ID.stringValue;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (BOOL)base_navigationBarWhiteStyle{
    
    return NO;
    
}

- (void)setGw_white:(BOOL)gw_white{
    
    if (_gw_white==gw_white) return;
    
    _gw_white = gw_white;

    UIImage *image = gw_white?[UIImage imageWithColor:UIColor.whiteColor]:[UIImage imageNamed:@"author_cell_bg"];
    
    self.gw_bgImage.image = image;
    
}

@end
