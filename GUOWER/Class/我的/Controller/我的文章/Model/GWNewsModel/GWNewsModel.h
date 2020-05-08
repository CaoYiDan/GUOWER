//
//  GWNewsModel.h
//  GUOWER
//
//  Created by ourslook on 2018/7/17.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *    @brief    BusNewsVo
 */
@interface GWNewsModel : NSObject

/** 是否显示大图 */
@property (nonatomic, assign, getter=isGw_bigImage) BOOL gw_bigImage;

/** 作者 */
@property (nonatomic, strong) NSNumber *author;
/** 作者头像 */
@property (nonatomic, strong) NSString *authorHeadPortrait;
/** 作者名 */
@property (nonatomic, strong) NSString *authorName;
/** 审核类型【2.未通过 0.审核中 1.通过】 */
@property (nonatomic, strong) NSNumber *examineType;
/** 编号 */
@property (nonatomic, strong) NSNumber *ID;
/** 大图标 */
@property (nonatomic, strong) NSString *image;
/** 是否为广告【1.广告 0.非广告】 */
@property (nonatomic, strong) NSNumber *isAdvertisement;
/** 是否上热点【1.热点 0.非热点】 */
@property (nonatomic, strong) NSNumber *isHotspot;
/** 暂留 */
@property (nonatomic, strong) NSNumber *isRelease;
/** 阅读量 */
@property (nonatomic, strong) NSNumber *lookTimes;
/** 正文【详情】 */
@property (nonatomic, strong) NSString *mainText;
/** 暂留 */
@property (nonatomic, strong) NSString *newsRemarks2;
/** 暂留 */
@property (nonatomic, strong) NSString *newsRemarks3;
/** 文章类型 */
@property (nonatomic, strong) NSString *newsType;
/** 新闻类型名 */
@property (nonatomic, strong) NSString *newsTypeName;
/** 发布时间 */
@property (nonatomic, strong) NSString *releaseDate;
/** 发布类型【1.后台 2.作者】 */
@property (nonatomic, strong) NSNumber *releaseType;
/** 发布人 */
@property (nonatomic, strong) NSNumber *releaseUserId;
/** 发布人名称 */
@property (nonatomic, strong) NSString *releaseUserName;
/** 责任编辑 */
@property (nonatomic, strong) NSString *responsibleEditor;
/** 小图标 */
@property (nonatomic, strong) NSString *smallImage;
/** 副标题【简介】 */
@property (nonatomic, strong) NSString *smallTitle;
/** 排序 */
@property (nonatomic, strong) NSNumber *sort;
/** 排序到期时间 */
@property (nonatomic, strong) NSString *sortTime;
/** 文章标签【2.NEW 1.HOT 0.无标签】 */
@property (nonatomic, strong) NSNumber *tag;
/** 内容标签1 */
@property (nonatomic, strong) NSString *tag1;
/** 内容标签2 */
@property (nonatomic, strong) NSString *tag2;
/** 内容标签3 */
@property (nonatomic, strong) NSString *tag3;
/** 标题 */
@property (nonatomic, strong) NSString *title;

/**
 *    @brief    获取对应标题
 *
 *    @param     lineSpacing     是否有行间距
 *    @param     isBig     是否显示大图标
 */
- (NSMutableAttributedString*)titleWithLineSpacing:(BOOL)lineSpacing isBig:(BOOL)isBig;

@end
