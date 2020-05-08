//
//  URLCommonSubPathMode.h
//  OURSLOOK_Network
//
//  Created by ourslook on 2018/4/23.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLCommonSubPathMode : NSObject
+ (instancetype)sharedCommon;

#pragma mark -- 广告表
/** 首页banner */
@property (nonatomic, copy) NSString *api_app_advertisement_list;
/** 文章详情广告 */
@property (nonatomic, copy) NSString *api_app_advertisement_listByNewsDetails;
#pragma mark -- config相关接口
/** 查询字典，只能查询单个字典 */
@property (nonatomic, copy) NSString *api_cfg_dictInfo;
/** 文案 */
@property (nonatomic, copy) NSString *api_cfg_clause;
#pragma mark -- 核心接口
/** 上传单文件 */
@property (nonatomic, copy) NSString *api_fileUpload;
/** 上传多个文件 */
@property (nonatomic, copy) NSString *api_fileUploads;
#pragma mark --  登录注册相关接口
/** 获取手机验证码 */
@property (nonatomic, copy) NSString *api_p_getMobileCode;
/** 注册 */
@property (nonatomic, copy) NSString *api_p_register;
/** 检查手机验证码是否正确 */
@property (nonatomic, copy) NSString *api_p_checkSmsCode;
/** 登录 */
@property (nonatomic, copy) NSString *api_p_login;
/** 修改密码 */
@property (nonatomic, copy) NSString *api_p_pwdUpdate;
/** 忘记密码 */
@property (nonatomic, copy) NSString *api_p_pwdForget;
/** 用户详情(更新token) */
@property (nonatomic, copy) NSString *api_p_updateToken;
#pragma mark --  web端用户相关接口
/** 获取我的文章列表,这里是必须要传token */
@property (nonatomic, copy) NSString *api_p_user_getMyNews;
#pragma mark --  用户相关接口
/** 修改头像 */
@property (nonatomic, copy) NSString *api_app_user_updateHead;
/** 修改昵称 */
@property (nonatomic, copy) NSString *api_app_user_updateNickName;
/** 修改个性签名 */
@property (nonatomic, copy) NSString *api_app_user_updateSignature;
/** 获取用户最新认证状态 */
@property (nonatomic, copy) NSString *api_app_user_getExamineType;
/** 申请认证 */
@property (nonatomic, copy) NSString *api_app_user_applyExamine;
/** id查询用户详情 */
@property (nonatomic, copy) NSString *api_app_user_infoByUserId;
#pragma mark --  新闻文章表
/** 我的新闻文章 */
@property (nonatomic, copy) NSString *api_app_news_listByMy;
/** 搜索新闻文章 */
@property (nonatomic, copy) NSString *api_app_news_listByType;
/** 搜索新闻文章 */
@property (nonatomic, copy) NSString *api_app_news_listByTitle;
/** 新闻文章表详情 */
@property (nonatomic, copy) NSString *api_app_news_findBusNewsByid;
/** 利好 */
@property (nonatomic, copy) NSString *api_app_fastnews_addgood;
/** 利空 */
@property (nonatomic, copy) NSString *api_app_fastnews_addbad;

/** 热门文章 */
@property (nonatomic, copy) NSString *api_app_news_listByHot;
/** 根据用户id查找他的新闻文章 */
@property (nonatomic, copy) NSString *api_app_news_listByUserId;
#pragma mark --  兑换表
/** 兑换列表 */
@property (nonatomic, copy) NSString *api_app_currency_list;
/** 兑换 */
@property (nonatomic, copy) NSString *api_app_currency_exchange;
/** 兑换记录 */
@property (nonatomic, copy) NSString *api_app_currency_exchangeRecord;
#pragma mark --  快报表
/** 查询所有快报表信息 */
@property (nonatomic, copy) NSString *api_app_fastnews_list;
#pragma mark --  微博相关接口
/** 查询微博列表(获取当前登录用户及其所关注（授权）用户的最新微博) */
@property (nonatomic, copy) NSString *api_weibo_homeTimeline;
/** 查询微博列表(客户提供账号所发布微博) */
@property (nonatomic, copy) NSString *api_weibo_list;

@end
