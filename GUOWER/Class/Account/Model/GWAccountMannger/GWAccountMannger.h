//
//  GWAccountMannger.h
//  XueYouHui_User
//
//  Created by ourslook on 2018/5/15.
//  Copyright © 2018年 Ourslook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GWUserModel.h"

/** 通知接受 */
#define AccountMannger_userInfoDidChangeNotification(...) [[[NSNotificationCenter defaultCenter] rac_addObserverForName:AccountUserInfoDidChangeNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {\
__VA_ARGS__\
}]

@interface GWAccountMannger : NSObject


/**
 *    @brief    设置用户信息
 */
+(void)setUserInfo:(GWUserModel*)userInfo;
#define AccountMannger_setUserInfo(object) [GWAccountMannger setUserInfo:object]

/**
 *    @brief    获取用户信息
 */
+(GWUserModel*)getUserInfo;
#define AccountMannger_userInfo [GWAccountMannger getUserInfo]

/**
 *    @brief    更新用户信息
 *
 *    @param     value     值  如果是double类型需转换成NSNumber类型
 *    @param     key     键  需要更新的值
 *    @param     notice     是否发送用户信息更新通知
 */
+(void)updateUserInfoValue:(id)value forKey:(NSString*)key notice:(BOOL)notice;
#define AccountMannger_updateUserInfo(value,key) [GWAccountMannger updateUserInfoValue:(value) forKey:(key) notice:YES]
#define AccountMannger_updateUserInfoNoNotice(value,key) [GWAccountMannger updateUserInfoValue:(value) forKey:(key) notice:NO]

/**
 *    @brief    清除用户信息
 */
+(void)removeUserInfo;
#define AccountMannger_removeUserInfo [GWAccountMannger removeUserInfo]

/**
 *    @brief    用户是否登录
 */
+(BOOL)isLogin;
#define AccountMannger_isLogin [GWAccountMannger isLogin]

@end
