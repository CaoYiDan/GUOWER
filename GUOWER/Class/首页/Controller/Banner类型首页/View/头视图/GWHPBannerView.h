//
//  GWHPBannerView.h
//  GUOWER
//
//  Created by ourslook on 2018/7/2.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWAdvertModel;

/**
 *    @brief    BannerCell
 */
@interface GWHPBannerViewCell : UICollectionViewCell

@end

/**
 *    @brief    Banner
 */
@interface GWHPBannerView : UIView

/** Banner数组 */
@property (nonatomic, strong) NSMutableArray <GWAdvertModel*> *gw_datas;

/** banner点击回调 */
@property (nonatomic, copy) void(^bannerClickBlock)(GWAdvertModel*currentModel);

@end
