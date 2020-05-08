//
//  GWNewsModel.h
//  GUOWER
//
//  Created by ourslook on 2018/7/13.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWFastNewsModel : NSObject

/** 暂留 */
@property (nonatomic, copy) NSString *fastnewsRemarks1;
/** 暂留 */
@property (nonatomic, copy) NSString *fastnewsRemarks2;
/** 暂留 */
@property (nonatomic, copy) NSString *fastnewsRemarks3;
/** 果味指数 */
@property (nonatomic, strong) NSNumber *guowerIndex;
/** 编号 */
@property (nonatomic, strong) NSNumber *ID;
/** 是否为724小时快讯【0.默认快报 1.724小时快讯】 */
@property (nonatomic, strong) NSNumber *isNewsFlash;
/** 阅读量 */
@property (nonatomic, strong) NSNumber *lookTimes;
/** 正文【详情】 */
@property (nonatomic, copy) NSString *mainText;
/** 发布时间 */
@property (nonatomic, copy) NSString *releaseDate;
/** 发布人 */
@property (nonatomic, strong) NSNumber *releaseUserId;
/** 发布人名称 */
@property (nonatomic, copy) NSString *releaseUserName;
/** 排序 */
@property (nonatomic, strong) NSNumber *sort;
/** 排序到期时间 */
@property (nonatomic, copy) NSString *sortTime;
/** 标题 */
@property (nonatomic, copy) NSString *title;

/**
 利好数量
 */
@property (nonatomic,assign) NSInteger good;

/**
 利空数量
 */
@property (nonatomic,assign) NSInteger bad;

/**
 利好
 */
@property (nonatomic,assign)BOOL isGood;

/**
 利空
 */
@property (nonatomic,assign) BOOL isBad;
@end
