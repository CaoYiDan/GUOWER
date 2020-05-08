//
//  URLRequestHelper.h
//  OURSLOOK_Network
//
//  Created by ourslook on 2018/4/23.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 后缀缩写 */
#define kURL_BLOCK_RESPONSE  parentView:(UIView *)parentView hasHud:(BOOL)hasHud hasMask:(BOOL)hasMask end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure netWorkError:(kRequestNetWorkError)netWorkError;

@interface URLRequestHelper : NSObject

#pragma mark -- 广告表

/**
*    @brief    首页banner
*
*    @param     pageCurrent     页号,字段名:pageCurrent,默认1,从第1页开始
*    @param     pageSize     页长,字段名:pageSize,默认10
*/
+ (NSURLSessionTask *)api_app_advertisement_listWithPageCurrent:(NSString*)pageCurrent pageSize:(NSString*)pageSize kURL_BLOCK_RESPONSE;
/**
 *    @brief   快报利空
 *
 *    @param     ID     文章新闻ID
 */
+ (NSURLSessionTask *)api_app_news_fastnews_addbad
:(NSString*)ID kURL_BLOCK_RESPONSE;
/**
 *    @brief   快报利好
 *
 *    @param     ID     文章新闻ID
 */
+ (NSURLSessionTask *)api_app_news_fastnews_addgood
:(NSString*)ID kURL_BLOCK_RESPONSE;
/**
 *    @brief    文章详情广告
 *
 *    @param     pageCurrent     页号,字段名:pageCurrent,默认1,从第1页开始
 *    @param     pageSize     页长,字段名:pageSize,默认10
 */
+ (NSURLSessionTask *)api_app_advertisement_listByNewsDetailsWithPageCurrent:(NSString*)pageCurrent pageSize:(NSString*)pageSize kURL_BLOCK_RESPONSE;

#pragma mark -- config相关接口

/**
 *    @brief    查询字典，只能查询单个字典
 *
 *    @param     code     字典类型code,字段名:code
 */
+ (NSURLSessionTask *)api_cfg_dictInfoWithCode:(NSString*)code kURL_BLOCK_RESPONSE;

/**
 *    @brief    文案
 *
 *    @param     clauseType     文案类型
 */
+ (NSURLSessionTask *)api_cfg_clauseWithClauseType:(NSString*)clauseType kURL_BLOCK_RESPONSE;

#pragma mark -- 核心接口

/**
 *    @brief    上传单个
 *
 *    @param     image     图片
 */
+ (NSURLSessionTask *)api_fileUploadWithImage:(UIImage *)image end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure netWorkError:(kRequestNetWorkError)netWorkError;

/**
 *    @brief    多文件上传
 *
 *    @param     images     图片数组
 */
+(NSURLSessionTask *)api_fileUploadsWithImages:(NSArray <UIImage*> *)images end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure netWorkError:(kRequestNetWorkError)netWorkError;

#pragma mark --  登录注册相关接口

/**
 *    @brief    获取手机验证码
 *
 *    @param     type     类型,字段名:type(1:注册 2:忘记密码 3:修改密码 4:修改手机号码 5:手机号码登录 6:绑定用户),必填
 *    @param     mobile     手机号码,字段名:mobile,必填
 */
+ (NSURLSessionTask *)api_p_getMobileCodeWithType:(NSString*)type mobile:(NSString*)mobile kURL_BLOCK_RESPONSE;

/**
 *    @brief    注册
 *
 *    @param     mobile     手机号
 *    @param     password     密码
 *    @param     msgcode     短信验证码
 */
+ (NSURLSessionTask *)api_p_registerWithMobile:(NSString*)mobile password:(NSString*)password msgcode:(NSString*)msgcode kURL_BLOCK_RESPONSE;

/**
 *    @brief    检查手机验证码是否正确
 *
 *    @param     phone     手机号
 *    @param     code     验证码
 */
+ (NSURLSessionTask *)api_p_checkSmsCodeWithPhone:(NSString*)phone code:(NSString*)code kURL_BLOCK_RESPONSE;

/**
 *    @brief    登录
 *
 *    @param     mobile     手机号
 *    @param     password     密码
 */
+ (NSURLSessionTask *)api_p_loginWithMobile:(NSString*)mobile password:(NSString*)password kURL_BLOCK_RESPONSE;

/**
 *    @brief    修改密码
 *
 *    @param     mobile     手机号,字段名:mobile
 *    @param     msgcode     验证码,字段名:msgcode
 *    @param     password     新密码,字段名:password
 */
+ (NSURLSessionTask *)api_p_pwdUpdateWithMobile:(NSString*)mobile msgcode:(NSString*)msgcode password:(NSString*)password kURL_BLOCK_RESPONSE;

/**
 *    @brief    忘记密码(登录)
 *
 *    @param     mobile     手机号,字段名:mobile
 *    @param     newPassword     新密码,字段名:newPassword
 */
+ (NSURLSessionTask *)api_p_pwdForgetWithMobile:(NSString*)mobile newPassword:(NSString*)newPassword kURL_BLOCK_RESPONSE;

/**
 *    @brief    用户详情(更新token)
 */
+ (NSURLSessionTask *)api_p_updateTokenWithToken:(NSString*)token kURL_BLOCK_RESPONSE;

#pragma mark --  web端用户相关接口

/**
 *    @brief    获取我的文章列表,这里是必须要传token
 */
+ (NSURLSessionTask *)api_p_user_getMyNewsWithPageCurrent:(NSString*)pageCurrent pageSize:(NSString*)pageSize kURL_BLOCK_RESPONSE;

#pragma mark --  用户相关接口

/**
 *    @brief    修改用户头像
 *
 *    @param     headPortrait    头像
 */
+ (NSURLSessionTask *)api_app_user_updateHeadWithHeadPortrait:(NSString*)headPortrait kURL_BLOCK_RESPONSE;

/**
 *    @brief    修改昵称
 *
 *    @param     nickName     昵称
 */
+ (NSURLSessionTask *)api_app_user_updateNickNameWithNickName:(NSString*)nickName kURL_BLOCK_RESPONSE;

/**
 *    @brief    修改个性签名
 *
 *    @param     signature     签名
 */
+ (NSURLSessionTask *)api_app_user_updateSignatureWithSignature:(NSString*)signature kURL_BLOCK_RESPONSE;

/**
 *    @brief    获取用户最新认证状态
 *
 *    @param     token     token
 */
+ (NSURLSessionTask *)api_app_user_getExamineTypeWithToken:(NSString*)token kURL_BLOCK_RESPONSE;

/**
 *    @brief    申请认证
 *
 *    @param     userType     认证类型,字段名:userType【1.企业认证 2.作者认证 3.媒体认证】
 *    @param     userName     姓名,字段名:userName
 *    @param     userIdCard     身份证号,字段名:userIdCard
 *    @param     userTel     手机号码,字段名:userTel
 *    @param     userEmail     电子邮箱,字段名:userEmail
 *    @param     userCertificatesImage     证件照,字段名:userCertificatesImage
 *    @param     enterpriseName     企业名称,字段名:enterpriseName
 *    @param     enterpriseIdCard     企业证件号,字段名:enterpriseIdCard
 *    @param     enterpriseImage     营业执照,字段名:enterpriseImage
 */
+ (NSURLSessionTask *)api_app_user_applyExamineWithUserType:(NSInteger)userType userName:(NSString*)userName userIdCard:(NSString*)userIdCard userTel:(NSString*)userTel userEmail:(NSString*)userEmail userCertificatesImage:(NSString*)userCertificatesImage enterpriseName:(NSString*)enterpriseName enterpriseIdCard:(NSString*)enterpriseIdCard enterpriseImage:(NSString*)enterpriseImage kURL_BLOCK_RESPONSE;

/**
 *    @brief    id查询用户详情
 *
 *    @param     ID     用户ID
 */
+ (NSURLSessionTask *)api_app_user_infoByUserIdWithID:(NSString*)ID kURL_BLOCK_RESPONSE;


#pragma mark --  新闻文章表

/**
 *    @brief    我的新闻文章
 *
 *    @param     pageCurrent     页号,字段名:pageCurrent,默认1,从第1页开始
 *    @param     pageSize     页长,字段名:pageSize,默认10
 */
+ (NSURLSessionTask *)api_app_news_listByMyWithPageCurrent:(NSString*)pageCurrent pageSize:(NSString*)pageSize kURL_BLOCK_RESPONSE;

/**
 *    @brief    搜索新闻文章
 *
 *    @param     pageCurrent     页号,字段名:pageCurrent,默认1,从第1页开始
 *    @param     pageSize     页长,字段名:pageSize,默认10
 *    @param     newsType     文章类型【字典类remarks字段】
 *    @param     isHotspot     是否热点【1.是】
 *    @param     releaseType     是否专栏【2.是】
 */
+ (NSURLSessionTask *)api_app_news_listByTypeWithPageCurrent:(NSString*)pageCurrent pageSize:(NSString*)pageSize newsType:(NSString*)newsType isHotspot:(NSString*)isHotspot releaseType:(NSString*)releaseType kURL_BLOCK_RESPONSE;

/**
 *    @brief    搜索新闻文章
 *
 *    @param     pageCurrent     页号,字段名:pageCurrent,默认1,从第1页开始
 *    @param     pageSize     页长,字段名:pageSize,默认10
 *    @param     title     标题,若填写排序只按浏览量排序
 */
+ (NSURLSessionTask *)api_app_news_listByTitleWithPageCurrent:(NSString*)pageCurrent pageSize:(NSString*)pageSize title:(NSString*)title kURL_BLOCK_RESPONSE;

/**
 *    @brief    新闻文章表详情
 *
 *    @param     ID     文章新闻ID
 */
+ (NSURLSessionTask *)api_app_news_findBusNewsByidWithID:(NSString*)ID kURL_BLOCK_RESPONSE;

/**
 *    @brief    热门文章
 *
 *    @param     pageCurrent     页号,字段名:pageCurrent,默认1,从第1页开始
 *    @param     pageSize     页长,字段名:pageSize,默认10
 */
+ (NSURLSessionTask *)api_app_news_listByHotWithPageCurrent:(NSString*)pageCurrent pageSize:(NSString*)pageSize kURL_BLOCK_RESPONSE;

/**
 *    @brief    根据用户id查找他的新闻文章
 *
 *    @param     pageCurrent     页号,字段名:pageCurrent,默认1,从第1页开始
 *    @param     pageSize     页长,字段名:pageSize,默认10
 *    @param     userId     用户ID
 */
+ (NSURLSessionTask *)api_app_news_listByUserIdWithPageCurrent:(NSString*)pageCurrent pageSize:(NSString*)pageSize userId:(NSString*)userId kURL_BLOCK_RESPONSE;

#pragma mark --  兑换表

/**
 *    @brief    兑换列表
 *
 *    @param     pageCurrent     页号,字段名:pageCurrent,默认1,从第1页开始
 *    @param     pageSize     页长,字段名:pageSize,默认10
 */
+ (NSURLSessionTask *)api_app_currency_listWithPageCurrent:(NSString*)pageCurrent pageSize:(NSString*)pageSize kURL_BLOCK_RESPONSE;

/**
 *    @brief    兑换
 *
 *    @param     currencyId     货币id,字段名:id
 *    @param     purseAddress     钱包地址,字段名:purseAddress
 */
+ (NSURLSessionTask *)api_app_currency_exchangeWithCurrencyId:(NSString*)currencyId purseAddress:(NSString*)purseAddress kURL_BLOCK_RESPONSE;

/**
 *    @brief    兑换记录
 *
 *    @param     pageCurrent     页号,字段名:pageCurrent,默认1,从第1页开始
 *    @param     pageSize     页长,字段名:pageSize,默认10
 */
+ (NSURLSessionTask *)api_app_currency_exchangeRecordWithPageCurrent:(NSString*)pageCurrent pageSize:(NSString*)pageSize kURL_BLOCK_RESPONSE;

#pragma mark --  快报表

/**
 *    @brief    查询所有快报表信息
 *
 *    @param     pageCurrent     页号,字段名:pageCurrent,默认1,从第1页开始
 *    @param     pageSize     页长,字段名:pageSize,默认10
 */
+ (NSURLSessionTask *)api_app_fastnews_listWithPageCurrent:(NSString*)pageCurrent pageSize:(NSString*)pageSize kURL_BLOCK_RESPONSE;

#pragma mark --  微博相关接口

/**
 *    @brief    查询微博列表(获取当前登录用户及其所关注（授权）用户的最新微博)
 *
 *    @param     pageCurrent     页号,字段名:pageCurrent,默认1,从第1页开始
 *    @param     pageSize     页长,字段名:pageSize,默认10
 */
+ (NSURLSessionTask *)api_weibo_homeTimelineWithPageCurrent:(NSString*)pageCurrent pageSize:(NSString*)pageSize kURL_BLOCK_RESPONSE;

/**
 *    @brief    查询微博列表(客户提供账号所发布微博)
 *
 *    @param     pageCurrent     页号,字段名:pageCurrent,默认1,从第1页开始
 *    @param     pageSize     页长,字段名:pageSize,默认10
 */
+ (NSURLSessionTask *)api_weibo_listWithPageCurrent:(NSString*)pageCurrent pageSize:(NSString*)pageSize kURL_BLOCK_RESPONSE;

@end
