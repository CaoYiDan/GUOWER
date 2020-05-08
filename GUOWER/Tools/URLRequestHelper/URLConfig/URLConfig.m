//
//  URLConfig.m
//  OURSLOOK_Network
//
//  Created by ourslook on 2018/4/23.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "URLConfig.h"
#import "URLResponse.h"

@interface URLConfig ()

/** 错误码回调注册表 */
@property (nonatomic, strong) NSMutableDictionary *request_code_dict;

@end

@implementation URLConfig

-(NSMutableDictionary *)request_code_dict{
    
    if (!_request_code_dict) {
        _request_code_dict = [NSMutableDictionary dictionary];
    }
    return _request_code_dict;
    
}

/**
 *  单例
 */
+ (instancetype)sharedConfig
{
    static URLConfig *selfClass = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        selfClass = [[URLConfig alloc] init];
    });
    
    return selfClass;
}


+(void)load{
    
    //配置网络请求
    [self configuration];
    
}

+(void)configuration{
    
    [PPNetworkHelper openLog];
    URLConfig *sharedConfig = [URLConfig sharedConfig];
    sharedConfig.request_successCode = 0;
    sharedConfig.request_tokenFailureCode = 101;
    sharedConfig.request_tokenFailureBlock = ^(URLResponse *response, NSInteger errorCode) {
        
        //防止用户没登录出现Token失效情况
        if (AccountMannger_isLogin) {
            
            AccountMannger_removeUserInfo;
            
        }

    };
    
}

/**
 *    @brief    添加一些额外的code 以及 相应的block回调
 *
 *    @param     code     结果码
 */
+(void)request_registerRedundantBlock:(void(^)(URLResponse *response, id request_obj))block withCode:(NSInteger)code{
    
    NSString *key = [NSNumber numberWithInteger:code].stringValue;
    URLConfig.sharedConfig.request_code_dict[key] = [block copy];
    
}

@end
