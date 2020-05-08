//
//  GWExchangeCell.h
//  GUOWER
//
//  Created by ourslook on 2018/7/16.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWExchangeGoodsModel;

@interface GWExchangeCell : UITableViewCell

/** model */
@property (nonatomic, strong) GWExchangeGoodsModel *model;

/** 立即兑换点击回调 */
@property (nonatomic, copy) void(^immediatelyChangeBlock)(void);

@end
