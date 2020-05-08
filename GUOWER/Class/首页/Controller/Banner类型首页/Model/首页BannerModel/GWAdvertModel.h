//
//  GWAdvertModel.h
//  GUOWER
//
//  Created by ourslook on 2018/7/19.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWAdvertModel : NSObject

/** 暂留 */
@property (nonatomic, copy) NSString *advertisemenRemarks1;
/** 暂留 */
@property (nonatomic, copy) NSString *advertisemenRemarks2;
/** 暂留 */
@property (nonatomic, copy) NSString *advertisemenRemarks3;
/** 广告类型 */
@property (nonatomic, copy) NSString *advertisementType;
/** 编号 */
@property (nonatomic, strong) NSNumber *ID;
/** 大图标 */
@property (nonatomic, copy) NSString *image;
/** 跳转新闻文章id */
@property (nonatomic, strong) NSNumber *jumpNewsId;
/** 跳转方式【1.链接 2.视频 3.富文本 4.新闻文章】 */
@property (nonatomic, strong) NSNumber *jumpType;
/** 跳转地址 */
@property (nonatomic, copy) NSString *jumpUrl;
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
/** 小图标 */
@property (nonatomic, copy) NSString *smallImage;
/** 副标题【简介】 */
@property (nonatomic, copy) NSString *smallTitle;
/** 排序 */
@property (nonatomic, strong) NSNumber *sort;
/** 排序到期时间 */
@property (nonatomic, copy) NSString *sortTime;
/** 标题 */
@property (nonatomic, copy) NSString *title;

@end
