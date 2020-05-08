//
//  GWHPBannerView.m
//  GUOWER
//
//  Created by ourslook on 2018/7/2.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWHPBannerView.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
//model
#import "GWAdvertModel.h"

/**
 *    @brief    BannerCell
 */
@interface GWHPBannerViewCell ()

/** 图片 */
@property (nonatomic, strong) ZYLoadingImageView *gw_imageView;

@end

@implementation GWHPBannerViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {

        [self.contentView addSubview:self.gw_imageView];
        [self.gw_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        self.masksToBounol_ol = YES;
        self.cornerRadius_ol = 4;

    }
    return self;

}

- (UIImageView *)gw_imageView{
    
    if (!_gw_imageView) {
        _gw_imageView = [[ZYLoadingImageView alloc]init];
    }
    return _gw_imageView;
    
}

@end

/**
 *    @brief    Banner
 */
@interface GWHPBannerView ()<TYCyclePagerViewDelegate,TYCyclePagerViewDataSource>

/** Banner */
@property (nonatomic, strong) TYCyclePagerView *gw_bannerView;
/** pageControl */
@property (nonatomic, strong) TYPageControl *gw_pageControl;

@end

@implementation GWHPBannerView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self.gw_bannerView registerClass:GWHPBannerViewCell.class forCellWithReuseIdentifier:NSStringFromClass(GWHPBannerViewCell.class)];
        [self addSubview:self.gw_bannerView];
        [self.gw_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-5);
        }];
        [self addSubview:self.gw_pageControl];
        @weakify(self);
        [self.gw_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self_weak_.gw_bannerView.mas_bottom).mas_equalTo(-3);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(3);
        }];
        
    }
    return self;
    
}

- (void)setGw_datas:(NSMutableArray<GWAdvertModel *> *)gw_datas{
    
    _gw_datas = gw_datas;
    [self.gw_bannerView updateData];
    self.gw_pageControl.numberOfPages = gw_datas.count;
    
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    
    return self.gw_datas.count;
    
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    
    GWHPBannerViewCell *cell = (GWHPBannerViewCell*)[pagerView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(GWHPBannerViewCell.class) forIndex:index];
    GWAdvertModel *model = [self.gw_datas objectAtIndex:index];
    cell.gw_imageView.ol_data = model.image;
    return cell;
    
}

-(void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index{
    
    GWAdvertModel *model = [self.gw_datas objectAtIndex:index];
    if (self.bannerClickBlock) {
        self.bannerClickBlock(model);
    }
    
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(self.ol_width - 46, self.ol_height - 26);
    layout.itemSpacing = 10;
//    layout.minimumScale = 0.2;
//    layout.maximumAngle = 0.2;
    layout.layoutType = TYCyclePagerTransformLayoutLinear;
    return layout;
    
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {

    [self.gw_pageControl setCurrentPage:toIndex animate:YES];

}

- (TYCyclePagerView *)gw_bannerView{
    
    if (!_gw_bannerView) {
        _gw_bannerView = [[TYCyclePagerView alloc]init];
        _gw_bannerView.isInfiniteLoop = YES;
        _gw_bannerView.autoScrollInterval = 3.0;
        _gw_bannerView.layout.itemHorizontalCenter = YES;
        _gw_bannerView.dataSource = self;
        _gw_bannerView.delegate = self;
    }
    return _gw_bannerView;
}

- (TYPageControl *)gw_pageControl{
    
    if (!_gw_pageControl) {
        _gw_pageControl = [[TYPageControl alloc]init];
        _gw_pageControl.pageIndicatorImage = [UIImage imageNamed:@"Dot"];
        _gw_pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"DotSelected"];
        _gw_pageControl.pageIndicatorSpaing = 7;
        _gw_pageControl.pageIndicatorSize = CGSizeMake(10, 3);
        _gw_pageControl.currentPageIndicatorSize = CGSizeMake(10, 3);
        _gw_pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _gw_pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _gw_pageControl;
    
}

@end
