//
//  GWAccountMannger.m
//  XueYouHui_User
//
//  Created by ourslook on 2018/5/15.
//  Copyright © 2018年 Ourslook. All rights reserved.
//

#import "GWAccountMannger.h"
#import <PPNetworkHelper.h>
#import <MARTNSObject.h>
#import <RTProperty.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <JPUSHService.h>

@implementation GWAccountMannger

/**
 *    @brief    设置用户信息
 */
+(void)setUserInfo:(GWUserModel*)userInfo{

    m_UserDefaultSetObjectForKey([NSKeyedArchiver archivedDataWithRootObject:userInfo], AccountUserInfoKey);

    [self setUserLoginStatus:YES];
    
    //保存的用户信息没有Token 清空用户信息
    if ([NSString ol_isNullOrNilWithObject:userInfo.token]) {
        
        [self removeUserInfo];
        
    }

}

/**
 *    @brief    设置用户登录状态
 *
 *    @param     status     登录状态
 */
+(void)setUserLoginStatus:(BOOL)status{

    BOOL isLogin = [self isLogin];
    
    if (status != isLogin) {//变更登录状态
        
        NSNumber *loginStatus = [NSNumber numberWithBool:status];
        m_UserDefaultSetObjectForKey(loginStatus, AccountUserIsLoginKey);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AccountUserLoginStatusDidChangeDidChangeNotification object:loginStatus];
        
        NSLog(@"\n\n\n 用户登录状态变更 \n *** %@ *** \n\n\n",status?@"已登录":@"未登录");
        
    }
    
}

/**
 *    @brief    获取用户信息
 */
+(GWUserModel*)getUserInfo{

    return [NSKeyedUnarchiver unarchiveObjectWithData:m_UserDefaultObjectForKey(AccountUserInfoKey)];

}

/**
 *    @brief    更新用户信息
 */
+(void)updateUserInfoValue:(id)value forKey:(NSString*)key notice:(BOOL)notice{

    RTProperty *property = [GWUserModel rt_propertyForName:key];

    if (property) {//键真实存在

        GWUserModel *userInfo = [self getUserInfo];
        
        id oldValue = [userInfo valueForKey:key];
        
        //目前只处理NSNumber/NSString两种类型

        if ([property.typeEncoding isEqualToString:@"d"]) {
            NSAssert([value isKindOfClass:NSNumber.class], @" %s 目标为double类型，而传入的Value不是NSNumber类型",__func__);
        }

        [userInfo setValue:value forKey:key];

        m_UserDefaultSetObjectForKey([NSKeyedArchiver archivedDataWithRootObject:userInfo], AccountUserInfoKey);

        if (notice) {
            [[NSNotificationCenter defaultCenter] postNotificationName:AccountUserInfoDidChangeNotification object:userInfo];
        }

        NSLog(@"\n\n\n 用户信息Model变更 \n *** key *** \n %@ \n *** value *** \n %@\n *** oldValue *** \n %@\n\n\n",key,value,oldValue);

    }

}

/**
 *    @brief    清除用户信息
 */
+(void)removeUserInfo{

    m_UserDefaultRemoveObjectForKey(AccountUserInfoKey);

    [self setUserLoginStatus:NO];

    //清除推送别名
    [JPUSHService deleteAlias:nil seq:0];

    //清除第三方登录授权
    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
}

/**
 *    @brief    用户是否登录
 */
+(BOOL)isLogin{

    NSNumber *isLogin = m_UserDefaultObjectForKey(AccountUserIsLoginKey);
    return isLogin.boolValue;

}

@end
