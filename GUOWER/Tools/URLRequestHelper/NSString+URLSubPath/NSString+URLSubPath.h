//
//  NSString+URLSubPath.h
//  OURSLOOK_Network
//
//  Created by ourslook on 2018/4/23.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//内含简写及替换"_"为"/"的方法
#import "URLRequestHelper_Abbrev.h"



@interface NSString (URLSubPath)

/**
 *    @brief    发送Post请求
 *
 *    @param     parameters     参数
 *    @param     hasCache     是否缓存
 *    @param     parentView     需要显示HUD或者Mask的View
 *    @param     hasHud     是否显示HUD
 *    @param     hasMask     是否显示MASK
 *    @param     end     请求结束回调
 *    @param     success     请求成功回调
 *    @param     failure     请求失败回调
 *    @param     netWorkError     服务器、网络错误回调
 *
 *    @return    会话
 */
-(NSURLSessionTask*)post_parameters:(id)parameters hasCache:(BOOL)hasCache parentView:(UIView*)parentView hasHud:(BOOL)hasHud hasMask:(BOOL)hasMask end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure netWorkError:(kRequestNetWorkError)netWorkError;

/**
 *    @brief    发送get请求
 *
 *    @param     parameters     参数
 *    @param     hasCache     是否缓存
 *    @param     parentView     需要显示HUD或者Mask的View
 *    @param     hasHud     是否显示HUD
 *    @param     hasMask     是否显示MASK
 *    @param     end     请求结束回调
 *    @param     success     请求成功回调
 *    @param     failure     请求失败回调
 *    @param     netWorkError     服务器、网络错误回调
 *
 *    @return    会话
 */
-(NSURLSessionTask*)get_parameters:(id)parameters hasCache:(BOOL)hasCache parentView:(UIView*)parentView hasHud:(BOOL)hasHud hasMask:(BOOL)hasMask end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure netWorkError:(kRequestNetWorkError)netWorkError;

/**
 *    @brief    发送put请求
 *
 *    @param     parameters     参数
 *    @param     parentView     需要显示HUD或者Mask的View
 *    @param     hasHud     是否显示HUD
 *    @param     hasMask     是否显示MASK
 *    @param     end     请求结束回调
 *    @param     success     请求成功回调
 *    @param     failure     请求失败回调
 *    @param     netWorkError     服务器、网络错误回调
 *
 *    @return    会话
 */
-(NSURLSessionTask*)put_parameters:(id)parameters parentView:(UIView*)parentView hasHud:(BOOL)hasHud hasMask:(BOOL)hasMask end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure netWorkError:(kRequestNetWorkError)netWorkError;

/**
 *    @brief    发送delete请求
 *
 *    @param     parameters     参数
 *    @param     parentView     需要显示HUD或者Mask的View
 *    @param     hasHud     是否显示HUD
 *    @param     hasMask     是否显示MASK
 *    @param     end     请求结束回调
 *    @param     success     请求成功回调
 *    @param     failure     请求失败回调
 *    @param     netWorkError     服务器、网络错误回调
 *
 *    @return    会话
 */
-(NSURLSessionTask*)delete_parameters:(id)parameters parentView:(UIView*)parentView hasHud:(BOOL)hasHud hasMask:(BOOL)hasMask end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure netWorkError:(kRequestNetWorkError)netWorkError;

@end
