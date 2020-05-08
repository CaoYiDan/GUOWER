//
//  URLConfig.h
//  OURSLOOK_Network
//
//  Created by ourslook on 2018/4/23.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@class URLResponse;

/** 基地址 */
#if defined(DEBUG)||defined(_DEBUG)
//static NSString *const API_BASE_URL = @"http://192.168.1.126:8981/xueyouhui";
static NSString *const API_BASE_URL = @"http://www.iguower.com/guower";
#else
static NSString *const API_BASE_URL = @"http://www.iguower.com/guower";
#endif



/** 请求彻底成功 */
typedef void(^kRequestSuccess)(URLResponse *response, id object);
/** 请求失败 */
typedef void(^kRequestFailure)(URLResponse *response, NSInteger code, NSString *message);
/** 服务器、网络异常 */
typedef void(^kRequestNetWorkError)(NSError *error);
/** 请求结束 */
typedef void(^kRequestEnd)(URLResponse *response);



@interface URLConfig : NSObject

/** 请求 "成功code" 默认为: 0 */
@property (nonatomic, assign) NSInteger request_successCode;

/** 请求 "token失效code" 默认为: 250 */
@property (nonatomic, assign) NSInteger request_tokenFailureCode;

/** 请求 "token失效" 的回调 */
@property (nonatomic, copy) void(^request_tokenFailureBlock)(URLResponse *response,NSInteger errorCode);

/** code注册表 */
@property (readonly) NSMutableDictionary *request_code_dict;

/**
 *    @brief    注册一些额外的code 以及 相应的block回调
 *
 *    @param     code     结果码
 */
+(void)request_registerRedundantBlock:(void(^)(URLResponse *response, id request_obj))block withCode:(NSInteger)code;

/**
 *  单例
 */
+ (instancetype)sharedConfig;

@end
