//
//  GWImmediatelyVC.h
//  GUOWER
//
//  Created by ourslook on 2018/7/16.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWBaseVC.h"

@class GWExchangeGoodsModel;

@interface GWImmediatelyVC : GWBaseVC

/** model */
@property (nonatomic, strong) GWExchangeGoodsModel *model;

/** modelChange */
@property (nonatomic, copy) void(^modelChangeBlock)(void);

@end
