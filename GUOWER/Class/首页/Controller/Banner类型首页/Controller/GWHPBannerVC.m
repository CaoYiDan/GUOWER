//
//  GWHPBannerVC.m
//  GUOWER

//  Created by ourslook on 2018/7/2.

//  Copyright © 2018年 Vanne. All rights reserved.

#import "GWHPBannerVC.h"
//Banner
#import "GWHPBannerView.h"
//model
#import "GWAdvertModel.h"
//web
#import "VAWebViewController.h"
//newsDetail
#import "GWNewsDetailVC.h"
//player
#import "VAPlayerViewController.h"
//nav
#import "GWNavigationController.h"

@interface GWHPBannerVC ()

/** header */
@property (nonatomic, weak) GWHPBannerView *banner;

@end

@implementation GWHPBannerVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupHeaderView];
    
}

- (void)setupHeaderView{
    
    GWHPBannerView *banner = [[GWHPBannerView alloc]initWithFrame:CGRectMake(0, 0, m_ScreenW, m_ScreenW/2)];
    
    self.tableView.tableHeaderView = banner;
    
    self.banner = banner;
    
    [self loadBannerData];
    
}

- (void)loadBannerData{
    
    @weakify(self);
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_advertisement_listWithPageCurrent:@"1" pageSize:@"999" parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
        
    } success:^(URLResponse *response, id object) {
        
        NSMutableArray *array = [GWAdvertModel mj_objectArrayWithKeyValuesArray:object];
        self_weak_.banner.gw_datas = array;
        self_weak_.banner.bannerClickBlock = ^(GWAdvertModel *currentModel) {
            [self_weak_ gw_bannerDidSelected:currentModel];
        };
        
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        
    } netWorkError:^(NSError *error) {
        
    }]];
    
}

- (void)gw_bannerDidSelected:(GWAdvertModel*)model{
    
    //【1.链接 2.视频 3.富文本 4.新闻文章】
    switch (model.jumpType.integerValue) {
        case 1:
        {
            VAWebViewController *webVC = [[VAWebViewController alloc]initWithType:VAWebViewContentURL content:model.jumpUrl];
            webVC.title = model.title;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 2:
        {
            VAPlayerViewController *player = [[VAPlayerViewController alloc]init];
            player.url = model.jumpUrl;
            [self presentViewController:player animated:YES completion:nil];
        }
            break;
        case 3:
        {
            VAWebViewController *webVC = [[VAWebViewController alloc]initWithType:VAWebViewContentHTMLString content:model.mainText];
            webVC.title = model.title;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 4:
        {
            GWNewsDetailVC *vc = [[GWNewsDetailVC alloc]init];
            vc.newsID = model.jumpNewsId.stringValue;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)base_headerRefreshingMethod:(MJRefreshHeader *)refreshHeader page:(NSNumber *)page size:(NSNumber *)size{
    
    [super base_headerRefreshingMethod:refreshHeader page:page size:size];
    
    [self loadBannerData];
    
}

@end
