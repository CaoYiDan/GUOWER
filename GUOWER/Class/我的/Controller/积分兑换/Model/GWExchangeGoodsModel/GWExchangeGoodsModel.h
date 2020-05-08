//
//  GWExchangeGoodsModel.h
//  GUOWER
//
//  Created by ourslook on 2018/7/18.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *    @brief    InfCurrencyEntity
 */
@interface GWExchangeGoodsModel : NSObject

/** 库存 */
@property (nonatomic, strong) NSNumber *count;
/** 货币名称 */
@property (nonatomic, copy) NSString *currencyName;
/** <#Description#> */
@property (nonatomic, strong) NSNumber *delFlag;
/** 编号 */
@property (nonatomic, strong) NSNumber *ID;
/** 图标 */
@property (nonatomic, copy) NSString *image;
/** 发布时间 */
@property (nonatomic, copy) NSString *releaseDate;
/** 发布人 */
@property (nonatomic, strong) NSNumber *releaseUserId;
/** 发布人名称 */
@property (nonatomic, copy) NSString *releaseUserName;
/** 积分价格 */
@property (nonatomic, strong) NSNumber *score;
/** 排序 */
@property (nonatomic, strong) NSNumber *sort;
/** 排序时间 */
@property (nonatomic, copy) NSString *sortTime;

@end
