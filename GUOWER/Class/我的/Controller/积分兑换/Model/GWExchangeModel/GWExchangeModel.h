//
//  GWExchangeModel.h
//  GUOWER
//
//  Created by ourslook on 2018/7/18.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *    @brief    InfExchangeRecordVo
 */
@interface GWExchangeModel : NSObject

/** 创建时间 */
@property (nonatomic, copy) NSString *createDate;
/** 货币id */
@property (nonatomic, strong) NSNumber *currencyId;
/** 货币图标 */
@property (nonatomic, copy) NSString *currencyImg;
/** 货币名称 */
@property (nonatomic, copy) NSString *currencyName;
/** 编号 */
@property (nonatomic, strong) NSNumber *ID;
/** 钱包地址 */
@property (nonatomic, copy) NSString *purseAddress;
/** 消耗积分 */
@property (nonatomic, strong) NSNumber *score;
/** 状态【1.兑换中 2.已完成】 */
@property (nonatomic, strong) NSNumber *state;
/** 操作人 */
@property (nonatomic, strong) NSNumber *sysUserId;
/** 操作人名称 */
@property (nonatomic, copy) NSString *sysUserName;
/** 用户id */
@property (nonatomic, strong) NSNumber *userId;
/** 用户名称 */
@property (nonatomic, copy) NSString *userName;

@end
