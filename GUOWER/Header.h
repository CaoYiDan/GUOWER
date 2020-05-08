//
//  Header.h
//  GUOWER
//
//  Created by ourslook on 2018/6/25.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#ifndef Header_h
#define Header_h

/** 用户信息键 */
static NSString *const AccountUserInfoKey = @"AccountUserInfoKey";
/** 用户是否登录键 */
static NSString *const AccountUserIsLoginKey = @"AccountUserIsLoginKey";
/** 用户信息变更通知 */
static NSString *const AccountUserInfoDidChangeNotification = @"AccountUserInfoDidChangeNotification";
/** 用户登录状态变更通知 */
static NSString *const AccountUserLoginStatusDidChangeDidChangeNotification = @"AccountUserLoginStatusDidChangeDidChangeNotification";

/** 刷新快报数据通知 */
static NSString *const NewsReloadNotification = @"NewsReloadNotification";

/** 用户重复点击某个UITabBarItem的通知 */
static NSString *const GWUserRepeatClickTabBarItemNotification = @"GWUserRepeatClickTabBarItemNotification";

/**
 *    @brief    网络状态
 */
typedef NS_ENUM(NSInteger,GWNetworkReachabilityStatus) {
    
    /** 未知网络 */
    GWNetworkReachabilityStatusUnknown          = -1,
    /** 没有网络 */
    GWNetworkReachabilityStatusNotReachable     = 0,
    /** 蜂窝 */
    GWNetworkReachabilityStatusReachableViaWWAN = 1,
    /** WIFI */
    GWNetworkReachabilityStatusReachableViaWiFi = 2,
    
};

/**
 *    @brief    新闻标题图标类型
 */
typedef NS_ENUM(NSInteger,GWNewsTitleIconType) {
    
    /** Normal */
    GWNewsTitleIconTypeNormal = 0,
    /** HOT */
    GWNewsTitleIconTypeHot,
    /** NEW */
    GWNewsTitleIconTypeNew
    
};

/**
 *    @brief    申请认证类型
 */
typedef NS_ENUM(NSInteger,GWCertificationType) {
    
    /** 企业 */
    GWCertificationEnterprise = 1,
    /** 作者 */
    GWCertificationAuthor,
    /** 媒体 */
    GWCertificationMedia
    
    
};

/**
 *    @brief    申请认证状态
 */
typedef NS_ENUM(NSInteger,GWCertificationResultState) {
    
    /** 审核中 */
    GWCertificationResultOngoing = 0,
    /** 审核成功 */
    GWCertificationResultSuccess,
    /** 审核失败 */
    GWCertificationResultFailure
    
};

/**
 *    @brief    提交结果类型
 */
typedef NS_ENUM(NSInteger,GWSubmitResultType) {
    
    /** 认证申请提交成功 */
    GWSubmitResultCertificationSuccess = 0,
    /** 积分兑换申请提交成功 */
    GWSubmitResultExchangeSuccess,
    /** 积分兑换申请提交失败 */
    GWSubmitResultExchangeFailure
    
};

#endif /* Header_h */
